program aserver;  // A Generic WebHub Application Server
                  // for use with WH DEMOS, without Dreamweaver

(*
Copyright (c) 1998 HREF Tools Corp.

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

// Usage: aserver.exe /ID:AppID [/NoMenu]

(* To disable the HTML Preview Panel:
   Remove this from uses clause: whHtmlVw in 'h:\whHtmlVw.pas' {fmAppHtmlViewer},
   Remove this from list of forms created in DPR:
   Application.CreateForm(TfmAppHtmlViewer, fmAppHtmlViewer);

   Or, if you want the Preview panel to work, purchase THtmlViewer from
   HREFShop.  Details are in the whHtmlVw.pas file.
*)

uses
  MultiTypeApp,
  SysUtils,
  webapp,
  whMacroAffixes,
  ucString,
  uCode,
  updateOk,
  webLink in 'h:\webLink.pas',
  utpanfrm in 'h:\utPanFrm.pas' {utParentForm},
  utmainfm in 'h:\utMainFm.pas' {fmMainForm},
  uttrayfm in 'h:\utTrayFm.pas' {fmTrayForm},
  whdemo_About in '..\..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Extensions in '..\..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_CodeSite in '..\..\..\Common\whdemo_CodeSite.pas',
  whdemo_UIHelpers in '..\..\..\Common\whdemo_UIHelpers.pas',
  whdemo_ViewSource in '..\..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  dmWHPWApp in 'dmWHPWApp.pas' {dmWebHubPowerApp: TdmWebHubPowerApp},
  whpwMain in 'whpwMain.pas' {fmWebHubPowerMainForm},
  fmsetups in 'fmsetups.pas' {fmAppsetups},
  whhtml in 'h:\whHtml.pas' {fmAppHTML},
  whgui_CoverPage in 'h:\whgui_CoverPage.pas' {whfmCoverPage},
  whutil_ZaphodsMap in 'h:\whutil_ZaphodsMap.pas',
  whAppOut in 'h:\whAppOut.pas' {fmAppOut},
  whcfg_App in 'h:\whcfg_App.pas',
  uAutoDataModules in 'h:\uAutoDataModules.pas',
  whAppIn in 'h:\whAppIn.pas' {fmAppIn};

(*
  whHtmlVw in 'h:\whHtmlVw.pas' {fmAppHtmlViewer},

  Htmlview in 'd:\vcl\thtml9\Package\htmlview.pas',
  vwPrint in 'd:\vcl\thtml9\Package\vwPrint.pas',
  MetaFilePrinter in 'd:\vcl\thtml9\Package\MetaFilePrinter.pas',
  StyleUn in 'd:\vcl\thtml9\Package\StyleUn.pas',
  Htmlsubs in 'd:\vcl\thtml9\Package\htmlsubs.pas',
  HTMLUn2 in 'd:\vcl\thtml9\Package\HTMLUn2.pas',
  DitherUnit in 'd:\vcl\thtml9\Package\DitherUnit.pas',
  PngImage1 in 'd:\vcl\thtml9\Package\PngImage1.pas',
  PNGZLIB1 in 'd:\vcl\thtml9\Package\PNGZLIB1.pas',
  Readhtml in 'd:\vcl\thtml9\Package\ReadHTML.pas',
  HTMLGif1 in 'd:\vcl\thtml9\Package\HTMLGif1.pas',
  HTMLGif2 in 'd:\vcl\thtml9\Package\HTMLGif2.pas',
  Htmlsbs1 in 'd:\vcl\thtml9\Package\Htmlsbs1.pas',
  StylePars in 'd:\vcl\thtml9\Package\StylePars.pas',
  URLSubs in 'd:\vcl\thtml9\Package\URLSubs.pas';
*)

{$R *.RES}
{$R WHPOWER.RES}   // icon for WebHub Power HTML Application Server.
{$R HTICONS.RES}   // component icons for combo bar (not essential)
{$R HTGLYPHS.RES}  // icons for WebHub UI features

begin
  {M}Application.Initialize;
  CreateCoreWebHubDataModule;

  pWebApp.AppID := DefaultsTo(LowerCase(ParamString('ID')), 'appvers');
  pWebApp.Refresh;

  {M}Application.CreateForm(TDemoExtensions, DemoExtensions);
  Application.CreateForm(TfmAppIn, fmAppIn);
  InitCoreWebHubDataModule;
  DemoExtensions.Init;

  {M}Application.CreateForm(TfmWebHubPowerMainForm, fmWebHubPowerMainForm);
  {M}Application.CreateForm(TfmAppsetups, fmAppsetups);
  {M}Application.CreateForm(TfmAppHTML, fmAppHTML);
  {M}Application.CreateForm(TfmAppAboutPanel, fmAppAboutPanel);
  {M}Application.CreateForm(TfmAppOut, fmAppOut);
  InitCoreWebHubDataModuleGUI;

  {M}Application.Run;
end.

