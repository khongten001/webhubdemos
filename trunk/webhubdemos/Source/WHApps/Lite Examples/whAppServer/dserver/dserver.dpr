program dserver;  { WebHub App EXE for use by HREF/inhouse with Dreamweaver }

// Usage: dserver.exe /ID:AppID

(* See "How to Work with WebHub Demos.rtf" in the webhubdemos\source\docs folder
   for information about "drives" H: and K:. *)

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'k:\webhub\tpack\tpProj.pas',
  utPanFrm in 'h:\utPanFrm.pas' {utParentForm},
  utMainFm in 'h:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'h:\utTrayFm.pas' {fmTrayForm},
  uCode,
  htWebApp in 'k:\webhub\lib\htWebApp.pas',
  dserver_whdmGeneral in 'dserver_whdmGeneral.pas' {dmwhGeneral: TDataModule},
  dserver_dmProjMgr in 'dserver_dmProjMgr.pas' {DMForDServer: TDataModule},
  whdemo_About in '..\..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Extensions in '..\..\..\Common\whdemo_Extensions.pas',
  whdemo_Initialize in '..\..\..\Common\whdemo_Initialize.pas',
  whdemo_Refresh in '..\..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whdemo_ViewSource in '..\..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_ColorScheme in '..\..\..\Common\whdemo_ColorScheme.pas' {DataModuleColorScheme: TDataModule},
  webSend in 'k:\webhub\lib\whvcl\webSend.pas',
  webApp in 'k:\webhub\lib\whvcl\webApp.pas',
  whcfg_App in 'K:\WebHub\lib\whcfg_App.pas',
  webCall in 'K:\WebHub\lib\whvcl\webCall.pas';

{$R dserver_version.RES}
{$R WHDICON.RES}   // dserver tray icon
{$R HTICONS.RES}   // component icons for combo bar (not essential)
{$R HTGLYPHS.RES}  // icons for WebHub UI features

(* save for compiling with source

// Search path for HREF Tools in-house usage:
// k:\webhub\Lib;k:\webhub\Lib\whvcl;k:\webhub\Lib\WHRun;k:\webhub\Lib\WHRun\ISAPI;k:\webhub\Lib\WHEditors;k:\webhub\Lib\WHPlus;k:\webhub\Lib\WHDB;k:\webhub\TPack;k:\webhub\regex;

  webCore in 'k:\webhub\lib\whvcl\webCore.pas',
  webVars in 'k:\webhub\lib\webVars.pas',
  webSend in 'k:\webhub\lib\whvcl\webSend.pas',
  webApp in 'k:\webhub\lib\whvcl\webApp.pas',

  ucAnsiUtil in 'k:\webhub\tpack\ucAnsiUtil.pas',
  whAppOut in 'k:\webhub\lib\whAppOut.pas',
  NativeXml in 'K:\WebHub\ZaphodsMap\NativeXml.pas',
  tpMemo in 'k:\webhub\tpack\tpMemo.pas',
  ZaphodsMap in 'K:\WebHub\ZaphodsMap\ZaphodsMap.pas',
  ucFile in 'K:\WebHub\tpack\ucFile.pas',
  ucString in 'K:\WebHub\tpack\ucString.pas',
  ucLogFil in 'k:\webhub\tpack\ucLogFil.pas',
  ucPos in 'k:\webhub\tpack\ucPos.pas',
  cgiVars in 'k:\webhub\Lib\WHRun\cgiVars.pas',
  apiBuilt in 'K:\WebHub\lib\whrun\apiBuilt.pas',
  apiStat in 'K:\WebHub\lib\whrun\apiStat.pas',
  apiMail in 'k:\webhub\Lib\WHRun\apiMail.pas',
  ipcMail in 'K:\WebHub\lib\whrun\ipcMail.pas',
  webAjax in 'K:\WebHub\lib\whplus\webAjax.pas',
  webTypes in 'K:\WebHub\lib\webTypes.pas',
  webRead in 'K:\WebHub\lib\whvcl\webRead.pas',
  webBase in 'k:\webhub\Lib\WHVCL\webBase.pas',
  webCall in 'K:\WebHub\lib\whvcl\webCall.pas',
  htStrWWW in 'K:\WebHub\lib\whvcl\htStrWWW.pas',
  htStream in 'k:\webhub\Lib\WHVCL\htStream.pas',
  cgiServ in 'K:\WebHub\lib\whvcl\cgiServ.pas',
  htmlCore in 'K:\WebHub\lib\whvcl\htmlCore.pas',
  whsample_DWSecurity in 'k:\webhub\lib\whsample_DWSecurity.pas',
  webApp in 'K:\WebHub\lib\whvcl\webApp.pas',
  htmConst in 'K:\WebHub\lib\whvcl\htmConst.pas',
  whcfg_App in 'K:\WebHub\lib\whcfg_App.pas',
  webServ in 'K:\WebHub\lib\whvcl\webServ.pas',
  *)

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

var
  DemoAppID: string;

begin
  Application.Initialize;
  Application.CreateForm(TDMForDServer, DMForDServer);

  {$IFDEF PREVENTSVCMGR}
  if HaveParam('/id') then
    ParamValue('id', DemoAppID)
  else
    DemoAppID := 'adv';
  {$ELSE}
  DemoAppID := 'adv';
  {$ENDIF}

  DMForDServer.SetDemoFacts(DemoAppID, 'Lite Examples\whAppServer',
    True);
  DMForDServer.ProjMgr.ManageStartup;
  Application.Run;
end.

