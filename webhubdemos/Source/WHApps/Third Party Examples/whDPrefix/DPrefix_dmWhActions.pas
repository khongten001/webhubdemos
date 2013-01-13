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
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure waAddExecute(Sender: TObject);
    procedure waCountPendingExecute(Sender: TObject);
    procedure waCleanup2013LoginExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
    procedure WebDataFormSetCommand(Sender: TObject; var Command: String);
    procedure WebDataFormField(Sender: TwhdbForm; aField: TField;
      var Text, Value: String);
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
  ucCodeSiteInterface, ucString, ucMsTime, ucBase64,
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
      if StartsWith(aFieldName,'Mpf ') //ucstring
      and (FindField(aFieldName)<>nil) then
        FieldByName(aFieldName).asString :=
          RightOfEqual(pWebApp.Session.StringVars[i]);
    end;
    if Copy(FieldByName('Mpf Webpage').AsString, 1, 7) = 'http://' then
      FieldByName('Mpf Webpage').AsString := Copy(
        FieldByName('Mpf Webpage').AsString, 8, MaxInt);
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
  DPREmail := pWebApp.StringVar['DPREmail'];
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
          pWebApp.StringVar['ErrorMessage'] := 'expired password';
        break;
      end
      else
        Next;
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

procedure TDMDPRWebAct.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

procedure TDMDPRWebAct.WebDataFormField(Sender: TwhdbForm; aField: TField;
  var Text, Value: String);
begin
  inherited;
  // indicate that the primary key is off limits
  if aField.fieldname='MpfID' then begin
    text:='ID*';
    value:='<span style="color:#666667; font-weight: 900;">'+aField.asString+
      '</span>';
    end;
end;

procedure TDMDPRWebAct.WebDataFormSetCommand(Sender: TObject;
  var Command: String);
var
  a1:string;
begin
  inherited;
  SplitString(Command,'.',Command,a1);
  a1:=Uncode64String(a1);
  with pWebApp.Response, wdsAdmin.DataSet do
    if Locate('MpfID',StrToIntDef(a1,-1),[]) then
      SendComment('found ok')
    else
      SendHdr('2','Error - MpfID '+a1+' not found.');
end;

(*
object WebDataForm: TwhdbForm
  ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
  OnSetCommand = WebDataFormSetCommand
  Border = 'BORDER'
  WrapMemo = False
  SkipBlank = False
  WebDataSource = wdsAdmin
  OnField = WebDataFormField
  Left = 30
  Top = 310
end
*)

end.
