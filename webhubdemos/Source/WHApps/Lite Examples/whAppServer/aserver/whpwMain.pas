unit whpwMain;

////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995-2007 HREF Tools Corp.  All Rights Reserved Worldwide.  //
//                                                                            //
//  This source code file is part of WebHub v2.1x.  Please obtain a WebHub    //
//  development license from HREF Tools Corp. before using this file, and     //
//  refer friends and colleagues to href.com/webhub for downloading. Thanks!  //
////////////////////////////////////////////////////////////////////////////////

// Project search path needs to include WebHub lib\ for *.res and other files.

(* This form was copied from lib\whMain.pas, and then the menu
   was customized.  Added lines are marked with "whpwmain" in the comments.
   "whpwmain" stands for "WebHub Power HTML Main Form".
  In WebHub 1.x, WebHub Power HTML was a product including AServer.exe. *)


interface

{$I hrefdefines.inc}
{$I WebHub_Comms.inc}

uses
{$IFDEF CLR}
  WinUtils,
{$ENDIF}
{$IFNDEF LINUX}
  Windows, Messages,
{$ENDIF}
  SysUtils, Classes,
{$IFDEF LINUX}
  QGraphics, QControls, QForms, QDialogs, QMenus, QComCtrls, QExtCtrls,
  QStdActns, QActnList,
{$ELSE}
  Graphics, Controls, Forms, Dialogs, Menus, ComCtrls, ExtCtrls,
  {$I xe_actnlist.inc}
  StdActns, 
{$ENDIF}
  toolbar, utTrayFm, utMainFm, restorer, restEdit, gridRest, 
  updateOK{non-gui}, updateOKGUI,
  tpAction{non-gui}, tpActionGUI, tpStatus, comboBar, 
  tpApplic{non-gui}, tpApplicGUI, tpPopup, tpSysPop,
  tpTrayIc, ZaphodsMap, whdemo_Extensions, tpCompPanel;

