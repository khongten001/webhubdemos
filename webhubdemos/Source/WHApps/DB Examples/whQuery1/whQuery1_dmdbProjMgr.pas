unit whQuery1_dmdbProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMDBProjMgr, tpProj;

type
  TDMForWHQuery1 = class(TDMForWHDBDemo)
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
  DMForWHQuery1: TDMForWHQuery1;

implementation

{$R *.dfm}

uses
  MultiTypeApp, Htqry1C, whQuery1_whdmData;

procedure TDMForWHQuery1.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Application.CreateForm(TDMHTQ1, DMHTQ1);
end;

procedure TDMForWHQuery1.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Continue := DMHTQ1.Init(ErrorText);
end;

procedure TDMForWHQuery1.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TfmHTQ1Panel, fmHTQ1Panel);

end;

end.

