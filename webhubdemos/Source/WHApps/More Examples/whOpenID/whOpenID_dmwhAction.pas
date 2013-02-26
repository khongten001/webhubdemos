unit whOpenID_dmwhAction;

(* this unit is essentially a port from
https://github.com/janrain/Janrain-Sample-Code/blob/master/php/rpx-token-url.php
*)

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2013 HREF Tools Corp.                                      * }
{ *                                                                          * }
{ * WebHub datamodule login via the janrain.com OpenID system                * }
{ *                                                                          * }
{ * This works only on whitelisted domains e.g. more.demos.href.com          * }
{ *                                                                          * }
{ ---------------------------------------------------------------------------- }

(* download SSL libraries from here for use with Indy:
   http://indy.fulgan.com/SSL/
   as of 13-Jun-2011, suitable for Delphi XE...
   as of  3-Jan-2013, latests ones for win32 are working with XE3
*)


(* URLs of note as of 10-January-2013:
   https://developers.google.com/accounts/docs/OpenID#settingup
   https://sites.google.com/site/oauthgoog/UXFedLogin/summary
   http://www.puffypoodles.com/lso2

   https://rpxnow.com/relying_parties/webhubdemos  -- used by HREF Tools demos
*)

interface

uses
  SysUtils, Classes,
  IdHTTP, IdSSLOpenSSL, IdSSL,
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
    FAPIKey: string;
    FEngage_Pro: Boolean;
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMWHOpenIDviaJanrain: TDMWHOpenIDviaJanrain;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  DBXJSON,
  IdSSLOpenSSLHeaders,
  ucLogFil, ucCodeSiteInterface, ucURLEncode, ucString,
  webApp, htWebApp, whdemo_ViewSource;

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
var
  b: Boolean;
const
  cInstall = 'install libeay32 and ssleay32 DLLs';
begin
  ErrorText := '';
  b := True;
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    try
      // libeay32 and ssleay32
      if not IdSSLOpenSSLHeaders.Load then
      begin
        ErrorText := 'IdSSLOpenSSLHeaders.Load failed; ' + cInstall;
        LogSendError(ErrorText);
        b := False;
      end;
    except
      on e: exception do
      begin
        ErrorText := E.Message + sLineBreak + cInstall;
        b := False;
      end;
    end;

    (*
    Set this to true if your application is Pro or Enterprise.
    Set this to false if your application is Basic or Plus.
    *)
    FEngage_Pro := false;

    if b and Assigned(pWebApp) and pWebApp.IsUpdated then
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
        FlagInitDone := True;
      end
      else
        ErrorText := 'Invalid length of janrain_api_key.txt';
    end;
  end;
  Result := FlagInitDone;
end;

function HTTPSGet(const URL: string): string;
const cFn = 'HTTPSGet';
var
  IdHTTP: TIdHTTP;
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(cFn);{$ENDIF}
  CSSend('URL', URL);
  IdHTTP := nil;
  IdSSLIOHandlerSocket := nil;
  CSSend('01');
  try
    try
      IdHTTP := TIdHTTP.Create(nil);
  CSSend('02');
      IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  CSSend('03');
      IdHTTP.IOHandler := IdSSLIOHandlerSocket;
  CSSend('04');
      IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
  CSSend('05');
      Result := IdHTTP.Get(URL);
      {$IFDEF CodeSite}
      LogToCodeSiteKeepCRLF('Result', Result);
      {$ENDIF}
    except
      on E: Exception do
      begin
        LogSendException(E, cFn);
      end;
    end;
  finally
    FreeAndNil(IdSSLIOHandlerSocket);
    if Assigned(IdHTTP) and Assigned(IdHTTP.IOHandler) then
      IdHTTP.IOHandler := nil;
    FreeAndNil(IdHTTP);
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(cFn);{$ENDIF}
end;


procedure TDMWHOpenIDviaJanrain.waJanrainExecute(Sender: TObject);
var
  ErrorText: string;
  token: string;
  SRequest: string;
  SResponse: string;
  json: TJSONObject;
  jsonProfile: TJSONObject;
  pair: TJSONPair;
  i: Integer;
  S1: string;
  identifier, email, preferredUsername, providerName: string;
  LeftKey: string;
  cn: string;
