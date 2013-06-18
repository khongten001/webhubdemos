unit whQuery2_dmdbProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Forms,
  whdemo_DMProjMgr, tpProj;

type
  TDMForWHQuery2 = class(TDMForWHDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrGUIInit(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: string; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject; var ErrorText: string;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHQuery2: TDMForWHQuery2;

implementation

{$R *.dfm}

uses
  MultiTypeApp,
  webApp,
  htqry2C, counter, whQuery2_whdmData;

procedure TDMForWHQuery2.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TDMQuery2, DMQuery2);
end;

procedure TDMForWHQuery2.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Continue := DMQuery2.Init(ErrorText);
end;

procedure TDMForWHQuery2.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TfmHTQ2Panel, fmHTQ2Panel);
  {M}Application.CreateForm(TfmCounterPanel, fmCounterPanel);

end;

procedure TDMForWHQuery2.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  // implement a simplistic session counter
  pWebApp.OnNewSession := fmCounterPanel.htWebAppNewSession;
end;

end.

