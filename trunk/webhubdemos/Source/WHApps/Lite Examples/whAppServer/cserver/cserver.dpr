program cserver;  // Lite WebHub application server to be compiled as-service

uses
  whBuildInfo,
  {$IF cWebHubVersion <= 3.268} // uses whBuildInfo (DCU not PAS)
  ucCodeSiteInterface in 'h:\ucCodeSiteInterface.pas', // compiles in v3.268
  {$ELSE}
  ZM_CodeSiteInterface in 'h:\ZM_CodeSiteInterface.pas',
  {$IFEND}
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  MultiTypeAppSvc in 'h:\MultiTypeAppSvc.pas',
  tpProj in 'H:\tpProj.pas',
  utPanFrm in 'H:\utPanFrm.pas' {utParentForm},
  utMainFm in 'H:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'H:\utTrayFm.pas' {fmTrayForm},
  uAutoDataModules in 'H:\uAutoDataModules.pas',
  uAutoPanels in 'H:\uAutoPanels.pas',
  CServer_dmProjMgr in 'CServer_dmProjMgr.pas' {DMForWHDemoC: TDataModule},
  cfmwhCustom in 'cfmwhCustom.pas' {fmAppCustomPanel},
  ucAWS_CloudFront_PrivateURLs in 'H:\ucAWS_CloudFront_PrivateURLs.pas',
  whdemo_Extensions in '..\..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_DMProjMgr in '..\..\..\Common\whdemo_DMProjMgr.pas' {DMForWHDemo: TDataModule},
  whdemo_CodeSite in '..\..\..\Common\whdemo_CodeSite.pas',
  whdemo_UIHelpers in '..\..\..\Common\whdemo_UIHelpers.pas',
  whdemo_ViewSource in '..\..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_Initialize in '..\..\..\Common\whdemo_Initialize.pas',
  whdemo_About in '..\..\..\Common\whdemo_About.pas' {fmAppAboutPanel};

{$R cserver_version.RES}
{$R WHAPPICO.RES}
{$R HTICONS.RES}
{$R HTGLYPHS.RES}

begin
  {M}Application.Initialize;
  {M}Application.CreateForm(TDMForWHDemoC, DMForWHDemoC);
  DMForWHDemoC.SetDemoFacts('adv', 'Lite Examples\whAppServer\cserver', True);
  DMForWHDemoC.ProjMgr.ManageStartup;
  {M}Application.Run;
  {$IFDEF LogInitFinal}CSSend('dpr ending');{$ENDIF}
end.


