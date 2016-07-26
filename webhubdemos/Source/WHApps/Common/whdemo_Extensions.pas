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
  ucAWS_CloudFront_PrivateURLs,
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
    waTextFileContent: TwhWebAction;
    waAWSKey2Filename: TwhWebAction;
    waAWSCloudFrontSecurityProvider: TwhWebAction;
    waEvaporateSign: TwhWebAction;
    waJQFileUpload: TwhWebAction;
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
    procedure waTextFileContentExecute(Sender: TObject);
    procedure waAWSKey2FilenameExecute(Sender: TObject);
    procedure waAWSCloudFrontSecurityProviderExecute(Sender: TObject);
    procedure waEvaporateSignExecute(Sender: TObject);
    procedure waJQFileUploadExecute(Sender: TObject);
  strict private
    { Private declarations }
    FMonitorFilespec: string; // for use with WebHubGuardian
    FAdminIpNumber: string;
    FServerIpNumber: string;
    FDomainIDList: TStringList;
    FCFSP: TCloudFrontSecurityProvider;
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
    procedure DemoAppBadBrowser(Sender: TwhRespondingApp;
      var bContinue: Boolean);
    procedure DemoAppExceptionHandler(Sender: TObject; E: Exception;
      var Handled, ReDoPage: Boolean);
    function Init: Boolean;
    function IsSuperuser(const InSurferIP: string): Boolean;
    function AWSCloudFrontSecurityURL(const url, minutesToLiveStr,
    restrictByIPStr: string): string;
  end;

var
  DemoExtensions: TDemoExtensions = nil;

implementation

uses
  {$IFDEF EUREKALOG}ExceptionLog7, EExceptionManager,{$ENDIF}
  DateUtils, Math, TypInfo, JSON,
  ucVers, ucString, ucBase64, ucLogFil, ucPos, ucCodeSiteInterface, uCode,
  ucMsTime, ucJSONWrapper,
  whBuildInfo,
  whConst, webApp, htWebApp, whMacroAffixes, webCore, whutil_ZaphodsMap,
  webSock, runConst, whcfg_AppInfo, whSharedLog, whxpGlobal, webCall,
  whdemo_ViewSource, webSysMsg, ucAWS_S3_Upload, ucAWS_Security;

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

  pWebApp.UseSharedLogFolder := False;
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

function TDemoExtensions.AWSCloudFrontSecurityURL(const url, minutesToLiveStr,
    restrictByIPStr: string): string;
const cFn = 'AWSCloudFrontSecurityURL';
var
  expiresOnAt: TDateTime;
begin
  CSEnterMethod(Self, cFn);

  if NOT Assigned(fcfsp) then
    FCFSP := TCloudFrontSecurityProvider.Create;

  CSSend(cFn + ': url', url);

  expiresOnAt := IncMinute(NowUTC, StrToIntDef(minutesToLiveStr, 1));
  CSSend(csmLevel6, 'expiresOnAt',
      FormatDateTime('yyyy-mm-dd hh:nn:ss', expiresOnAt));

  FCFSP.KeyPairID := 'APKAIGAY3EJC77HVGRFQ'; // visible in URL
  FCFSP.DiskFolder := getWebHubDemoInstallRoot + 'Source\WHApps\' +
      'Lite Examples\AWS\';

  // The PEM is issued by AWS. Secret. Not in version control.
  FCFSP.PrivateKeyPEM := StringLoadFromFile(FCFSP.DiskFolder +
      'demos.cloudfront.pem');

  FCFSP.Policy := FCFSP.GetPolicyAsStr(url, expiresOnAt, restrictByIPStr);
  CSSend(csmLevel5, cFn + ': Policy', FCFSP.Policy);

  Result := FCFSP.GetCustomUrl(url);

  CSExitMethod(Self, cFn);
end;

procedure TDemoExtensions.DataModuleCreate(Sender: TObject);
const
  cFn = 'DataModuleCreate';
begin
  CSEnterMethod(Self, cFn);
  FMonitorFilespec := ''; // for use with WebHubGuardian
  FDomainIDList := nil;
  FCFSP := nil;
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
  FreeAndNil(FCFSP);
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

procedure TDemoExtensions.waAWSCloudFrontSecurityProviderExecute(
  Sender: TObject);
const cFn = 'waAWSCloudFrontSecurityProviderExecute';
var
  url: string;
  minutesToLiveStr: string;
  restrictByIPStr: string;
  protectedURL: string;
