unit DPrefix_dmWhActions;

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
  private
    { Private declarations }
    FlagInitDone: Boolean;
    FMpfID: Integer;
    procedure WebAppUpdate(Sender: TObject);
    procedure WebDataFormSetCommand(Sender: TObject; var Command: string);
    procedure WebDataFormField(Sender: TwhdbForm; aField: TField;
      var THCellText, TDCellValue: string);
    procedure WebDataFormSkipField(Sender: TwhdbForm; const iFieldNo: Integer;
      const AFieldName: string; AField: TField; var Skip: Boolean);
    procedure WebDataFormFooter(Sender: TwhdbForm; var Html: string);
  public
    { Public declarations }
    WebDBAlphabet: TWebnxdbAlphabet;
    WebDataForm: TwhdbForm;  // requires WebHub v3.220+
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
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  DateUtils,
  IdHTTP,
  ucCodeSiteInterface, ucString, ucMsTime, ucBase64, ucPos,
  webApp, htWebApp, wdbSSrc,
  DPrefix_dmNexus, whutil_ValidEmail, whdemo_Extensions;

{ TDMDPRWebAct }

procedure TDMDPRWebAct.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  WebDBAlphabet := TWebnxdbAlphabet.Create(Self);
  with WebDBAlphabet do
  begin
    Name := 'WebDBAlphabet';
    Separator := '.';
    WebDataSource := nil; //wdsManPref;
    if Assigned(pWebApp) then
    begin
      // let the webmaster adjust the # of alphabet letters on a row.
      NumPerRow:=StrToIntDef(pWebApp.AppSetting['AlphaLetters'],26);
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
    //DisplaySet := 'ActiveFields';
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

function TDMDPRWebAct.TestURL(const InURL: string; out IStatusCode: Integer)
  : Boolean;
var
  SResponse: string;

  function HTTPGet(const URL: string; out HTTPStatusCode: Integer): string;
  const cFn = 'HTTPGet';
  var
    IdHTTP: TIdHTTP;
  begin
    {$IFDEF CodeSite}CodeSite.EnterMethod(cFn);{$ENDIF}
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
    {$IFDEF CodeSite}CodeSite.ExitMethod(cFn);{$ENDIF}
  end;

begin
  SResponse := HTTPGet(InURL, iStatusCode);
  Result := SResponse <> '';
end;

procedure TDMDPRWebAct.waAddExecute(Sender: TObject);
const cFn = 'waAddExecute';
var
  aFieldname: string;
  i,iKey: integer;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
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
    FieldByName('MpfID').asInteger:=iKey;
    // Mpf Prefix is excluded from editing so process it here
    FieldByName('Mpf Prefix').asString:= pWebApp.StringVar['Mpf Prefix'];
    FieldByName('Mpf EMail').asString := Lowercase(pWebApp.StringVar['_email']); // OpenID
    // MpfOpenIDOnAt set during Stamp
    FieldByName('MpfFirstLetter').asString:=
      UpperCase(Copy(pWebApp.StringVar['Mpf Prefix'], 1, 1));
    FieldByName('Mpf Status').AsString := 'P';  // new records always Pending
    FieldByName('Mpf Date Registered').asDateTime := NowGMT;

    for i:=0 to Pred(pWebApp.Session.StringVars.count) do
    begin
      //example stringvar: Mpf EMail=info@href.com
      aFieldName:=LeftOfEqual(pWebApp.Session.StringVars[i]);
      if DMNexus.IsAllowedRemoteDataEntryField(aFieldname) then
      begin
        CSSend(S(i) + ' aFieldName', aFieldName);
        if {StartsWith(aFieldName,'Mpf') and }
          (FindField(aFieldName)<>nil) then
          FieldByName(aFieldName).asString :=
            RightOfEqual(pWebApp.Session.StringVars[i]);
      end;
    end;
    if Copy(FieldByName('Mpf Webpage').AsString, 1, 7) = 'http://' then
      FieldByName('Mpf Webpage').AsString := Copy(
        FieldByName('Mpf Webpage').AsString, 8, MaxInt);
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
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMDPRWebAct.waCleanup2013LoginExecute(Sender: TObject);
const cFn = 'waCleanup2013LoginExecute';
var
  DPREmail, DPRPassword: string;
  bFound: Boolean;
  cn: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  bFound := False;
  cn := TwhWebAction(Sender).Name;
  DPREmail := Lowercase(Trim(pWebApp.StringVar['DPREMail']));
  if DPREmail <> '' then
  begin
    DPRPassword := Trim(pWebApp.StringVar['DPRPassword']);
    CSSend('DPRPassword', DPRPassword);
    if (DPRPassword = '') and DemoExtensions.IsSuperuser(
      pWebApp.Request.RemoteAddress) then
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
        if (Lowercase(Trim(FieldByName('Mpf Email').AsString)) = DPREmail) and
          (FieldByName('MpfPassToken').AsString = DPRPassword) then
        begin
          if (NowGMT < FieldByName('MpfPassUntil').AsDateTime) then
            bFound := True
          else
            pWebApp.StringVar[cn + '-ErrorMessage'] := 'expired password; ' +
            'please login via Add/Edit using an OpenID provider that knows about ' + 
            DPREmail;
          break;
        end
        else
          Next;
      end;
    end;
  end;
  if bFound then
  begin
    pWebApp.StringVar['_email'] := DPREMail;
    pWebApp.Response.SendBounceToPage('pgmaintain', '');
  end
  else
    pWebApp.Response.SendBounceToPage('cleanup2013error', '');
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMDPRWebAct.waConfirmOpenIDExecute(Sender: TObject);
const cFn = 'waConfirmOpenIDExecute';
var
  wasEMail, newEMail: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}

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

  //rename _wasEMail -> _email and erase any pass token details
  with DMNexus.TableAdmin do
  begin
    if NOT Filtered then
    begin
      First;
      while NOT EOF do
      begin
        if IsEqual(FieldByName('Mpf Email').AsString, wasEMail) then
        begin
          Edit;
          FieldByName('Mpf EMail').AsString := Lowercase(newEMail);
          FieldByName('MpfPassToken').AsString := '';
          FieldByName('MpfPassUntil').AsDateTime := IncDay(Now, -365);
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
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMDPRWebAct.waCountPendingExecute(Sender: TObject);
var
  N: Integer;
