unit DPrefix_dmNexus;

interface

uses
  SysUtils, Classes, DB,
  nxdb, nxllComponent, nxsdServerEngine, nxseAllEngines, nxsrServerEngine,
  webLink;

type
  TDMNexus = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure TableFilterPendingApprovedRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure TableFilterPending(DataSet: TDataSet; var Accept: Boolean);
    procedure TableFilterDelete(DataSet: TDataSet; var Accept: Boolean);
    procedure TableFilterBlankEmail(DataSet: TDataSet; var Accept: Boolean);
    procedure TableFilterAmpersand(DataSet: TDataSet; var Accept: Boolean);
    procedure TableFilterEMail(DataSet: TDataSet; var Accept: Boolean);
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    nxServerEngine1: TnxServerEngine;
    nxSession1: TnxSession;
    nxDatabase1: TnxDatabase;
    Table1: TnxTable;
    TableAdmin: TnxTable;
    function Init(out ErrorText: string): Boolean;
    procedure TableAdminOnlyPending;
    procedure TableAdminOnlyDelete;
    procedure TableAdminOnlyBlankEMail;
    procedure TableAdminUnfiltered;
    procedure TableAdminOnlyAmpersand;
    procedure Table1OnlyMaintain;
    procedure Table1OnlyApproved;
    procedure Stamp(DS: TDataSet; const UpdatedBy: string);
    function CountPending: Integer;
    function IsAllowedRemoteDataEntryField(const AFieldName: string): Boolean;
    function DataNoAmpersand(var AText: string; const ReplaceWith: string = '')
      : Boolean;
    function RecordNoAmpersand(DS: TDataSet): Boolean;
  end;

var
  DMNexus: TDMNexus;

const
  cManPrefDatabase='ManPrefDatabase';

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  Character,
  ucCodeSiteInterface, ucMsTime, ucPos, ucString,
  webApp, htWebApp, whdemo_ViewSource, DPrefix_dmWhActions, whdemo_Extensions;


{ TDMNexus }

function TDMNexus.CountPending: Integer;
begin
  TableAdminOnlyPending;
  Result := 0;
  TableAdmin.First;
  while NOT TableAdmin.EOF do
  begin
    inc(Result);
    TableAdmin.Next;
  end;
  TableAdminUnfiltered;
end;

procedure TDMNexus.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;

  nxServerEngine1 := TnxServerEngine.Create(Self);
  nxServerEngine1.Name := 'nxServerEngine1';
  with nxServerEngine1 do
  begin
    ActiveDesigntime := False;
    ServerName := '';
    Options := [];
    TableExtension := 'nx1';
  end;

  nxSession1 := TnxSession.Create(Self);
  nxSession1.Name := 'nxSession1';
  with nxSession1 do
  begin
    ActiveDesigntime := False;
    ServerEngine := nxServerEngine1;
  end;

  nxDatabase1 := TnxDatabase.Create(Self);
  nxDatabase1.Name := 'nxDatabase1';
  nxDatabase1.Session := nxSession1;

  Table1 := TnxTable.Create(Self);
  Table1.Name := 'Table1';
  with Table1 do
  begin
    Database := nxDatabase1;
    Filtered := True;
    FilterOptions := [foCaseInsensitive];
    OnFilterRecord := TableFilterPendingApprovedRecord;
    TableName := 'manpref.nx1';
    ReadOnly := True;
  end;
  Table1.IndexName := 'Prefix';
  TableAdmin := TnxTable.Create(Self);
  TableAdmin.Name := 'TableAdmin';
  TableAdmin.TableName := Table1.TableName;
  TableAdmin.Database := Table1.Database;
  TableAdmin.Filtered := False;
end;

procedure TDMNexus.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(TableAdmin);
  FreeAndNil(Table1);
  FreeAndNil(nxDatabase1);
  FreeAndNil(nxSession1);
  FreeAndNil(nxServerEngine1);
end;

function TDMNexus.DataNoAmpersand(var AText: string;
  const ReplaceWith: string = ''): Boolean;
begin
  Result := Pos('&', AText) > 0;
  if Result then
  begin
    AText := StringReplaceAll(AText, '&', ReplaceWith);
    if ReplaceWith = ' and ' then
      AText := StringReplaceAll(AText, '  and  ', ReplaceWith); // extra spaces
  end;
end;

function TDMNexus.Init(out ErrorText: string): Boolean;
var
  a1: string;
