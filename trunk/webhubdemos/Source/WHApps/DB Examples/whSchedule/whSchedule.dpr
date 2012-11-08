program whSchedule;

(* See "How to Work with WebHub Demos.rtf" in the webhubdemos\source\docs folder
   for information about "drives" H: and K:. *)

{$R *.res}
{$R *.dres}

uses
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  ucCalifTime in 'O:\WebApplication\project-hrefrack-d\trunk\meta\Source\SharedAll\ucCalifTime.pas',
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
  wdbIBObjNSource in 'h:\wdbIBObjNSource.pas',
  uLingvoCodePoints in '..\..\Common\uLingvoCodePoints.pas',
  whdemo_DMDBProjMgr in '..\..\Common\whdemo_DMDBProjMgr.pas' {DMForWHDBDemo: TDataModule},
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDemoViewSource},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_Refresh in '..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_DMIBObjCodeGen in '..\..\Common\whdemo_DMIBObjCodeGen.pas' {DMIBObjCodeGen: TDataModule},
  whdemo_IbObjCodeGenGUI in '..\..\Common\whdemo_IbObjCodeGenGUI.pas',
  whSchedule_dmdbProjMgr in 'whSchedule_dmdbProjMgr.pas' {DMForWHSchedule: TDataModule},
  whSchedule_dmKeywordSearch in 'whSchedule_dmKeywordSearch.pas' {DMRubiconSearch: TDataModule},
  whSchedule_dmwhActions in 'whSchedule_dmwhActions.pas' {DMCodeRageActions: TDataModule},
  whSchedule_whpanelInterrupt in 'whSchedule_whpanelInterrupt.pas' {fmAppDBInterrupt},
  whSchedule_fmCodeGen in 'whSchedule_fmCodeGen.pas' {fmCodeGenerator},
  whSchedule_fmKeywordIndex in 'whSchedule_fmKeywordIndex.pas' {fmRubiconIndex},
  ucIBObjCodeGen_Bootstrap in 'h:\ucIBObjCodeGen_Bootstrap.pas',
  ucIBObjCodeGen in 'h:\ucIBObjCodeGen.pas',
  ucIbAndFbCredentials in 'h:\ucIbAndFbCredentials.pas',
  uFirebird_Connect_CodeRageSchedule in 'uFirebird_Connect_CodeRageSchedule.pas',
  uFirebird_SQL_Snippets_CodeRageSchedule in 'uFirebird_SQL_Snippets_CodeRageSchedule.pas',
  ucIBObjPrepare in 'K:\WebHub\tpack\ucIBObjPrepare.pas';

(* when compiling with source use these:
  IB_Import in 'K:\Vendors\CPS\IBObjects\v5.x\source\tools\IB_Import.pas',
  IB_Export in 'K:\Vendors\CPS\IBObjects\v5.x\source\tools\IB_Export.pas',
  rbMake in 'K:\Rubicon\source\rbMake.pas',
  rbAccept in 'K:\Rubicon\source\rbAccept.pas',
  rbPrgDlg in 'K:\Rubicon\source\rbPrgDlg.pas' {rbProgressDlg},
  rbCache in 'K:\Rubicon\source\rbCache.pas',
  rbSearch in 'K:\Rubicon\source\rbSearch.pas',
  webRubi in 'K:\WebHub\lib\whplus\rubi\webRubi.pas',
  whCodeGenIBObj in 'K:\WebHub\lib\whplus\whCodeGenIBObj.pas',
  whutil_RegExParsing in 'K:\WebHub\lib\whplus\whutil_RegExParsing.pas',
*)

begin
  {M}Application.Initialize;
  {M}Application.CreateForm(TDMForWHSchedule, DMForWHSchedule);
  DMForWHSchedule.SetDemoFacts('coderage', 'DB Examples', True);
  DMForWHSchedule.ProjMgr.ManageStartup;
  {M}Application.Run;
end.
