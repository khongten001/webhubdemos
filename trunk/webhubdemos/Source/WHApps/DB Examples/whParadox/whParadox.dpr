program whParadox;
(*
Copyright (c) 2008 HREF Tools Corp.
Author: Ann Lynnworth
*)

uses
  utpanfrm in 'h:\utPanFrm.pas' {utParentForm},
  utmainfm in 'h:\utMainFm.pas' {fmMainForm},
  uttrayfm in 'H:\utTrayFm.pas' {fmTrayForm},
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_Refresh in '..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver: TfmWhDreamweaver},
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  whMain in 'H:\whMain.pas' {fmWebHubMainForm},
  whhtml in 'H:\whhtml.pas' {fmAppHTML},
  dmWHApp in 'H:\dmWHApp.pas' {dmWebHubApp: TDataModule},
  whParadox_fmWhProcess in 'whParadox_fmWhProcess.pas' {fmWhProcess},
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  whdemo_DMProjMgr in '..\..\Common\whdemo_DMProjMgr.pas' {DMForWHDemo: TDataModule},
  whParadox_dmProjMgr in 'whParadox_dmProjMgr.pas' {DMForWHParadox: TDataModule},
  whParadox_dmWhProcess in 'whParadox_dmWhProcess.pas' {dmwhProcess: TDataModule};

{$R *.RES}
{$R HTDEMOS.RES}     // main icon for WebHub demos
{..$R HTICONS.RES}   // component icons for combo bar, needed if compiling without WH package
{..$R HTGLYPHS.RES}  // icons for WebHub UI features, needed if compiling without WH package

begin
  {M}Application.Initialize;
  {M}Application.CreateForm(TDMForWHParadox, DMForWHParadox);
  Application.CreateForm(TdmwhProcess, dmwhProcess);
  DMForWHParadox.SetDemoFacts('paradox', 'DB Examples',True);
  DMForWHParadox.ProjMgr.ManageStartup;
  {M}Application.Run;
end.

