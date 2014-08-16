program whEZMap;

uses
  Forms,
  WebApp,
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver: TfmWhDreamweaver},
  utPanFrm in 'h:\utpanfrm.pas' {utParentForm},
  utmainfm in 'h:\utmainfm.pas' {fmMainForm},
  uttrayfm in 'h:\utTrayFm.pas' {fmTrayForm},
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  dmWHApp in 'h:\dmWHApp.pas' {dmWebHubApp: TDataModule},
  whMain in 'h:\whMain.pas' {fmWebHubMainForm},
  WebEZMap in 'WebEZMap.pas',
  whEZMap_fmMap in 'whEZMap_fmMap.pas' {fmMap};

{$R *.RES}
{$R HTDEMOS.RES}     // main icon for WebHub demos
{..$R HTICONS.RES}   // component icons for combo bar, needed if compiling without WH package
{..$R HTGLYPHS.RES}  // icons for WebHub UI features, needed if compiling without WH package

begin
  Application.Initialize;
  Application.CreateForm(TfmWebHubMainForm, fmWebHubMainForm);
  CreateCoreWebHubDataModule;
  whDemoSetAppIdThenCreateSharedPanels('htmp');
  Application.CreateForm(TfmMap, fmMap);
  InitCoreWebHubDataModule;
  whDemoSetDelphiSourceLocation('Third Party Examples',True);
  whDemoInit;
  Application.Run;
end.


