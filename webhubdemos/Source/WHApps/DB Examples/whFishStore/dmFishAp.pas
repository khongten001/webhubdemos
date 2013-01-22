unit dmfishap; {example of using a custom app-object, instantiated at runtime}

(*
Copyright (c) 2009 HREF Tools Corp.

Permission is hereby granted, on 31-Dec-2009, free of charge, to any person
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
  Forms, Classes, 
  {$I xe_actnlist.inc}
  tpApplic{non-gui}, updateok, tpAction{no-gui}, tpActionGUI, 
  webBrows, whsample_EvtHandlers, cgivars, apistat, apibuilt, apicall, 
  webcall, cgiserv, webserv, htmlbase, htmlcore, htmlsend, weblink, 
  webTypes, webInfoU, webBase, webcore, webSend, webapp,
  htWebApp, htbdeWApp, webvars,
  tFish, webInfoBase;

procedure CreateCoreWebHubDataModule;
procedure DestroyCoreWebHubDataModuleGUI;
procedure InitCoreWebHubDataModule;
procedure InitCoreWebHubDataModuleGUI;

type
  TdmWebHubFishApp = class(TDataModule)
    tpActionListCentralInfo: TtpActionList;
    CentralInfo: TwhCentralInfo;
    tpActionListApp: TtpActionList;
    tpActionListConnection: TtpActionList;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FishApp: TFishApp;
    whSession0: TFishSession;
  public
    { Public declarations }
  end;

var
  dmWebHubFishApp: TdmWebHubFishApp;

implementation

{$R *.DFM}

uses
  SysUtils,
  ucDlgs,
  webSplat, whMain;

procedure TdmWebHubFishApp.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FishApp := TFishApp.Create(Self);
  FishApp.Name := 'app';
  FishApp.CentralInfo := CentralInfo;
  FishApp.AppID := 'htfs';  // HREF Tools Fish Store
  FishApp.Refresh;
  whSession0 := TFishSession(FishApp.Session);
end;

procedure TdmWebHubFishApp.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(whSession0);
  FreeAndNil(FishApp);
end;

procedure CreateCoreWebHubDataModule;
begin
  { The purpose of this procedure is to establish a standard way of creating
    the core webhub datamodule while still allowing developers to have a
    choice of TwhApplication or TwhbdeApplication or a custom-derived class. If you make
    a custom-derived class, put this same procedure, CreateCoreWebHubDataModule,
    into your datamodule, and adjust the parameters on the next line. }
  Application.CreateForm(TwhdmCommonEventHandlers, whdmCommonEventHandlers);
  Application.CreateForm(TdmWebHubFishApp, dmWebHubFishApp);
end;

procedure DestroyCoreWebHubDataModuleGUI;
begin
  // placeholder; no action required
end;

procedure InitCoreWebHubDataModule;
begin
  { This is another standard procedure. }
  if pWebApp.GUI = nil then
    MsgErrorOk('Inconceivable!?!');
  whdmCommonEventHandlers.Init;
end;

procedure InitCoreWebHubDataModuleGUI;
begin
  fmWebHubMainForm.Init;

  whdmCommonEventHandlers.InitMenuActionsForApp(
    dmWebHubFishApp.tpActionListApp);
  whdmCommonEventHandlers.InitMenuActionsForCentralInfo(
    dmWebHubFishApp.tpActionListCentralInfo);
  whdmCommonEventHandlers.InitMenuActionsForConnection(
    dmWebHubFishApp.tpActionListConnection);
  WebMessage(''); // clear WebHub splash screen
end;

end.
