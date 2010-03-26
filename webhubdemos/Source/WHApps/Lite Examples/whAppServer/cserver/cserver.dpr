program cserver;  // Created 29-Jun-2006 by the WebHub New Project Wizard

uses
  Forms,
  webApp,
  uCode,
  ucString,
  whMacroAffixes,
  utPanFrm in '..\..\..\..\..\..\..\Apps\HREFTools\WebHub\lib\utPanFrm.pas' {utParentForm},
  utMainFm in '..\..\..\..\..\..\..\Apps\HREFTools\WebHub\lib\utMainFm.pas' {fmMainForm},
  utTrayFm in '..\..\..\..\..\..\..\Apps\HREFTools\WebHub\lib\utTrayFm.pas' {fmTrayForm},
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  whMain in '..\..\..\..\..\..\..\Apps\HREFTools\WebHub\lib\whMain.pas' {fmWebHubMainForm},
  dmWHApp in '..\..\..\..\..\..\..\Apps\HREFTools\WebHub\lib\dmWHApp.pas' {dmWebHubApp: TDataModule},
  whHTML in '..\..\..\..\..\..\..\Apps\HREFTools\WebHub\lib\whHtml.pas' {fmAppHTML},
  whdw_RemotePages in '..\..\..\..\..\..\..\Apps\HREFTools\WebHub\lib\whdw_RemotePages.pas' {DataModuleDreamWeaver: TDataModule},
  whpanel_RemotePages in '..\..\..\..\..\..\..\Apps\HREFTools\WebHub\lib\whpanel_RemotePages.pas' {fmWhDreamweaver},
  whsample_DWSecurity in '..\..\..\..\..\..\..\Apps\HREFTools\WebHub\lib\whsample_DWSecurity.pas' {dmDWSecurity: TDataModule},
  cfmwhCustom in 'cfmwhCustom.pas' {fmAppCustomPanel};

{$R *.res}
//{$R WHAPPICO.RES}
//{$R HTICONS.RES}
//{$R HTGLYPHS.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmWebHubMainForm, fmWebHubMainForm);
  CreateCoreWebHubDataModule;
  with pWebApp do
  begin
    AppID := DefaultsTo(Lowercase(ParamString('ID')), 'hreftest');
    Refresh;
  end;
  // create additional forms AFTER refresh
  Application.CreateForm(TfmAppHTML, fmAppHTML);
  Application.CreateForm(TDataModuleDreamWeaver, DataModuleDreamWeaver);
  Application.CreateForm(TfmWhDreamweaver, fmWhDreamweaver);
  Application.CreateForm(TdmDWSecurity, dmDWSecurity);
  Application.CreateForm(TfmAppCustomPanel, fmAppCustomPanel);
  InitCoreWebHubDataModule;
  DataModuleDreamWeaver.Init;
  dmDWSecurity.Init;
  whDemoInit;
  Application.Run;
end.
 