type
  TfmWebHubPowerMainForm = class(TfmTrayForm)
    sysmiSuspend: TMenuItem;
    sysmiUseWebHub: TMenuItem;
    sysmiRefresh: TMenuItem;
    ActionListStd: TActionList;
    FileExit1: TFileExit;
    HelpContents1: THelpContents;
    HelpTopicSearch1: THelpTopicSearch;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New2: TMenuItem;
    Open2: TMenuItem;
    Exit1: TMenuItem;
    AppID2: TMenuItem;
    Properties6: TMenuItem;
    PickAppID2: TMenuItem;
    Components2: TMenuItem;
    WebInfo2: TMenuItem;
    WebCommandLine2: TMenuItem;
    WebCycle2: TMenuItem;
    WebLogin2: TMenuItem;
    ListWebActions1: TMenuItem;
    View1: TMenuItem;
    Toolbar1: TMenuItem;
    Statusbar1: TMenuItem;
    Help1: TMenuItem;
    Contents1: TMenuItem;
    opicSearch1: TMenuItem;
    About1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    WebInfoRefresh1: TMenuItem;
    htWebAppRefresh1: TMenuItem;
    WebCycleRefresh1: TMenuItem;
    Properties1: TMenuItem;
    EditUserList1: TMenuItem;
    Refresh1: TMenuItem;
    EditItems1: TMenuItem;
    actHelpAbout: TAction;
    actComponentsListAll: TAction;
    Properties2: TMenuItem;
    WebCommandLineProperties1: TMenuItem;
    WebInfoProperties1: TMenuItem;
    UseWebHubCentral1: TMenuItem;
    htWebAppEditINIFile1: TMenuItem;
    actToolbarNone: TAction;
    actToolbarVerbmode: TAction;
    actViewStatusbar: TAction;
    htWebAppEditAppSettings1: TMenuItem;
    htWebAppExportPages1: TMenuItem;
    htWebAppViewErrors1: TMenuItem;
    htWebAppViewUploadedFiles1: TMenuItem;
    htWebAppEditMediaServers1: TMenuItem;
    htWebAppEditFiles1: TMenuItem;
    htWebAppEditMacros1: TMenuItem;
    htWebAppEditEvents1: TMenuItem;
    ShowTools1: TMenuItem;
    ShowComponentVerbs1: TMenuItem;
    actToolbarToolmode: TAction;
    N4: TMenuItem;
    miConnectionActive: TMenuItem;
    CentralInfoEditCentralConfigFile1: TMenuItem;
    CentralInfoEditNetworkInfoFile1: TMenuItem;
    CentralInfoEditLicenseFile1: TMenuItem;
    CentralInfoEditSystemMessagesFile1: TMenuItem;
    N5: TMenuItem;
    CentralInfoViewHTTPServers1: TMenuItem;
    CentralInfoViewRunners1: TMenuItem;
    CentralInfoViewServerProfiles1: TMenuItem;
    CentralInfoNewAppID1: TMenuItem;
    N6: TMenuItem;
    miAppUnCoverApp1: TMenuItem;               // --------------------------------------
    procedure TrayIconClick(Sender: TObject);
    procedure TrayIconMouseDown(Sender: TObject);
    procedure sysmiSuspendClick(Sender: TObject);
    procedure TrayToggleFormClick(Sender: TObject);
    procedure FormTrayFormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sysmiRefreshClick(Sender: TObject);
    procedure sysmiUseWebHubClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
                                                          // -------------------
    procedure New1Click(Sender: TObject);                 //
    procedure Open1Click(Sender: TObject);                // These procedures
                                                          // were added to
                                                          // whpwmain.pas
                                                          // relative to
                                                          // whmain.pas.
                                                          //
                                                          //
                                                          //
    procedure actComponentsListAllExecute(Sender: TObject);
    procedure actToolbarNoneExecute(Sender: TObject);
    procedure actToolbarVerbmodeExecute(Sender: TObject);
    procedure actViewStatusbarExecute(Sender: TObject);
    procedure actToolbarToolmodeExecute(Sender: TObject);
    procedure miConnectionActiveClick(Sender: TObject);   //
                                                          // -------------------
  private
    { Private declarations }
    fClicked: Boolean; //helper var for tray-icon left-click message.
    fIconPing,
    fIconBusy,
    fIconStopped,
    fIconRestored: TIcon;
    fProcessId: String;
    procedure UpdateTrayIcon;
    procedure WebCommandLineExecute(Sender: TObject);
    procedure WebCommandLineAfterExecute(Sender: TObject);
    procedure WebCommandLineSuspendResume(Sender: TObject);
    function ConnectionStatus(const FlagMakeActive: Boolean): Boolean;
  protected
    procedure Loaded; Override;
    procedure MenuItemSuspense(const NewSuspendedState: Boolean;
      miInTray: TMenuItem);
  public
    { Public declarations }
    function Init: Boolean; override;
    end;

var
  fmWebHubPowerMainForm: TfmWebHubPowerMainForm;

implementation

{$R *.DFM}

uses
  uCode,
  ucString,
  whsample_EvtHandlers,
  WebCall,
  WebSplat,
  webinfou, webapp, ucDlgs, webcycle, weblogin,
  whutil_ZaphodsMap, fmsetups;

//----------------------------------------------------------------------

