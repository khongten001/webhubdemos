program WHEditor;  // Created 29-Aug-2006 by the WebHub New Project Wizard

uses
  Forms,
  SysUtils,
  webApp,
  uCode,
  ucString,
  whMacroAffixes,
  utPanFrm in 'H:\utPanFrm.pas' {utParentForm},
  utMainFm in 'H:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'H:\utTrayFm.pas' {fmTrayForm},
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  whMain in 'H:\whMain.pas' {fmWebHubMainForm},
  dmWHApp in 'h:\dmWHApp.pas' {dmWebHubApp: TDataModule},
  whHTML in 'H:\whHtml.pas' {fmAppHTML},
  whMail in 'H:\whMail.pas' {DataModuleWhMail: TDataModule},
  whpanel_Mail in 'H:\whpanel_Mail.pas' {fmWebMail},
  Htmlview in '..\..\..\..\..\..\vcl\thtml9\Package\htmlview.pas',
  vwPrint in '..\..\..\..\..\..\vcl\thtml9\Package\vwPrint.pas',
  MetaFilePrinter in '..\..\..\..\..\..\vcl\thtml9\Package\MetaFilePrinter.pas',
  StyleUn in '..\..\..\..\..\..\vcl\thtml9\Package\StyleUn.pas',
  Htmlsubs in '..\..\..\..\..\..\vcl\thtml9\Package\htmlsubs.pas',
  HTMLUn2 in '..\..\..\..\..\..\vcl\thtml9\Package\HTMLUn2.pas',
  DitherUnit in '..\..\..\..\..\..\vcl\thtml9\Package\DitherUnit.pas',
  PngImage1 in '..\..\..\..\..\..\vcl\thtml9\Package\PngImage1.pas',
  PNGZLIB1 in '..\..\..\..\..\..\vcl\thtml9\Package\PNGZLIB1.pas',
  Readhtml in '..\..\..\..\..\..\vcl\thtml9\Package\ReadHTML.pas',
  HTMLGif1 in '..\..\..\..\..\..\vcl\thtml9\Package\HTMLGif1.pas',
  HTMLGif2 in '..\..\..\..\..\..\vcl\thtml9\Package\HTMLGif2.pas',
  Htmlsbs1 in '..\..\..\..\..\..\vcl\thtml9\Package\Htmlsbs1.pas',
  StylePars in '..\..\..\..\..\..\vcl\thtml9\Package\StylePars.pas',
  URLSubs in '..\..\..\..\..\..\vcl\thtml9\Package\URLSubs.pas',
  whHtmlVw in 'h:\whHtmlVw.pas' {fmAppHtmlViewer},
  htWebApp in 'h:\htWebApp.pas';

{$R *.res}
{$R WHAPPICO.RES}
{$R HTICONS.RES}
{$R HTGLYPHS.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmWebHubMainForm, fmWebHubMainForm);
  fmWebHubMainForm.TrayIcon.Enabled := True;
  CreateCoreWebHubDataModule;
  with pWebApp do
  begin
    AppID := DefaultsTo(lowercase(ParamString('ID')),
      CentralInfo.GetDefaultWebAppID);
    Refresh;
  end;
  // create additional forms AFTER refresh
  Application.CreateForm(TfmAppHTML, fmAppHTML);
  Application.CreateForm(TDataModuleWhMail, DataModuleWhMail);
  Application.CreateForm(TfmWebMail, fmWebMail);
  Application.CreateForm(TfmAppHtmlViewer, fmAppHtmlViewer);
  InitCoreWebHubDataModule;
  DataModuleWhMail.Init;
  {Do not connect to Hub}
  TwhApplication(pWebApp).Connection.Free;
  TwhApplication(pWebApp).Connection := nil;
  Application.Run;
end.

