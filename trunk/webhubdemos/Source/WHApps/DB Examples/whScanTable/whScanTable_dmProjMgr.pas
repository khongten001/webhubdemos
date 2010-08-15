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
  scanfm;
  
procedure TDMForWHScanTable.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TfmDBPanel, fmDBPanel);
end;

end.
