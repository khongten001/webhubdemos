program cserver;  // Created 29-Jun-2006 by the WebHub New Project Wizard

uses
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  utPanFrm in 'H:\utPanFrm.pas' {utParentForm},
  utMainFm in 'H:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'H:\utTrayFm.pas' {fmTrayForm},
  uAutoDataModules in 'H:\uAutoDataModules.pas',
  uAutoPanels in 'H:\uAutoPanels.pas',
  CServer_dmProjMgr in 'CServer_dmProjMgr.pas' {DMForWHDemoC: TDataModule},
  cfmwhCustom in 'cfmwhCustom.pas' {fmAppCustomPanel},
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  whdemo_Extensions in '..\..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_DMProjMgr in '..\..\..\Common\whdemo_DMProjMgr.pas' {DMForWHDemo: TDataModule},
  whdemo_ViewSource in '..\..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_Initialize in '..\..\..\Common\whdemo_Initialize.pas',
  whdemo_Refresh in '..\..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whdemo_About in '..\..\..\Common\whdemo_About.pas' {fmAppAboutPanel};

{$R *.res}
{$R WHAPPICO.RES}
{$R HTICONS.RES}
{$R HTGLYPHS.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDMForWHDemoC, DMForWHDemoC);
  DMForWHDemoC.SetDemoFacts('appvers', 'Lite Examples\whAppServer\cserver',
    True);
  DMForWHDemoC.ProjMgr.ManageStartup;
  Application.Run;
end.


