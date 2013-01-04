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
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  wnxdbAlpha in 'wnxdbAlpha.pas',
  whcfg_App in 'h:\whcfg_App.pas',
  whutil_ZaphodsMap in 'h:\whutil_ZaphodsMap.pas',
  DPrefix_fmWhActions in 'DPrefix_fmWhActions.pas' {fmWhActions},
  DPrefix_DMProjMgr in 'DPrefix_DMProjMgr.pas' {DMSampleForWHProject: TDataModule},
  DPrefix_dmNexus in 'DPrefix_dmNexus.pas' {DMNexus: TDataModule},
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  DPrefix_dmWhActions in 'DPrefix_dmWhActions.pas' {DMDPRWebAct: TDataModule};

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
  {M}Application.CreateForm(TDMSampleForWHProject, DMSampleForWHProject);
  DMSampleForWHProject.ProjMgr.ManageStartup;
  {M}Application.Run;
end.

