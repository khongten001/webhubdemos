unit DPrefix_dmWhActions;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 1999-2013 HREF Tools Corp.  All Rights Reserved Worldwide. * }
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
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure waAddExecute(Sender: TObject);
    procedure waCountPendingExecute(Sender: TObject);
    procedure waCleanup2013LoginExecute(Sender: TObject);
    procedure waDeleteExecute(Sender: TObject);
    procedure waDeleteSetCommand(Sender: TObject; var ThisCommand: string);
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
    WebDataForm: TwhdbForm;
    dsAdmin: TDataSource;
    wdsAdmin: TwhdbSource;
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMDPRWebAct: TDMDPRWebAct;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucCodeSiteInterface, ucString, ucMsTime, ucBase64, ucPos,
  webApp, htWebApp, wdbSSrc,
  DPrefix_dmNexus;

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
    First;
    while not EOF do
    begin
      if FieldByName('MpfID').AsInteger > iKey then
        iKey := FieldByName('MpfID').AsInteger;
      Next;
    end;
  end;

  Inc(iKey);
  CSSend('iKey', S(iKey));

  with TwhWebActionEx(Sender), DMNexus.TableAdmin do
  begin
    Filtered := False;
    Insert;
    FieldByName('MpfID').asInteger:=iKey;
    FieldByName('Mpf EMail').asString := pWebApp.StringVar['_email']; // OpenID
    FieldByName('Mpf Status').asString:='P';  // pending
    FieldByName('Mpf Date Registered').asDateTime:=now;
    FieldByName('Mpf Notes').asString :=
      pWebApp.Session.TxtVars.List['txtComment'].text;
    CSSend('Mpf Notes', FieldByName('Mpf Notes').asString);

    for i:=0 to Pred(pWebApp.Session.StringVars.count) do
    begin
      //example stringvar: Mpf EMail=info@href.com
      aFieldName:=LeftOfEqual(pWebApp.Session.StringVars[i]);
      CSSend(S(i) + ' aFieldName', aFieldName);
      if StartsWith(aFieldName,'Mpf') and (FindField(aFieldName)<>nil) then
        FieldByName(aFieldName).asString :=
          RightOfEqual(pWebApp.Session.StringVars[i]);
    end;
    if Copy(FieldByName('Mpf Webpage').AsString, 1, 7) = 'http://' then
      FieldByName('Mpf Webpage').AsString := Copy(
        FieldByName('Mpf Webpage').AsString, 8, MaxInt);
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
var
  DPREmail, DPRPassword: string;
  bFound: Boolean;
begin
  bFound := False;
  DPREmail := pWebApp.StringVar['_email'];
  if DPREmail = '' then
  begin
    DPREmail := pWebApp.StringVar['DPREmail'];
    pWebApp.StringVar['_email'] := DPREMail;
  end;
  if DPREmail <> '' then
  begin
    DPRPassword := pWebApp.StringVar['DPRPassword'];

    with DMNexus.TableAdmin do
    begin
      First;
      while NOT EOF do
      begin
        if (FieldByName('Mpf Email').AsString = DPREmail) and
          (FieldByName('MpfPassToken').AsString = DPRPassword) then
        begin
          if (NowGMT < FieldByName('MpfPassUntil').AsDateTime) then
            bFound := True
          else
            pWebApp.StringVar['ErrorMessage'] := 'expired password; ' +
            'login using an OpenID provider that knows about ' + DPREmail;
          break;
        end
        else
          Next;
      end;
    end;
  end;
  pWebApp.BoolVar['_bCleanupOk'] := bFound;
  if NOT bFound then
    pWebApp.Response.SendBounceToPage('cleanup2013error', '');
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
        ErrorText := 'Error - MpfID '+ IntToStr(FMpfID) + ' not found.';
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
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  SplitString(Command, '.', Command, a1);
  a1 := Uncode64String(a1);
  with pWebApp.Response, wdsAdmin.DataSet do
  begin
    if Locate('MpfID',StrToIntDef(a1,-1),[]) then
      CSSendNote('found ' + a1 + ' ok')
    else
    begin
      ErrorText := 'Error - MpfID '+a1+' not found.';
      pWebApp.Debug.AddPageError(ErrorText);
      pWebApp.StringVar[TwhWebAction(Sender).Name + '-ErrorMessage']
        := ErrorText;
    end;
  end;
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
