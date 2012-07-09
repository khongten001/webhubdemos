unit whSchedule_dmdbProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMDBProjMgr, tpProj;

type
  TDMForWHSchedule = class(TDMForWHDBDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHSchedule: TDMForWHSchedule;

implementation

{$R *.dfm}

uses
  MultiTypeApp, uCode,
  CodeRage_dmCommon, whSchedule_dmwhActions,
  whSchedule_whpanelInterrupt, whSchedule_fmCodeGen;

procedure TDMForWHSchedule.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  if NOT HaveParam('/justexport') then
  begin
    {M}Application.CreateForm(TdmCommon, dmCommon);
    {M}Application.CreateForm(TDMCodeRageActions, DMCodeRageActions);
  end;
end;

procedure TDMForWHSchedule.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  // create additional forms AFTER appid has been set.
  if ShouldEnableGUI then
  begin
    if NOT HaveParam('/justexport') then
    begin
      {M}Application.CreateForm(TfmAppDBInterrupt, fmAppDBInterrupt);
    end;
    {M}Application.CreateForm(TfmCodeGenerator, fmCodeGenerator);
  end;
end;

procedure TDMForWHSchedule.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  if NOT HaveParam('/justexport') then
  begin
    Continue := DMCodeRageActions.Init;
  end;
end;

end.

