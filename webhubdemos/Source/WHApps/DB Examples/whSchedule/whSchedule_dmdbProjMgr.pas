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
  MultiTypeApp, uCode, ucString,
  webApp,
  whSchedule_dmwhActions,
  {$IFDEF INHOUSE}
  whSchedule_fmKeywordIndex, whSchedule_dmKeywordSearch,  // Rubicon
  {$ENDIF}
  whSchedule_whpanelInterrupt, whSchedule_fmCodeGen, whdemo_DMIBObjCodeGen;

procedure TDMForWHSchedule.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  if NOT HaveParam('/justexport') then
  begin
    {M}Application.CreateForm(TDMCodeRageActions, DMCodeRageActions);
  end;
  Application.CreateForm(TDMIBObjCodeGen, DMIBObjCodeGen);

  if IsEqual(pWebApp.ZMDefaultMapContext, 'DEMOS') or
     IsEqual(pWebApp.ZMDefaultMapContext, 'DORIS') 
  then
    DMIBObjCodeGen.ProjectAbbreviationNoSpaces := 'CodeRageSchedule'
  else
    DMIBObjCodeGen.ProjectAbbreviationNoSpaces := 'CodeRageScheduleLOCAL';
  {$IFDEF INHOUSE}
  Application.CreateForm(TDMRubiconSearch, DMRubiconSearch);
  {$ENDIF}
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
  begin
    Continue := DMIBObjCodeGen.Init(ErrorText);
    {$IFDEF INHOUSE}
    if Continue then
      Continue := DMRubiconSearch.Init(ErrorText);
    {$ENDIF}
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
    {$IFDEF INHOUSE}
    {M}Application.CreateForm(TfmRubiconIndex, fmRubiconIndex);
    {$ENDIF}
  end;
end;

end.

