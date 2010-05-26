unit whdemo_Extensions;
////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1998-2010 HREF Tools Corp.  All Rights Reserved Worldwide.  //
//                                                                            //
//  This source code file is part of WebHub v2.10x.  Please obtain a WebHub   //
//  development license from HREF Tools Corp. before using this file, and     //
//  refer friends and colleagues to href.com/webhub for downloading. Thanks!  //
////////////////////////////////////////////////////////////////////////////////

// This unit must be created AFTER the TwhApplication component exists.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList,
  updateOk, tpAction, tpActionGUI,
  webSend, webTypes, webLink, webCycle, webLogin;

type
  TDemoExtensions = class(TDataModule)
    WebLogin: TwhLogin;
    WebCycle: TwhCycle;
    waVersionInfo: TwhWebAction;
    waGetExename: TwhWebAction;
    waLSec: TwhWebAction;
    procedure DataModuleDestroy(Sender: TObject);
    procedure waGetExenameExecute(Sender: TObject);
    procedure waVersionInfoExecute(Sender: TObject);
    procedure waLSecExecute(Sender: TObject);
  private
    { Private declarations }
    function IsHREFToolsQATestAgent: Boolean;
  protected
    procedure DemoAppExecute(Sender: TwhRespondingApp; var bContinue: Boolean);
    procedure DemoAppUpdate(Sender: TObject);
    procedure DemoAppBadIP(Sender: TwhRespondingApp; var bContinue: Boolean);
    procedure DemoAppNewSession(Sender: TObject; InSessionNumber: Cardinal;
      const Command: string);
    procedure DemoAppPageComplete(Sender: TwhRespondingApp;
      const PageContent: TwhString);
  public
    { Public declarations }
    function Init: Boolean;
  end;

var
  DemoExtensions: TDemoExtensions = nil;

implementation

uses
  DateUtils,
  ucVers, ucString, ucBase64, ucLogFil, ucPos,
  webApp, htWebApp, whMacroAffixes, webCore;

{$R *.DFM}

type
  TVersionType = (vtExe, vtWHsetupdate);

var
  FlagBeenHere: Boolean = False;

function TDemoExtensions.Init: Boolean;
begin
  Result := True;
  // make the components in this data module refresh
  // when the app object updates.
  Assert(Assigned(pWebApp));

  if NOT FlagBeenHere then
  begin
    AddAppUpdateHandler(DemoAppUpdate);  // without this, changes to AppID will not refresh the mail panel.
    AddAppExecuteHandler(DemoAppExecute);
    FlagBeenHere := True;
  end;
  pWebApp.OnBadIP := DemoAppBadIP;
  pWebApp.OnNewSession := DemoAppNewSession;
  pWebApp.OnPageComplete := DemoAppPageComplete;

  DemoAppUpdate(nil); // do this once, in case the app has already been loaded - likely.

end;

function TDemoExtensions.IsHREFToolsQATestAgent: Boolean;
begin
  with pWebApp do
    Result := (SessionID = Security.AdminSessionID) and
      ((Request.UserAgent = 'HREF Tools QA Test Agent') or
      (Request.RemoteAddress = '208.201.252.43'));
end;

//------------------------------------------------------------------------------

procedure TDemoExtensions.DemoAppUpdate(Sender: TObject);
begin
  // Note: the only likely reason these pointers would be nil
  // is when this unit is used within the WebHub Editor, which frees
  // them because they are n/a.
  //
  if assigned(WebLogin) then
    // reload the user list based on the current AppID.
    WebLogin.Refresh;
  if assigned(WebCycle) then
    // reload the cycle list information
    WebCycle.Refresh;
end;

procedure TDemoExtensions.DataModuleDestroy(Sender: TObject);
begin
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
    pWebApp.Debug.AddPageError(Format(
      '%s Syntax: .execute|[ExeVersion|whSetupDate|version-property-name]',
      [waVersionInfo.Name]) );
  end;
end;

procedure TDemoExtensions.waGetExenameExecute(Sender: TObject);
begin
  inherited;
  pWebApp.SendString(ExtractFilename(Application.ExeName));
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
  //S8: UTF8String;
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
      ASeconds := WebApp.MoreIfParentild(ASeconds);
      NSeconds := StrToIntDef(string(ASeconds), 120);
      S16 := Format('%s.%s',
        [Name, Code64String(MakeOutgoingToken)]);
      WebApp.SendStringImm(S16);
    end
    else
    if IsEqual(HtmlParam, 'in') then
    begin
      WebApp.BoolVar['_lowerSecurity'] := False;
      // decode
      if Command <> '' then
      begin
        try
          PossibleBypass := UnCode64String(Command);
        except
          PossibleBypass := '';  // failed decode process
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
              WebApp.BoolVar['_lowerSecurity'] := True;
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

