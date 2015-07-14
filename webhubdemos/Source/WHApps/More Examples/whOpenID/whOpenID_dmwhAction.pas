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

{$I hrefdefines.inc}

uses
  SysUtils, Classes,
  IdHTTP, IdSSLOpenSSL, IdSSL,
  updateOK, tpAction,
  webLink, webTypes, webSend;

type
  TDMWHOpenIDviaJanrain = class(TDataModule)
    waJanrain: TwhWebAction;
    waOpenIDServer: TwhWebAction;
    waSend301: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure waJanrainExecute(Sender: TObject);
    procedure waOpenIDServerExecute(Sender: TObject);
    procedure waSend301Execute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    FAPIKey: string;
    FEngage_Pro: Boolean;
    procedure SETAPIKey(const InValue: string);
    procedure SampleAppExecuteHandler(Sender: TwhRespondingApp;
      var bContinue: Boolean);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
    property APIKey: string read FAPIKey write SetAPIKey;
  end;

var
  DMWHOpenIDviaJanrain: TDMWHOpenIDviaJanrain;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  {$IFDEF Delphi20UP}JSON, {$ELSE} DBXJSON, {$ENDIF}
  IdSSLOpenSSLHeaders,
  ucLogFil, ucCodeSiteInterface, ucURLEncode, ucString, ucHTTPS,
  webApp, htWebApp;

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
// Set this in the project manager.
      FlagInitDone := True;

    end;

    (* additional initialization is for demonstration of 404 responses *)
    AddAppExecuteHandler(SampleAppExecuteHandler);

  end;
  Result := FlagInitDone;
end;

procedure TDMWHOpenIDviaJanrain.SampleAppExecuteHandler(
  Sender: TwhRespondingApp; var bContinue: Boolean);
const cFn = 'SampleAppExecuteHandler';
begin
  CSEnterMethod(Self, cFn);
  if pWebApp.Request.QueryString = 'htoi:pg404' then
  begin
    pWebApp.Response.HTTPStatusCode := 404;
    pWebApp.Response.HTTPStatusDesc := 'not found';
    pWebApp.Response.Send('###');
    bContinue := False;
  end;
  CSExitMethod(Self, cFn);
end;

procedure TDMWHOpenIDviaJanrain.SETAPIKey(const InValue: string);
begin
  //test the length of the API ID; it should be 40 characters
  if Length(InValue) = 40 then
  begin
    FAPIKey := InValue;
    RefreshWebActions(Self);
  end
  else
    LogSendError('Invalid length of janrain_api_key.txt');
end;

(*function HTTPSGet(const URL: string): string;
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
end; *)


procedure TDMWHOpenIDviaJanrain.waJanrainExecute(Sender: TObject);
const cFn = 'waJanrainExecute';
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
  givenName, familyName, url: string;
  LeftKey: string;
  cn: string;
begin
  CSEnterMethod(Self, cFn);
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
        SResponse := HTTPSGet(SRequest, ErrorText);
        LogToCodeSiteKeepCRLF('SResponse', SResponse);
        if ErrorText <> '' then
          LogSendError(ErrorText);
      finally
        Free;
      end;

     (* STEP 3: Parse the JSON auth_info response *)
      try
        json := TJSONObject.Create;

        if (json.Parse(BytesOf(SResponse), 0) >= 0) then
        begin

          CSSend('json.Count', S(json.Count));
          if ({$IFDEF Delphi20UP}json.Count{$ELSE}json.Size{$ENDIF} >= 2) then
          begin
            pair := {$IFDEF Delphi20UP}json.Pairs[0]{$ELSE}json.Get(0){$ENDIF};
            CSSend('0 pair.JsonString', pair.JsonString.ToString);
            CSSend('0 pair.JsonValue', pair.JsonValue.ToString);
            if (NoQuotes(pair.JsonString.ToString) = 'stat') and
              (NoQuotes(pair.JsonValue.ToString) = 'ok') then
            begin
              jsonProfile := TJSONObject.Create;
              S1 := {$IFDEF Delphi20UP}json.Pairs[1]{$ELSE}json.Get(1){$ENDIF}.JSONValue.ToString;
              jsonProfile.Parse(BytesOf(S1), 0); // 0-based parsing ! ! !
              CSSend('jsonProfile.Size', S({$IFDEF Delphi20UP}json.Count{$ELSE}json.Size{$ENDIF}));
              for I := 0 to Pred({$IFDEF Delphi20UP}jsonProfile.Count{$ELSE}jsonProfile.Size{$ENDIF}) do
              begin
                pair := {$IFDEF Delphi20UP}jsonProfile.Pairs[i]{$ELSE}jsonProfile.Get(i){$ENDIF};
                LeftKey := NoQuotes(pair.JsonString.ToString);
                CSSend('i ' + S(i), LeftKey);
                //CSSend('i ' + S(i) + ' pair.JsonValue',  pair.JsonValue.ToString);
                if LeftKey = 'identifier' then
                begin
                  identifier := NoQuotes(pair.JsonValue.ToString);
                  CSSend('identifier', identifier);
                end
                else
                if (LeftKey = 'email') or (LeftKey = 'verifiedEmail') then
                  email := NoQuotes(pair.JsonValue.ToString)
                else
                if LeftKey = 'preferredUsername' then
                  preferredUsername := NoQuotes(pair.JsonValue.ToString)
                else
                if LeftKey = 'givenName' then
                  givenName := NoQuotes(pair.JsonValue.ToString)
                else
                if LeftKey = 'familyName' then
                  familyName := NoQuotes(pair.JsonValue.ToString)
                else
                if LeftKey = 'url' then
                  url := NoQuotes(pair.JsonValue.ToString)
                else
                if (LeftKey = 'providerName') or (LeftKey = 'providerSpecifier')
                then
                  providerName := NoQuotes(pair.JsonValue.ToString);
              end;
              pWebApp.StringVar['_identifier'] := identifier;
              pWebApp.StringVar['_email'] := Lowercase(email); // avoid dupes
              pWebApp.StringVar['_preferredUsername'] := preferredUsername;
              pWebApp.StringVar['_providerName'] := providerName;
              pWebApp.StringVar['_janrain_familyName'] := familyName;
              pWebApp.StringVar['_janrain_givenName'] := givenName;
              pWebApp.StringVar['_janrain_url'] := url;
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
            CSSend('json.Size', S({$IFDEF Delphi20UP}json.Count{$ELSE}json.Size{$ENDIF}));
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
  CSExitMethod(Self, cFn);