begin
  n := DMNexus.CountPending;
  pWebApp.SendStringImm(IntToStr(N));
end;

procedure TDMDPRWebAct.waDeleteExecute(Sender: TObject);
const cFn = 'waDeleteExecute';
var
  a1:string;
  ErrorText: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  if FMpfID <> -1 then
  begin
    with pWebApp.Response, wdsAdmin.DataSet do
    begin
      if Locate('MpfID', fMpfID,[]) then
      begin
        CSSendNote('found ' + a1 + ' ok');
        Edit;
        FieldByName('Mpf Status').AsString := 'D';
        DMNexus.Stamp(wdsAdmin.DataSet, 'srf');
        Post;
      end
      else
      begin
        ErrorText := 'Error - MpfID ['+ IntToStr(FMpfID) + '] not found.';
        pWebApp.Debug.AddPageError(ErrorText);
      end;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMDPRWebAct.waDeleteSetCommand(Sender: TObject;
  var ThisCommand: string);
const cFn = 'waDeleteSetCommand';
var
  a1:string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  FMpfID := -1;

  if ThisCommand <> '' then
  begin
    LogSendInfo('ThisCommand', ThisCommand, cFn);
    a1 := Uncode64String(ThisCommand);
    LogSendInfo('a1', a1, cFn);
    fMpfID := StrToIntDef(a1, -1);
    LogSendInfo('fMpfID', S(fMpfID), cFn);
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMDPRWebAct.waURLExecute(Sender: TObject);
const cFn = 'waURLExecute';
const cUpdatedBy = 'url';
var
  aURL: string;
  iStatusCode: Integer;
  ErrorText: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  if FMpfID <> -1 then
  begin
    with wdsAdmin.DataSet do
    begin

      if Locate('MpfID', fMpfID, []) then
      begin
        CSSendNote('found ' + IntToStr(fMpfID) + ' ok');

        AURL := FieldByName('Mpf WebPage').AsString;
        if AURL <> '' then
        begin
          AURL := 'http://' + AURL;
          DMDPRWebAct.TestURL(AURL, iStatusCode);
          if iStatusCode > 0 then
          begin
            Edit;
            FieldByName('MpfURLStatus').AsInteger := iStatusCode;
            FieldByName('MpfURLTestOnAt').AsDateTime := NowGMT;
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
            FieldByName('MpfURLTestOnAt').AsDateTime := NowGMT;
            DMNexus.Stamp(DMNexus.TableAdmin, cUpdatedBy);
            Post;
          end;
        end;

      end
      else
      begin
        ErrorText := 'Error - MpfID '+ IntToStr(FMpfID) + ' not found.';
        pWebApp.Debug.AddPageError(ErrorText);
      end;
    end;
  end;
  pWebApp.Response.SendBounceToPage('pgmaintain', '');
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMDPRWebAct.waURLSetCommand(Sender: TObject;
  var ThisCommand: string);
const cFn = 'waURLSetCommand';
var
  a1:string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  FMpfID := -1;

  if ThisCommand <> '' then
  begin
    a1 := Uncode64String(ThisCommand);
    fMpfID := StrToIntDef(a1, -1);
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMDPRWebAct.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

procedure TDMDPRWebAct.WebDataFormField(Sender: TwhdbForm; aField: TField;
  var THCellText, TDCellValue: string);
begin
  inherited;
  // indicate that the primary key is off limits
  THCellText := StringReplaceAll(THCellText, 'Mpf', ''); // strip from label
  if (AField.fieldname='MpfID') or (AField.FieldName = 'Mpf Prefix') then
  begin
    TDCellValue := '<span style="color:#666; font-weight: 900;">' +
      AField.AsString + '</span>';
  end;
end;

procedure TDMDPRWebAct.WebDataFormFooter(Sender: TwhdbForm; var Html: string);
begin
  Html := '(~mcSubmitWebDataForm~)';
end;

procedure TDMDPRWebAct.WebDataFormSetCommand(Sender: TObject;
  var Command: string);
const cFn = 'WebDataFormSetCommand';
var
  a1:string;
  ErrorText: string;
  b: Boolean;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  Assert(Sender is TwhdbForm);

  a1 := Uncode64String(Command);
  CSSend('Uncoded command', a1);

  with pWebApp.Response, wdsAdmin.DataSet do
  begin
    b := Locate('MpfID', StrToIntDef(a1,-1),[]);
    (Sender as TwhdbForm).LocateResult := b;   // must tag both properties True
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
      pWebApp.StringVar[TwhWebAction(Sender).Name + '-ErrorMessage']
        := ErrorText;
    end;
  end;
  (Sender as TwhdbForm).AlreadyLocated := True; // attempted.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMDPRWebAct.WebDataFormSkipField(Sender: TwhdbForm;
  const iFieldNo: Integer; const AFieldName: string; AField: TField;
  var Skip: Boolean);
begin
  if iFieldNo = 0 then
    Skip := False // display primary key
  else
  if AFieldName = 'Mpf Prefix' then
    Skip := False // display the prefix
  else
    Skip := NOT DMNexus.IsAllowedRemoteDataEntryField(AFieldName);
end;

end.