begin
  // reserved for code that should run once, after AppID set
  ErrorText := '';
  if NOT FlagInitDone then
  begin
    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      a1 := pWebApp.AppSetting[cManPrefDatabase];
      nxDatabase1.AliasPath := getHtDemoDataRoot + 'whDPrefix';
      nxDatabase1.Active := True;
      Table1.Filtered := True;
      try
        Table1.Open;
      except
        on E: Exception do
        begin
          LogSendException(E);
          Table1.IndexName := '';
          Table1.Open;
        end;
      end;
      TableAdmin.IndexName := Table1.IndexName;
      TableAdmin.Open;
      RefreshWebActions(Self);

      // helpful to know that WebAppUpdate will be called whenever the
      // WebHub app is refreshed.
      AddAppUpdateHandler(WebAppUpdate);
      FlagInitDone := True;
    end;
  end;
  Result := FlagInitDone;
end;

function TDMNexus.IsAllowedRemoteDataEntryField(
  const AFieldName: string): Boolean;
begin
  // prevent all of these from being posted-to from the web
  Result := PosCI(AFieldName, 'MpfID;Mpf Prefix;' +
    ';UpdatedBy;UpdatedOnAt;UpdateCounter;' +
    'Mpf Status;MpfFirstLetter;Mpf Notes;' +
    'MpfURLStatus;MpfURLTestOnAt;MpfOpenIDOnAt;MpfOpenIDProviderName;' +
    'MpfPassToken;MpfPassUntil;Mpf Date Registered') = 0;
  if Result then
  begin
    if IsEqual(AFieldName, 'Mpf EMail') then
      Result := DemoExtensions.IsSuperUser(pWebApp.Request.RemoteAddress);
  end;
end;

function TDMNexus.RecordNoAmpersand(DS: TDataSet): Boolean;
var
  AText: string;
  b: Boolean;

  function OneField(const AFieldName, ReplaceWith: string): Boolean;
  begin
    with DS do
    begin
      AText := FieldByName(AFieldName).AsString;
      if DMNexus.DataNoAmpersand(AText, ReplaceWith) then
      begin
        if NOT b then
          Edit;
        FieldByName(AFieldName).asString := AText;
        Result := True;
      end
      else
        Result := False;
    end;
  end;
