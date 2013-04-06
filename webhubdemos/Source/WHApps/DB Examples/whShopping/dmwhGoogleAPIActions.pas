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
    waOAuth2Step1: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure waTestGeoLocationExecute(Sender: TObject);
    procedure waTestFreebaseExecute(Sender: TObject);
    procedure waOAuth2Step1Execute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
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
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp, htWebApp,
  ucCodeSiteInterface, ucURLEncode, ucHttps, ucGoogleAPICredentials,
  whdemo_ViewSource, tpGoogle_ServiceResource;

{ TDMGAPI}

procedure TDMGAPI.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMGAPI.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      // Call RefreshWebActions here only if it is not called within a TtpProject event
      // RefreshWebActions(Self);

      // helpful to know that WebAppUpdate will be called whenever the
      // WebHub app is refreshed.
      AddAppUpdateHandler(WebAppUpdate);
      FlagInitDone := True;
    end;
  end;
  Result := FlagInitDone;
  {$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMGAPI.waOAuth2Step1Execute(Sender: TObject);
const
  cFn = 'waOAuth2Step1Execute';
var
  ClientID, ClientSecret, SimpleAPIKey: string;
  AccessToken, TokenType: string;
  ExpiresInMinutes: Integer;
  IDToken, RefreshToken: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  if ZMLookup_GoogleAPI_Credentials('WebHub Demo', ClientID, ClientSecret,
    SimpleAPIKey) then
  begin
    if ExchangeApiKeyForToken(SimpleAPIKey, pWebApp.DynURL.ToSessionIDW,
      pWebApp.DynURL.ToAppID + pWebApp.DynURL.W + 'pgGoogleApiStep2' +
      pWebApp.DynURL.W + pWebApp.SessionID,
      ClientID, ClientSecret, AccessToken, TokenType, ExpiresInMinutes,
      IDToken, RefreshToken) then
    begin
      pWebApp.SendStringImm('AccessToken=' + AccessToken);
    end;
  end
  else
    pWebApp.Debug.AddPageError(TwhWebAction(Sender).Name +
      ': unable to look up GoogleAPI credentials');
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMGAPI.waTestFreebaseExecute(Sender: TObject);
const
  cFn = 'waTestFreebaseExecute';
  cBaseURL = 'https://www.googleapis.com/freebase/v1/search?';
var
  ClientID, ClientSecret, SimpleAPIKey: string;
  ResponseData: string;
  FreebaseQueryTerm, FreebaseFilter: string;
  ErrorText: string;
  RequestURL: string;
  ResponseLimit: Integer;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  if ZMLookup_GoogleAPI_Credentials('WebHub Demo', ClientID, ClientSecret,
    SimpleAPIKey) then
  begin
    FreebaseQueryTerm := pWebApp.StringVar['FreebaseQueryTerm'];
    FreebaseFilter := pWebApp.StringVar['FreebaseFilter'];

    ResponseLimit := 10;

    { NB: each (string) parameter *value* must be URLencoded separately }

    RequestURL := 'q=' +
        UrlEncode(FreebaseQueryTerm, True) +
        '&userIp=' + pWebApp.Request.RemoteAddress +
        '&limit=' + IntToStr(ResponseLimit) +
        '&indent=true' +
        '&filter=' + UrlEncode(FreebaseFilter, True) +
        '&key=' + UrlEncode(SimpleAPIKey, True)  // ==> 403 Forbidden !
        //'&key=' + SimpleAPIKey  ==> retest ?
        ;
    CSSend('RequestURL query portion', RequestURL);
    RequestURL := cBaseURL + RequestURL ;
    CSSend('RequestURL final', RequestURL);

    ResponseData :=
      // v1sandbox gives status 200 ok with empty result - useless.
      HTTPSGet(RequestURL,
        ErrorText,
        'HREF Tools WebHub Demo Agent',
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
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMGAPI.waTestGeoLocationExecute(Sender: TObject);
const cFn = 'waTestGeoLocationExecute';
var
  ClientID, ClientSecret, SimpleAPIKey: string;
  ResponseJSON: string;
  ErrorText: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  if ZMLookup_GoogleAPI_Credentials('WebHub Demo', ClientID, ClientSecret,
    SimpleAPIKey) then
  begin
    ResponseJSON := // CodeSite logs 403 Forbidden exception
      HTTPSPost('https://www.googleapis.com/geolocation/v1/geolocate?key=' +
        URLEncode(SimpleAPIKey, True),
        ErrorText,
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
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMGAPI.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