begin
  CSEnterMethod(Self, cFn);

  if NOT Assigned(fcfsp) then
    FCFSP := TCloudFrontSecurityProvider.Create;

  if SplitThree(TwhWebAction(Sender).HtmlParam, ' | ', url, minutesToLiveStr,
    restrictByIPStr) then
  begin
    url := pWebApp.Expand(url);
    CSSend(cFn + ': url', url);

    minutesToLiveStr := pWebApp.MoreIfParentild(minutesToLiveStr);

    // use /32 on the CIDR to restrict to a single IP
    restrictByIPStr := pWebApp.Expand(restrictByIPStr);
    CSSend('restrictByIPStr', restrictByIPStr);

    protectedURL := AWSCloudFrontSecurityURL(url, minutesToLiveStr,
      restrictByIPStr);

    pWebApp.SendStringImm(protectedURL);
  end
  else
    pWebApp.SendStringImm(FCFSP.Policy);

  CSExitMethod(Self, cFn);
end;

procedure TDemoExtensions.waAWSKey2FilenameExecute(Sender: TObject);
const cFn = 'waAWSKey2FilenameExecute';
var
  a1, akey: string;
  x: Integer;
begin
  CSEnterMethod(Self, cFn);
  x := Pos('key=', pWebApp.Command);
  if x > 0 then
  begin
    a1 := TwhWebAction(Sender).HtmlParam;
    akey := Copy(pWebApp.Command, x + 4, MaxInt);
    akey := LeftOfS('&', akey);
    if a1 <> '' then
      akey := Copy(akey, Succ(Length(a1)), MaxInt); // strip prefix
    pWebApp.SendStringImm(akey);
  end
  else
    CSSend(cFn + ': "key=" not found in command');
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

procedure TDemoExtensions.waEvaporateSignExecute(Sender: TObject);
const cFn = 'waEvaporateSignExecute';
var
  x: Integer;
  evaporateLines: TStringList;
begin
  CSEnterMethod(Self, cFn);

  evaporateLines := nil;

  LogToCodeSiteKeepCRLF('Command', pWebApp.Command);
  LogToCodeSiteKeepCRLF('QS', pWebApp.Request.QueryString);

  x := Pos('?to_sign=', pWebApp.Command);
  if x > 0 then
  begin
    try
      evaporateLines := TStringList.Create;
      evaporateLines.Text := Copy(pWebApp.Command, X + 9, MaxInt);
      LogToCodeSiteKeepCRLF('evaporateLines.Text', evaporateLines.Text);
      pWebApp.SendStringImm('test_12345');
    finally
      FreeAndNil(evaporateLines);
    end;
  end;

  CSExitMethod(Self, cFn);
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

procedure TDemoExtensions.waJQFileUploadExecute(Sender: TObject);
const cFn = 'waJQFileUploadExecute';
var
  actionKeywords: string;
  s3BucketName, urlPrefix, aMinutes, aRestrictIP: string;
  fileDetailJSONStr: string;
  InfoMsg: string;
var
  JSON: Variant;
  TempJO: TJSONObject;
  SavHtmlParam: string;
type
  TIncomingRec = record
    fname: string;
    ftype: string;
    fsize: string;
    flastmodified: string;
  end;
type
  TOutputRec = record
    awsResource: string;
    awsPolicy: string;
    awsPolicy64: string;
    awsUploadSignature: string;
    awsDownloadURL: string;
  end;
var
  incomingRec: TIncomingRec;
  outputRec: TOutputRec;
  FileUploadSecret: string;