procedure TfmWebHubPowerMainForm.FormCreate(Sender: TObject);
begin
  inherited;
  // This NoMenu parameter is required when running approximately ten or
  // more webapps on NT 4 because NT runs out of resource space for the menus.
  // This is implemented as a command line option so that generally you will
  // get the menu but you can easily change things for deployment.
  if assigned(MainMenu1)
  and HaveParam('/NoMenu') then
    FreeAndNil(MainMenu1);
  //
  //initialize the 'state-icons'.
  //if you get an exception, add {$R WHAPPICO.RES} to the project's dpr.
  fIconPing:= TIcon.Create;
  fIconPing.Handle:= LoadIcon(MainInstance, 'PING');
  fIconBusy:= TIcon.Create;
  fIconBusy.Handle:= LoadIcon(MainInstance, 'BUSY');
  fIconStopped:= TIcon.Create;
  fIconStopped.Handle:= LoadIcon(MainInstance, 'STOPPED');
  fIconRestored:= TIcon.Create;
  fIconRestored.Handle:= LoadIcon(MainInstance, 'RESTORED');
  fProcessId:= inttostr(GetCurrentProcessId);
end;

//----------------------------------------------------------------------

const
  HREFWebHubBranch = {$I HREFToolsZMConfigVersion.inc};

procedure TfmWebHubPowerMainForm.Loaded;
begin
{$IFNDEF NOTRAYICON}
  TrayIco:='A_MAINICON';
  FormIco:='A_MAINICON';
{$ENDIF}
  if Assigned(Restorer) then
  begin
    {Set the Branch and KeyGroupName just in case a WebHub programmer has
     accidentally changed whMain.dfm. We use these settings so that all
     WebHub apps that use whMain will share the same restorer file.}
    Restorer.ZaphodBranch := HREFWebHubBranch;
    Restorer.ZaphodKeyGroupName := 'WebHub';
  end;
  Inherited Loaded;
end;

//----------------------------------------------------------------------

function TfmWebHubPowerMainForm.Init:Boolean;
begin
  Result:=inherited Init;
  if not Result then
    exit;
  {$IFNDEF WEBHUBACE}
  {Here we tap into the TwhConnection component
   so that we can adjust the icon used by the application to indicate
   the active/not-active state.}
  AddConnectionExecuteHandler(WebCommandLineExecute);
  AddConnectionAfterExecuteHandler(WebCommandLineAfterExecute);
  AddConnectionResumeHandler(WebCommandLineSuspendResume);
  AddConnectionSuspendHandler(WebCommandLineSuspendResume);
  if Assigned(pConnection) then
    MenuItemSuspense(NOT pConnection.Active, nil);
  {$ENDIF}
end;

//----------------------------------------------------------------------

procedure TfmWebHubPowerMainForm.FormTrayFormClose(Sender:TObject; var Action:TCloseAction);
begin
  inherited;
end;

function TfmWebHubPowerMainForm.ConnectionStatus(
  const FlagMakeActive: Boolean): Boolean;
begin
  if FlagMakeActive then
  begin
    {becoming active}
    if not pConnection.Active then
      pConnection.Active := True;
  end
  else
  begin
    {becoming suspended}
    if pConnection.Active then
      pConnection.Active := False;
  end;

  Application.ProcessMessages;
  Result := pConnection.Active;
end;

//----------------------------------------------------------------------
//manage displaying the proper icons

procedure TfmWebHubPowerMainForm.WebCommandLineExecute(Sender: TObject);
var
  i:integer;
begin
  with pConnection,TrayIcon do begin
    //changing the tooltip may not be so very swift..
    // .. consider commenting out this line in high volume apps where
    // the time between pages served is <100ms.
    ToolTip:=
      AddToString(
      AddToString(
      AddToString(pWebApp.AppID
        ,pWebApp.PageID,':')
        ,pWebApp.SessionID,':')
        ,Command,':')
      +' '+IntToStr(Application.Handle)
      +' '+pWebApp.AppProcessId;
    //
    //we use low session numbers like these to check our apps robotically
    //and suspect that you do the same. so, here we make a distinction
    //between external and robotic session based on the session number
    //alone. you probably want to beef up this logic to recognize IP#s
    //as well and use pWebApp.RejectSession from pWebApp.OnNewSession to
    //reject manually generated numbers if they do not originate on your
    //subnet..
    i:=strtointdef(pWebApp.SessionID,0);
    if (i>=1000) and (i<=1010) then
      Icon:=fIconPing
    else
      Icon:=fIconBusy;
    end;
