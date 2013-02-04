unit whClone_dmdbProjMgr;

interface

uses
  SysUtils, Classes,
  whdemo_DMDBProjMgr, tpProj;

type
  TDMForWHClone = class(TDMForWHDBDemo)
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
  DMForWHClone: TDMForWHClone;

implementation

{$R *.dfm}

uses
  MultiTypeApp,
  {$IFNDEF PREVENTGUI}fmclone,{$ENDIF}
  whClone_dmwhData, whClone_dmwhGridsNScans;

procedure TDMForWHClone.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TDMData2Clone, DMData2Clone);
  {M}Application.CreateForm(TDMGridsNScans, DMGridsNScans);
end;

procedure TDMForWHClone.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Continue := DMData2Clone.Init(ErrorText);
  if Continue then
    Continue := DMGridsNScans.Init(ErrorText);
end;

procedure TDMForWHClone.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {$IFNDEF PREVENTGUI}
  if ShouldEnableGUI then
    {M}Application.CreateForm(TfmBendFields, fmBendFields);
  {$ENDIF}
end;

end.