begin
  CSEnterMethod(Self, cFn);

  //CSSend(pWebApp.Request.FormData.Text);
  fileDetailJSONStr := pWebApp.StringVar['fileDetails'];
  CSSend('fileDetails', fileDetailJSONStr);
  SavHtmlParam := TwhWebAction(Sender).HtmlParam;
  CSSend('SavHtmlParam', SavHtmlParam);

  if fileDetailJSONStr <> '' then
  try
    try
      if Pos('|', SavHtmlParam) = 0 then
        actionKeywords := Trim(SavHtmlParam)
      else
      begin
        if SplitFive(SavHtmlParam, ' | ', actionKeywords, s3BucketName,
          urlPrefix, aMinutes, aRestrictIP) then
          actionKeywords := Trim(LowerCase(actionKeywords));
      end;

      CSSend('actionKeywords', actionKeywords);
      JSON := VarJSONParse(fileDetailJSONStr);
      incomingRec.fname := JSON.fname;
      incomingRec.ftype := JSON.ftype;
      incomingRec.fsize := JSON.fsize;
      incomingRec.flastmodified := JSON.flastmodified;
      CSSend('incomingRec.fname', incomingRec.fname);

      if actionKeywords = 'echo fname' then
      begin
        pWebApp.SendStringImm(incomingRec.fname);
      end
      else
      if actionKeywords = 'sign fname' then
      begin
        CSSend('urlPrefix', urlPrefix);
        CSSend('aMinutes', aMinutes);
        CSSend('aRestrictIP', aRestrictIP);
        CSSend(pWebApp.Request.FormData.Text);

        outputRec.awsResource := urlPrefix + incomingRec.fname;
        outputRec.awsPolicy := FileUploadPolicy(
          IncMinute(nowUTC, StrToIntDef(aMinutes, 30)),
          s3BucketName,
          'authenticated-read', // acl
          '', // success url
          urlPrefix, // key starts with
          incomingRec.ftype, // content type
          
          //{$IF cWebHubVersion >= 3.263}
          // ["starts-with","$Content-Disposition","attachment"]
          'attachment',
          //{$IFEND}
          
          400 * 1024 * 1024, // max file size bytes
          7 * 1440 * 60, // cache for 7 days
          0);
        CSSend(csmLevel7, 'outputRec.awsPolicy', outputRec.awsPolicy);
        outputRec.awsPolicy64 :=
          StringToBase64NoCRLF(UTF8String(outputRec.awsPolicy));
        FileUploadSecret := StringLoadFromFile(
          pWebApp.AppSetting['TextFileContent-FileUploadSecret']);
        CSSend('FileUploadSecret', FileUploadSecret);
        outputRec.awsUploadSignature :=
          AWS_Signature_for_FileUpload(outputRec.awsPolicy64, FileUploadSecret);

        TempJO := TJSONObject.Create;
        TempJO.AddPair('awsResource', outputRec.awsResource);
        //TempJO.AddPair('awsPolicy', outputRec.awsPolicy);  See CSL for detail
        TempJO.AddPair('awsPolicy64', outputRec.awsPolicy64);
        TempJO.AddPair('awsUploadSignature', outputRec.awsUploadSignature);

        outputRec.awsDownloadURL := AWSCloudFrontSecurityURL(
          pWebApp.Request.Scheme + '://' + s3BucketName + '/' + urlPrefix +
          incomingRec.fname, aMinutes, aRestrictIP);
        CSSend('outputRec.awsDownloadURL', outputRec.awsDownloadURL);
        TempJO.AddPair('awsDownloadURL', outputRec.awsDownloadURL);

        CSSend('ToJSON', TempJO.ToJSON);
        pWebApp.SendStringImm(TempJO.ToJSON);
      end
      else
      begin
        CSSendWarning('Invalid HtmlParam=' + TwhWebAction(Sender).HtmlParam);
        InfoMsg := 'Invalid syntax for ' + waJQFileUpload.Name;
        CSSendWarning(InfoMsg);
        pWebApp.Debug.AddPageError(InfoMsg);
      end;
    except
      on E: Exception do
      begin
        CSSendException(Self, cFn, E); // silent ignore for now.
      end;
    end;
  finally
    //
  end;

  CSExitMethod(Self, cFn);
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

procedure TDemoExtensions.waTextFileContentExecute(Sender: TObject);
const cFn = 'waTextFileContentExecute';
var
  AFilespec: string;
  FileContents: string;
begin
  CSEnterMethod(Self, cFn);

  AFilespec := TwhWebAction(Sender).HtmlParam;
  CSSend('HtmlParam', AFilespec);

  AFilespec := pWebApp.MoreIfParentild(AFilespec);
  if (AFilespec<>'') and (NOT FileExists(AFilespec)) then
  begin
    CSSend(cFn + ': prepending AppPath to PEMFilespec [' + AFilespec + ']');
    AFilespec := pWebApp.AppPath + AFilespec;
  end;

  if (AFilespec<>'') and FileExists(AFilespec) then
  begin
    FileContents := StringLoadFromFile(AFilespec);
    //CSSend('Contents', PEMContents);
    pWebApp.SendStringImm(FileContents);
  end
  else
  begin
    pWebApp.Debug.AddPageError(Format(
      '%s: Invalid syntax. Expected filename, either as ' +
      'full path or relative to the app-level config file.',
        [TwhWebAction(Sender).Name]));
  end;

  CSExitMethod(Self, cFn);
end;

procedure TDemoExtensions.waSimulateBadNewsExecute(Sender: TObject);
var
  AKeyword: string;
begin
  AKeyword := TwhWebAction(Sender).HtmlParam;
  if AKeyword = 'HubNotFound' then
    pWebApp.Response.SimulateSituation(whsitHubNotFound)
  else
  if AKeyword = 'AppNotDefined' then
    pWebApp.Response.SimulateAppNotDefined
  else
  if AKeyword = 'AppNotRunning' then
    pWebApp.Response.SimulateSituation(whsitAppNotRunning)
  else
  if AKeyword = 'RequestTimeout' then
    pWebApp.Response.SimulateRequestTimeout(35)
  else
  if AKeyword = 'AppIDBusy' then
    pWebApp.Response.SimulateSituation(whsitAppIDBusy)
  else
  if AKeyword = 'AppCoverPage' then
    pWebApp.Response.SimulateAppCoverPage(Now, 5, 'testing system messages')
  else
  if AKeyword = 'UploadErrorBig' then
    pWebApp.Response.SimulateUploadError(True, 45, 0)
  else
  if AKeyword = 'UploadErrorSlow' then
    pWebApp.Response.SimulateUploadError(False, 0, 15)
  else
  if AKeyword = 'WHBusy' then
    pWebApp.Response.SendCustomError(AKeyword, 500, 13)
  else
  if AKeyword = 'WHStarting' then
    pWebApp.Response.SendCustomError(AKeyword, 500, 12)
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
    { This can be set by waLSec web action, in WebHub Demos, see showcase. }
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
  InfoMsg: string;
