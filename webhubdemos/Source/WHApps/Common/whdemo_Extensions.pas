unit whdemo_Extensions;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 1998-2016 HREF Tools Corp.  All Rights Reserved Worldwide. * }
{ *                                                                          * }
{ * This source code file is part of WebHub v3.2x.  Please obtain a WebHub   * }
{ * development license from HREF Tools Corp. before using this file, and    * }
{ * refer friends and colleagues to http://www.href.com/webhub. Thanks!      * }
{ ---------------------------------------------------------------------------- }

// This unit must be created AFTER the TwhApplication component exists.

{$I hrefdefines.inc}

interface

uses
  Windows, SysUtils, Classes, Controls,
  System.Actions, Vcl.ActnList,
  MultiTypeApp, updateOk, tpAction, tpActionGUI, tpShareI,
  whcfg_App, webSend, webTypes, webLink, webCycle, webLogin, webCaptcha;

type
  TDemoExtensions = class(TDataModule)
    webLogin: TwhLogin;
    webCycle: TwhCycle;
    waVersionInfo: TwhWebAction;
    waGetExename: TwhWebAction;
    waLSec: TwhWebAction;  // secure link feature
    waDelaySec: TwhWebAction;
    waDemoCaptcha: TwhCaptcha;
    waImgSrc: TwhWebAction;
    FEATURE: TwhWebAction;
    waCheckSubnet: TwhWebAction;
    waFromList: TwhWebAction;
    waCauseAV: TwhWebAction;
    waWaitSeconds: TwhWebAction;
    waSimulateBadNews: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure waGetExenameExecute(Sender: TObject);
    procedure waVersionInfoExecute(Sender: TObject);
    procedure waLSecExecute(Sender: TObject);
    procedure waDelaySecExecute(Sender: TObject);
    procedure waImgSrcExecute(Sender: TObject);
    procedure FEATUREExecute(Sender: TObject);
    procedure waCheckSubnetExecute(Sender: TObject);
    procedure waFromListExecute(Sender: TObject);
    procedure waCauseAVExecute(Sender: TObject);
    procedure waWaitSecondsExecute(Sender: TObject);
    procedure waSimulateBadNewsExecute(Sender: TObject);
  strict private
    { Private declarations }
    FMonitorFilespec: string; // for use with WebHubGuardian
    FAdminIpNumber: string;
    FServerIpNumber: string;
    FDomainIDList: TStringList;
    function IsHREFToolsQATestAgent: Boolean;
  protected
    procedure DemoAppExecute(Sender: TwhRespondingApp; // uses webSend
      var bContinue: Boolean);
    procedure DemoAppUpdate(Sender: TObject);
    procedure DemoAppNewSession(Sender: TObject; InSessionNumber: Cardinal;
      const Command: string);
    procedure DemoAppPageComplete(Sender: TwhRespondingApp;
      const PageContent: UTF8String);
    procedure DemoAppPageErrors(Sender: TwhAppDebug; var Continue: Boolean);
  public
    { Public declarations }
    procedure DemoAppBadIP(Sender: TwhRespondingApp; var bContinue: Boolean);
    procedure DemoAppBadBrowser(Sender: TwhRespondingApp;
      var bContinue: Boolean);
    procedure DemoAppExceptionHandler(Sender: TObject; E: Exception;
      var Handled, ReDoPage: Boolean);
    function Init: Boolean;
    function IsSuperuser(const InSurferIP: string): Boolean;
  end;

var
  DemoExtensions: TDemoExtensions = nil;

implementation

uses
  {$IFDEF EUREKALOG}ExceptionLog7, EExceptionManager,{$ENDIF}
  DateUtils, Math, TypInfo,
  ucVers, ucString, ucBase64, ucLogFil, ucPos, ucCodeSiteInterface, uCode,
  whConst, webApp, htWebApp, whMacroAffixes, webCore, whutil_ZaphodsMap,
  webSock, runConst, whcfg_AppInfo, whSharedLog, whxpGlobal, webCall,
  whdemo_ViewSource;

{$R *.DFM}

type
  TVersionType = (vtExe, vtWHsetupdate);

var
  FlagBeenHere: Boolean = False;

function TDemoExtensions.Init: Boolean;
const cFn = 'Init';
var
  ExtraConfigFilespec: string;
begin
  CSEnterMethod(Self, cFn);
  Result := True;
  // make the components in this data module refresh
  // when the app object updates.
  Assert(Assigned(pWebApp));

  if NOT FlagBeenHere then
  begin
    FEATURE.SilentExecution := True; // requires WebHub v3.217+
    
    AddAppUpdateHandler(DemoAppUpdate);
    // without this, changes to AppID will not refresh the mail panel.
    AddAppExecuteHandler(DemoAppExecute);

    pWebApp.OnError := DemoAppExceptionHandler;

    // Extra configuration path containing pairs of domain=id entries
    // Example:  lite.demos.href.com=1
    // Example:  db.demos.href.com=2
    // Example:  dsp.href.com=3
    ExtraConfigFilespec := pWebApp.AppPath + '..\Config\DomainIDList.ini';
    if FileExists(ExtraConfigFilespec) then
    begin
      FDomainIDList := TStringList.Create;
      FDomainIDList.LoadFromFile(pWebApp.AppPath + '..\Config\DomainIDList.ini');
      FDomainIDList.Sorted := True;
    end;

    pWebApp.OnBadBrowser := DemoAppBadBrowser;
    pWebApp.OnBadIP := DemoAppBadIP;
    pWebApp.OnNewSession := DemoAppNewSession;
    pWebApp.OnPageComplete := DemoAppPageComplete;

    {$IFDEF Log2CSL}UseWebHubSharedLog;{$ENDIF}

    DemoAppUpdate(nil);   // do this once
    
    FlagBeenHere := True;
  end;


  CSExitMethod(Self, cFn);
end;

function TDemoExtensions.IsHREFToolsQATestAgent: Boolean;
begin
  with pWebApp do
    Result := (SessionID = Security.AdminSessionID) and
      (Request.UserAgent = 'HREF Tools QA Test Agent');
end;

function TDemoExtensions.IsSuperuser(const InSurferIP: string): Boolean;
const cFn = 'IsSuperuser';

  function IP_ABC(const ipv4: string): string;
  var
    x: Integer;
  begin
    // A.B.C.D
    x := StrRScanPos(ipv4, '.');  // from 123.123.22.1 to 123.123.22
    Result := Copy(ipv4, 1, Pred(x));
  end;

begin
  CSEnterMethod(Self, cFn);

  if Assigned(pWebApp) and pWebApp.IsUpdated then
  begin
    // compare A.B.C without .D
    Result := IP_ABC(InSurferIP) = IP_ABC(FServerIpNumber);
  end
  else
    Result := False;

  if (NOT Result) and (FAdminIpNumber <> '') then
    Result := (InSurferIP = FAdminIpNumber) or  // extra WAN override
      (InSurferIP = '127.0.0.1');
  CSExitMethod(Self, cFn);
end;

// ------------------------------------------------------------------------------

procedure TDemoExtensions.DemoAppUpdate(Sender: TObject);
const cFn = 'DemoAppUpdate';
var
  AdminFilespec: string;
begin
  CSEnterMethod(Self, cFn);

  pWebApp.Security.CheckSurferIP := True;
  pWebApp.Security.CheckUserAgent := True;
  pWebApp.Debug.OnBeforeSendPageErrors := DemoAppPageErrors;

  // Note: the only likely reason these pointers would be nil
  // is when this unit is used within the WebHub Editor, which frees
  // them because they are n/a.
  if Assigned(webLogin) then
    // reload the user list based on the current AppID.
    webLogin.Refresh;
  if Assigned(webCycle) then
    // reload the cycle list information
    webCycle.Refresh;

  AdminFilespec := getHtDemoWWWRoot + '..\Config\remoteadmin.txt';

  if FileExists(AdminFilespec) then
    FAdminIpNumber := Trim(StringLoadFromFile(AdminFilespec))
  else
    FAdminIpNumber := '';
  if FAdminIpNumber <> '' then
    {$IFNDEF LogSTime}CSSend(cFn + ': FAdminIpNumber', FAdminIpNumber){$ENDIF}
  else
    LogSendError(cFn + ': File not found or empty: ' + AdminFilespec);

  {$IFNDEF LogSTime}
  CSSend('pWebApp.DynURL.CurrentServerProfile.Authority',
    pWebApp.DynURL.CurrentServerProfile.Authority);
  {$ENDIF}

  FServerIpNumber := HostToIPv4(LeftOf(':',
      pWebApp.DynURL.CurrentServerProfile.Authority));
  {$IFNDEF LogSTime}CSSend('FServerIpNumber', FServerIpNumber);{$ENDIF}

  SetCodeSiteLoggingStateFromText(pWebApp.AppSetting['CodeSiteLogging']);

  CSExitMethod(Self, cFn);
end;

procedure TDemoExtensions.FEATUREExecute(Sender: TObject);
var
  InputData: string;
  Flag: Boolean;
begin
  InputData := FEATURE.HtmlParam;

  if IsEqual(LeftOfEqual(InputData), 'SilentUnrecognizedExpressions') then
  begin
    Flag := IsEqual(RightOfEqual(InputData), 'true'); // case insensitive
    pWebApp.Debug.SilentUnrecognizedExpressions := Flag;
  end
  else
    pWebApp.Debug.AddPageError('invalid FEATURE syntax: ' + InputData);
end;

procedure TDemoExtensions.DataModuleCreate(Sender: TObject);
const
  cFn = 'DataModuleCreate';
begin
  CSEnterMethod(Self, cFn);
  FMonitorFilespec := ''; // for use with WebHubGuardian
  FDomainIDList := nil;
  CSExitMethod(Self, cFn);
end;

procedure TDemoExtensions.DataModuleDestroy(Sender: TObject);
begin
  if FMonitorFilespec <> '' then
  begin
{$IFDEF Delphi12Up}{$INLINE OFF}{$ENDIF}
    DeleteFile(FMonitorFilespec);
  end;
  FreeAndNil(FDomainIDList);
  DemoExtensions := nil;
end;

procedure TDemoExtensions.waVersionInfoExecute(Sender: TObject);
var
  S: TwhString;

  function GetVersionInfo(versionType: TVersionType): string;
  begin
    if versionType = vtExe then
      Result := GetVersionDigits(False)
    else if versionType = vtWHsetupdate then
      Result := GetVersionString('whSetupDate')
    else
      Result := '';
  end;

  function GetVersionInformation(const S: string): string;
  begin
    if IsEqual(S, 'exeversion') then
      Result := GetVersionInfo(vtExe)
    else if IsEqual(S, 'whSetupDate') then
      Result := GetVersionInfo(vtWHsetupdate)
    else
      Result := GetVersionString(S);
  end;

begin
  inherited;
  S := (GetVersionInformation(waVersionInfo.HtmlParam));
  if S <> '' then
    pWebApp.SendStringImm(S)
  else
  begin
    pWebApp.Debug.AddPageError
      (Format('%s Syntax: .execute|[ExeVersion|whSetupDate|version-property-name]',
      [waVersionInfo.Name]));
  end;
end;

procedure TDemoExtensions.waWaitSecondsExecute(Sender: TObject);
const cFn = 'waWaitSecondsExecute';
var
  S1: string;
  i, n: Integer;
begin
  CSEnterMethod(Self, cFn);

  // use this to introduce an artifical delay into page processing
  // see pgIntentionallySlow in webhubdemos
  S1 := TwhWebAction(Sender).HtmlParam;
  S1 := pWebApp.MoreIfParentild(S1);
  n := StrToIntDef(s1, 5);
  for i := 1 to n do
  begin
    Sleep(1000);
    Application.ProcessMessages;
  end;
  CSExitMethod(Self, cFn);
end;

procedure TDemoExtensions.waCauseAVExecute(Sender: TObject);
const cFn = 'waCauseAVExecute';
var
  y: TStringList;
begin
  CSEnterMethod(Self, cFn);
  y := nil;
  y.Add('abc');  // intentional access violation
  CSExitMethod(Self, cFn);
end;

procedure TDemoExtensions.waCheckSubnetExecute(Sender: TObject);
var
  SurferIP: string;
  Flag: Boolean;
  DestYesPageID, DestNoPageID: string;
begin
  SurferIP := pWebApp.Request.RemoteAddress;

  Flag := IsSuperuser(SurferIP);

  if SplitString(TwhWebAction(Sender).HtmlParam, '||', DestYesPageID,
    DestNoPageID) then
  begin
    if Flag then
    begin
      if DestYesPageID = 'just continue' then
        // nothing
      else
      begin
        if Copy(DestYesPageID, 1, 2) = MacroStart then
          pWebApp.Response.Send(DestYesPageID)
        else
          pWebApp.Response.SendBounceToPage(DestYesPageID, '');
      end;
    end
    else
    begin
      if DestNoPageID = 'just continue' then
        // nothing
      else
      begin
        if Copy(DestNoPageID, 1, 2) = MacroStart then
          pWebApp.Response.Send(DestNoPageID)
        else
          pWebApp.Response.SendBounceToPage(DestNoPageID, '');
      end;
    end;
  end
  else
    pWebApp.Debug.AddPageError(TwhWebAction(Sender).Name +
      ' requires 2 parameters such as PageID, a command, or "just continue"');
end;

procedure TDemoExtensions.waDelaySecExecute(Sender: TObject);
var
  SecondsToDelay: Integer;
begin
  SecondsToDelay := StrToIntDef(TwhWebAction(Sender).HtmlParam, 0) * 1000;
  Sleep(SecondsToDelay);
end;

procedure TDemoExtensions.waFromListExecute(Sender: TObject);
var
  mcListName, InnerPairSeparator, Key: string;
  s1, s2: string;
  sLeft, sRight: string;
const
  OuterPairSeparator = ',';   // required separator within Macro lists.
begin
  with TwhWebAction(Sender) do
  begin
    if SplitThree(HtmlParam, '|', mcListName, InnerPairSeparator, Key) then
    begin
      s2 := WebApp.Macros.Values[mcListName];
      Key := pWebApp.MoreIfParentild(Key);
      while s2 <> '' do
      begin
        SplitString(s2, OuterPairSeparator, s1, s2);
        if SplitString(s1, InnerPairSeparator, sLeft, sRight) then
        begin
          if sLeft = Key then
          begin
            Response.Send(sRight);
            break;
          end;
        end;
      end;
    end;
  end;
end;

procedure TDemoExtensions.waGetExenameExecute(Sender: TObject);
begin
  inherited;
  pWebApp.SendString(ExtractFilename(FilePathAndNameForModule));
end;

procedure TDemoExtensions.waImgSrcExecute(Sender: TObject);
const cFn = 'waImgSrcExecute';
var
  AFilespec: string;
begin
  {This is meant to be used to send a JPG file plus an optional cookie.
   Reference the WebHub Demo "FAST" and look at the Order Form button.
   November 2011
  }
  with TwhWebAction(Sender) do
  begin
    if HtmlParam <> '' then
    begin
      if WebApp.Expand(HtmlParam) <> '' then
        AFilespec := getWebHubDemoInstallRoot + WebApp.Expand(HtmlParam)
      else
        AFilespec := getWebHubDemoInstallRoot + HtmlParam;
      if FileExists(AFilespec) then
      begin
        WebApp.Response.Flush;
        if WebApp.AppInfo.SessionNumberLocation in
          [whsnlCookieFixedDomain, whsnlCookieVaryDomain] then
        begin
          // extremely important to use Request.Host here, rather than
          // Security.CookieDefaultDomain, so that this particular cookie
          // comes from the same place as the JPEG file.
          WebApp.AddCookieWithSessionNumber(True, WebApp.Request.Host);
        end;
        WebApp.Response.SendFileIIS(AFilespec, 'image/jpeg', False);
      end
      else
      begin
        LogSendError(cFn + ': File not found: ' + AFilespec);
      end;
    end;
  end;
end;

procedure TDemoExtensions.waLSecExecute(Sender: TObject);
var
  PossibleBypass: string;
  ACutOff: string;
  CutOff: TDateTime;
  y, m, d, h, n: Integer;
  temp, temp2: string;
  ASeconds: TwhString;
  NSeconds: Integer;
  // S8: UTF8String;
  S16: TwhString;

  function MakeOutgoingToken: string;
  begin
    Result := Format('ok until %s',
      [FormatDateTime('yyyymmdd hhnn', IncSecond(Now, NSeconds))]);
  end;

begin
  with TwhWebAction(Sender) do
  begin
    if (Copy(HtmlParam, 1, 3) = 'out') then
    begin
      SplitString(HtmlParam, ',', temp, temp2);
      ASeconds := webApp.MoreIfParentild(ASeconds);
      NSeconds := StrToIntDef(string(ASeconds), 120);
      S16 := Format('%s.%s', [Name, Code64String(MakeOutgoingToken)]);
      webApp.SendStringImm(S16);
    end
    else if IsEqual(HtmlParam, 'in') then
    begin
      webApp.BoolVar['_lowerSecurity'] := False;
      // decode
      if Command <> '' then
      begin
        try
          PossibleBypass := UnCode64String(Command);
        except
          PossibleBypass := ''; // failed decode process
        end;
        if pos('ok until ', PossibleBypass) > 0 then
        begin
          ACutOff := Copy(PossibleBypass, 10, MaxInt);
          try
            y := StrToIntDef(Copy(ACutOff, 1, 4), 0);
            m := StrToIntDef(Copy(ACutOff, 5, 2), 0);
            d := StrToIntDef(Copy(ACutOff, 7, 2), 0);
            h := StrToIntDef(Copy(ACutOff, 10, 2), 0);
            n := StrToIntDef(Copy(ACutOff, 12, 2), 0);
            CutOff := EncodeDateTime(y, m, d, h, n, 0, 0);
            if Now <= CutOff then
            begin
              // grant lower security
              webApp.BoolVar['_lowerSecurity'] := True;
            end;
          except
          end;
        end;
      end;
    end
    else
      pWebApp.Debug.AddPageError(Format('%s Invalid param: %s',
        [Name, HtmlParam]));
  end;
end;

procedure TDemoExtensions.waSimulateBadNewsExecute(Sender: TObject);
var
  AKeyword: string;
begin
  AKeyword := TwhWebAction(Sender).HtmlParam;
  if AKeyword = 'HubNotFound' then
    pWebApp.Response.SimulateHubNotFound
  else
  if AKeyword = 'AppNotRunning' then
    pWebApp.Response.SimulateAppNotRunning
  else
  if AKeyword = 'RequestTimeout' then
    pWebApp.Response.SimulateRequestTimeout(35)
  else
  if AKeyword = 'AppIDBusy' then
    pWebApp.Response.SimulateAppIDBusy
  else
  if AKeyword = 'AppCoverPage' then
    pWebApp.Response.SimulateAppCoverPage(Now, 5, 'testing system messages')
  else
  begin
    pWebApp.SendStringImm(Self.ClassName + ': invalid syntax');
    pWebApp.Response.Close;
  end;
end;

function HonorLowerSecurity: Boolean;
begin
  Result := False;
  if (pos('waLSec', pWebApp.Command) > 0) then
  begin
    { This can be set by waLSec web action, in WebHub Demos. }
    pWebApp.Expand(MacroStart + 'waLSec.execute|in' + MacroEnd);
    if pWebApp.BoolVar['_LowerSecurity'] then
    begin
      pWebApp.StringVar['_BypassAllowed'] :=
        FormatDateTime('dddd hh:nn:ss:zzz', Now);
      pWebApp.BoolVar['_LowerSecurity'] := False; // immediately reset
      Result := True;
    end;
  end;
end;

const
  cUnitName = 'whdemo_Extensions';

procedure TDemoExtensions.DemoAppBadBrowser(Sender: TwhRespondingApp;
  var bContinue: Boolean);
const
  cFn = 'DemoAppBadBrowser';
begin
{ processing to catch cases where a surfers changes browsers in mid-session.
  while this may be a nice thing to do during development, we default this
  to reject the session unconditionally. }

  {$IFDEF LOGBAD}CSEnterMethod(Self, cFn);{$ENDIF}
  inherited;

  {NB: OnBadBrowser is NOT called when IsWebRobotRequest is True.}
  //Assert(NOT Sender.IsWebRobotRequest);

  { Sender is essentially pWebApp here. }

  { bContinue defaults to false and will produce a fixed-format error
    message unless we reset it here. resetting the value also allows
    us to provide a custom message based on a page in app-defaults below: }
  bContinue := True;

  {$IFDEF LOGBAD}
  CSSend(Format('PageID ?= Sender.Session.PriorPageID... (%s ?= %s)',
    [Sender.PageID, Sender.Session.PriorPageID]),
    S(Sender.PageID = Sender.Session.PriorPageID));

  CSSend(Format('Command ?= Sender.Session.PriorCommand... (%s ?= %s)',
    [Sender.Command, Sender.Session.PriorCommand]),
    S(Sender.Command = Sender.Session.PriorCommand));

  CSSend(Format(
    'UserAgentHash(Request.UserAgent) ?= Session.UserAgentID... (%s ?= %s)',
    [UserAgentHash(Sender.Request.UserAgent), Sender.Session.UserAgentID]),
    S(UserAgentHash(Sender.Request.UserAgent) = Sender.Session.UserAgentID));
  {$ENDIF}

  //if (Session.UserAgentID = FHashGoogleMediaPartners) {1 request ago} then
  //begin
  //  { Do NOTHING because human was just interrupted by MediaPartner }
  //  CSSend('Allowing user agent change because ' +
  //    'prior request was from a Google MediaPartner');
  //end
  //else
  //if (PageID = Sender.Session.PriorPageID) and
  //   (Command = Sender.Session.PriorCommand) and
  //   (Request.UserAgent = 'Mediapartners-Google') {now} then
  //begin
    {When using Google Adsense, the bot will always echo the request of the
     surfer, as the advertisement is being chosen.  For this reason,
     Mediapartners-Google is no longer on the StreamCatcher list of webrobots.
     Checking the prior PageID and Command increases security (good) but
     cannot work reliably if your WebHub site is in a frameset (sorry). For
     use within framesets, you will need to customize the if-statement above.
     30-March-2011. }

    {Do NOTHING -- do NOT reject the request.}
  //  CSSend('Allowing user agent change ' +
  //    'to Google MediaPartner');

  //end
  //else
  begin
    if Sender.Situations.ChangedUserAgentPageID <> '' then
      Sender.PageID := Sender.Situations.ChangedUserAgentPageID
    else
      Sender.PageID := Sender.Situations.HomePageID;
    Sender.RejectSession(cUnitName + ', ' + cFn + '()');
  end;
  {$IFDEF LOGBAD}CSExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDemoExtensions.DemoAppBadIP(Sender: TwhRespondingApp;
  var bContinue: Boolean);
const cFn = 'DemoAppBadIP';
var
  b: Boolean;
begin
{ processing to catch cases where a surfers IP# changes in mid-session,
  it rejects continuation if the refering page is not in the same domain
  as the server producing this page. catches someone copying a session#
  This code is only called if TwhAppBase.Security.CheckSurferIP is true.
  It is false by default. }
  {$IFDEF LOGBAD}CSEnterMethod(Self, cFn);{$ENDIF}
  inherited;
  // bContinue defaults to false and will produce a fixed-format error
  // message unless we reset it here. Resetting the value also allows
  // us to provide a custom message.
  bContinue := True;

  b := NOT IsHREFToolsQATestAgent;
  if b then
  begin
    with Sender, Request do
    begin
      // determine the domain
      if PosCI(ExtractParentDomain(Request.Host) + '.', Referer) > 0 then
      begin
        { The surfer's IP changed and the referer includes the domain
          of this server. let it go by!

          Please Note: The NT HOSTS file can make your browser believe that
          it is a machine on an arbitrary domain. This makes this check
          undesirable if you are positive that all your client machines
          are going to be on static IPs.. for the general public though,
          this is probably as good as you will get it without resorting
          to storing a cookie on the user's machine. }
        {$IFDEF LOGBAD}CSSend('allow based on referer');{$ENDIF}
        b := False;
      end;

      if b and (PosCI('AOL', Request.UserAgent) > 0) then
      begin
        { AOL has a long history of pooling requests by its users among many
          IP numbers so it is very normal for an AOL browser to change IP numbers
          in the middle of a session.  Allow this.
          Reconfirmed 18-Apr-2008 }
        {$IFDEF LOGBAD}CSSend('AOL');{$ENDIF}
        b := False;
      end;

      if b and HonorLowerSecurity then
      begin
        {$IFDEF LOGBAD}CSSend('HonorLowerSecurity');{$ENDIF}
        b := False;
      end;

      if b then
      begin
        if Situations.ChangedIPPageID <> '' then
          PageID := Situations.ChangedIPPageID
        else
          PageID := Situations.HomePageID;
        {$IFDEF LOGBAD}CSSend('PageID', PageID);{$ENDIF}
        RejectSession(cUnitName + ', ' + cFn + '()', False);
      end;
    end;
  end
  else
    {$IFDEF LOGBAD}CSSend('Allow HREFTools Quality Assurance Agent'){$ENDIF};
    
  {$IFDEF LOGBAD}CSExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDemoExtensions.DemoAppNewSession(Sender: TObject;
  InSessionNumber: Cardinal; const Command: string);
const
  cFn = 'DemoAppNewSession';
var
  bNewSessionInURL: Boolean;
  bForceNewSession: Boolean;
  QueryStringWithoutCommand: string;
  x: Integer;
  bKeepChecking: Boolean;
const
  cDomainLevels = 3; // demos.href.com has 3 levels.
begin
  //CSEnterMethod(Self, cFn);
  inherited;
  bKeepChecking := InSessionNumber <> 0;

  { web robots are expected to come in with a (single) session number. }
  { v3.204: Security.ReadOnlySession }
  if bKeepChecking then
    bKeepChecking := NOT pWebApp.IsReadOnlySessionNumber(InSessionNumber);

  if bKeepChecking then
    bKeepChecking := Assigned(pWebApp) and pWebApp.IsUpdated;
  if bKeepChecking then
    bKeepChecking := NOT IsHREFToolsQATestAgent;

  if bKeepChecking then
  begin
    with pWebApp do
    begin

      // implement new-session security.
      bForceNewSession := False;

      // Avoid continuous loops which can occur when sessionid is also
      // part of the command string, specifically when RejectSession(.., True)
      // is called and waRSPrior is involved   06-Sep-2011
      if pWebApp.Command = '' then
        x := 0
      else
        x := pos(pWebApp.Command, Request.QueryString);
      QueryStringWithoutCommand := Copy(Request.QueryString, 1,
        IfThen(x > 0, Pred(x), MaxInt));
      // Check the query string, avoiding the command portion
      bNewSessionInURL := pos(IntToStr(InSessionNumber),
        QueryStringWithoutCommand) > 0;
      if HonorLowerSecurity then
      begin
        // do nothing -- allow the page to run
      end
      else
      begin
        if bNewSessionInURL then
        begin
          {$IF Defined(CodeSite) and (NOT Defined(LogSTime))}
          CSSend('bNewSessionInURL', S(bNewSessionInURL));
          CSSendNote(Request.QueryString);
          {$IFEND}
          { user comes in from a bookmark or a search engine }
          bForceNewSession :=
            (PosCI(ExtractParentDomain(Request.Host, cDomainLevels),
            Request.Referer) = 0);
        end
        else
        begin
          {$IF Defined(CodeSite) and (NOT Defined(LogSTime))}CSSend(Self.Name + #183 + cFn + #183 +
            'HaveSessionCookie',
            GetEnumName(TypeInfo(TwhSessionNumberCookieState), Ord(HaveSessionCookie)));
          {$IFEND}
          if (HaveSessionCookie = whsncPresent) then
          begin
            { worst case.. user fakes a cookie or comes back days later with the
              non-stored session cookie still loaded in the browser }
            CSSendError('unexpected session cookie in ' + cFn);
            bForceNewSession := True;
          end;
        end;
      end;

      if bForceNewSession then
        RejectSession(cUnitName + ', ' + cFn + '()', False);  // was True
    end;
  end;
  //CSExitMethod(Self, cFn);
end;

var
  TestNumber: Integer = 0;

procedure TDemoExtensions.DemoAppPageComplete(Sender: TwhRespondingApp;
  const PageContent: UTF8String);
var
  S: string;
  AFolder, AFilename: string;
begin
  if IsHREFToolsQATestAgent and
    (Sender.SessionID = pWebApp.Security.AdminSessionID) then
  begin
    { archive page content for functionality test sequences }
    S := pWebApp.Request.Headers.Values['X-Selenium-PageCount'];
    if S <> '' then
      TestNumber := StrToIntDef(S, 1)
    else
      Inc(TestNumber);

    AFolder := Format('%sLive\WebRoot\webhub\%s\%s\%s%s\',
      [getWebHubDemoInstallRoot, 'echoqa', FormatDateTime('yyyymmdd', Now),
       Sender.AppID, Sender.CentralInfo.PascalCompilerCode]);
    ForceDirectories(AFolder);
    AFilename := Format('test%d.txt', [TestNumber]);
    UTF8StringWriteToFile(AFolder + AFilename, PageContent);
  end;
end;

procedure TDemoExtensions.DemoAppPageErrors(Sender: TwhAppDebug;
  var Continue: Boolean);
begin
  LogSendInfo('QueryString', pWebApp.Request.QueryString);
  LogSendInfo('SurferIP', pWebApp.Request.RemoteAddress);
  LogSendInfo('UserAgent', pWebApp.Request.UserAgent);
  if pWebApp.Request.CookiesIn.Count > 0 then
    LogSendInfo('Cookies', pWebApp.Request.CookiesIn.Text);
end;

procedure TDemoExtensions.DemoAppExceptionHandler(Sender: TObject; E: Exception;
  var Handled, ReDoPage: Boolean);
const cFn = 'DemoAppExceptionHandler';
var
  iDelaySeconds: Integer;
begin
  CSEnterMethod(Self, cFn);

  Handled := True;
  LogSendException(E); // just in case it has not already been logged.

  {$IFDEF EUREKALOG}
  // uses ExceptionLog7, EExceptionManager
  LogSendWarning('EurekaLog provides the following CallStack');
  LogSendError(ExceptionManager.LastThreadException.CallStack.ToString);
  {$ENDIF}

  iDelaySeconds := StrToIntDef(TpJustDigits(pWebApp.Command), 0);
  if iDelaySeconds > 2 then
  begin
    CSSend('Sleeping for seconds', S(iDelaySeconds));
    Sleep(iDelaySeconds * 1000);
  end;

  (*
  For some applications, having the EXE exit after an A/V is a good idea.
  if E is EAccessViolation then
    pConnection.MarkTerminateASAP; // uses webCall
  *)

  (*
  For some applications, bouncing the surfer to an error message page is useful.
  pWebApp.Response.SendBounceToPage('pgSyntaxError', '');  // status 302; surfer likely to see 'app not running' system message
  // application EXE could be auto-restarted by WebHub Guardian feature
  *)

  // if you do not bounce out, the rest of the page will execute...
  // which is fine for the WebHub demos.

  CSExitMethod(Self, cFn);
end;

procedure TDemoExtensions.DemoAppExecute(Sender: TwhRespondingApp;
  var bContinue: Boolean);
var
  SurferHostname: string;
  SurferHostid: string;
begin
  if pWebApp.SessionNumber <> 0 then
  begin
    if Assigned(FDomainIDList) then
    begin
      if (pWebApp.StringVar['_hostID'] = '') or pWebApp.IsWebRobotRequest then
      begin
        SurferHostname := pWebApp.Request.Host;
        SurferHostid := FDomainIDList.Values[SurferHostname];
        pWebApp.StringVar['_hostID'] := SurferHostid;  // remember
      end;
    end;
    if NOT pWebApp.IsWebRobotRequest then
    begin
      if (SameText(Sender.AppID, 'showcase') or SameText(Sender.AppID, 'htsc')) and
        (NOT IsHREFToolsQATestAgent) then
      begin
        { do not allow blank referer within the showcase or htsc demos
          unless on the home page  or  switching http/https }
        if (Sender.Request.Referer = '') and
          (NOT IsEqual(Sender.PageID, Sender.Situations.HomePageID)) and
          (NOT IsEqual(Sender.PageID, Sender.Situations.FrontDoorPageID)) and
          (pWebApp.Session.PriorScheme = pWebApp.Request.Scheme) then
        begin
          if (NOT HonorLowerSecurity) then
          begin
            Sender.RejectSession('Blank referer, scheme ' +
              pWebApp.Session.PriorScheme + ', without security token', False);
          end;
        end;
      end;
    end;
  end;
end;

end.
