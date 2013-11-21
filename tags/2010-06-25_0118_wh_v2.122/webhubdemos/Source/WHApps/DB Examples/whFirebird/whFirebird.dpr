program whFirebird;  // Created 01-Nov-2006 by the WebHub New Project Wizard

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
  whfmEmployee in 'whfmEmployee.pas' {fmEmployee},
  whdw_RemotePages in 'H:\whdw_RemotePages.pas' {DataModuleDreamWeaver: TDataModule},
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver},
  whibds in 'h:\whibds.pas',
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDemoViewSource},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_Refresh in '..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  webLink in 'h:\webLink.pas',
  whFirebird_dmdbProjMgr in 'whFirebird_dmdbProjMgr.pas' {DMForWHFirebird: TDataModule};

{$R *.res}
{$R HTDEMOS.RES}     // main icon for WebHub demos
{$R HTICONS.RES}
{$R HTGLYPHS.RES}

begin
  {M}Application.Initialize;
  {M}Application.CreateForm(TDMForWHFirebird, DMForWHFirebird);
  DMForWHFirebird.SetDemoFacts('fire', 'DB Examples', True);
  DMForWHFirebird.ProjMgr.ManageStartup;
  {M}Application.Run;
end.
