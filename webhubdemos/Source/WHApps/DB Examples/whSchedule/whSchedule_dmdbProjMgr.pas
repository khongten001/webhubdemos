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
  webApp,
  whSchedule_dmwhActions,
  whSchedule_whpanelInterrupt, whSchedule_fmCodeGen, whdemo_DMIBObjCodeGen,
  whSchedule_fmKeywordIndex;

procedure TDMForWHSchedule.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  if NOT HaveParam('/justexport') then
  begin
    {M}Application.CreateForm(TDMCodeRageActions, DMCodeRageActions);
  end;
  Application.CreateForm(TDMIBObjCodeGen, DMIBObjCodeGen);
  if pWebApp.ZMDefaultMapContext = 'DEMOS' then
    DMIBObjCodeGen.ProjectAbbreviationNoSpaces := 'CodeRageSchedule'
  else
    DMIBObjCodeGen.ProjectAbbreviationNoSpaces := 'CodeRageScheduleLOCAL';
end;

procedure TDMForWHSchedule.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  if NOT HaveParam('/justexport') then
  begin
    Continue := DMCodeRageActions.Init(ErrorText);
  end;
  if Continue then
    DMIBObjCodeGen.Init;
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
    {M}Application.CreateForm(TfmRubiconIndex, fmRubiconIndex);
  end;
end;


end.

