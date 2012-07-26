program f2hdemo;

(* See "How to Work with WebHub Demos.rtf" in the webhubdemos\source\docs folder 
   for information about "drives" H: and K:. *)

uses
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  sample in 'sample.pas' {sampleFrm},
  whDM in 'whDM.pas' {whDataModule: TDataModule},
  fmf2h in 'fmf2h.pas' {fmF2HDemo},
  f2h in 'h:\f2h.pas',
  f2hf {f2hFrm},
  webapp,
  webcall,
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_Refresh in '..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver: TfmWhDreamweaver},
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  webCycle in 'h:\webCycle.pas',
  webLink in 'h:\webLink.pas',
  tpProj in 'h:\tpProj.pas',
  f2hdemo_dmProjMgr in 'f2hdemo_dmProjMgr.pas' {PMforF2H: TDataModule};

{$R *.RES}


begin
  {M}Application.Initialize;
  {M}Application.CreateForm(TPMforF2H, PMforF2H);
  PMforF2H.ProjMgr.ManageStartup;
  {M}Application.Run;
end.
