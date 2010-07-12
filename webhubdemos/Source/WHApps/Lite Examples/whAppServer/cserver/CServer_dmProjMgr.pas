unit CServer_dmProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TDMForWHDemoC = class(TDMForWHDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: string;
      var Continue: Boolean);
    procedure ProjMgrStartupComplete(Sender: TtpProject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHDemoC: TDMForWHDemoC;

implementation

{$R *.dfm}

uses
  ucLogFil,
  webApp,
  cfmwhCustom;

procedure TDMForWHDemoC.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  if ShouldEnableGUI then
  begin
    // this is normal when starting as an app
    HREFTestLog('info', 'ShouldEnableGUI', 'True');
    Application.CreateForm(TfmAppCustomPanel, fmAppCustomPanel);
  end
  else
  begin
    // this is normal when starting it as a service
    // e.g. net start webhubsample1
    HREFTestLog('info', 'ShouldEnableGUI', 'False');
  end;
end;

procedure TDMForWHDemoC.ProjMgrStartupComplete(Sender: TtpProject);
begin
  inherited;
  HREFTestLog('ProjMgrStartupComplete', 'my appid is', pWebApp.AppID);
  if NOT pWebApp.IsUpdated then
    HREFTestLog('info', 'refreshed', BoolToStr(pWebApp.IsUpdated, True));
  if NOT pWebApp.ConnectToHub then
    HREFTestLog('info', 'ConnectToHub', BoolToStr(pWebApp.ConnectToHub, True));
end;

end.
