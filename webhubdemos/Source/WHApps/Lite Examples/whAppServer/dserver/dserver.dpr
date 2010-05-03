program dserver;  { WebHub App EXE for use by HREF/inhouse with Dreamweaver }

// Usage: dserver.exe /ID:AppID [/NoMenu]
// Search path for HREF:
// k:\webhub\Lib;k:\webhub\Lib\WHVCL;k:\webhub\Lib\WHRun;k:\webhub\Lib\WHRun\ISAPI;k:\webhub\Lib\WHEditors;k:\webhub\Lib\WHPlus;k:\webhub\Lib\WHDB;k:\webhub\TPack;
// D:\vcl\thtml9\Package

uses
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  utPanFrm in 'h:\utPanFrm.pas' {utParentForm},
  utMainFm in 'h:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'h:\utTrayFm.pas' {fmTrayForm},
  dserver_whdmGeneral in 'dserver_whdmGeneral.pas' {dmwhGeneral: TDataModule},
  dserver_dmProjMgr in 'dserver_dmProjMgr.pas' {DMForDServer: TDataModule},
  whdemo_About in '..\..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Extensions in '..\..\..\Common\whdemo_Extensions.pas',
  whdemo_Initialize in '..\..\..\Common\whdemo_Initialize.pas',
  whdemo_Refresh in '..\..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whdemo_ViewSource in '..\..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_ColorScheme in '..\..\..\Common\whdemo_ColorScheme.pas' {DataModuleColorScheme: TDataModule};

{$R *.RES}
{$R WHDICON.RES}   // dserver tray icon
{$R HTICONS.RES}   // component icons for combo bar (not essential)
{$R HTGLYPHS.RES}  // icons for WebHub UI features

(* save for preview panel
{ S DEFINE HTMLVIEWERAVAILABLE}   {http://www.href.com/htmlview}
  whHtmlVw in 'h:\whHtmlVw.pas' {fmAppHtmlViewer},
  Htmlview in '..\..\..\..\..\..\..\vcl\thtml9\Package\htmlview.pas',
  vwPrint in '..\..\..\..\..\..\..\vcl\thtml9\Package\vwPrint.pas',
  MetaFilePrinter in '..\..\..\..\..\..\..\vcl\thtml9\Package\MetaFilePrinter.pas',
  StyleUn in '..\..\..\..\..\..\..\vcl\thtml9\Package\StyleUn.pas',
  Htmlsubs in '..\..\..\..\..\..\..\vcl\thtml9\Package\htmlsubs.pas',
  HTMLUn2 in '..\..\..\..\..\..\..\vcl\thtml9\Package\HTMLUn2.pas',
  DitherUnit in '..\..\..\..\..\..\..\vcl\thtml9\Package\DitherUnit.pas',
  PngImage1 in '..\..\..\..\..\..\..\vcl\thtml9\Package\PngImage1.pas',
  PNGZLIB1 in '..\..\..\..\..\..\..\vcl\thtml9\Package\PNGZLIB1.pas',
  Readhtml in '..\..\..\..\..\..\..\vcl\thtml9\Package\ReadHTML.pas',
  HTMLGif1 in '..\..\..\..\..\..\..\vcl\thtml9\Package\HTMLGif1.pas',
  HTMLGif2 in '..\..\..\..\..\..\..\vcl\thtml9\Package\HTMLGif2.pas',
  Htmlsbs1 in '..\..\..\..\..\..\..\vcl\thtml9\Package\Htmlsbs1.pas',
  StylePars in '..\..\..\..\..\..\..\vcl\thtml9\Package\StylePars.pas',
  URLSubs in '..\..\..\..\..\..\..\vcl\thtml9\Package\URLSubs.pas',
*)

begin
  Application.Initialize;
  Application.CreateForm(TDMForDServer, DMForDServer);
  DMForDServer.SetDemoFacts('adv',
    'Lite Examples\whAppServer\dserver', True);
  DMForDServer.ProjMgr.ManageStartup;
  Application.Run;
end.