end;

procedure TfmWebHubPowerMainForm.UpdateTrayIcon;
begin
  //swap in the 'restored' or application main icon
  //depending on whether this instance is on-screen
  if assigned(pConnection)
  and assigned(TrayIcon) then
  with TrayIcon, pConnection do
    if Active and ConnectToHub then
      if IsFormShown then
        Icon := fIconRestored
      else
        Icon := Application.Icon
    else
      Icon := fIconStopped;
end;

procedure TfmWebHubPowerMainForm.WebCommandLineAfterExecute(Sender: TObject);
begin
  UpdateTrayIcon;
end;

procedure TfmWebHubPowerMainForm.TrayToggleFormClick(Sender: TObject);
begin
  inherited;
  fClicked:=false;
  WebMsgFlags:=WebMsgFlags-[splSplashing];
  UpdateTrayIcon;
end;

//----------------------------------------------------------------------
// suspend and reactivate the app without removing it from the connected panel

procedure TfmWebHubPowerMainForm.sysmiRefreshClick(Sender: TObject);
begin
  inherited;
  if assigned(pWebApp) then
  begin
    pWebApp.CentralInfo.Refresh;
    pWebApp.Refresh;
  end
  else
  begin
    if BestCentralInfo <> nil then
      BestCentralInfo.Refresh;
  end;
end;

procedure TfmWebHubPowerMainForm.MenuItemSuspense(
  const NewSuspendedState: Boolean; miInTray: TMenuItem);
begin
  SysMiSuspend.Checked := NewSuspendedState;
  if Assigned(miInTray) then
    miInTray.Checked := NewSuspendedState;
  miConnectionActive.Checked := NOT NewSuspendedState;
  SystemPopUp.SynchronizeMenus;                     //update system menu
  UpdateTrayIcon;
end;

procedure TfmWebHubPowerMainForm.sysmiSuspendClick(Sender: TObject);
var
  NewSuspendedState: Boolean;
begin
  inherited;
  if Assigned(pConnection) then
  begin
    NewSuspendedState := NOT
      ConnectionStatus(SysMiSuspend.Checked);
    // TMenuItem(Sender) is a live copy made by the tray icon
    MenuItemSuspense(NewSuspendedState, TMenuItem(Sender));
  end
  else
    MsgErrorOk('Connection is nil.  Feature is not applicable.');
end;

procedure TfmWebHubPowerMainForm.miConnectionActiveClick(Sender: TObject);
var
  NewSuspendedState: Boolean;
begin
  inherited;
  NewSuspendedState := NOT
    ConnectionStatus(NOT pConnection.Active);
  MenuItemSuspense(NewSuspendedState, nil);
end;

procedure TfmWebHubPowerMainForm.sysmiUseWebHubClick(Sender: TObject);
begin
  inherited;
  if Assigned(pWebApp) and Assigned(pConnection) then
  begin
    // toggle the original
    with SysMiUseWebHub do
      Checked := not Checked;
    // live copy made by tray icon
    TMenuItem(Sender).Checked := SysMiUseWebHub.Checked;
    SystemPopUp.SynchronizeMenus; // update system menu
    if Assigned(pWebApp) then
    begin
      pWebApp.ConnectToHub := SysMiUseWebHub.Checked; // act on it.
      pWebApp.Refresh;
    end;
  end
  else
    MsgErrorOk('App and/or Connection is nil.  Feature is not applicable.');
end;

procedure TfmWebHubPowerMainForm.WebCommandLineSuspendResume(Sender: TObject);
begin
  if Assigned(pConnection) then
    MenuItemSuspense(NOT pConnection.Active, nil);
end;

//----------------------------------------------------------------------
// TWO examples of how to react to a single left-click on the tray-icon

