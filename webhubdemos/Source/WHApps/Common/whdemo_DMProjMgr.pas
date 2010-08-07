unit whdemo_DMProjMgr;  { initialization shared by all webhub demos }

(*
Copyright (c) 2004-2010 HREF Tools Corp.

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
  Forms,
  MultiTypeApp,
  {$IFNDEF PREVENTGUI}ucDlgs,{$ENDIF}
  ucLogFil, webApp, webBase, webSplat, dmWHApp, htWebApp, webCall,
  whdemo_Extensions, whdemo_Initialize, whdemo_ViewSource, whMain,
  whsample_EvtHandlers, whpanel_RemotePages, whpanel_Mail, uAutoPanels;

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
begin
  {$IFNDEF UNICODE}
  // extra flag required in Delphi 7 for UTF-8 support 
  whConst.isDelphi7UTF8 := True;  
  {$ENDIF}
  CreateCoreWebHubDataModule;
end;

procedure TDMForWHDemo.ProjMgrDataModulesCreate2(
  Sender: TtpProject; const SuggestedAppID: String; var ErrorText: String;
  var Continue: Boolean);
var
  UsedAppID: string;
  S: string;
begin
  if (Sender.Identifier <> '') and (Sender.Identifier <> 'appvers') and
     (SuggestedAppID <> '') then
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

  whDemoSetAppId(UsedAppID);  // this refreshes the app

  //Cover again after refresh
  CoverApp(UsedAppID, 1, 'Loading WebHub Demo application', False, S);
  Sender.Item := S;

  whDemoCreateSharedDataModules;
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
var
  SplashMessage: string;
begin
  if ShouldEnableGUI then
  begin
    SplashMessage := 'Creating panels';
    WebMessage(SplashMessage);

    {M}Application.CreateForm(TfmWebHubMainForm, fmWebHubMainForm);
    fmWebHubMainForm.Caption := pWebApp.AppID;

    whDemoCreateSharedPanels;

    WebMessage('-' + SplashMessage);
  end;
end;

procedure TDMForWHDemo.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  Assert(Assigned(pWebApp));
  Assert(pWebApp.IsUpdated);

  if ShouldEnableGUI then
  begin
    pWebApp.DoUpdateGUI;

    fmWebHubMainForm.Restorer.Flags := [];  // !!! Restorer not fully functional, 26-Aug-2008

    InitCoreWebHubDataModuleGUI;
    InitStandardWHModulesGUI;

    WebMessage('0');         // required to close splash screen
  end;

end;

procedure TDMForWHDemo.ProjMgrStartupComplete(Sender: TtpProject);
begin
  UncoverApp(Sender.Item);
end;

procedure TDMForWHDemo.ProjMgrStartupError(Sender: TtpProject;
  const ErrorText: String);
begin
  HREFTestLog('error', 'during demo startup', ErrorText);
  WebMessage(ErrorText);
end;

procedure TDMForWHDemo.ProjMgrStop(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  try
    if Assigned(pConnection) then
      pConnection.Active := False;
    FreeAndNil(fmWebHubMainForm);
    DestroyCoreWebHubDataModuleGUI;
    whDemoDestroySharedDataModules;
  except
  end;
end;

end.
