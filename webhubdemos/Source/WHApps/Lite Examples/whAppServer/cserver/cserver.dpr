program cserver;  // Lite WebHub application server to be compiled as-service

uses
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  MultiTypeAppSvc in 'h:\MultiTypeAppSvc.pas',
  tpProj in 'H:\tpProj.pas',
  utPanFrm in 'H:\utPanFrm.pas' {utParentForm},
  utMainFm in 'H:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'H:\utTrayFm.pas' {fmTrayForm},
  ucCodeSiteInterface in 'H:\ucCodeSiteInterface.pas',
  uAutoDataModules in 'H:\uAutoDataModules.pas',
  uAutoPanels in 'H:\uAutoPanels.pas',
  CServer_dmProjMgr in 'CServer_dmProjMgr.pas' {DMForWHDemoC: TDataModule},
  cfmwhCustom in 'cfmwhCustom.pas' {fmAppCustomPanel},
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
  {M}Application.Initialize;
  {M}Application.CreateForm(TDMForWHDemoC, DMForWHDemoC);
  DMForWHDemoC.SetDemoFacts('bw', 'Lite Examples\whAppServer\cserver', True);
  DMForWHDemoC.ProjMgr.ManageStartup;
  {M}Application.Run;
  CSSend('dpr ending');
end.


