unit dmwhGoogleAPIActions;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

uses
  SysUtils, Classes,
  webLink, updateOK, tpAction, webTypes;

type
  TDMGAPI = class(TDataModule)
    waTestGeoLocation: TwhWebAction;
    waTestFreebase: TwhWebAction;
    waOAuth2StepToken: TwhWebAction;
    waOAuth2CallbackState: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure waTestGeoLocationExecute(Sender: TObject);
    procedure waTestFreebaseExecute(Sender: TObject);
    procedure waOAuth2StepTokenExecute(Sender: TObject);
    procedure waOAuth2CallbackStateExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    FClientID, FClientSecret, FSimpleAPIKey: string;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMGAPI: TDMGAPI;

implementation

{$R *.dfm}

uses
{$IFDEF CodeSite}CodeSiteLogging, {$ENDIF}
  DateUtils,
  webApp, htWebApp,
  ucString, ucCodeSiteInterface, ucURLEncode, ucHttps, ucGoogleAPICredentials,
  ucMsTime,
  whdemo_ViewSource, tpGoogle_ServiceResource;

{ TDMGAPI }

procedure TDMGAPI.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMGAPI.Init(out ErrorText: string): Boolean;
const
  cFn = 'Init';
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  ErrorText := '';

  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin
    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      RefreshWebActions(Self);
      AddAppUpdateHandler(WebAppUpdate);
      WebAppUpdate(pWebApp); // call once, now.
      FlagInitDone := True;
    end;
  end;
  Result := FlagInitDone;
{$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

procedure TDMGAPI.waOAuth2CallbackStateExecute(Sender: TObject);
const cFn = 'waOAuth2CallbackStateExecute';
var
  a1, a2: string;
  targetURL: string;
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
(*
Query String (after remap by StreamCatcher): shop1:oauth2callback::state=/profile1294912795&code=4/lR5tzQlU83XlhOJmNmSYIqJlE2oy.QrarjwvN688cgrKXntQAax0uBr3iewI
*)

// reference required settings for use with GoogleAPI OAuth2
// http://screenshots.href.com/webhub/rsrcdef/snapCodeGoogleAPISConsole.png

  LogSendInfo('QueryString', pWebApp.Request.QueryString);
  SplitString(pWebApp.Request.QueryString, 'state=/profile', a1, a2);
  SplitString(a2, '&code=', a1, a2);
  { a1 now contains the session id for the surfer who started this }
  LogSendInfo('session number in a1', a1);

  { now bounce to a URL starting with http(s)
    that includes the correct session number, keeping the
    command string intact for subsequent use }
  targetURL := pWebApp.Request.Scheme + '://' + pWebApp.Request.Authority +
    pWebApp.DynURL.ToAppID + pWebApp.DynURL.W +
    'oauth2callback02' + pWebApp.DynURL.W + a1 + pWebApp.DynURL.W +
    pWebApp.Command;
  pWebApp.Response.SendBounceTo(targetURL);

{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

procedure TDMGAPI.waOAuth2StepTokenExecute(Sender: TObject);
const
  cFn = 'waOAuth2Step1Execute';
var
  AccessToken, TokenType: string;
  ExpiresInSeconds: Integer;
  IDToken, RefreshToken: string;
  S1, S2: string;
  ErrorText: string;
  RawHeadersUsed, UnsecretDataUsed: string;
  ExpiresOnAt: TDateTime;
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  { this only makes sense AFTER the surfer has been to google and returned
    to an official callback URL, with either an approval code or a refusal
    to participate.

    Docs from https://developers.google.com/accounts/docs/OAuth2WebServer:

    An error response:
    https://oauth2-login-demo.appspot.com/code?error=access_denied&state=/profile

    An authorization code response:
    https://oauth2-login-demo.appspot.com/code?state=/profile&code=4/P7q7W91a-oMsCeLvIaQm6bTrgtp7
  }

  if (Pos('error=access_denied', pWebApp.Request.QueryString) > 0) then
  begin
    pWebApp.Response.SendBounceToPage('pgOAuth2AccessDenied', '');
  end
  else
  begin
    if SplitString(pWebApp.Request.QueryString, 'code=', S1, S2) then
    begin
      SplitString(S2, '&', S1, S2);
      if FClientSecret <> '' then
      begin
        if ExchangeAuthCodeForToken(
          S1, // this authorization code is returned via URL from google

          //redirect uri MUST be the SAME as when the code was requested !
          // and it is NOT USED because we are requesting behind the scenes !
          pWebApp.Request.Scheme + '://' +
          pWebApp.Request.Authority + '/googleapi/shop1/oauth2callback',

          'WebHub Demo', // any user agent is fine
          FClientID, FClientSecret, AccessToken, TokenType, ExpiresInSeconds,
          IDToken, RefreshToken, ErrorText, RawHeadersUsed, UnsecretDataUsed) then
        begin
          pWebApp.Response.SendLine('<pre>');
          pWebApp.StringVar['_access_token'] := AccessToken;  // save
          pWebApp.Response.SendLine('AccessToken=' + AccessToken);
          pWebApp.StringVar['_id_token'] := IDToken;  // save
          pWebApp.Response.SendLine('IDToken=' + IDToken);
          pWebApp.StringVar['_token_type'] := TokenType;  // save
          pWebApp.Response.SendLine('TokenType=' + TokenType);
          ExpiresOnAt := IncSecond(NowGMT, ExpiresInSeconds - 45);
          pWebApp.StringVar['_expires_on_at'] := IntToStr(DateTimeToUnix(ExpiresOnAt));
          pWebApp.Response.SendLine('Expires approximately ' +
            FormatDateTime('dd-MMM hh:nn:ss', ExpiresOnAt) + ' gmt');
          pWebApp.Response.SendLine('</pre>');
        end
        else
        begin
          pWebApp.Response.SendLines(['<h1>Bad News</h1>',
          '<p>ExchangeApiKeyForToken failed.</p>', '<p>', ErrorText, '</p>']);
          pWebApp.Response.SendLines(['<h2>Raw Headers used on TIdHttp</h2>',
            '<pre>', RawHeadersUsed, '</pre>']);
          pWebApp.Response.SendLines(['<h2>Data Posted</h2>',
            '<p>', 'The following data was put into a Delphi UTF8String and ' +
                   'sent through TIdHTTP using a TMemoryStream.', '</p>',
            '<p>The client_id is the one from the google oauth2 playground. ' +
            'The client_secret has been removed.</p>' +
            '<p>The authorization code is the one assigned to YOU by ' +
            'google, a few moments ago.</p>',
            '<p>', UnsecretDataUsed, '</p>']);

        end;
      end
      else
      begin
        // this does not happen in April 2013 but if google broke oauth2,
        // perhaps it could occur.
        pWebApp.SendStringImm('code not found in callback url from google.');
      end;
    end;
  end;
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

procedure TDMGAPI.waTestFreebaseExecute(Sender: TObject);
const
  cFn = 'waTestFreebaseExecute';
  cBaseURL = 'https://www.googleapis.com/freebase/v1/search?';
var
  ResponseData: string;
  FreebaseQueryTerm, FreebaseFilter: string;
  ErrorText: string;
  RequestURL: string;
  ResponseLimit: Integer;
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  if (FClientSecret <> '') then
  begin
    FreebaseQueryTerm := pWebApp.StringVar['FreebaseQueryTerm'];
    FreebaseFilter := pWebApp.StringVar['FreebaseFilter'];

    ResponseLimit := 10;

    { NB: each (string) parameter *value* must be URLencoded separately }

    RequestURL := 'q=' + UrlEncode(FreebaseQueryTerm, True) + '&userIp=' +
      pWebApp.Request.RemoteAddress + '&limit=' + IntToStr(ResponseLimit) +
      '&indent=true' + '&filter=' + UrlEncode(FreebaseFilter, True) + '&key=' +
      UrlEncode(FSimpleAPIKey, True) // ==> 403 Forbidden !
    // '&key=' + SimpleAPIKey  ==> retest ?
      ;
    CSSend('RequestURL query portion', RequestURL);
    RequestURL := cBaseURL + RequestURL;
    CSSend('RequestURL final', RequestURL);

    ResponseData :=
    // v1sandbox gives status 200 ok with empty result - useless.
      HTTPSGet(RequestURL, ErrorText, 'HREF Tools WebHub Demo Agent',
      pWebApp.Request.Referer, // forward the actual referer
      True);
    if ErrorText <> '' then
    begin
      pWebApp.Debug.AddPageError(ErrorText);
      pWebApp.SendStringImm('Error: ' + ErrorText);
    end
    else
      pWebApp.SendStringImm('<pre>' + ResponseData + '</pre>');
  end
  else
    pWebApp.Debug.AddPageError(TwhWebAction(Sender).Name +
      ': unable to look up GoogleAPI credentials');
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

procedure TDMGAPI.waTestGeoLocationExecute(Sender: TObject);
const
  cFn = 'waTestGeoLocationExecute';
var
  ResponseJSON: string;
  ErrorText, RawHeadersUsed: string;
  InputFilespec: string;
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  if (FClientSecret <> '') then
  begin
    InputFilespec := getHtDemoCodeRoot +
      'DB Examples\whShopping\google_geoloc_sample.json';

    ResponseJSON :=
      HTTPSPost('https://www.googleapis.com/geolocation/v1/geolocate?' +
        PctEncodeWWWFormPair2005('key', FSimpleAPIKey),
        ErrorText, RawHeadersUsed,
        InputFilespec, // using JSON file as input
        nil, // not using TMemoryStream as input
        'HREF Tools WebHub Demo Agent',
        pWebApp.Request.Scheme + '://' + pWebApp.Request.Authority +
        pWebApp.DynURL.ToSessionIDW, // Current page as Referer for next page
        cCTApplicationJson);

    if ErrorText <> '' then
      pWebApp.SendStringImm('Exception: ' + ErrorText)
    else
      pWebApp.SendStringImm('<h2>JSON</h2><pre>' + ResponseJSON + '</pre>');
  end
  else
    pWebApp.Debug.AddPageError(TwhWebAction(Sender).Name +
      ': unable to look up GoogleAPI credentials');
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

procedure TDMGAPI.WebAppUpdate(Sender: TObject);
const
  cFn = 'WebAppUpdate';
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.

  ZMLookup_GoogleAPI_Credentials('WebHub Demo', FClientID, FClientSecret,
    FSimpleAPIKey);
  pWebApp.AppSetting['GoogleClientID'] := FClientID; // visible in URLs

{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

end.
