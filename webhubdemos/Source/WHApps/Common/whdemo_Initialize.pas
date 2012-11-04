unit whdemo_Initialize;  {Initialization code shared by the WebHub demos}
////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2002-2012 HREF Tools Corp.  All Rights Reserved Worldwide.  //
//                                                                            //
//  This source code file is part of WebHub v2.09x.  Please obtain a WebHub   //
//  development license from HREF Tools Corp. before using this file, and     //
//  refer friends and colleagues to href.com/webhub for downloading. Thanks!  //
////////////////////////////////////////////////////////////////////////////////

interface

uses
  SysUtils, Classes,
  webSend, htmlBase, whcfg_App;

procedure whDemoSetAppId(const whDemoAppID: string);
procedure whDemoCreateSharedPanels;
procedure whDemoCreateSharedDataModules;
procedure whDemoInit;
procedure whDemoDestroySharedDataModules;
procedure whDemoDestroySharedPanels;

type
  TDemoHelperComponent = class(TComponent)
    private
    public
      procedure CalcDemoButtonLinks(Sender: TwhRespondingApp; var bContinue: Boolean);
      procedure DemoAppUpdate(Sender: TObject);
      procedure DemoForceConfig(Sender: TwhAppPropertyCategory);
    end;

var
  DemoHelperComponent: TDemoHelperComponent;

implementation

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  Forms,
  ZaphodsMap,
  MultiTypeApp, ucLogFil,
  whConst, webSplat,
  webApp, webInfoU, whMacroAffixes, htmConst, htWebApp,
  whsample_DWSecurity,
  webCall, whdemo_Extensions, whdemo_ViewSource,
  ucPos, uCode, ucString, ucDlgs, whpanel_Mail,
  whutil_ZaphodsMap, uAutoDataModules, uAutoPanels, whdemo_About,
  whdemo_Refresh;

procedure whDemoSetAppId(const whDemoAppID: string);
begin
  with pWebApp do
  begin
    // Ensure that extra settings for demos are reset whenever app refreshes.
    AddAppUpdateHandler(DemoHelperComponent.DemoAppUpdate);
    OnAfterLoadFromConfig := DemoHelperComponent.DemoForceConfig;
    AppID := whDemoAppID;
    Refresh;  // instantiate nested components
  end;
end;

procedure whDemoCreateSharedDataModules;
const cFn = 'whDemoCreateSharedDataModules';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(cFn);{$ENDIF}
  CreateStandardWHModules; // based on flags in app's config

  // The dmWhRefresh datamodule enables global refresh of all WebHub demos.
  {M}Application.CreateForm(TdmWhRefresh, dmWhRefresh);

  // The "view source" and "extensions" data modules are required
  // on demos.href.com
  {M}Application.CreateForm(TDemoViewSource, DemoViewSource);
  {M}Application.CreateForm(TDemoExtensions, DemoExtensions);
  {$IFDEF CodeSite}CodeSite.ExitMethod(cFn);{$ENDIF}
end;

procedure whDemoDestroySharedDataModules;
begin
  DestroyStandardWHModules;
  FreeAndNil(dmWhRefresh);
  FreeAndNil(DemoViewSource);
  FreeAndNil(DemoExtensions);
end;

var
 FlagDestroyOnce: Boolean = False;

procedure whDemoDestroySharedPanels;
begin
  if FlagDestroyOnce then Exit;
  FlagDestroyOnce := True;

  DestroyStandardWHModulesGUI;
  FreeAndNil(fmAppAboutPanel);
end;

procedure whDemoCreateSharedPanels;
begin
  {M}Application.Title := 'WebHub Demo: ' + pWebApp.AppID;
  {M}Application.CreateForm(TfmAppAboutPanel, fmAppAboutPanel);
  CreateStandardWHModulesGUI;
end;

procedure whDemoInit;
begin
  InitStandardWHModules;
  DemoExtensions.Init;  // initialize WebCycle, WebLogin
end;

procedure TDemoHelperComponent.CalcDemoButtonLinks(Sender: TwhRespondingApp;
  var bContinue: Boolean);
const
  HREFHome='http://www.href.com/';
  FarBackPhrase='[Back+]';
  litKey='litSpeedBack';
var
  s,s2:string;
  goHere:string;
