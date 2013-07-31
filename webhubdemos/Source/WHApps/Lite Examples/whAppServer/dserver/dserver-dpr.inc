{$IFDEF EUREKALOG}
  EMemLeaks,
  EResLeaks,
  EMapWin32,
  EAppVCL,
  ExceptionLog7,
{$ENDIF}
  whSharedLog in 'h:\whSharedLog.pas',
  ucCodeSiteInterface in 'h:\ucCodeSiteInterface.pas',
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'k:\webhub\tpack\tpProj.pas',
  utPanFrm in 'h:\utPanFrm.pas' {utParentForm},
  utMainFm in 'h:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'h:\utTrayFm.pas' {fmTrayForm},
  htWebApp in 'h:\htWebApp.pas',
  {$IFDEF CPUX64}
  webAjax in 'k:\webhub\lib\whplus\webAjax.pas',
  {$ENDIF}
  whdemo_About in '..\..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Extensions in '..\..\..\Common\whdemo_Extensions.pas',
  whdemo_Initialize in '..\..\..\Common\whdemo_Initialize.pas',
  whdemo_Refresh in '..\..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whdemo_ViewSource in '..\..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_ColorScheme in '..\..\..\Common\whdemo_ColorScheme.pas' {DataModuleColorScheme: TDataModule},
  whcfg_App in 'h:\whcfg_App.pas',
  uCode,