begin
  json := nil;
  jsonProfile := nil;
  cn := TwhWebaction(Sender).Name;

  if TwhWebAction(Sender).HtmlParam = '' then
  begin
    (* STEP 1: Extract token POST parameter *)
    token := pWebApp.StringVar['token'];
    LogSendInfo('token', token, cn);
    if Length(token) = 40 then
    begin

      pWebApp.Session.DeleteStringVarByName('_identifier');
      pWebApp.Session.DeleteStringVarByName('_email'); // not LinkedIn, Twitter, MySpace
      pWebApp.Session.DeleteStringVarByName('_preferredUsername');
      pWebApp.Session.DeleteStringVarByName('_providerName');

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
        //CSSend('SRequest', SRequest);
        SResponse := HTTPSGet(SRequest);
        //CSSend('SResponse', SResponse);
      finally
        Free;
      end;

     (* STEP 3: Parse the JSON auth_info response *)
      try
        json := TJSONObject.Create;

        if (json.Parse(BytesOf(SResponse), 0) >= 0) then
        begin

          if (json.Size >= 2) then
          begin
            pair := json.Get(0);
            CSSend('0 pair.JsonString', pair.JsonString.ToString);
            CSSend('0 pair.JsonValue', pair.JsonValue.ToString);
            if (NoQuotes(pair.JsonString.ToString) = 'stat') and
              (NoQuotes(pair.JsonValue.ToString) = 'ok') then
            begin
              jsonProfile := TJSONObject.Create;
              S1 := json.Get(1).JSONValue.ToString;
              //CSSend('json.Get(1).JSONValue', json.Get(1).JSONValue.ToString);
              jsonProfile.Parse(BytesOf(S1), 0); // 0-based parsing ! ! !
              CSSend('jsonProfile.Size', S(json.Size));
              for I := 0 to Pred(jsonProfile.Size) do
              begin
                pair := jsonProfile.Get(i);
                LeftKey := NoQuotes(pair.JsonString.ToString);
                //CSSend('i ' + S(i), LeftKey);
                //CSSend('i ' + S(i) + ' pair.JsonValue',  pair.JsonValue.ToString);
                if LeftKey = 'identifier' then
                begin
                  identifier := NoQuotes(pair.JsonValue.ToString);
                  CSSend('identifier', identifier);
                end
                else
                if LeftKey = 'email' then
                  email := NoQuotes(pair.JsonValue.ToString)
                else
                if LeftKey = 'preferredUsername' then
                  preferredUsername := NoQuotes(pair.JsonValue.ToString)
                else
                if LeftKey = 'providerName' then
                  providerName := NoQuotes(pair.JsonValue.ToString);
              end;
              pWebApp.StringVar['_identifier'] := identifier;
              pWebApp.StringVar['_email'] := Lowercase(email); // avoid dupes
              pWebApp.StringVar['_preferredUsername'] := preferredUsername;
              pWebApp.StringVar['_providerName'] := providerName;
              pWebApp.Session.DeleteStringVarByName('token');
            end
            else
            begin
              ErrorTExt := 'status is not ok';
              pWebApp.StringVar[cn + '-ErrorMessage'] := ErrorText;
              LogSendError(ErrorText);
              LogSendError(SResponse);
            end;
          end
          else
          begin
            ErrorText := 'unexpected json.size';
            LogSendWarning(ErrorText);
            CSSend('json.Size', S(json.Size));
            pWebApp.StringVar[cn + '-ErrorMessage'] := ErrorText;
          end;
        end
        else
        begin
          ErrorText := 'Unable to parse JSON response';
          pWebApp.StringVar[cn + '-ErrorMessage'] := ErrorText;
          pWebApp.Debug.AddPageError(cn + ': ' + ErrorText);
          LogSendError(SResponse);
        end;
      finally
        FreeAndNil(json);
        FreeAndNil(jsonProfile);
      end;
    end
    else
    begin
      ErrorText := 'invalid token length';
      pWebApp.StringVar[Self.Name + '-ErrorMessage'] := ErrorText;
      pWebApp.Debug.AddPageError(TwhWebaction(Sender).Name + ': ' + ErrorText);
    end;
  end
  else
  begin
    CSSend('htmlparam', TwhWebAction(Sender).HtmlParam);
    // htmlparam cookieclear
    pWebApp.SendMacro('COOKIECLEAR|login_tab');
    pWebApp.SendMacro('COOKIECLEAR|expected_tab');
    pWebApp.SendMacro('COOKIECLEAR|welcome_info_name');
    pWebApp.SendMacro('HEADER|Set-Cookie: login_tab=; Domain=' +
      pWebApp.Request.Host + '; Path=/;');
    pWebApp.SendMacro('HEADER|Set-Cookie: expected_tab=; Domain=' +
      pWebApp.Request.Host + '; Path=/;');
    pWebApp.SendMacro('HEADER|Set-Cookie: welcome_info_name=; Domain=' +
      pWebApp.Request.Host + '; Path=/;');
  end;
end;

end.
