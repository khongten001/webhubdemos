unit DPrefix_DMProjMgr;

(*
Copyright (c) 2008-2012 HREF Tools Corp.

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

interface

uses
  SysUtils, Classes,
  tpProj;

type
  TDMSampleForWHProject = class(TDataModule)
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMSampleForWHProject: TDMSampleForWHProject;

implementation

{$R *.dfm}

uses
  MultiTypeApp,
  ucLogFil,
  {$IFNDEF PREVENTGUI}ucDlgs, uAutoPanels, whMain,{$ENDIF}
  dmWHApp, whAppOut,
  DPrefix_dmNexus, DPrefix_dmWhActions,
  webApp, webCall, whcfg_App, webBase, webSplat, uAutoDataModules,
  DPrefix_fmWhActions, whsample_EvtHandlers;

procedure TDMSampleForWHProject.ProjMgrBeforeFirstCreate(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
  { This event handler (BeforeFirstCreate) is reserved for logging, for example,
    to report that the application is has started.

    It is ok to ignore or delete this event handler.}
end;

procedure TDMSampleForWHProject.ProjMgrDataModulesCreate1(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
  CreateCoreWebHubDataModule;
end;

procedure TDMSampleForWHProject.ProjMgrDataModulesCreate2(
  Sender: TtpProject; const SuggestedAppID: String; var ErrorText: String;
  var Continue: Boolean);
begin
  { This event handler, DataModulesCreate2, is reserved for setting the WebHub
    AppID and refreshing the application object. }
  pWebApp.AppID := SuggestedAppID;  // e.g. from /id=adv on command line
  pWebApp.Refresh;
end;

procedure TDMSampleForWHProject.ProjMgrDataModulesCreate3(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
  { This event handler, DataModulesCreate3, is reserved for the creation of
    non-visual datamodules which depend on the AppID having been set,
    such as standard WebHub modules (email, dreamweaver, etc.) and custom
    datamodules containing database access components. }

  with pWebApp do
  begin
    OnBadBrowser := whdmCommonEventHandlers.WebAppBadBrowser;
    AppID := 'dpr';
    Refresh;
    Response.HttpMinorVersion := 1;
    Security.CheckUserAgent := True;
    Security.CheckSurferIP := True;
    Security.BuiltInPagesEnabled := False;
  end;

  CreateStandardWHModules;
  //if NOT (pWebApp.Startup.CustomModuleStatus('TDM001') = mstatusDisabled) then
    Application.CreateForm(TDMNexus, DMNexus);

  //if NOT (pWebApp.Startup.CustomModuleStatus('TDM001') = mstatusDisabled) then
    Application.CreateForm(TDMDPRWebAct, DMDPRWebAct);

  { Special Comment for DataModules - do not delete!

    This comment is used by the WebHub Wizard to position non-gui CreateForm
    statements for you, just above here. You may add your own CreateForm
    statements as well, either above or below this comment, as you wish. }
end;

procedure TDMSampleForWHProject.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  { This event handler, DataModulesInit, is reserved for calling the Init method
    on any datamodules which require one-time initialization. }
  InitCoreWebHubDataModule;
  InitStandardWHModules;
  Continue := DMNexus.Init(ErrorText);
  if Continue then
    Continue := DMDPRWebAct.Init(ErrorText);
end;

procedure TDMSampleForWHProject.ProjMgrGUICreate(Sender: TtpProject;
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

procedure TDMSampleForWHProject.ProjMgrGUIInit(Sender: TtpProject;
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

procedure TDMSampleForWHProject.ProjMgrStartupError(Sender: TtpProject;
  const ErrorText: String);
begin
  HREFTestLog('error', 'during startup', ErrorText);
{$IFNDEF PREVENTGUI}
  MsgErrorOk(ErrorText);
{$ENDIF}
end;

end.

