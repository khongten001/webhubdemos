program whRubicon; {Rubicon full text search example.}
////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995-2008 HREF Tools Corp.  All Rights Reserved Worldwide.  //
////////////////////////////////////////////////////////////////////////////////

(* See "How to Work with WebHub Demos.rtf" in the webhubdemos\source\docs folder 
   for information about "drives" H: and K:. *)

uses
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  whdemo_DMDBProjMgr in '..\..\Common\whdemo_DMDBProjMgr.pas' {DMForWHDBDemo: TDataModule},
  utpanfrm in 'h:\utPanFrm.pas' {utParentForm},
  utmainfm in 'h:\utMainFm.pas' {fmMainForm},
  uttrayfm in 'h:\utTrayFm.pas' {fmTrayForm},
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_Refresh in '..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver: TfmWhDreamweaver},
  whsample_EvtHandlers in 'H:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  dmBasic in '..\whDSP\dmBasic.pas' {dmBasicDatamodule: TDataModule},
  dmwhBDEApp in 'h:\dmwhBDEApp.pas' {dmWebHubBDEApp: TdmWebHubDBApp},
  whMain in 'h:\whMain.pas' {fmWebHubMainForm},
  htRubiC in 'htRubiC.pas' {fmHTRUPanel},
  htru_fmExMakeU in 'htru_fmExMakeU.pas' {fmRubiconMakeBDE},
  webrubi in 'k:\webhub\lib\whplus\rubi\webrubi.pas',
  webScanKeys in 'K:\WebHub\lib\whplus\webScanKeys.pas',
  whRubicon_dmdbProjMgr in 'whRubicon_dmdbProjMgr.pas' {DMForWHRubicon: TDataModule};

(* The webRubi and webScanKeys files are available with source.
   The webRubi unit is included with Rubicon, and the webScanKeys unit is 
   included when you license the WebHub "useful source." 
*)


{$R *.RES}
{$R HTDEMOS.RES}   // main icon for demos
                   // for regular Delphi icon, use $ *.RES
{..$R HTICONS.RES}   // component icons for combo bar, needed if compiling without WH package
{..$R HTGLYPHS.RES}  // icons for WebHub UI features, needed if compiling without WH package

begin
  {M}Application.Initialize;
  {M}Application.CreateForm(TDMForWHRubicon, DMForWHRubicon);
  DMForWHRubicon.SetDemoFacts('htru', 'Third Party Examples', True);
  DMForWHRubicon.ProjMgr.ManageStartup;
  {M}Application.Run;
end.