begin
  inherited;
  with DS do
  begin
    b := False;
    if OneField('Mpf Company', ' and ') then b := True;
    if OneField('Mpf Contact', ' and ') then b := True;
    if OneField('MpfPurpose', ' and ') then b := True;
    if OneField('Mpf Prefix', #$271A) then b := True;
    if OneField('Mpf WebPage', '') then b := True;
  end;
  Result := b;
end;

procedure TDMNexus.Stamp(DS: TDataSet; const UpdatedBy: string);
var
  ACap: string;
  OpenIDProvider: string;
  url: string;
begin
  DS.FieldByName('UpdatedBy').AsString := UpdatedBy;
  DS.FieldByName('UpdatedOnAt').AsDateTime := NowGMT;
  if DS.FieldByName('UpdateCounter').IsNull then
    DS.FieldByName('UpdateCounter').AsInteger := 0
  else
    DS.FieldByName('UpdateCounter').AsInteger :=
      DS.FieldByName('UpdateCounter').AsInteger + 1;

  url := Trim(DS.FieldByName('Mpf WebPage').AsString);
  if (Copy(URL, 1, 7) = 'http://') then
    URL := Copy(URL, 8, MaxInt);
  if URL <> DS.FieldByName('Mpf WebPage').AsString then
    DS.FieldByName('Mpf WebPage').AsString := URL;

  OpenIDProvider := pWebApp.StringVar['_providerName'];
  if OpenIDProvider <> '' then
  begin
    // non-blank only when surfer goes through OpenID process
    DS.FieldByName('MpfOpenIDOnAt').AsDateTime := NowGMT;
    DS.FieldByName('MpfOpenIDProviderName').AsString :=
      OpenIDProvider;
  end;

  ACap := Uppercase(Copy(DS.FieldByName('Mpf Prefix').AsString, 1, 1));
  if IsDigit(ACap[1]) then
    ACap := '1';
  if DS.FieldByName('MpfFirstLetter').asString <> ACap then
    DS.FieldByName('MpfFirstLetter').asString := ACap;

end;

procedure TDMNexus.Table1OnlyApproved;
const cFn = 'Table1OnlyApproved';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  with Table1 do
  begin
    //if OnFilterRecord <> TableFilterPendingApprovedRecord then
    begin
      if Filtered then
        Filtered := False;
      OnFilterRecord := TableFilterPendingApprovedRecord;
      Filtered := True;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMNexus.Table1OnlyMaintain;
const cFn = 'Table1OnlyMaintain';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  with Table1 do
  begin
    //if OnFilterRecord <> TableFilterEMail then
    begin
      if Filtered then
        Filtered := False;
      OnFilterRecord := TableFilterEMail;
      Filtered := True;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMNexus.TableAdminOnlyAmpersand;
begin
  with TableAdmin do
  begin
    //if OnFilterRecord <> TableFilterPending then
    begin
      if Filtered then
        Filtered := False;
      OnFilterRecord := TableFilterAmpersand;
      Filtered := True;
    end;
  end;
end;

procedure TDMNexus.TableAdminOnlyBlankEMail;
const cFn = 'TableAdminOnlyBlankEMail';
begin
  with TableAdmin do
  begin
    //if OnFilterRecord <> TableFilterPending then
    begin
      if Filtered then
        Filtered := False;
      OnFilterRecord := TableFilterBlankEMail;
      Filtered := True;
    end;
  end;
end;

procedure TDMNexus.TableAdminOnlyDelete;
const cFn = 'TableAdminOnlyDelete';
begin
  with TableAdmin do
  begin
    //if OnFilterRecord <> TableFilterPending then
    begin
      if Filtered then
        Filtered := False;
      OnFilterRecord := TableFilterDelete;
      Filtered := True;
    end;
  end;
end;

procedure TDMNexus.TableAdminOnlyPending;
const cFn = 'TableAdminOnlyPending';
begin
  with TableAdmin do
  begin
    //if OnFilterRecord <> TableFilterPending then
    begin
      if Filtered then
        Filtered := False;
      OnFilterRecord := TableFilterPending;
      Filtered := True;
    end;
  end;
end;

procedure TDMNexus.TableAdminUnfiltered;
const cFn = 'TableAdminUnfiltered';
begin
  TableAdmin.Filtered := False;
  TableAdmin.OnFilterRecord := nil;
end;

procedure TDMNexus.TableFilterAmpersand(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := (DataSet.FieldByName('UpdatedBy').AsString = 'amp');
end;

procedure TDMNexus.TableFilterBlankEmail(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := (DataSet.FieldByName('Mpf EMail').AsString = '');
end;

procedure TDMNexus.TableFilterDelete(DataSet: TDataSet; var Accept: Boolean);
const cFn = 'TableFilterDelete';
begin
  Accept := (DataSet.FieldByName('Mpf Status').AsString = 'D');
  if Accept then
  begin
    CSSend(cFn + ' Accept', S(Accept));
    CSSend(cFn + ' MpfID', DataSet.FieldByName('MpfID').AsString);
  end;
end;

procedure TDMNexus.TableFilterEMail(DataSet: TDataSet; var Accept: Boolean);
var
  e1: string;
begin
  e1 := DataSet.FieldByName('Mpf EMail').AsString;
  with pWebApp do
    Accept := (e1 = StringVar['_email']);
end;

procedure TDMNexus.TableFilterPending(DataSet: TDataSet; var Accept: Boolean);
const cFn = 'TableFilterPending';
begin
  Accept := (DataSet.FieldByName('Mpf Status').AsString = 'P');
  //CSSend(cFn + ' Accept', S(Accept));
end;

procedure TDMNexus.TableFilterPendingApprovedRecord(DataSet: TDataSet;
  var Accept: Boolean);
const cFn = 'TableFilterPendingApprovedRecord';
var
  aStatus: string;
begin
  inherited;
  with pWebApp do
  begin
    aStatus := UpperCase(DataSet.FieldByName('Mpf Status').asString);
    if BoolVar['_bAdminMode'] then
      if BoolVar['bShowAll'] then
        Accept:=true
      else
        Accept:=(aStatus='P')  //pending
    else
    begin
      Accept := (DataSet.FieldByname('MpfFirstLetter').AsString =
        DMDPRWebAct.WebDBAlphabet.ActiveChar) and (aStatus='A');   //approved
    end;
  end;
  //CSSend(cFn + ' Accept', S(Accept));
end;

procedure TDMNexus.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

(*
object Table1: TTable
  Filtered = True
  FilterOptions = [foCaseInsensitive]
  OnFilterRecord = Table1FilterRecord
  TableName = 'MANPREF.DB'
  Left = 126
  Top = 134
end

object TableAdmin: TTable
  TableName = 'MANPREF.DB'
  Left = 86
  Top = 254
end

*)

end.
