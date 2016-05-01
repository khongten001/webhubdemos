unit DPrefix_dmwhActions;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 1999-2014 HREF Tools Corp.  All Rights Reserved Worldwide. * }
{ *                                                                          * }
{ * This source code file is part of the Delphi Prefix Registry.             * }
{ *                                                                          * }
{ * This file is licensed under a Creative Commons Attribution 2.5 License.  * }
{ * http://creativecommons.org/licenses/by/2.5/                              * }
{ * If you use this file, please keep this notice intact.                    * }
{ *                                                                          * }
{ * Author: Ann Lynnworth                                                    * }
{ *                                                                          * }
{ * Refer friends and colleagues to www.href.com/whvcl. Thanks!              * }
{ ---------------------------------------------------------------------------- }

interface

uses
  SysUtils, Classes, DB,
  wnxdbAlpha, wdbForm, wdbSource,
  webLink, updateOK, tpAction, webTypes;

type
  TDMDPRWebAct = class(TDataModule)
    waAdd: TwhWebAction;
    waCountPending: TwhWebAction;
    waCleanup2013Login: TwhWebAction;
    waDelete: TwhWebAction;
    waConfirmOpenID: TwhWebAction;
    waURL: TwhWebAction;
    waPrice: TwhWebAction;
    waSaveAndroidCountryCode: TwhWebAction;
    waSelectBigMacCountry: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure waAddExecute(Sender: TObject);
    procedure waCountPendingExecute(Sender: TObject);
    procedure waCleanup2013LoginExecute(Sender: TObject);
    procedure waDeleteExecute(Sender: TObject);
    procedure waDeleteSetCommand(Sender: TObject; var ThisCommand: string);
    procedure waConfirmOpenIDExecute(Sender: TObject);
    procedure waURLExecute(Sender: TObject);
    procedure waURLSetCommand(Sender: TObject; var ThisCommand: string);
    procedure waPriceExecute(Sender: TObject);
    procedure waSaveAndroidCountryCodeExecute(Sender: TObject);
    procedure waSelectBigMacCountryExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    FMpfID: Integer;
    procedure WebAppUpdate(Sender: TObject);
    procedure WebDataFormSetCommand(Sender: TObject; var Command: string);
    procedure WebDataFormField(Sender: TwhdbForm; aField: TField;
      var THCellText, TDCellValue: string);
    procedure WebDataFormSkipField(Sender: TwhdbForm; const iFieldNo: Integer;
      const AFieldName: string; aField: TField; var Skip: Boolean);
    procedure WebDataFormFooter(Sender: TwhdbForm; var Html: string);
  public
    { Public declarations }
    WebDBAlphabet: TWebnxdbAlphabet;
    WebDataForm: TwhdbForm; // requires WebHub v3.220+
    dsAdmin: TDataSource;
    wdsAdmin: TwhdbSource;
    function Init(out ErrorText: string): Boolean;
    function TestURL(const InURL: string; out IStatusCode: Integer): Boolean;
  end;

var
  DMDPRWebAct: TDMDPRWebAct;

implementation

{$R *.dfm}

uses
{$IFDEF CodeSite}CodeSiteLogging, {$ENDIF}
  DateUtils,
  IdHTTP,
  ucCodeSiteInterface, ucString, ucMsTime, ucBase64, ucPos,
  webApp, htWebApp, wdbSSrc,
  DPrefix_dmNexus, whutil_ValidEmail, whdemo_Extensions, uBigMacIndex;

{ TDMDPRWebAct }

const
  cSVSurferCountryCode = '_SurferCountryCode';
  cSVSurferErrorMsg = '_SurferErrorMsg';

procedure TDMDPRWebAct.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  WebDBAlphabet := TWebnxdbAlphabet.Create(Self);
  with WebDBAlphabet do
  begin
    Name := 'WebDBAlphabet';
    Separator := '.';
    WebDataSource := nil; // wdsManPref;
    if Assigned(pWebApp) then
    begin
      // let the webmaster adjust the # of alphabet letters on a row.
      NumPerRow := StrToIntDef(pWebApp.AppSetting['AlphaLetters'], 26);
    end;
  end;

  dsAdmin := TDataSource.Create(Self);
  dsAdmin.Name := 'dsAdmin';
  dsAdmin.DataSet := DMNexus.TableAdmin;

  wdsAdmin := TwhdbSource.Create(Self);
  with wdsAdmin do
  begin
    Name := 'wdsAdmin';
    ComponentOptions := [];
    GotoMode := wgGotoKey;
    MaxOpenDataSets := 1;
    OpenDataSets := 0;
    SaveTableName := False;
    DataSource := dsAdmin;
    KeyFieldNames := 'MpfID';
    // DisplaySet := 'ActiveFields';
  end;

  WebDataForm := TwhdbForm.Create(Self);
  with WebDataForm do
  begin
    Name := 'WebDataForm';
    ComponentOptions := [];
    OnSetCommand := WebDataFormSetCommand;
    WrapMemo := False;
    SkipBlank := False;
    WebDataSource := wdsAdmin;
    OnField := WebDataFormField;
    OnSkipField := WebDataFormSkipField;
    OnFooter := WebDataFormFooter;
  end;

end;

procedure TDMDPRWebAct.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(WebDBAlphabet);
  FreeAndNil(dsAdmin);
  FreeAndNil(wdsAdmin);
end;

function TDMDPRWebAct.Init(out ErrorText: string): Boolean;
begin
  ErrorText := '';

  if NOT FlagInitDone then
  begin
    // reserved for code that should run once, after AppID set

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      RefreshWebActions(Self);

      // helpful to know that WebAppUpdate will be called whenever the
      // WebHub app is refreshed.
      AddAppUpdateHandler(WebAppUpdate);
      FlagInitDone := True;
    end;
  end;
  Result := FlagInitDone;
end;

function TDMDPRWebAct.TestURL(const InURL: string;
  out IStatusCode: Integer): Boolean;
var
  SResponse: string;

  function HTTPGet(const URL: string; out HTTPStatusCode: Integer): string;
  const
    cFn = 'HTTPGet';
  var
    IdHTTP: TIdHTTP;
  begin
{$IFDEF CodeSite}CodeSite.EnterMethod(cFn); {$ENDIF}
    CSSend('URL', URL);
    IdHTTP := nil;
    HTTPStatusCode := 0;
    try
      IdHTTP := TIdHTTP.Create(nil);
      IdHTTP.Request.UserAgent := 'HREFTools (http://delphiprefix.href.com/)';
      try
        Result := IdHTTP.Get(URL);
        HTTPStatusCode := IdHTTP.Response.ResponseCode;
      except
        on E: Exception do
        begin
{$IFDEF CodeSite}
          CodeSite.SendException(E);
{$ENDIF}
          if Pos('Host not found.', E.Message) > 0 then
            HTTPStatusCode := 500
          else
          begin
            if Assigned(IdHTTP) and Assigned(IdHTTP.Response) then
              HTTPStatusCode := IdHTTP.Response.ResponseCode;
          end;
        end;
      end;
      CSSend('HTTPStatusCode', S(HTTPStatusCode));
{$IFDEF CodeSite}
      LogToCodeSiteKeepCRLF('Result', Result);
{$ENDIF}
    finally
      FreeAndNil(IdHTTP);
    end;
{$IFDEF CodeSite}CodeSite.ExitMethod(cFn); {$ENDIF}
  end;

begin
  SResponse := HTTPGet(InURL, IStatusCode);
  Result := SResponse <> '';
end;

procedure TDMDPRWebAct.waAddExecute(Sender: TObject);
const
  cFn = 'waAddExecute';
var
  AFieldName: string;
  i, iKey: Integer;
begin
CSEnterMethod(Self, cFn);
  inherited;

  iKey := 0;
  with DMNexus.TableAdmin do
  begin
    Close;
    IndexName := 'MpfID';
    Open;
    First;
    while not EOF do
    begin
      if FieldByName('MpfID').AsInteger > iKey then
        iKey := FieldByName('MpfID').AsInteger;
      Next;
    end;
  end;

  Inc(iKey);
  CSSend('New Primary Key iKey', S(iKey));

  with TwhWebActionEx(Sender), DMNexus.TableAdmin do
  begin
    Filtered := False;
    Insert;
    // process some fields by name, explicitly, to avoid garbage-in
    FieldByName('MpfID').AsInteger := iKey;
    // Mpf Prefix is excluded from editing so process it here
    FieldByName('Mpf Prefix').asString := pWebApp.StringVar['Mpf Prefix'];
    FieldByName('Mpf EMail').asString := Lowercase(pWebApp.StringVar['_email']);
    // OpenID
    // MpfOpenIDOnAt set during Stamp
    FieldByName('MpfFirstLetter').asString :=
      UpperCase(Copy(pWebApp.StringVar['Mpf Prefix'], 1, 1));
    FieldByName('Mpf Status').asString := 'P'; // new records always Pending
    FieldByName('Mpf Date Registered').asDateTime := NowUTC;

    for i := 0 to Pred(pWebApp.Session.StringVars.count) do
    begin
      // example stringvar: Mpf EMail=info@href.com
      AFieldName := LeftOfEqual(pWebApp.Session.StringVars[i]);
      if DMNexus.IsAllowedRemoteDataEntryField(AFieldName) then
      begin
        CSSend(S(i) + ' aFieldName', AFieldName);
        if { StartsWith(aFieldName,'Mpf') and }
          (FindField(AFieldName) <> nil) then
          FieldByName(AFieldName).asString :=
            RightOfEqual(pWebApp.Session.StringVars[i]);
      end;
    end;
    if Copy(FieldByName('Mpf Webpage').asString, 1, 7) = 'http://' then
      FieldByName('Mpf Webpage').asString :=
        Copy(FieldByName('Mpf Webpage').asString, 8, MaxInt);
    DMNexus.RecordNoAmpersand(DMNexus.TableAdmin);
    DMNexus.Stamp(DMNexus.TableAdmin, 'add');
    try
      Post;
    except
      on E: Exception do
      begin
        LogSendException(E);
      end;
    end;
  end;
CSExitMethod(Self, cFn);
end;

procedure TDMDPRWebAct.waCleanup2013LoginExecute(Sender: TObject);
const
  cFn = 'waCleanup2013LoginExecute';
var
  DPREmail, DPRPassword: string;
  bFound: Boolean;
  cn: string;
begin
CSEnterMethod(Self, cFn);
  bFound := False;
  cn := TwhWebAction(Sender).Name;
  DPREmail := Lowercase(Trim(pWebApp.StringVar['DPREMail']));
  if DPREmail <> '' then
  begin
    DPRPassword := Trim(pWebApp.StringVar['DPRPassword']);
    CSSend('DPRPassword', DPRPassword);
    if (DPRPassword = '') and DemoExtensions.IsSuperuser
      (pWebApp.Request.RemoteAddress) then
    begin
      bFound := True;
      CSSend('superuser');
    end
    else
      with DMNexus.TableAdmin do
      begin
        First;
        while NOT EOF do
        begin
          if (Lowercase(Trim(FieldByName('Mpf Email').asString)) = DPREmail) and
            (FieldByName('MpfPassToken').asString = DPRPassword) then
          begin
            if (NowUTC < FieldByName('MpfPassUntil').asDateTime) then
              bFound := True
            else
              pWebApp.StringVar[cn + '-ErrorMessage'] := 'expired password; ' +
                'please login via Add/Edit using an OpenID provider that knows about '
                + DPREmail;
            break;
          end
          else
            Next;
        end;
      end;
  end;
  if bFound then
  begin
    pWebApp.StringVar['_email'] := DPREmail;
    pWebApp.Response.SendBounceToPage('pgmaintain', '');
  end
  else
    pWebApp.Response.SendBounceToPage('cleanup2013error', '');
CSExitMethod(Self, cFn);
end;

procedure TDMDPRWebAct.waConfirmOpenIDExecute(Sender: TObject);
const
  cFn = 'waConfirmOpenIDExecute';
var
  wasEMail, newEMail: string;
begin
CSEnterMethod(Self, cFn);
  if pWebApp.IsWebRobotRequest then
    pWebApp.Response.SendBounceToPage('pghomepage', '');

  wasEMail := pWebApp.StringVar['_wasEMail'];
  CSSend('_wasEMail', wasEMail);

  if (wasEMail = '') or (NOT StrIsEMail(wasEMail)) then
    pWebApp.Response.SendBounceToPage('pghomepage', '');

  newEMail := pWebApp.StringVar['_email']; // openid
  CSSend('newEMail', newEMail);

  if (newEMail = '') or (NOT StrIsEMail(newEMail)) then
    pWebApp.Response.SendBounceToPage('pghomepage', '');

  // rename _wasEMail -> _email and erase any pass token details
  with DMNexus.TableAdmin do
  begin
    if NOT Filtered then
    begin
      First;
      while NOT EOF do
      begin
        if IsEqual(FieldByName('Mpf Email').asString, wasEMail) then
        begin
          Edit;
          FieldByName('Mpf EMail').asString := Lowercase(newEMail);
          FieldByName('MpfPassToken').asString := '';
          FieldByName('MpfPassUntil').asDateTime := IncDay(Now, -365);
          DMNexus.Stamp(DMNexus.TableAdmin, 'oid');
          Post;
        end;
        Next;
      end;
    end
    else
      LogSendError('admin table filtered; cannot switch email');
  end;
  pWebApp.Session.DeleteStringVarByName('_wasEMail');
  pWebApp.Session.DeleteStringVarByName('DPREMail');
  pWebApp.Response.SendBounceToPage('pgmaintain', '');
CSExitMethod(Self, cFn);
end;

procedure TDMDPRWebAct.waCountPendingExecute(Sender: TObject);
var
  N: Integer;
begin
  N := DMNexus.CountPending;
  pWebApp.SendStringImm(IntToStr(N));
end;

procedure TDMDPRWebAct.waDeleteExecute(Sender: TObject);
const
  cFn = 'waDeleteExecute';
var
  a1: string;
  ErrorText: string;
begin
CSEnterMethod(Self, cFn);
  inherited;
  if FMpfID <> -1 then
  begin
    with pWebApp.Response, wdsAdmin.DataSet do
    begin
      if Locate('MpfID', FMpfID, []) then
      begin
        CSSendNote('found ' + a1 + ' ok');
        Edit;
        FieldByName('Mpf Status').asString := 'D';
        DMNexus.Stamp(wdsAdmin.DataSet, 'srf');
        Post;
      end
      else
      begin
        ErrorText := 'Error - MpfID [' + IntToStr(FMpfID) + '] not found.';
        pWebApp.Debug.AddPageError(ErrorText);
      end;
    end;
  end;
CSExitMethod(Self, cFn);
end;

procedure TDMDPRWebAct.waDeleteSetCommand(Sender: TObject;
  var ThisCommand: string);
const
  cFn = 'waDeleteSetCommand';
var
  a1: string;
begin
CSEnterMethod(Self, cFn);
  inherited;
  FMpfID := -1;

  if ThisCommand <> '' then
  begin
    LogSendInfo('ThisCommand', ThisCommand, cFn);
    a1 := Uncode64String(ThisCommand);
    LogSendInfo('a1', a1, cFn);
    FMpfID := StrToIntDef(a1, -1);
    LogSendInfo('fMpfID', S(FMpfID), cFn);
  end;
CSExitMethod(Self, cFn);
end;

procedure TDMDPRWebAct.waPriceExecute(Sender: TObject);
var
  SurferCountryCode: string;
  Price: Currency;
begin
  SurferCountryCode := pWebApp.StringVar[cSVSurferCountryCode];
  Price := BigMacPriceForCountry(SurferCountryCode, 1);
  pWebApp.Response.Send(Format('%m usd', [Price]));
end;

procedure TDMDPRWebAct.waSaveAndroidCountryCodeExecute(Sender: TObject);
const
  cFn = 'waSaveAndroidCountryCode';
var
  ThisCountryCode: string;
begin
  CSEnterMethod(Self, cFn);
  pWebApp.StringVar[cSVSurferErrorMsg] := '';
  if Pos('country=', pWebApp.Command) > 0 then // country=CH  for Switzerland
  begin
    ThisCountryCode := RightOfEqual(pWebApp.Command);
    { allow reasonable data entry from non-Android-app surfers }
    if ThisCountryCode = 'input' then
    begin
      ThisCountryCode := UpperCase(pWebApp.StringVar['inCountryCode']);
      if NOT IsCountrySupported(ThisCountryCode) then
      begin
        pWebApp.StringVar[cSVSurferErrorMsg] :=
          Format('Error: %s is not a country supported by the Big Mac Index.',
          [ThisCountryCode]);
        pWebApp.Response.SendBounceToPage('pgChangeCountry', '');
      end;

    end;
    { remember the surfer country }
    pWebApp.StringVar[cSVSurferCountryCode] := ThisCountryCode;
  end
  else
  begin
    CSSend('command', pWebApp.Command);
    if pWebApp.StringVar[cSVSurferCountryCode] = '' then
    begin
      // do not reset if we already have a valid answer, e.g. from Android
      // location sensor.
      pWebApp.StringVar[cSVSurferCountryCode] := 'US';
    end;
  end;
  CSExitMethod(Self, cFn);
end;

procedure TDMDPRWebAct.waSelectBigMacCountryExecute(Sender: TObject);
const
  cFn = 'waSelectBigMacCountryExecute';
var
  HtmlSelectStr: string;
  FieldName, FieldID, FieldCSS: string;
begin
  CSEnterMethod(Self, cFn);
  SplitThree(TwhWebAction(Sender).HtmlParam, ',', FieldName, FieldID, FieldCSS);

  HtmlSelectStr := HtmlSelectCountry(FieldName, FieldID, FieldCSS);

  CSSend('HtmlSelectStr', HtmlSelectStr);
  pWebApp.SendStringImm(HtmlSelectStr);

  CSExitMethod(Self, cFn);
end;

procedure TDMDPRWebAct.waURLExecute(Sender: TObject);
const
  cFn = 'waURLExecute';
const
  cUpdatedBy = 'url';
var
  aURL: string;
  IStatusCode: Integer;
  ErrorText: string;
begin
  CSEnterMethod(Self, cFn);
  inherited;
  if FMpfID <> -1 then
  begin
    with wdsAdmin.DataSet do
    begin

      if Locate('MpfID', FMpfID, []) then
      begin
        CSSendNote('found ' + IntToStr(FMpfID) + ' ok');

        aURL := FieldByName('Mpf WebPage').asString;
        if aURL <> '' then
        begin
          aURL := 'http://' + aURL;
          DMDPRWebAct.TestURL(aURL, IStatusCode);
          if IStatusCode > 0 then
          begin
            Edit;
            FieldByName('MpfURLStatus').AsInteger := IStatusCode;
            FieldByName('MpfURLTestOnAt').asDateTime := NowUTC;
            DMNexus.Stamp(DMNexus.TableAdmin, cUpdatedBy);
            Post;
          end;
        end
        else
        begin
          if (NOT FieldByName('MpfURLStatus').IsNull) and
            (FieldByName('MpfURLStatus').AsInteger <> -1) then
          begin
            Edit;
            FieldByName('MpfURLStatus').AsInteger := -1;
            FieldByName('MpfURLTestOnAt').asDateTime := NowUTC;
            DMNexus.Stamp(DMNexus.TableAdmin, cUpdatedBy);
            Post;
          end;
        end;

      end
      else
      begin
        ErrorText := 'Error - MpfID ' + IntToStr(FMpfID) + ' not found.';
        pWebApp.Debug.AddPageError(ErrorText);
      end;
    end;
  end;
  pWebApp.Response.SendBounceToPage('pgmaintain', '');
  CSExitMethod(Self, cFn);
end;

procedure TDMDPRWebAct.waURLSetCommand(Sender: TObject;
  var ThisCommand: string);
const
  cFn = 'waURLSetCommand';
var
  a1: string;
begin
CSEnterMethod(Self, cFn);
  inherited;
  FMpfID := -1;

  if ThisCommand <> '' then
  begin
    a1 := Uncode64String(ThisCommand);
    FMpfID := StrToIntDef(a1, -1);
  end;
CSExitMethod(Self, cFn);
end;

procedure TDMDPRWebAct.WebAppUpdate(Sender: TObject);
begin
  // placeholder
end;

procedure TDMDPRWebAct.WebDataFormField(Sender: TwhdbForm; aField: TField;
  var THCellText, TDCellValue: string);
begin
  inherited;
  // indicate that the primary key is off limits
  THCellText := StringReplaceAll(THCellText, 'Mpf', ''); // strip from label
  if (aField.FieldName = 'MpfID') or (aField.FieldName = 'Mpf Prefix') then
  begin
    TDCellValue := '<span style="color:#666; font-weight: 900;">' +
      aField.asString + '</span>';
  end;
end;

procedure TDMDPRWebAct.WebDataFormFooter(Sender: TwhdbForm; var Html: string);
begin
  Html := '(~mcSubmitWebDataForm~)';
end;

procedure TDMDPRWebAct.WebDataFormSetCommand(Sender: TObject;
  var Command: string);
const
  cFn = 'WebDataFormSetCommand';
var
  a1: string;
  ErrorText: string;
  b: Boolean;
begin
CSEnterMethod(Self, cFn);
  inherited;
  Assert(Sender is TwhdbForm);

  a1 := Uncode64String(Command);
  CSSend('Uncoded command', a1);

  with pWebApp.Response, wdsAdmin.DataSet do
  begin
    b := Locate('MpfID', StrToIntDef(a1, -1), []);
    (Sender as TwhdbForm).LocateResult := b; // must tag both properties True
    CSSend('WebDataForm.LocateResult', S(WebDataForm.LocateResult));
    CSSend('WebDataForm.AlreadyLocated', S(WebDataForm.AlreadyLocated));
    if b then
    begin
      CSSendNote('found ' + a1 + ' ok');
      (Sender as TwhdbForm).AlreadyLocated := True;
      (Sender as TwhdbForm).SetWorkKey(a1);
      CSSend('WebDataForm.WorkKey', (Sender as TwhdbForm).WorkKey);
    end
    else
    begin
      ErrorText := 'Error - MpfID [' + a1 + '] not found.';
      CSSendError(ErrorText);
      pWebApp.Debug.AddPageError(ErrorText);
      pWebApp.StringVar[TwhWebAction(Sender).Name + '-ErrorMessage'] :=
        ErrorText;
    end;
  end;
  (Sender as TwhdbForm).AlreadyLocated := True; // attempted.
CSExitMethod(Self, cFn);
end;

procedure TDMDPRWebAct.WebDataFormSkipField(Sender: TwhdbForm;
  const iFieldNo: Integer; const AFieldName: string; aField: TField;
  var Skip: Boolean);
begin
  if iFieldNo = 0 then
    Skip := False // display primary key
  else if AFieldName = 'Mpf Prefix' then
    Skip := False // display the prefix
  else
    Skip := NOT DMNexus.IsAllowedRemoteDataEntryField(AFieldName);
end;

end.
