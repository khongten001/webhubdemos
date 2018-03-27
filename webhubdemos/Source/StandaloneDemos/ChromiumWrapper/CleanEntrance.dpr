// ************************************************************************
// ***************************** CEF4Delphi *******************************
// ************************************************************************
//
// CEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to CEF4Delphi.
//
// For more information about CEF4Delphi visit :
//         https://www.briskbard.com/index.php?lang=en&pageid=cef
//
//        Copyright © 2018 Salvador Díaz Fau. All rights reserved.
//
// ************************************************************************
// ************ vvvv Original license and comments below vvvv *************
// ************************************************************************
(*
 *                       Delphi Chromium Embedded 3
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Unit owner : Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)


program CleanEntrance;

{$I cef.inc}

uses
  Vcl.Forms,
  Windows,
  uCEFApplication,
  ZM_CodeSiteInterface in 'h:\ZM_CodeSiteInterface.pas',
  GoogleAs_uCEF3_Init in 'GoogleAs_uCEF3_Init.pas',
  GoogleAs_uBookmark in 'GoogleAs_uBookmark.pas',
  CleanEntrance_fmMiniBrowser in 'CleanEntrance_fmMiniBrowser.pas' {MiniBrowserFrm},
  uPreferences in 'Externals\CEF4\demos\MiniBrowser\uPreferences.pas' {PreferencesFrm},
  uSimpleTextViewer in 'Externals\CEF4\demos\MiniBrowser\uSimpleTextViewer.pas' {SimpleTextViewerFrm},
  CleanEntrance_dmMainMenu in 'CleanEntrance_dmMainMenu.pas' {DataModuleBrowserMenu: TDataModule};

{$R *.res}

{$IFNDEF CPUx64}
{$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE} // uses Windows
{$ENDIF}

const
  cDpr = 'CleanEntrance';

begin
  SetCodeSiteLoggingState([cslAll]);
  CSSend(cDpr);
  GlobalCEFApp := TCefApplication.Create;

  CSSend('GlobalCEFApp.StartMainProcess', S(GlobalCEFApp.StartMainProcess));
  CSSend('GlobalCEFApp.Cache on process startup', GlobalCEFApp.Cache);

  if GlobalCEFApp.StartMainProcess then
    begin
      Init_Global_CEF;
      Application.Initialize;
      EraseCacheFiles;  // First CEF3 instance erase cache prior to loading DLLs
      Application.MainFormOnTaskbar := True;
      Application.CreateForm(TDataModuleBrowserMenu, DataModuleBrowserMenu);
      Application.CreateForm(TMiniBrowserFrm, MiniBrowserFrm);
      Application.CreateForm(TPreferencesFrm, PreferencesFrm);
      Application.CreateForm(TSimpleTextViewerFrm, SimpleTextViewerFrm);
      Application.Run;
    end;

  GlobalCEFApp.Free;
end.
