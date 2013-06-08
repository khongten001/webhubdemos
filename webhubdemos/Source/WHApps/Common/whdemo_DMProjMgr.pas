unit whdemo_DMProjMgr;  { initialization shared by all webhub demos }

(*
Copyright (c) 2004-2013 HREF Tools Corp.

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
{$I WebHub_Comms.inc}

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
      var ErrorText: String; var Continue: Boolean);
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
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  Forms,
  MultiTypeApp,
  {$IFNDEF PREVENTGUI}ucDlgs,{$ENDIF}
  ucCodeSiteInterface,
  ucLogFil, webApp, webBase, webSplat, dmWHApp, htWebApp, webCall,
  whutil_ZaphodsMap,
  whdemo_Extensions, whdemo_Initialize, whdemo_ViewSource, whMain, whConst,
  whsample_PrototypeJS, 
  whpanel_RemotePages, whpanel_Mail, uAutoPanels;

{ TDMForWHDemo }

procedure TDMForWHDemo.SetDemoFacts(const DemoAppID, SourceSubdir: string;
  const IsRelativePath: Boolean);
begin
  ProjMgr.Identifier := DemoAppID;
  FSourceSubDir := SourceSubDir;
  FIsRelativePath := IsRelativePath;
end;

procedure TDMForWHDemo.ProjMgrDataModulesCreate1(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
const cFn = 'ProjMgrDataModulesCreate1';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  try
    CreateCoreWebHubDataModule;
  except
    on E: Exception do
    begin
      LogSendException(E);
      Continue := False;
      ErrorText := E.Message;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMForWHDemo.ProjMgrDataModulesCreate2(
  Sender: TtpProject; const SuggestedAppID: String; var ErrorText: String;
  var Continue: Boolean);
const cFn = 'Create2';
var
  UsedAppID: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}

  try
    if (Sender.Identifier <> '') and (Sender.Identifier <> 'appvers') and
       (Sender.Identifier <> 'bw') and (SuggestedAppID <> '') then
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

    {$IFDEF CodeSite}CodeSite.Send('UsedAppID', UsedAppID);{$ENDIF}

    whDemoSetAppId(UsedAppID);  // this refreshes the app
    whDemoCreateSharedDataModules;
  except
    on E: Exception do
    begin
      {$IFDEF CodeSite}CodeSite.SendException(E);{$ENDIF}
      Continue := False;
      ErrorText := E.Message;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMForWHDemo.ProjMgrDataModulesCreate3(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
//
end;

procedure TDMForWHDemo.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  InitCoreWebHubDataModule;
  whDemoInit;
  whDemoSetDelphiSourceLocation(FSourceSubDir, FIsRelativePath);
end;

procedure TDMForWHDemo.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
const 
  cFn = 'ProjMgrGUICreate';
var
  SplashMessage: string;
begin
  ErrorText := '';
  if ShouldEnableGUI then
  begin
    SplashMessage := 'Creating panels';
    WebMessage(SplashMessage);

    try
      {M}Application.CreateForm(TfmWebHubMainForm, fmWebHubMainForm);
      fmWebHubMainForm.Caption := pWebApp.AppID;

      whDemoCreateSharedPanels;

      WebMessage('-' + SplashMessage);
    except
      on E: Exception do
       begin
          ErrorText := cFn + Chr(183) + E.Message;
          Continue := False;
       end;
    end;
  end;
end;

procedure TDMForWHDemo.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
const
  cFn = 'ProjMgrGUIInit';
begin
  Assert(Assigned(pWebApp));
  Assert(pWebApp.IsUpdated);

  if ShouldEnableGUI then
  begin
    try
      pWebApp.DoUpdateGUI;

     // fmWebHubMainForm.Restorer.Flags := [];  // can disable Restorer here

      InitCoreWebHubDataModuleGUI;
      InitStandardWHModulesGUI;

      WebMessage('0');   
    except
      on E: Exception do
       begin
          ErrorText := cFn + Chr(183) + E.Message;
          Continue := False;
       end;
    end;
  end;

end;

procedure TDMForWHDemo.ProjMgrStartupComplete(Sender: TtpProject);
{$IFDEF CodeSite}const cFn = 'ProjMgrStartupComplete';{$ENDIF}
begin
  { override anything else that was in v3.189- and use these handlers }
  pWebApp.Security.CheckSurferIP := True;
  pWebApp.Security.CheckUserAgent := True;
  pWebApp.OnBadIP := DemoExtensions.DemoAppBadIP;
  pWebApp.OnBadBrowser := DemoExtensions.DemoAppBadBrowser;
  UncoverAppOnStartup(pWebApp.AppID);
  {$IFDEF WEBHUBACE}
  pConnection.MarkReadyToWork;
  {$ENDIF}
end;

procedure TDMForWHDemo.ProjMgrStartupError(Sender: TtpProject;
  const ErrorText: String);
begin
  LogSendError(ErrorText, 'during demo startup');
  WebMessage(ErrorText);
end;

procedure TDMForWHDemo.ProjMgrStop(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  try
    FreeAndNil(fmWebHubMainForm);
    DestroyCoreWebHubDataModuleGUI;
    whDemoDestroySharedDataModules;
  except
    on E: Exception do
    begin
      {$IFDEF CodeSite}CodeSite.SendException(E);{$ENDIF}
    end;
  end;
end;

initialization
  {$IFDEF CodeSite}CodeSite.Send('hello');{$ENDIF}

end.
