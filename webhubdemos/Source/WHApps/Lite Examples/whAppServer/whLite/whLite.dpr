program whLite;  {A fairly generic WebHub application.}
(*
Copyright (c) 1999-2013 HREF Tools Corp.

Permission is hereby granted, on 04-Jun-2004, free of charge, to any person
obtaining a copy of this file (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*)

// Usage: whLite.exe /ID:AppID 
// Check Run|Parameters if you are running this from within the Delphi IDE!

// Full paths are required on utpanfrm, utmainfm, uttrayfm so that WebHub Panels
// will open inside the Delphi IDE.

// Either map h: to your WebHub "lib" directory or change the paths as needed.
// e.g. h: would be mapped to c:\Program Files\HREFTools\WebHub\lib

(* See "How to Work with WebHub Demos.rtf" in the webhubdemos\source\docs folder 
   for information about "drives" H: and K:. *)

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  whSharedLog in 'h:\whSharedLog.pas',
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  uCode,
  utPanFrm in 'h:\utPanFrm.pas' {utParentForm},
  utMainFm in 'h:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'h:\utTrayFm.pas' {fmTrayForm},
  webLink in 'h:\webLink.pas',
  whutil_ZaphodsMap in 'H:\whutil_ZaphodsMap.pas',
  whdemo_DMProjMgr in '..\..\..\Common\whdemo_DMProjMgr.pas' {DMForWHDemo: TDataModule},
  whdemo_Initialize in '..\..\..\Common\whdemo_Initialize.pas',
  whdemo_ViewSource in '..\..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDemoViewSource},
  whdemo_Extensions in '..\..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_About in '..\..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Refresh in '..\..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver: TfmWhDreamweaver},
  whpanel_Mail in 'h:\whpanel_Mail.pas' {fmWebMail},
  dmWHApp in 'h:\dmWHApp.pas' {dmWebHubApp: TDataModule},
  whMain in 'h:\whMain.pas' {fmWebHubMainForm},
  htWebApp in 'h:\htWebApp.pas',
  whMail in 'h:\whMail.pas' {DataModuleWhMail: TDataModule},
  whAppOut in 'h:\whAppOut.pas',
  webTypes in 'h:\webTypes.pas',
  whHTML in 'h:\whHTML.pas' {fmAppHTML},
  whcfg_App in 'h:\whcfg_App.pas',
  uAutoDataModules in 'h:\uAutoDataModules.pas',
  uAutoPanels in 'h:\uAutoPanels.pas';

{$R *.RES}
{$R h:\HTDEMOS.RES}  // main icon for WebHub demos
{..$R HTICONS.RES}   // component icons for combo bar, needed if compiling without WH package
{..$R HTGLYPHS.RES}  // icons for WebHub UI features, needed if compiling without WH package

begin
  {M}Application.Initialize;
  {M}Application.CreateForm(TDMForWHDemo, DMForWHDemo);
  DMForWHDemo.SetDemoFacts('', 'Lite Examples\whAppServer', True);
  DMForWHDemo.ProjMgr.ManageStartup;

  DemoExtensions.Init;  // make extra sure that these event handlers go LAST.

  {M}Application.Run;
end.