const
  cDomainLevels = 3; // demos.href.com has 3 levels.
begin
  CSEnterMethod(Self, cFn);
  inherited;
  bKeepChecking := (InSessionNumber <> 0);

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
          if (HaveSessionCookie = whsncPresent) then
          begin
            InfoMsg := Format(
              'session cookie %s in %s.%s %s on %s ' +
              'while %d.var exists=%s. IP %s; Agent %s; PageCount %d; QS %s',
              [pWebApp.AppInfo.SessionCookieName,
               Self.Name, cFn,
               GetEnumName(TypeInfo(TwhSessionNumberCookieState),
               Ord(pWebApp.HaveSessionCookie)),
               pWebApp.Request.Host,
               InSessionNumber,
               S(FileExists(pWebApp.Session.SessionFileName)),
               pWebApp.Request.RemoteAddress,
               pWebApp.Request.UserAgent, pWebApp.Session.PageCount,
               pWebApp.Request.QueryString]);
            if pWebApp.AppInfo.SessionNumberLocation <> whsnlURL then
            begin
              // Session Cookie is in use, so there will not be a session # in
              // the URL.
              if pWebApp.Session.PageCount > 1 then
                CSSendWarning('unexpected call to ' + cFn);
              CSSendNote(InfoMsg);
              bForceNewSession := False; // June 2016: do not reject
            end
            else
              CSSendWarning('unexpected ' + InfoMsg);
          end;
        end;
      end;

      if bForceNewSession then
        RejectSession(cUnitName + ', ' + cFn + '()', False);  
    end;
  end;
  CSExitMethod(Self, cFn);
end;

var
  TestNumber: Integer = 0;

procedure TDemoExtensions.DemoAppPageComplete(Sender: TwhRespondingApp;
  const PageContent: UTF8String);
var
  S1: string;
  AFolder, AFilename: string;
begin
  if IsHREFToolsQATestAgent and
    (Sender.SessionID = pWebApp.Security.AdminSessionID) then
  begin
    { archive page content for functionality test sequences }
    S1 := pWebApp.Request.Headers.Values['X-Selenium-PageCount'];
    if S1 <> '' then
      TestNumber := StrToIntDef(S1, 1)
    else
      Inc(TestNumber);

    AFolder := Format('%sLive\WebRoot\webhub\%s\%s\%s%s\',
      [getWebHubDemoInstallRoot, 'echoqa', FormatDateTime('yyyymmdd', Now),
       Sender.AppID, Sender.CentralInfo.PascalCompilerCode]);
    ForceDirectories(AFolder);
    AFilename := Format('test%d.txt', [TestNumber]);
    UTF8StringWriteToFile(AFolder + AFilename, PageContent);
  end;
  if (SameText(Sender.AppID, 'showcase') or SameText(Sender.AppID, 'htsc'))
  then
  begin
    pWebApp.AddCookie('WHPartTwo', S(pWebApp.Session.PageCount), '',
      IncMinute(NowUTC, 10), pWebApp.Security.CookieDomainDefault, False);
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
const cFn = 'DemoAppExecute';
var
  SurferHostname: string;
  SurferHostid: string;
begin
  CSEnterMethod(Self, cFn);
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

    if (NOT pWebApp.IsWebRobotRequest) then
    begin
      if (SameText(Sender.AppID, 'showcase') or SameText(Sender.AppID, 'htsc'))
      and
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
            if PosCI(Sender.PageID, pWebApp.Situations.SideDoorPageIDs) = 0
            then
            begin
              CSSend(cFn + ': Sender.Request.Referer', Sender.Request.Referer);
              CSSend(cFn + ': Sender.PageID', Sender.PageID);
              CSSend(cFn + ': pWebApp.Session.PriorScheme',
                pWebApp.Session.PriorScheme);

              if pWebApp.Request.CookiesIn.Values['WHPartTwo'] =
                S(pWebApp.Session.PageCount) then
                CSSend(cFn + ': allowed due to cookie match')
              else
              begin
                Sender.RejectSession('Blank referer, scheme ' +
                  pWebApp.Session.PriorScheme +
                  ', without security token, second cookie is missing, ' +
                  'and not using a side door.', False);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  CSExitMethod(Self, cFn);
end;

end.
