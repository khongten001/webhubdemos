program whSchedule;  // Created 01-Nov-2006 by the WebHub New Project Wizard

uses
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  whdemo_DMDBProjMgr in '..\..\Common\whdemo_DMDBProjMgr.pas' {DMForWHDBDemo: TDataModule},
  utPanFrm in 'H:\utPanFrm.pas' {utParentForm},
  utMainFm in 'H:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'H:\utTrayFm.pas' {fmTrayForm},
  whMain in 'H:\whMain.pas' {fmWebHubMainForm},
  dmWHApp in 'H:\dmWHApp.pas' {dmWebHubApp: TdmWebHubApp},
  whsample_EvtHandlers in 'H:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  whHTML in 'h:\whHtml.pas' {fmAppHTML},
  whdw_RemotePages in 'H:\whdw_RemotePages.pas' {DataModuleDreamWeaver: TDataModule},
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver},
  whibds in 'h:\whibds.pas',
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDemoViewSource},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_Refresh in '..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  webLink in 'h:\webLink.pas',
  whSchedule_dmdbProjMgr in 'whSchedule_dmdbProjMgr.pas' {DMForWHSchedule: TDataModule},
  whSchedule_dmwhActions in 'whSchedule_dmwhActions.pas' {DMCodeRageActions: TDataModule},
  CodeRage_dmCommon in 'DBDesign\gen_delphi\1\CodeRage_dmCommon.pas' {dmCommon: TDataModule},
  ldiDmUtil in '..\..\..\..\..\..\vcl\LDI\ldiDmUtil.pas',
  whibods in 'h:\whibods.pas',
  whSchedule_whpanelInterrupt in 'whSchedule_whpanelInterrupt.pas' {fmAppDBInterrupt},
  whSchedule_uImport in 'whSchedule_uImport.pas',
  ucCalifTime in 'O:\WebApplication\Shared\All\ucCalifTime.pas';

{$R *.res}
{$R HTDEMOS.RES}     // main icon for WebHub demos
{$R HTICONS.RES}
{$R HTGLYPHS.RES}

begin
  {M}Application.Initialize;
  {M}Application.CreateForm(TDMForWHSchedule, DMForWHSchedule);
  DMForWHSchedule.SetDemoFacts('coderage', 'DB Examples', True);
  DMForWHSchedule.ProjMgr.ManageStartup;
  {M}Application.Run;
end.

