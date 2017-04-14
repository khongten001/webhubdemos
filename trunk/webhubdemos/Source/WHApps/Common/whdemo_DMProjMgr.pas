unit whdemo_DMProjMgr;  { initialization shared by all webhub demos }

(*
Copyright (c) 2004-2017 HREF Tools Corp.

Permission is hereby granted, on 31-Mar-2010, free of charge, to any person
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

interface

{$I hrefdefines.inc}

uses
  SysUtils, Classes, tpProj;

type
  TDMForWHDemo = class(TDataModule)
    ProjMgr: TtpProject;
    procedure ProjMgrDataModulesCreate1(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesCreate2(Sender: TtpProject;
      const SuggestedAppID: String; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject;
      var ErrorText: String; var bContinue: Boolean);
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrGUIInit(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrStartupError(Sender: TtpProject;
      const ErrorText: String);
    procedure ProjMgrStop(Sender: TtpProject; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrStartupComplete(Sender: TtpProject);
    procedure ProjMgrBeforeFirstCreate(Sender: TtpProject;
      var ErrorText: string; var Continue: Boolean);
  private
    { Private declarations }
    FSourceSubDir: string;
    FIsRelativePath: Boolean;
  public
    { Public declarations }
    procedure SetDemoFacts(const DemoAppID, SourceSubdir: string;
      const IsRelativePath: Boolean);
  end;

var
  DMForWHDemo: TDMForWHDemo;

implementation

{$R *.dfm}

uses
  Forms,
  whBuildInfo,
  {$IF cWebHubVersion <= 3.268} // uses whBuildInfo (DCU not PAS)
  ucCodeSiteInterface, // compiles in v3.268
  {$ELSE}
  ZM_CodeSiteInterface,
  {$IFEND}
  MultiTypeApp,
  ucDlgs, whSharedLog,
  ucLogFil, webApp, webBase, webSplat, dmWHApp, htWebApp, webCall,
  whutil_ZaphodsMap, whdemo_CodeSite, whdemo_UIHelpers,
  whdemo_Extensions, whdemo_Initialize, whdemo_ViewSource, whMain, whConst,
  webAjax, whsample_PrototypeJS,  // for showcase demo
  whpanel_RemotePages, whpanel_Mail, uAutoPanels;

{ TDMForWHDemo }

procedure TDMForWHDemo.SetDemoFacts(const DemoAppID, SourceSubdir: string;
  const IsRelativePath: Boolean);
begin
  ProjMgr.Identifier := DemoAppID;
  FSourceSubDir := SourceSubDir;
  FIsRelativePath := IsRelativePath;
end;

procedure TDMForWHDemo.ProjMgrBeforeFirstCreate(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  SetCodeSiteLoggingState([]); // none initially
end;

procedure TDMForWHDemo.ProjMgrDataModulesCreate1(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
const cFn = 'ProjMgrDataModulesCreate1';
begin
  CSEnterMethod(Self, cFn);
  try
    CreateCoreWebHubDataModule;
  except
    on E: Exception do
    begin
      CSSendError(E.StackTrace);
      LogSendException(E);
      Continue := False;
      ErrorText := E.Message;
    end;
  end;
  CSExitMethod(Self, cFn);
end;

procedure TDMForWHDemo.ProjMgrDataModulesCreate2(
  Sender: TtpProject; const SuggestedAppID: String; var ErrorText: String;
  var Continue: Boolean);
const cFn = 'ProjMgrDataModulesCreate2';
var
  UsedAppID: string;
begin
  CSEnterMethod(Self, cFn);

  try
    if (Sender.Identifier <> '') and (Sender.Identifier <> 'appvers') and
       (Sender.Identifier <> 'adv') and (SuggestedAppID <> '') then
    begin
      {This "error" is here primarily to enable easy testing of setting Continue
       to False.}
      ErrorText := Format('Fixed AppID = %s. Do not override the AppID to %s',
        [Sender.Identifier, SuggestedAppID]);
      Continue := False;
    end;

    // the suggested appid is from the command line - we should let it take
    // precedence

    UsedAppID := SuggestedAppID;
    if UsedAppID = '' then
    begin
      UsedAppID := Sender.Identifier;
      if UsedAppID = '' then
        UsedAppID := 'appvers';
    end;

    CSSend('UsedAppID', UsedAppID);

    Continue := whDemoSetAppId(UsedAppID);  // this refreshes the app
    if Continue then
    begin
      ResetLogFileSpec;
      SetCodeSiteLoggingStateFromText(pWebApp.AppSetting['CodeSiteLogging']);
      whDemoCreateSharedDataModules;
    end
    else
    begin
      CSSendError('unable to set AppID');
      //Halt
      ;
    end;
  except
    on E: Exception do
    begin
      CSSendException(Self, cFn, E);
      Continue := False;
      ErrorText := E.Message;
    end;
  end;
  CSExitMethod(Self, cFn);
end;

procedure TDMForWHDemo.ProjMgrDataModulesCreate3(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
const cFn = 'ProjMgrDataModulesCreate3';
begin
  CSEnterMethod(Self, cFn);
  Application.CreateForm(TdmwhCodeSiteHelper, dmwhCodeSiteHelper);
  Application.CreateForm(TdmwhUIHelpers, dmwhUIHelpers);
  if pWebApp.AppID = 'showcase' then
    Application.CreateForm(TDMPrototypeJS, DMPrototypeJS);
  CSExitMethod(Self, cFn);
end;

procedure TDMForWHDemo.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var bContinue: Boolean);
const cFn = 'ProjMgrDataModulesInit';
begin
  CSEnterMethod(Self, cFn);
  InitCoreWebHubDataModule;
  whDemoInit;
  whDemoSetDelphiSourceLocation(FSourceSubDir, FIsRelativePath);
  bContinue := dmwhUIHelpers.Init(ErrorText);
  if bContinue then
    bContinue := dmwhCodeSiteHelper.Init(ErrorText);
  if bContinue then
  begin
    if Pos(pWebApp.AppID, ',showcase,htaj,') > 0 then
      bContinue := DMPrototypeJS.Init(ErrorText);   
  end;
  CSExitMethod(Self, cFn);
end;

procedure TDMForWHDemo.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
const
  cFn = 'ProjMgrGUICreate';
begin
  CSEnterMethod(Self, cFn);
  ErrorText := '';
  if ShouldEnableGUI then
  begin
    try
      {M}Application.CreateForm(TfmWebHubMainForm, fmWebHubMainForm);
      if Pos(pWebApp.ZMDefaultMapContext, ',DEMOS,DORIS,ultraann,') > 0
      then
      begin
        if Assigned(fmWebHubMainForm.Restorer) then
        begin
          { avoid Restorer feature on production server
            with multiple instances -- too much conflict on the
            WHAppRestorer.xml file during shutdown }
          CSSend(csmLevel5, 'Restorer.Forget on ZMContext', 
            pWebApp.ZMDefaultMapContext);
          fmWebHubMainForm.Restorer.Forget;  // cleanup pointers on nested panels
          FreeAndNil(fmWebHubMainForm.Restorer);
        end
        else
          CSSend('fmWebHubMainForm.Restorer already nil');
      end;

      fmWebHubMainForm.Caption := pWebApp.AppID;

      whDemoCreateSharedPanels;
    except
      on E: Exception do
       begin
         CSSendException(Self, cFn, E);
         ErrorText := cFn + Chr(183) + E.Message;
         Continue := False;
       end;
    end;
  end;
  CSExitMethod(Self, cFn);
end;

procedure TDMForWHDemo.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
const
  cFn = 'ProjMgrGUIInit';
begin
  CSEnterMethod(Self, cFn);
  Assert(Assigned(pWebApp));
  Assert(pWebApp.IsUpdated);
  CSSend('ShouldEnableGUI', S(ShouldEnableGUI));

  if ShouldEnableGUI then
  begin
    try
      pWebApp.DoUpdateGUI;

     // fmWebHubMainForm.Restorer.Flags := [];  // can disable Restorer here

      InitCoreWebHubDataModuleGUI;
      InitStandardWHModulesGUI;

    except
      on E: Exception do
       begin
          ErrorText := cFn + Chr(183) + E.Message;
          Continue := False;
       end;
    end;
  end;

  CSExitMethod(Self, cFn);
end;

procedure TDMForWHDemo.ProjMgrStartupComplete(Sender: TtpProject);
const cFn = 'ProjMgrStartupComplete';
begin
  CSEnterMethod(Self, cFn);
  { override anything else that was in v3.189- and use these handlers }
  pWebApp.Security.CheckUserAgent := True;
  pWebApp.OnBadBrowser := DemoExtensions.DemoAppBadBrowser;

  UncoverAppOnStartup(pWebApp.AppID);
  if Assigned(pConnection) then
    pConnection.MarkReadyToWork
  else
    CSSendError(cFn + ': pConnection nil');

  CSExitMethod(Self, cFn);
end;

procedure TDMForWHDemo.ProjMgrStartupError(Sender: TtpProject;
  const ErrorText: String);
begin
  LogSendError(ErrorText, 'during demo startup');
  WebMessage(ErrorText);
end;

procedure TDMForWHDemo.ProjMgrStop(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
const cFn = 'ProjMgrStop';
begin
  CSEnterMethod(Self, cFn);
  try
    FreeAndNil(fmWebHubMainForm);
    DestroyCoreWebHubDataModuleGUI;
    whDemoDestroySharedDataModules;   // or: if Assigned(pWebApp) then pWebApp.Free;
  except
    on E: Exception do
    begin
      CSSendException(Self, cFn, E);
    end;
  end;

  CSExitMethod(Self, cFn);
end;

initialization
  {$IFDEF Log2CSL}UseWebHubSharedLog;{$ENDIF}

end.

