unit whOpenID_dmwhAction;

(* this unit is essentially a port from
   https://github.com/janrain/Janrain-Sample-Code/blob/master/php/
   rpx-token-url.php
*)
(* no copyright claimed for this file *)

(* URLs of note
https://developers.google.com/accounts/docs/OpenID#settingup
https://sites.google.com/site/oauthgoog/UXFedLogin/summary
http://www.puffypoodles.com/lso2
*)

interface

uses
  SysUtils, Classes,
  IdHTTP, IdSSLOpenSSL, {$IFDEF UNICODE}IdSSL,{$ENDIF}
  webLink, webTelnt, updateOK, tpAction, webTypes;

type
  TDMWHOpenIDviaJanrain = class(TDataModule)
    waJanrain: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure waJanrainExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    IdHTTP: TIdHTTP;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
    FAPIKey: string;
    FEngage_Pro: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMWHOpenIDviaJanrain: TDMWHOpenIDviaJanrain;

implementation

{$R *.dfm}

uses
  DBXJSON, DBXJSONReflect,
  ucLogFil, ucCodeSiteInterface, ucURLEncode,
  webApp, htWebApp, whdemo_ViewSource, ldiJSONFormatter;

{ TDMWHOpenIDviaJanrain }

procedure TDMWHOpenIDviaJanrain.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

procedure TDMWHOpenIDviaJanrain.DataModuleDestroy(Sender: TObject);
begin
  //
end;

function TDMWHOpenIDviaJanrain.Init(out ErrorText: string): Boolean;
begin
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    (*
    Set this to true if your application is Pro or Enterprise.
    Set this to false if your application is Basic or Plus.
    *)
    FEngage_Pro := false;

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin

// PATH_TO_API_KEY_FILE should contain a path to a plain text file containing only
// your API key. This file should exist in a path that can be read by your web server,
// but not publicly accessible to the Internet.
      FAPIKey := Trim(StringLoadFromFile(getHtDemoCodeRoot +
        'More Examples\whOpenID\janrain_api_key.txt'));

      //test the length of the API ID; it should be 40 characters
      if Length(FAPIKey) = 40 then
      begin

        RefreshWebActions(Self);

        // helpful to know that WebAppUpdate will be called whenever the
        // WebHub app is refreshed.
        AddAppUpdateHandler(WebAppUpdate);
        FlagInitDone := True;
      end
      else
        ErrorText := 'Invalid length of janrain_api_key.txt';
    end;
  end;
  Result := FlagInitDone;
end;

function HTTPSGet(URL: string): string; overload;
var
  IdHTTP: TIdHTTP;
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  IdHTTP := TIdHTTP.Create(nil);
  try
    IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    try
      IdHTTP.IOHandler := IdSSLIOHandlerSocket;
      IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
      Result := IdHTTP.Get(URL);
    finally
      IdSSLIOHandlerSocket.Free;
    end;
  finally
    IdHTTP.Free;
  end;
end;

(* download SSL libraries from here for use with Indy:
http://indy.fulgan.com/SSL/
as of 13-Jun-2011, suitable for Delphi XE...
as of  3-Jan-2013, latests ones for win32 are working with XE3
*)

procedure TDMWHOpenIDviaJanrain.waJanrainExecute(Sender: TObject);
var
  token: string;
  SRequest: string;
  SResponse: string;
  json: TJSONObject;
  json2: TJSONObject;
  pair: TJSONPair;
begin
  json := nil;
  json2 := nil;
  pair := nil;

  {$IFDEF CodeSite}
  //Some output to help debugging
  LogToCodeSiteKeepCRLF('StringVars', pWebApp.StringVars.Text);
  {$ENDIF}

  (* STEP 1: Extract token POST parameter *)
  token := pWebApp.StringVar['token'];
  if Length(token) = 40 then
  begin

    (* STEP 2: Use the token to make the auth_info API call *)
    with TStringList.Create do
    try
      SRequest := Format(
        'https://rpxnow.com/api/v2/auth_info?' +
        'token=%s&' +
        'apiKey=%s&' +
        'format=&' +
        'extended=%s', [
        URLEncode(token, False),
        URLEncode(FAPIKey, False),
        URLEncode('json', False),
        URLEncode(Lowercase(BoolToStr(FEngage_Pro, True)), False)]);
      CSSend('SRequest', SRequest);
      SResponse := HTTPSGet(SRequest);
      CSSend('SResponse', SResponse);
    finally
      Free;
    end;

   (* STEP 3: Parse the JSON auth_info response *)

    try
      json := TJSONObject.Create;
      //pair := json.ParseJSONValue(SResponse);
      pair := TJSONPair.Create(SResponse);
      pWebApp.SendStringImm(ldiFormatJSONString(json2, jfBoldNameFormat));
    finally
      FreeAndNil(json);
      FreeAndNil(json2);
      FreeAndNil(pair);
    end;
  end;
end;

procedure TDMWHOpenIDviaJanrain.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

end.