begin
  {do not call inherited at the beginning, because that executes the
   App and the session# resets to 0.}
  //
  with Sender do begin
    if ComponentUpdated and assigned(Request) and assigned(Session)
    and (StringVar[litKey]='') then begin
      s:=Request.ServerVariables.Values['Referer'];
      //
      if (s='') then begin
        s:=HREFHome;
        end
      else begin
        s2:=lowercase(s);
        if (pos('.exe',s2)>0) OR (pos('.dll',s2)>0) then
          if Session.PriorAppIDPageID='' then
            {8.5a: PriorAppIDPageID is blank inside HubApp}
            goHere:=HREFHome  {exe with no way to get to app}
          else
          {added by John Molino to adjust for IIS 1.0 differences in Referer
           from Website CGI Referer....

           IIS keeps the '? + Session.PriorAppIDPageID + Session# included
           (eg. http://localhost/scripts/runisa.dll?AppID:PageID:Session#

           Website does not (eg. http://localhost/cgi-win/runwin.exe )}

           if pos('?',s)=0 then // add info for website-style
              goHere:=s+'?'+Session.PriorAppIDPageID+':'+IntToStr(SessionNumber)
            else
          {the condition is right but the cure may not be..
             gohere:=s+':'+IntToStr(Session)}
              gohere := s//+':'+IntToStr(Session)  --leave as is. M Ax.
        else
          gohere:=s;   {regular non-cgi referer}
        StringVar[litKey] := Format('%sHREF|%s|%s%s',
          [MacroStart, goHere, farBackPhrase, MacroEnd]);
        end;
      end;
    end;
end;

procedure TDemoHelperComponent.DemoForceConfig(Sender: TwhAppPropertyCategory);
var
  flagPublicDemos: Boolean;
begin

  // Find out whether we are running on a demos server, in production mode
  flagPublicDemos := IsEqual('demos', pWebApp.ZMDefaultMapContext) or
    IsEqual('doris', pWebApp.ZMDefaultMapContext);

  if Sender is TwhAppDynURLConfig then
  begin
    if flagPublicDemos and (pWebApp.AppID = 'dsp') then
    begin
      // 'dsp' is the default AppID on dsp.href.com, in StreamCatcher config
      TwhAppDynURLConfig(Sender).UseAppID := False;
    end
    else
      TwhAppDynURLConfig(Sender).UseAppID := True;
  end
  else
  if Sender is TwhAppSituations then
  begin
    TwhAppSituations(Sender).ChangedIPPageID := 'pgBadIP';
    TwhAppSituations(Sender).InvalidPageID := 'InvalidPage';
  end
  else
  if Sender is TwhAppStartup then
  begin
    TwhAppStartup(Sender).SplashEnabled := True;  // ensure splash on all demos
  end;
    { One could force the project to load a particular syntax using this
      technique. The demos load their stage from the config file however.
    OnLoadProjectSyntax := DemoHelperComponent.DemoAppProjectSyntax;
    OnLoadProjectLingvo := DemoHelperComponent.DemoAppProjectLingvo;}
end;

procedure TDemoHelperComponent.DemoAppUpdate(Sender: TObject);
begin
  with pWebApp do
  begin
    { To demonstrate the INDEX and other built-in pages, the demos use
      Security.BuiltInPagesEnabled True.  Normally, on a production server,
      Security.BuiltInPagesEnabled would be FALSE. }
    Security.CheckSurferIP := True;  // See also: TwhAppBase.OnBadIP handler.
    Security.BuiltInPagesEnabled := True;

    // HTTP 1.1 specification
    Response.HttpMajorVersion := 1;
    Response.HttpMinorVersion := 1;

    AppInfo.ShareSessions := True;
    AppInfo.ShareByFile := True;

    {Only set the homepage if it has not already been set in the config file.}
    if Situations.HomePageID = '' then
      Situations.HomePageID := 'pgWelcome';

    {All demo pages contain their own headers and footers as of 30-May-2004.}
    PageGeneration.AutoPageHeader := 'None';
    PageGeneration.AutoPageFooter := 'None';

    if Assigned(pConnection) then
    begin
      if Situations.FrontDoorPageID = '' then
        pConnection.OnFrontDoorTriggered := nil
      else
        pConnection.OnFrontDoorTriggered :=
          dmDWSecurity.FrontDoorTriggered;
    end;

    Debug.ErrorAlerts := [eaSummary, eaLogToFile];
  end;
  WebMessage('0');
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

initialization
  DemoHelperComponent := TDemoHelperComponent.create(nil);

finalization
  FreeAndNil(DemoHelperComponent);

end.