function HonorLowerSecurity: Boolean;
begin
  Result := False;
  if (pos('waLSec', pWebApp.Command) > 0) then
  begin
    {This can be set by waLSec web action, in WebHub Demos.}
    pWebApp.Expand(MacroStart + 'waLSec.execute|in' + MacroEnd);
    if pWebApp.BoolVar['_LowerSecurity'] then
    begin
      pWebApp.StringVar['_BypassAllowed'] := FormatDateTime('dddd hh:nn:ss:zzz', Now);
      pWebApp.BoolVar['_LowerSecurity'] := False;  // immediately reset
      Result := True;
    end;
  end;
end;

const
  cUnitName = 'whdemo_Extensions';

procedure TDemoExtensions.DemoAppBadIP(Sender: TwhRespondingApp;
  var bContinue: Boolean);
{ processing to catch cases where a surfers IP# changes in mid-session,
  it rejects continuation if the refering page is not in the same domain
  as the server producing this page. catches someone copying a session#
  This code is only called if TwhAppBase.Security.CheckSurferIP is true.
  It is false by default. }
begin
  inherited;
  //bContinue defaults to false and will produce a fixed-format error
  //message unless we reset it here. Resetting the value also allows
  //us to provide a custom message.
  bContinue := True;
  if IsHREFToolsQATestAgent then
    Exit;

  with Sender, Request do
  begin
    //determine the domain
    if PosCI(ExtractParentDomain(Request.Host) + '.', Referer) > 0 then
      { The surfer's IP changed and the referer includes the domain
        of this server. let it go by!

        Please Note: The NT HOSTS file can make your browser believe that
        it is a machine on an arbitrary domain. This makes this check
        undesirable if you are positive that all your client machines
        are going to be on static IPs.. for the general public though,
        this is probably as good as you will get it without resorting
        to storing a cookie on the user's machine. }
      Exit;

    if PosCI('AOL', Request.UserAgent) > 0 then
    begin
      { AOL has a long history of pooling requests by its users among many
        IP numbers so it is very normal for an AOL browser to change IP numbers
        in the middle of a session.  Allow this.
        Reconfirmed 18-Apr-2008 }
      Exit;
    end;

    if HonorLowerSecurity then Exit;

    if Situations.ChangedIPPageID <> '' then
      PageID := Situations.ChangedIPPageID;
    RejectSession(cUnitName + ', WebAppBadIP()', True);
  end;
end;


procedure TDemoExtensions.DemoAppNewSession(Sender: TObject;
  InSessionNumber: Cardinal; const Command: string);
var
  bNewSessionInURL: Boolean;
  bForceNewSession: Boolean;
const
  cDomainLevels = 3;  // demos.href.com has 3 levels.
begin
  inherited;
  if InSessionNumber = 0 then Exit;

  if Assigned(pWebApp) and pWebApp.IsUpdated then
  begin
    with pWebApp do
    begin
      if IsHREFToolsQATestAgent then
        Exit;

      //implement new-session security.
      bForceNewSession := False;

      if IsWebRobotRequest then
      begin
        // an already determined web robot session, therefore expected to
        // come in with a session number.
      end
      else
      begin
        bNewSessionInURL := Pos(IntToStr(InSessionNumber),
          Request.QueryString) > 0;
        if HonorLowerSecurity then
        begin
          // do nothing -- allow the page to run
        end
        else
        begin
        if bNewSessionInURL then
          begin
            {user comes in from a bookmark or a search engine}
            bForceNewSession := (posci(
              ExtractParentDomain(Request.Host, cDomainLevels),
              Request.Referer)=0);
          end
          else
          begin
            { worst case.. user fakes a cookie or comes back days later with the
              non-stored session cookie still loaded in the browser }
            bForceNewSession := HaveSessionCookie;
          end;
        end;
      end;

      if bForceNewSession then
        RejectSession(cUnitName + ', WebAppNewSession()', True);
    end;
  end;
end;

var
  TestNumber: Integer = 0;

procedure TDemoExtensions.DemoAppPageComplete(Sender: TwhRespondingApp;
  const PageContent: Twhstring);
var
  S: string;
  AFilename: string;
begin
  if Sender.SessionNumber = 1204 then
  begin
    S := pWebApp.Request.Headers.Values['X-Selenium-PageCount'];
    if S <> '' then
      TestNumber := StrToIntDef(S, 1)
    else
      Inc(TestNumber);

    AFilename := Format('%stest%d.txt',
      ['D:\Projects\webhubdemos\Live\WebRoot\webhub\echoqa\', TestNumber]);
    UTF8StringWriteToFile(AFilename, UTF8Encode(PageContent));
  end;
end;

procedure TDemoExtensions.DemoAppExecute(Sender: TwhRespondingApp;
  var bContinue: Boolean);
begin
  if NOT pWebApp.IsWebRobotRequest then
  begin
    if IsEqual(pWebApp.AppID, 'showcase') and (NOT IsHREFToolsQATestAgent) then
    begin
      {do not allow blank referer within the showcase demo}
      if (pWebApp.Session.PageCount > 1) and
        (pWebApp.Request.Referer = '') then
      begin
        if NOT HonorLowerSecurity then
        begin
          pWebApp.RejectSession('Blank referer', False);
        end;
      end;
    end;
  end;
end;

end.
