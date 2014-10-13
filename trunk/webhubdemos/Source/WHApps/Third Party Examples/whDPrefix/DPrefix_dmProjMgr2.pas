unit DPrefix_DMProjMgr;

(*
Copyright (c) 2008-2014 HREF Tools Corp.

Permission is hereby granted, on 09-Aug-2008, free of charge, to any person
obtaining a copy of this file (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*)

{$I hrefdefines.inc}
{$I WebHub_Comms.inc}

interface

uses
  SysUtils, Classes,
  tpProj;

type
  TDMDPrefixProjMgr = class(TDataModule)
    ProjMgr: TtpProject;
    procedure ProjMgrBeforeFirstCreate(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesCreate1(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesCreate2(Sender: TtpProject;
      const SuggestedAppID: String; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrGUIInit(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrStartupError(Sender: TtpProject;
      const ErrorText: String);
    procedure ProjMgrStartupComplete(Sender: TtpProject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMDPrefixProjMgr: TDMDPrefixProjMgr;

implementation

{$R *.dfm}

uses
  MultiTypeApp,
  ucLogFil, ucCodeSiteInterface,
  {$IFNDEF PREVENTGUI}ucDlgs, uAutoPanels, whMain,{$ENDIF}
  dmWHApp, whAppOut,
  DPrefix_dmNexus, DPrefix_dmWhActions, DPrefix_dmWhNexus,
  Unit1,
  webApp, webCall, whcfg_App, webBase, webSplat, whSharedLog, uAutoDataModules,
  whutil_ZaphodsMap, htWebApp,
  whdemo_About, whdemo_Extensions,
  DPrefix_fmWhActions, whgui_Menu, whOpenID_dmwhAction;

procedure TDMDPrefixProjMgr.ProjMgrBeforeFirstCreate(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
  { This event handler (BeforeFirstCreate) is reserved for logging, for example,
    to report that the application is has started.

    It is ok to ignore or delete this event handler.}
end;

procedure TDMDPrefixProjMgr.ProjMgrDataModulesCreate1(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
  CreateCoreWebHubDataModule;
  {$IFDEF CodeSite}
  UseWebHubSharedLog;
  {$ENDIF}
end;

procedure TDMDPrefixProjMgr.ProjMgrDataModulesCreate2(
  Sender: TtpProject; const SuggestedAppID: String; var ErrorText: String;
  var Continue: Boolean);
begin
  { This event handler, DataModulesCreate2, is reserved for setting the WebHub
    AppID and refreshing the application object. }
  pWebApp.AppID := SuggestedAppID;  // e.g. from /id=adv on command line
  pWebApp.Refresh;
  {$IFDEF CodeSite}
  UseWebHubSharedLog;
  {$ENDIF}
end;

procedure TDMDPrefixProjMgr.ProjMgrDataModulesCreate3(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
  { This event handler, DataModulesCreate3, is reserved for the creation of
    non-visual datamodules which depend on the AppID having been set,
    such as standard WebHub modules (email, dreamweaver, etc.) and custom
    datamodules containing database access components. }

  with pWebApp do
  begin
    AppID := 'dpr';
    Refresh;
    Response.HttpMinorVersion := 1;
    Security.BuiltInPagesEnabled := False;
  end;

  CreateStandardWHModules;
  Application.CreateForm(TDMNexus, DMNexus);

  Application.CreateForm(TDMWHOpenIDviaJanrain, DMWHOpenIDviaJanrain);

  Application.CreateForm(TDMDPRWebAct, DMDPRWebAct);

  Application.CreateForm(TDemoExtensions, DemoExtensions);

  Application.CreateForm(TDMWHNexus, DMWHNexus);

  //if NOT (pWebApp.Startup.CustomModuleStatus('TDM001') = mstatusDisabled) then
    Application.CreateForm(TDM001, DM001);

  { Special Comment for DataModules - do not delete!

    This comment is used by the WebHub Wizard to position non-gui CreateForm
    statements for you, just above here. You may add your own CreateForm
    statements as well, either above or below this comment, as you wish. }
end;

procedure TDMDPrefixProjMgr.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  { This event handler, DataModulesInit, is reserved for calling the Init method
    on any datamodules which require one-time initialization. }
  InitCoreWebHubDataModule;
  InitStandardWHModules;
    Continue := DM001.Init(ErrorText);
  Continue := DMNexus.Init(ErrorText);
  if Continue then
    Continue := DMWHNexus.Init(ErrorText);
  if Continue then
    Continue := DMDPRWebAct.Init(ErrorText);
  if Continue then
    Continue := DMWHOpenIDviaJanrain.Init(ErrorText);
  if Continue then
    Continue := DemoExtensions.Init;
end;

procedure TDMDPrefixProjMgr.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
var
  SplashMessage: string;
begin
{$IFNDEF PREVENTGUI}
  if ShouldEnableGUI then
  begin
    SplashMessage := 'Creating Graphical User Interface';
    WebMessage(SplashMessage);
    // create the main form which will hold the WebHub panels (GUI)
    Application.CreateForm(TfmWebHubMainForm, fmWebHubMainForm); // MultiTypeApp
    // after the main form, create GUI modules
    Application.CreateForm(TfmAppAboutPanel, fmAppAboutPanel);
    CreateStandardWHModulesGUI;

    { Special Comment for Forms - do not delete!

      This comment is used by the WebHub Wizard to position GUI CreateForm
      statements for you, just above here. You may add your own CreateForm
      statements as well, either above or below this comment, as you wish.

      Example: Application.CreateForm(TfmMyWHPanel, fmMyPanel);
    }
  {M}Application.CreateForm(TfmWhActions, fmWhActions);
    WebMessage('-' + SplashMessage);
  end;
{$ENDIF}
end;

procedure TDMDPrefixProjMgr.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
{$IFNDEF PREVENTGUI}
  if ShouldEnableGUI then
  begin
    pWebApp.DoUpdateGUI;

    InitCoreWebHubDataModuleGUI;
    InitStandardWHModulesGUI;
  pWebApp.Response.OnClose := fmWhActions.WebAppOutputClose;
  pConnection.OnFrontDoorTriggered :=
    fmWhActions.WebCommandLineFrontDoorTriggered;

  fmAppOut.tbAppShowOut.Down := True;  // for w3 validation feature
    WebMessage('0');         // required to close splash screen
  end;
{$ENDIF}
end;

procedure TDMDPrefixProjMgr.ProjMgrStartupComplete(Sender: TtpProject);
begin
  UncoverAppOnStartup(pWebApp.AppID);
  pConnection.MarkReadyToWork; // v3.190+
end;

procedure TDMDPrefixProjMgr.ProjMgrStartupError(Sender: TtpProject;
  const ErrorText: String);
begin
  CSSendError('during startup: ' + ErrorText);
{$IFNDEF PREVENTGUI}
  MsgErrorOk(ErrorText);
{$ENDIF}
end;

end.

