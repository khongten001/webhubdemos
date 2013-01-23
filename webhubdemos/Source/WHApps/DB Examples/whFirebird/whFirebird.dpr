program whFirebird;  // Created 01-Nov-2006 by the WebHub New Project Wizard

(* See "How to Work with WebHub Demos.rtf" in the webhubdemos\source\docs folder
   for information about "drives" H: and K:. *)

uses
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  utPanFrm in 'H:\utPanFrm.pas' {utParentForm},
  utMainFm in 'H:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'H:\utTrayFm.pas' {fmTrayForm},
  whMain in 'H:\whMain.pas' {fmWebHubMainForm},
  dmWHApp in 'H:\dmWHApp.pas' {dmWebHubApp: TdmWebHubApp},
  whsample_EvtHandlers in 'H:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  whHtml in 'h:\whHtml.pas' {fmAppHTML},
  webLink in 'h:\webLink.pas',
  whdw_RemotePages in 'H:\whdw_RemotePages.pas' {DataModuleDreamWeaver: TDataModule},
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver},
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDemoViewSource},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_Refresh in '..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_DMDBProjMgr in '..\..\Common\whdemo_DMDBProjMgr.pas' {DMForWHDBDemo: TDataModule},
  uFirebird_Connect_Employee in 'uFirebird_Connect_Employee.pas',
  whFirebird_dmdbProjMgr in 'whFirebird_dmdbProjMgr.pas' {DMForWHFirebird: TDataModule},
  wdbIBObjNSource in 'h:\wdbIBObjNSource.pas',
  ucIbAndFbCredentials in 'H:\ucIbAndFbCredentials.pas',
  whFirebird_dmEmployee in 'whFirebird_dmEmployee.pas' {DMEmployeeFire: TDataModule};

{$R *.res}
{$R HTDEMOS.RES}     // main icon for WebHub demos
{$R HTICONS.RES}
{$R HTGLYPHS.RES}

(* when compiling with full source:
  wdbIBObjNSource in 'K:\WebHub\lib\wdbIBObjNSource.pas',
  wdbSSrc in 'K:\WebHub\lib\whdb\wdbSSrc.pas';

  else:
  wdbIBObjNSource in 'h:\wdbIBObjNSource.pas';
*)


begin
  {M}Application.Initialize;
  {M}Application.CreateForm(TDMForWHFirebird, DMForWHFirebird);
  DMForWHFirebird.SetDemoFacts('fire', 'DB Examples', True);
  DMForWHFirebird.ProjMgr.ManageStartup;
  {M}Application.Run;
end.

