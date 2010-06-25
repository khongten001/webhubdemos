program whDSP;

(* to do:

- 5/24/01 1:09:57 AM 211.189.211.6,91104,SEARCHDSP:waResults.Last,EDivByZero,Division by zero

*)


// Delphi Super Page, compiled with Delphi 7, WebHub v2.090 and Rubicon 2
// 20 August 2007, AML

// To compile, map drive h: to the WebHub "lib" directory, or change the paths
// below.

// The extra WebHub component in webrubi.pas needs to be installed in order
// to open DSP_dmWH1.pas.  However you can compile the project without installing
// the component, as long as you don't open the data module.

// Note that the LogInfo function does nothing, by default. It is enabled via
// compiler directive.  It's okay to comment out all calls to LogInfo.


uses
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  whdemo_DMProjMgr in '..\..\Common\whdemo_DMProjMgr.pas' {DMForWHDemo: TDataModule},
  utmainfm in 'H:\utMainFm.pas' {fmMainForm},
  utpanfrm in 'H:\utPanFrm.pas' {utParentForm},
  uttrayfm in 'H:\utTrayFm.pas' {fmTrayForm},
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {dmWebHubCore: TDataModule},
  dmWHApp in 'h:\dmWHApp.pas' {dmWebHubApp: TDataModule},
  whMain in 'h:\whMain.pas' {fmWebHubMainForm},
  whHtml in 'h:\whHtml.pas' {fmAppHTML},
  whAppIn in 'h:\whAppIn.pas' {fmAppIn},
  whAppOut in 'k:\webhub\lib\whAppOut.pas' {fmAppOut},
  DSP_dmRubicon in 'DSP_dmRubicon.pas' {DSPdm: TDataModule},
  DSP_u1 in 'DSP_u1.pas',
  DSP_fmPanel in 'DSP_fmPanel.pas' {fmPanel},
  DSP_fmPanelSearch in 'DSP_fmPanelSearch.pas' {fmSearchForm},
  DSP_dmWH1 in 'DSP_dmWH1.pas' {dmDSPWebSearch: TDataModule},
  HTMLText in 'htmltext.pas',
  webLink in 'k:\webhub\lib\webLink.pas',
  whMacroAffixes,
  webApp,
  webSplat,
  htWebApp in 'h:\htWebApp.pas',
  webCall,
  webVars,
  webScan,
  uCode,
  ucString,
  ucVers,
  DSP_dmDisplayResults in 'DSP_dmDisplayResults.pas' {dmDisplayResults: TDataModule},
  DSP_fmConfigure in 'DSP_fmConfigure.pas' {fmAppConfigure},
  whdw_RemotePages in 'H:\whdw_RemotePages.pas' {DataModuleDreamWeaver: TDataModule},
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Refresh in '..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  webInfoU,
  whcfg_App in 'h:\whcfg_app.pas',
  DSP_dmProjMgr in 'DSP_dmProjMgr.pas' {PMForDSP: TDataModule},
  uAutoDataModules in 'h:\uAutoDataModules.pas',
  uAutoPanels in 'H:\uAutoPanels.pas',
  whsample_GoogleSitemap in 'h:\whsample_GoogleSitemap.pas' {fmwhGoogleSitemap},
  webRubi in 'k:\webhub\lib\whplus\rubi\WebRubi.pas',
  webScanKeys in 'k:\webhub\lib\whplus\webScanKeys.pas',
  uDSPFuzziness in 'uDSPFuzziness.pas';

{$R *.RES}
{$R DspIcons.res}
{SR HtIcons.res}   // component icons for combo bar (not essential)
{$R HtGlyphs.res}  // icons for WebHub UI features

(*
  // Handy ancestor units.
  dmBasic in 'd:\Apps\HREF\WebHub\v2.007d\lib\dmBasic.pas' {dmBasicDatamodule: TDataModule},
  utmainfm in 'H:\Utmainfm.pas' {fmMainForm},
  utpanfrm in 'H:\Utpanfrm.pas' {utParentForm},
  uttrayfm in 'H:\utTrayFm.pas' {fmTrayForm},
*)


begin
  Application.Initialize;
  Application.CreateForm(TPMForDSP, PMForDSP);
  PMForDSP.SetDemoFacts('dsp', 'Third Party Examples', True);
  PMForDSP.ProjMgr.ManageStartup;
  Application.Run;
end.
