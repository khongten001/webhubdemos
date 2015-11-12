program cserver;  // Lite WebHub application server to be compiled as-service

uses
  ucCodeSiteInterface in 'H:\ucCodeSiteInterface.pas',
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  MultiTypeAppSvc in 'h:\MultiTypeAppSvc.pas',
  tpProj in 'H:\tpProj.pas',
  utPanFrm in 'H:\utPanFrm.pas' {utParentForm},
  utMainFm in 'H:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'H:\utTrayFm.pas' {fmTrayForm},
  uAutoDataModules in 'H:\uAutoDataModules.pas',
  uAutoPanels in 'H:\uAutoPanels.pas',

(*webBase in 'k:\webhub\lib\whvcl\webBase.pas',
webCall in 'k:\webhub\lib\whvcl\webCall.pas',
webCore in 'k:\webhub\lib\whvcl\webCore.pas',
webSend in 'k:\webhub\lib\whvcl\webSend.pas',
webRead in 'k:\webhub\lib\whvcl\webRead.pas',
whxpGlobal in 'k:\webhub\lib\whvcl\whxpGlobal.pas',
whxpUtils  in 'k:\webhub\lib\whvcl\whxpUtils.pas',
whutil_ZaphodsMap in 'k:\webhub\lib\whutil_ZaphodsMap.pas',
whMacros in 'k:\webhub\lib\whvcl\whMacros.pas',

  htWebApp in 'K:\webhub\lib\htWebApp.pas',
*)

  CServer_dmProjMgr in 'CServer_dmProjMgr.pas' {DMForWHDemoC: TDataModule},
  cfmwhCustom in 'cfmwhCustom.pas' {fmAppCustomPanel},
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


