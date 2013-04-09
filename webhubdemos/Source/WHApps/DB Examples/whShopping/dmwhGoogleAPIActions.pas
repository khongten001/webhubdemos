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
    procedure DataModuleCreate(Sender: TObject);
    procedure waTestGeoLocationExecute(Sender: TObject);
    procedure waTestFreebaseExecute(Sender: TObject);
    procedure waOAuth2StepTokenExecute(Sender: TObject);
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
  webApp, htWebApp,
  ucString, ucCodeSiteInterface, ucURLEncode, ucHttps, ucGoogleAPICredentials,
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

procedure TDMGAPI.waOAuth2StepTokenExecute(Sender: TObject);
const
  cFn = 'waOAuth2Step1Execute';
var
  AccessToken, TokenType: string;
  ExpiresInMinutes: Integer;
  IDToken, RefreshToken: string;
  S1, S2: string;
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
        if ExchangeApiKeyForToken(S1,
          // this code is returned via URL from google
          pWebApp.Request.Scheme + '://' + pWebApp.Request.Authority +
          pWebApp.DynURL.ToSessionIDW, pWebApp.Request.Scheme + '://' +
          pWebApp.Request.Authority + '/googleapi/shop1/oauth2token',
          // another pre-approved return URI
          FClientID, FClientSecret, AccessToken, TokenType, ExpiresInMinutes,
          IDToken, RefreshToken) then
        begin
          pWebApp.SendStringImm('AccessToken=' + AccessToken);
        end
        else
          pWebApp.SendStringImm('ExchangeApiKeyForToken failed');
      end
      else
        pWebApp.SendStringImm('code not found in callback url from google.');
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
  ErrorText: string;
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  if (FClientSecret <> '') then
  begin
    ResponseJSON := // CodeSite logs 403 Forbidden exception
      HTTPSPost('https://www.googleapis.com/geolocation/v1/geolocate?key=' +
      UrlEncode(FSimpleAPIKey, True), ErrorText,
      getHtDemoCodeRoot + 'DB Examples\whShopping\google_geoloc_sample.json',
      'HREF Tools WebHub Demo Agent', pWebApp.Request.Referer,
      'application/json', '', True);

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