(*
// #1
// give a message when you click (and hold) the tray icon
// if you're double-clicking, the message will flash just briefly.

procedure TfmMainForm1.TrayIconMouseDown(Sender: TObject);
var
  a1: String;
begin
  inherited;
  a1:=Caption; //+' '+inttostr(Application.Handle);
  if not WebCommandLine.Active then
    a1:=a1+' (suspended)';
  WebMessage('!'+a1); //splash mode msg. deactivate closes window
end;

procedure TfmMainForm1.TrayIconClick(Sender: TObject);
begin
  inherited;
  WebMessage('0'); //close the message window
end;

*)

// #2
// give a message only on a single-click.
// close the window on first mouse-down.

procedure TfmWebHubPowerMainForm.TrayIconMouseDown(Sender: TObject);
begin
  inherited;
  WebMessage('0'); //close the message window
end;

procedure TfmWebHubPowerMainForm.TrayIconClick(Sender: TObject);
begin
  inherited;
  fClicked:=not fClicked;
  if fClicked then
    WebMessage('!'+Caption); //splash mode msg. deactivate closes window
end;

//----------------------------------------------------------------------

procedure TfmWebHubPowerMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
//  AskQuestionOk('FormTrayFormClose; ucwinapi.RunningAsService='+bOOLtOsTRING(ucwinapi.RunningAsService));
end;

//----------------------------------------------------------------------
// Implementation of the menu options that are unique to whpwmain.pas
//----------------------------------------------------------------------

procedure TfmWebHubPowerMainForm.New1Click(Sender: TObject);
begin
  inherited;
  with PageControl do
    ActivePage:=Pages[0];
  //
  fmAppsetups.actNewAppIDExecute(Sender);
end;

//------------------------------------------------------------------------------

procedure TfmWebHubPowerMainForm.Open1Click(Sender: TObject);
begin
  inherited;
  with PageControl do
    ActivePage:=Pages[0];
  //
  fmAppsetups.actOpenAppIDExecute(Sender);
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TfmWebHubPowerMainForm.actComponentsListAllExecute(Sender: TObject);
begin
  inherited;
  if pConnection.ConnectToHub then
    msgInfoOk(
      'Web Action Components in this Application Server:'+sLineBreak+sLineBreak+
      //
      'Standard - documented by class in the help file:'+sLineBreak+
      #9+'WebCycle   (TwhCycle class)'+sLineBreak+
      #9+'WebLogin   (TwhLogin class)'+sLineBreak+
      #9+'WebMailForm   (TwhMailForm class)'+sLineBreak+sLineBreak+
      //
      'Extra - for Demos:' + sLineBreak +
      #9+'waShowFile   (TwhWebActionEx class)'+sLineBreak+
      #9+'waViewSource   (TwhWebActionEx class)'+sLineBreak
      )
  else
    // probably the standalone editor version
  msgInfoOk(
    'Web Action Components - see the help file:'+sLineBreak+sLineBreak+
    //
    #9+'WebCycle   (TwhCycle class)'
    );
end;

procedure TfmWebHubPowerMainForm.actToolbarNoneExecute(Sender: TObject);
begin
  inherited;
  tpComboBar1.Visible := False;
end;

procedure TfmWebHubPowerMainForm.actToolbarVerbmodeExecute(Sender: TObject);
begin
  inherited;
  tpComboBar1.Visible := True;
  {should set the combobar into verbbar mode}
end;

procedure TfmWebHubPowerMainForm.actToolbarToolmodeExecute(Sender: TObject);
begin
  inherited;
  tpComboBar1.Visible := True;
  {should set the combobar into toolbar mode}
end;

procedure TfmWebHubPowerMainForm.actViewStatusbarExecute(Sender: TObject);
begin
  inherited;
  StatusBar.Visible := TMenuItem(Sender).Checked;
end;

end.