end;

type
  TOpenIDRec = record
    identity: string;
    return_to: string;
    rpnonce: string;
    rpsig: string;
    trust_root: string;
    mode: string;
    ns_ext1: string;
    ext1_preferred_auth_policies: string; // Janrain has this
    ext1_max_auth_age: integer;           // Janrain has this
    ns_ext2: string;
    ext2_mode: string;                    // e.g. popup; Janrain has this
    ns_sreg: string;
    sreg_optional: string; // comma separated list
  end;

procedure TDMWHOpenIDviaJanrain.waOpenIDServerExecute(Sender: TObject);
const cFn = 'waOpenIDServerExecute';
var
  openidInfo: TOpenIDRec;
  s1, s2: string;
  key, value: string;
  b1, b2: Boolean;
begin
  CSEnterMethod(Self, cFn);

  s1 := pWebApp.Command;
  b2 := False;
  LogSendInfo('command',S1);

  while (S1 <> '') do
  begin
    b1 := SplitString(S1, '&', S1, S2);
    if S1 <> '' then
    begin
      b2 := SplitString(S1, '=', key, value);
      if (key = 'openid.identity') or (key=',openid.identity') then
      begin
        openidInfo.identity := value;
      end
      else
      if key = 'openid.return_to' then
      begin
        openidInfo.return_to := value;
      end
      else
      if key = 'openid.rpnonce' then
      begin
        openidInfo.rpnonce := value;
      end
      else
      if key = 'openid.rpsig' then
      begin
        openidInfo.rpsig := value;
      end
      else
      if key = 'openid.trust_root' then
      begin
        openidInfo.trust_root := value;
      end
      else
      if key = 'openid.mode' then
      begin
        openidInfo.mode := value;
      end
      else
      if key = 'openid.sreg.optional' then
      begin
        openidInfo.sreg_optional := value;
      end;
    end;
    if b1 then
      S1 := S2
    else
    if b2 then
      S1 := '';
  end;

  LogSendInfo('identity', openidInfo.identity, cFn);
  LogSendInfo('return_to', openidInfo.return_to, cFn);

  if openidInfo.return_to <> '' then
    pWebApp.Response.SendBounceTo(openidInfo.return_to +
      '&code=SplxlOBeZQQYbYS6WxSbIA&state=af0ifjsldkj');

  CSExitMethod(Self, cFn);
end;

procedure TDMWHOpenIDviaJanrain.waSend301Execute(Sender: TObject);
const cFn = 'waSend301Execute';
var
  TargetURL: string;
begin
  CSEnterMethod(Self, cFn);
  TargetURL := TwhWebAction(Sender).HtmlParam;
  TargetURL := pWebApp.MoreIfParentild(TargetURL);
  CSSend('TargetURL', TargetURL);
  pWebApp.Response.SendRedirection301(TargetURL);
  CSExitMethod(Self, cFn);
end;

end.
