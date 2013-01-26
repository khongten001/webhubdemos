unit whScanTable_dmProjMgr;

interface

uses
  Windows, SysUtils, Classes,
  tpProj,
  whdemo_DMProjMgr;

type
  TDMForWHScanTable = class(TDMForWHDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
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
  DMForWHScanTable: TDMForWHScanTable;

implementation

{$R *.dfm}

uses
  MultiTypeApp,
  scanfm, whScanTable_whdmData;

procedure TDMForWHScanTable.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TDMData, DMData);
end;

procedure TDMForWHScanTable.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Continue := DMData.Init(ErrorText);
end;

procedure TDMForWHScanTable.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TfmDBPanel, fmDBPanel);
end;

end.

