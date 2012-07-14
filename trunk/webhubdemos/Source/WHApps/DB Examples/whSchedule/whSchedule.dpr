program whSchedule;  // Created 01-Nov-2006 by the WebHub New Project Wizard

(* See "How to Work with WebHub Demos.rtf" in the webhubdemos\source\docs folder
   for information about "drives" H: and K:. *)

{$R *.dres}

uses
  MultiTypeApp in 'h:\MultiTypeApp.pas' {comment},
  tpProj in 'h:\tpProj.pas',
  utPanFrm in 'H:\utPanFrm.pas' {utParentForm},
  utMainFm in 'H:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'H:\utTrayFm.pas' {fmTrayForm},
  whMain in 'H:\whMain.pas' {fmWebHubMainForm},
  whHtml in 'h:\whHtml.pas' {fmAppHTML},
  webLink in 'h:\webLink.pas',
  dmWHApp in 'H:\dmWHApp.pas' {dmWebHubApp: TdmWebHubApp},
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver},
  whsample_EvtHandlers in 'H:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  whdw_RemotePages in 'H:\whdw_RemotePages.pas' {DataModuleDreamWeaver: TDataModule},
  whibds in 'h:\whibds.pas',
  whdemo_DMDBProjMgr in '..\..\Common\whdemo_DMDBProjMgr.pas' {DMForWHDBDemo: TDataModule},
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDemoViewSource},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_Refresh in '..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_DMIBObjCodeGen in '..\..\Common\whdemo_DMIBObjCodeGen.pas' {DMIBObjCodeGen: TDataModule},
  whSchedule_dmdbProjMgr in 'whSchedule_dmdbProjMgr.pas' {DMForWHSchedule: TDataModule},
  whSchedule_dmwhActions in 'whSchedule_dmwhActions.pas' {DMCodeRageActions: TDataModule},
  whSchedule_whpanelInterrupt in 'whSchedule_whpanelInterrupt.pas' {fmAppDBInterrupt},
  whSchedule_fmCodeGen in 'whSchedule_fmCodeGen.pas' {fmCodeGenerator},
  whCodeGenIBObj in 'K:\WebHub\lib\whplus\whCodeGenIBObj.pas',
  whutil_RegExParsing in 'K:\WebHub\lib\whplus\whutil_RegExParsing.pas',
  ucCalifTime in 'O:\WebApplication\project-hrefrack-d\trunk\meta\Source\SharedAll\ucCalifTime.pas',
  tpIBObjCodeGen_Bootstrap in 'K:\WebHub\tpack\tpIBObjCodeGen_Bootstrap.pas',
  tpIBObjCodeGen in 'K:\WebHub\tpack\tpIBObjCodeGen.pas',
  tpFirebirdCredentials in 'K:\WebHub\tpack\tpFirebirdCredentials.pas',
  uFirebird_Connect_CodeRageSchedule in 'uFirebird_Connect_CodeRageSchedule.pas',
  uFirebird_SQL_Snippets_CodeRageSchedule in 'uFirebird_SQL_Snippets_CodeRageSchedule.pas',
  IB_Import in 'K:\Vendors\CPS\IBObjects\v5.x\source\tools\IB_Import.pas',
  IB_Export in 'K:\Vendors\CPS\IBObjects\v5.x\source\tools\IB_Export.pas';

{$R *.res}
{$R HTDEMOS.RES}     // main icon for WebHub demos
{$R HTICONS.RES}
{$R HTGLYPHS.RES}

(*
  ldiDmUtil in 'd:\vcl\LDI\ldiDmUtil.pas',
  CodeRage_dmCommon in 'DBDesign\gen_delphi\1\CodeRage_dmCommon.pas' {dmCommon: TDataModule},
  whSchedule_uImport in 'whSchedule_uImport.pas',
*)

begin
  {M}Application.Initialize;
  {M}Application.CreateForm(TDMForWHSchedule, DMForWHSchedule);
  DMForWHSchedule.SetDemoFacts('coderage', 'DB Examples', True);
  DMForWHSchedule.ProjMgr.ManageStartup;
  {M}Application.Run;
end.

