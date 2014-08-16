program whDSP;

// Delphi Super Page, compiled with Delphi, WebHub and Rubicon

// To compile, map drive h: to the WebHub "lib" directory, or change the paths
// below.

// Note that the LogInfo function does nothing, by default. It is enabled via
// compiler directive.  It's okay to comment out all calls to LogInfo.

(* See "How to Work with WebHub Demos.rtf" in the webhubdemos\source\docs folder
   for information about "drives" H: and K:. *)

(* The webRubi and webScanKeys files are available with source.
   The webRubi unit is included with Rubicon, and the webScanKeys unit is
   included when you license the WebHub "useful source."
*)

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucCodeSiteInterface in 'h:\ucCodeSiteInterface.pas',
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  whdemo_DMProjMgr in '..\..\Common\whdemo_DMProjMgr.pas' {DMForWHDemo: TDataModule},
  utMainFm in 'H:\utMainFm.pas' {fmMainForm},
  utPanFrm in 'H:\utPanFrm.pas' {utParentForm},
  utTrayFm in 'H:\utTrayFm.pas' {fmTrayForm},
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {dmWebHubCore: TDataModule},
  dmWHApp in 'h:\dmWHApp.pas' {dmWebHubApp: TDataModule},
  whMain in 'h:\whMain.pas' {fmWebHubMainForm},
  whHtml in 'h:\whHtml.pas' {fmAppHTML},
  whAppIn in 'h:\whAppIn.pas' {fmAppIn},
  whAppOut in 'h:\whAppOut.pas' {fmAppOut},
  DSP_dmRubicon in 'DSP_dmRubicon.pas' {DSPdm: TDataModule},
  DSP_u1 in 'DSP_u1.pas',
  DSP_fmPanel in 'DSP_fmPanel.pas' {fmPanel},
  DSP_fmPanelSearch in 'DSP_fmPanelSearch.pas' {fmSearchForm},
  DSP_dmWH1 in 'DSP_dmWH1.pas' {dmDSPWebSearch: TDataModule},
  htmltext in 'htmltext.pas',
  webLink in 'H:\webLink.pas',
  whMacroAffixes,
  webApp,
  webSplat,
  htWebApp in 'h:\htWebApp.pas',
  webVars,
  webScan,
  uCode,
  ucString,
  ucVers,
  DSP_dmDisplayResults in 'DSP_dmDisplayResults.pas' {dmDisplayResults: TDataModule},
  whdw_RemotePages in 'H:\whdw_RemotePages.pas' {DataModuleDreamWeaver: TDataModule},
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_CodeSite in '..\..\Common\whdemo_CodeSite.pas',
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  webInfoU,
  whcfg_app in 'h:\whcfg_app.pas',
  DSP_dmProjMgr in 'DSP_dmProjMgr.pas' {PMForDSP: TDataModule},
  uAutoDataModules in 'h:\uAutoDataModules.pas',
  uAutoPanels in 'H:\uAutoPanels.pas',
  whsample_GoogleSitemap in 'h:\whsample_GoogleSitemap.pas' {fmwhGoogleSitemap},
  webrubi in 'k:\webhub\lib\whplus\rubi\webrubi.pas',
  webScanKeys in 'K:\WebHub\lib\whplus\webScanKeys.pas',
  uDSPFuzziness in 'uDSPFuzziness.pas';

{$R *.RES}
{$R DspIcons.res}
{SR HtIcons.res}   // component icons for combo bar (not essential)
{$R HtGlyphs.res}  // icons for WebHub UI features

(*
  // for working with source
  webScanKeys in 'k:\webhub\lib\whplus\webScanKeys.pas',
  webCall in 'k:\webhub\lib\whvcl\webCall.pas',
  webSend in 'k:\webhub\lib\whvcl\webSend.pas',
*)


begin
  Application.Initialize;
  Application.CreateForm(TPMForDSP, PMForDSP);
  PMForDSP.SetDemoFacts('dsp', 'Third Party Examples', True);
  PMForDSP.ProjMgr.ManageStartup;
  Application.Run;
end.
