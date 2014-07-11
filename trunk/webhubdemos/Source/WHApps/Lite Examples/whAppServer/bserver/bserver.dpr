program bserver;  // A Generic WebHub Application Server
                  // for use with WH DEMOS, with Dreamweaver
                  // with whsample_DWSecurity rules (not demo security rules)
                  // with whsample_GoogleSitemap feature

(*
Copyright (c) 2004-2007 HREF Tools Corp.

Permission is hereby granted, on 09-Nov-2004, free of charge, to any person
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

// Usage: bserver.exe /ID:AppID [/NoMenu]

uses
  Forms,
  whcfg_App,
  webapp,
  ucString,
  uCode,
  updateOk,
  htWebApp in 'h:\htWebApp.pas',
  utpanfrm in 'h:\utPanFrm.pas' {utParentForm},
  utmainfm in 'h:\utMainFm.pas' {fmMainForm},
  uttrayfm in 'h:\utTrayFm.pas' {fmTrayForm},
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  whdemo_About in '..\..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_CodeSite in '..\..\..\Common\whdemo_CodeSite.pas',
  whdemo_Extensions in '..\..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_Refresh in '..\..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whdw_RemotePages in 'h:\whdw_RemotePages.pas' {DataModuleDreamWeaver: TDataModuleDreamWeaver},
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver: TfmWhDreamweaver},
  fmsetups in '..\aserver\fmsetups.pas' {fmAppsetups},
  whsample_DWSecurity in 'h:\whsample_DWSecurity.pas' {dmDWSecurity: TDataModule},
  whsample_GoogleSitemap in 'h:\whsample_GoogleSitemap.pas' {fmwhGoogleSitemap},
  whAppIn in 'h:\whAppIn.pas' {fmAppIn},
  whAppOut in 'h:\whAppOut.pas' {fmAppOut},
  whHTML in 'h:\whhtml.pas' {fmAppHTML},
  whMail in 'h:\whMail.pas' {DataModuleWhMail: TDataModule},
  whpanel_Mail in 'h:\whpanel_Mail.pas' {fmWebMail},
  whMain in 'h:\whMain.pas' {fmWebHubMainForm},
  dmWHApp in 'h:\dmWHApp.pas' {dmWebHubApp: TDataModule};

{$R *.RES}
{$R WHDICON.RES}   // WebHub/Dreamweaver tray icon
{$R HTICONS.RES}   // component icons for combo bar (not essential)
{$R HTGLYPHS.RES}  // icons for WebHub UI features

begin

  Application.Initialize;

  Application.CreateForm(TfmWebHubMainForm, fmWebHubMainForm);
  CreateCoreWebHubDataModule;

  pWebApp.AppID := DefaultsTo(ParamString('ID'), 'appvers');
  pWebApp.Refresh;

  Application.CreateForm(TfmAppsetups, fmAppsetups);
  Application.CreateForm(TfmAppAboutPanel, fmAppAboutPanel);
  Application.CreateForm(TfmAppHTML, fmAppHTML);
  Application.CreateForm(TfmAppIn, fmAppIn);
  Application.CreateForm(TfmAppOut, fmAppOut);
  Application.CreateForm(TDemoExtensions, DemoExtensions);
  Application.CreateForm(TdmWhRefresh, dmWhRefresh);
  Application.CreateForm(TDataModuleDreamWeaver, DataModuleDreamWeaver);
  Application.CreateForm(TfmWhDreamweaver, fmWhDreamweaver);
  Application.CreateForm(TdmDWSecurity, dmDWSecurity);
  Application.CreateForm(TDataModuleWhMail, DataModuleWhMail);
  Application.CreateForm(TfmWebMail, fmWebMail);
  Application.CreateForm(TfmwhGoogleSitemap, fmwhGoogleSitemap);

  InitCoreWebHubDataModule;
  DataModuleDreamWeaver.Init;
  DataModuleWhMail.Init;
  fmWhDreamweaver.Init;
  dmDWSecurity.Init;

  pWebApp.Refresh;

  Application.Run;
end.

