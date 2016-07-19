unit whdemo_Initialize;  {Initialization code shared by the WebHub demos}

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2002-2016 HREF Tools Corp.  All Rights Reserved Worldwide. * }
{ *                                                                          * }
{ * This source code file is part of WebHub v3.2x.  Please obtain a WebHub   * }
{ * development license from HREF Tools Corp. before using this file, and    * }
{ * refer friends and colleagues to http://www.href.com/webhub. Thanks!      * }
{ ---------------------------------------------------------------------------- }

interface

uses
  SysUtils, Classes,
  webSend, webCall, htmlBase, whcfg_App;

function whDemoSetAppId(const whDemoAppID: string): Boolean;
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
      procedure DemoFrontDoorTriggered(Sender: TwhConnection;
        const ADesiredPageID: string);
    end;

var
  DemoHelperComponent: TDemoHelperComponent;

implementation

uses
  Forms,
  ZaphodsMap,
  ucCodeSiteInterface, ucPos, uCode, ucString, ucDlgs, MultiTypeApp, ucLogFil,
  {$IFNDEF PREVENTGUI}
  utPanFrm,
  {$ENDIF}
  whConst, webSplat,
  webApp, webInfoU, whMacroAffixes, htmConst, htWebApp,
  //whsample_DWSecurity, 
  whsample_PrototypeJS,
  whdemo_Extensions, whdemo_ViewSource,
  whpanel_Mail,
  whutil_ZaphodsMap, uAutoDataModules, uAutoPanels, whdemo_About;

function whDemoSetAppId(const whDemoAppID: string): Boolean;
const cFn = 'whDemoSetAppId';
begin
  CSEnterMethod(nil, cFn);
  Result := pWebApp <> nil;
  if Result then
  begin
    // Ensure that extra settings for demos are reset whenever app refreshes.
    AddAppUpdateHandler(DemoHelperComponent.DemoAppUpdate);
    pWebApp.OnAfterLoadFromConfig := DemoHelperComponent.DemoForceConfig;
    pWebApp.AppID := whDemoAppID;
    pWebApp.Refresh;  // instantiate nested components
    Result := pConnection <> nil;
    if Result then
      DemoHelperComponent.DemoAppUpdate(pWebApp) // call once
    else
      CSSendError(cFn + ': pConnection nil here');
  end
  else
    CSSendError(cFn + ': pWebApp nil here');


  CSExitMethod(nil, cFn);
end;

procedure whDemoCreateSharedDataModules;
const cFn = 'whDemoCreateSharedDataModules';
begin
  CSEnterMethod(nil, cFn);
  CreateStandardWHModules; // based on flags in app's config

  // The "view source" and "extensions" data modules are required
  // on lite.demos.href.com
  {M}Application.CreateForm(TDemoViewSource, DemoViewSource);
  {M}Application.CreateForm(TDemoExtensions, DemoExtensions);
  if False then
    {M}Application.CreateForm(TDMPrototypeJS, DMPrototypeJS); // Use JQuery...
  CSExitMethod(nil, cFn);
end;

procedure whDemoDestroySharedDataModules;
begin
  DestroyStandardWHModules;
  if False then
    FreeAndNil(DMPrototypeJS);
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
var
  ErrorText: string;
begin
  InitStandardWHModules;
  {$IFNDEF PREVENTGUI}
  TPackAllowDetach := False; // v3.247
  {$ENDIF}
  DemoExtensions.Init;  // initialize WebCycle, WebLogin
  if Assigned(DMPrototypeJS) then
    DMPrototypeJS.Init(ErrorText);
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
begin

  if Sender is TwhAppDynURLConfig then
  begin
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
    TwhAppStartup(Sender).SplashEnabled := True;
  end;

  { For developers transitioning from WebHub v2 to v3:
    One could force the project to load a particular syntax using this
    technique. The demos load their stage from the config file however.
    OnLoadProjectSyntax := DemoHelperComponent.DemoAppProjectSyntax;
    OnLoadProjectLingvo := DemoHelperComponent.DemoAppProjectLingvo;}
end;

procedure TDemoHelperComponent.DemoAppUpdate(Sender: TObject);
const cFn = 'DemoAppUpdate';
begin
  CSEnterMethod(Self, cFn);

  { To demonstrate the INDEX and other built-in pages, the demos use
    Security.BuiltInPagesEnabled True.  Normally, on a production server,
    Security.BuiltInPagesEnabled would be FALSE. }
  pWebApp.Security.BuiltInPagesEnabled := True;

  pWebApp.Security.CheckUserAgent := True;
  if pWebApp.AppID = 'showcase' then
  begin
    pWebApp.Situations.SideDoorPageIDs :=  // requires wh v3.258+ 19-Jun-2016
      'pgAWSStartFileUpload,pgAWSJqFileUpload,pgDownload';
  end;

  // HTTP 1.1 specification
  pWebApp.Response.HttpMajorVersion := 1;
  pWebApp.Response.HttpMinorVersion := 1;

  pWebApp.AppInfo.ShareSessions := True;
  pWebApp.AppInfo.ShareByFile := True;

  { Only set the homepage if it has not already been set in the config file. }
  if pWebApp.Situations.HomePageID = '' then
    pWebApp.Situations.HomePageID := 'pgWelcome';

  { All demo pages contain their own headers and footers as of 30-May-2004. }
  pWebApp.PageGeneration.AutoPageHeader := 'None';
  pWebApp.PageGeneration.AutoPageFooter := 'None';

  if Assigned(pConnection) then
  begin
    if pWebApp.Situations.FrontDoorPageID = '' then
    begin
      pConnection.OnFrontDoorTriggered := nil;
      CSSend('OnFrontDoorTriggered nil because there is no FrontDoorPageID');
    end
    else
    begin
      if Assigned(DemoHelperComponent) then
      begin
        pConnection.OnFrontDoorTriggered :=
          DemoHelperComponent.DemoFrontDoorTriggered;
        CSSend('OnFrontDoorTriggered := DemoHelperComponent.FrontDoorTriggered');
      end
      else
        CSSend('OnFrontDoorTriggered nil because DemoHelperComponent is nil');
    end;
  end
  else
    CSSend('OnFrontDoorTriggered nil because pConnection is nil');

  pWebApp.Debug.ErrorAlerts := [eaSummary, eaLogToFile];

  CSExitMethod(Self, cFn);
end;

procedure TDemoHelperComponent.DemoFrontDoorTriggered(Sender: TwhConnection;
  const ADesiredPageID: string);
const cFn = 'DemoFrontDoorTriggered';
var
  AllowedPages: string;
  story1: string;
begin
  CSEnterMethod(Self, cFn);

  AllowedPages := ',' + pWebApp.RemoteDesign.RemotePageIDs + ',' +
    pWebApp.Situations.FrontDoorPageID + ',' +
    pWebApp.Situations.SideDoorPageIDs + ',';
  //CSSend(cFn + ': aDesiredPageID', aDesiredPageID);
  //CSSend(cFn + ': AllowedPages', AllowedPages);

  if (PosCI(',' + aDesiredPageID + ',', AllowedPages) > 0) then
  begin
    {the desired page is on the list of allowed pages (for use with Dreamweaver)
     therefore we reverse the FrontDoor effect by resetting pWebApp.PageID }
    {or, the session number is the AdminSessionNumber so it is allowed in}
    pWebApp.PageID := aDesiredPageID;
    CSSend(cFn + ' Approved: ' + aDesiredPageID + ' instead of FrontDoor');
  end
  else
  begin
    story1 := 'PageID ' + aDesiredPageID +
      ' does not bypass the FrontDoor setting.';
    CSSend(story1);
    // the surfer will be bounced to the Frontdoor.
  end;
  CSExitMethod(Self, cFn);
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

initialization
  DemoHelperComponent := TDemoHelperComponent.create(nil);

finalization
  FreeAndNil(DemoHelperComponent);

end.
