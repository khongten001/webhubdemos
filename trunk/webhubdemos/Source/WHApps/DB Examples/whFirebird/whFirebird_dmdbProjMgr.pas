unit whFirebird_dmdbProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMDBProjMgr, tpProj;

type
  TDMForWHFirebird = class(TDMForWHDBDemo)
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
  DMForWHFirebird: TDMForWHFirebird;

implementation

{$R *.dfm}

uses
  MultiTypeApp, whFirebird_dmEmployee, whFirebird_dmwhMasterDetail;

procedure TDMForWHFirebird.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TDMEmployeeFire, DMEmployeeFire);
  {M}Application.CreateForm(TDMMastDet, DMMastDet);
end;

procedure TDMForWHFirebird.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Continue := DMEmployeeFire.Init(ErrorText);
  if Continue then
    Continue := DMMastDet.Init(ErrorText);
end;

end.

