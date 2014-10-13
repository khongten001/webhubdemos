program whDPrefix;

uses
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  utmainfm in 'h:\utmainfm.pas' {fmMainForm},
  utTrayFm in 'h:\utTrayFm.pas' {fmTrayForm},
  utPanFrm in 'h:\utPanFrm.pas' {utParentForm},
  whhtml in 'h:\whhtml.pas' {fmAppHTML},
  whmail in 'h:\whmail.pas' {DataModuleWhMail: TDataModuleWhMail},
  whappin in 'h:\whappin.pas' {fmAppIn},
  whappout in 'h:\whappout.pas' {fmAppOut},
  whMain in 'h:\whMain.pas' {fmWebHubMainForm},
  webScan in 'K:\WebHub\lib\whplus\webScan.pas',
  whdm_Lingvo in 'h:\whdm_Lingvo.pas',
  whcfg_App in 'k:\webhub\lib\whcfg_App.pas',
  htWebApp in 'k:\webhub\lib\htWebApp.pas',
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel: TDataModule},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  whsample_GoogleSitemap in 'h:\whsample_GoogleSitemap.pas' {fmwhGoogleSitemap},
  whdemo_CodeSite in '..\..\Common\whdemo_CodeSite.pas',
  wnxdbAlpha in 'wnxdbAlpha.pas',
  whutil_ZaphodsMap in 'h:\whutil_ZaphodsMap.pas',
  whutil_ValidEmail in 'h:\whutil_ValidEmail.pas',
  ucURLEncode in 'k:\webhub\tpack\ucURLEncode.pas',
  whOpenID_dmwhAction in '..\..\More Examples\whOpenID\whOpenID_dmwhAction.pas',
  DPrefix_fmWhActions in 'DPrefix_fmWhActions.pas' {fmWhActions},
  DPrefix_DMProjMgr in 'DPrefix_DMProjMgr.pas' {DMDPrefixProjMgr: TDataModule},
  DPrefix_dmNexus in 'DPrefix_dmNexus.pas' {DMNexus: TDataModule},
  DPrefix_dmWhActions in 'DPrefix_dmWhActions.pas' {DMDPRWebAct: TDataModule},
  webLink in 'h:\webLink.pas',
  wdbForm in 'h:\wdbForm.pas',
  wdbSSrc in 'K:\WebHub\lib\whdb\wdbSSrc.pas',
  wdbScan in 'k:\webhub\lib\whdb\wdbScan.pas',
  wdbSource in 'K:\WebHub\lib\whdb\wdbSource.pas',
  uBigMacIndex in 'uBigMacIndex.pas';

(* search path for debugging
k:\webhub\lib;k:\webhub\lib\whvcl;k:\webhub\lib\wheditors;k:\webhub\lib\whrun;k:\webhub\lib\whplus;k:\webhub\tpack
  wdbSSrc in 'k:\webhub\lib\whdb\wdbSSrc.pas',
  uAutoDataModules in 'k:\webhub\lib\uAutoDataModules.pas',
  uAutoPanels in 'k:\webhub\lib\uAutoPanels.pas',
*)

{$R *.RES}
{$R DPRICON.RES}
{$R HTICONS.RES}
{$R HTGLYPHS.RES}

begin
  {M}Application.Initialize;
  {M}Application.CreateForm(TDMDPrefixProjMgr, DMDPrefixProjMgr);
  DMDPrefixProjMgr.ProjMgr.ManageStartup;
  {M}Application.Run;
end.

