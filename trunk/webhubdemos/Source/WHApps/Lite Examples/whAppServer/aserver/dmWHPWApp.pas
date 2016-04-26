unit dmWHPWApp;
(*
Copyright (c) 1997 HREF Tools Corp.

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

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Vcl.ActnList, System.Actions,
  ExtCtrls,
  whgui_Menu, WebBase, WebCore, WebSend, WebApp, htWebApp, WebTypes,
  WebVars, tpApplic{non-gui}, 
  WebCall, CGiServ, WebServ, HtmlBase, HtmlCore,
  htmlSend, webLink, UpdateOk, tpAction{no-gui}, tpActionGUI, WebInfoU,
  webInfoBase;

procedure CreateCoreWebHubDataModule;
procedure InitCoreWebHubDataModule;
procedure InitCoreWebHubDataModuleGUI;

type
  TdmWebHubPowerApp = class(TDataModule)
    tpActionListApp: TtpActionList;
    actWebCommandLineProperties: TAction;
    app: TwhApplication;
    CentralInfo: TwhCentralInfo;
    tpActionListCentralInfo: TtpActionList;
    Action1: TAction;
    tpActionListConnection: TtpActionList;
    Action2: TAction;
    procedure actWebCommandLinePropertiesExecute(Sender: TObject);
    procedure appNewSession(Sender: TObject; Session: Cardinal;
      const Command: String);
  private
  public
    { Public declarations }
  end;

var
  dmWebHubPowerApp: TdmWebHubPowerApp;

implementation

{$R *.DFM}


uses
  Menus,
  webSplat,
  ucPos, ucWinAPI, 
  whpwMain;

//------------------------------------------------------------------------------

procedure CreateCoreWebHubDataModule;
begin
  { The purpose of this procedure is to establish a standard way of creating
    the core webhub datamodule while still allowing developers to have a
    choice of TwhApplication or TwhbdeApplication or a custom-derived class. If you make
    a custom-derived class, put this same procedure, CreateCoreWebHubDataModule,
    into your datamodule, and adjust the parameters on the next line. }
  Application.CreateForm(TwhdmCommonMenu,whdmCommonMenu);
  Application.CreateForm(TdmWebHubPowerApp,dmWebHubPowerApp);
end;


procedure InitCoreWebHubDataModule;
begin
  { ditto }

  whdmCommonMenu.Init;
end;

procedure InitCoreWebHubDataModuleGUI;
begin
  { ditto }

  fmWebHubPowerMainForm.Init;

  whdmCommonMenu.InitMenuActionsForApp(
    dmWebHubPowerApp.tpActionListApp);
  whdmCommonMenu.InitMenuActionsForCentralInfo(
    dmWebHubPowerApp.tpActionListCentralInfo);

  pWebApp.Refresh;
  WebMessage('');
end;

//------------------------------------------------------------------------------

procedure TdmWebHubPowerApp.actWebCommandLinePropertiesExecute(
  Sender: TObject);
begin
  inherited;
  if Assigned(pConnection) then
    pConnection.ExecuteVerbByName('Properties');
end;

procedure TdmWebHubPowerApp.appNewSession(Sender: TObject;
  Session: Cardinal; const Command: String);
begin
  (* example for testing the bounce of a newly arrived surfer to a different page
  if (Session mod 3) = 0 then
  begin
    pWebApp.Response.SendBounceToPage('pgBounceTestA2', '');
  end;*)
end;

end.

