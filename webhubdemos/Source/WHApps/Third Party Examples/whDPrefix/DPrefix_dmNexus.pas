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
    procedure TableFilterEMail(DataSet: TDataSet; var Accept: Boolean);
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    nxServerEngine1: TnxServerEngine;
    nxSession1: TnxSession;
    nxDatabase1: TnxDatabase;
    Table1: TnxTable;
    TableAdmin: TnxTable;
    procedure CopyTable(srcTbl:TnxTable; const Destination: string);
    function Init(out ErrorText: string): Boolean;
    procedure TableAdminOnlyPending;
    procedure TableAdminUnfiltered;
    procedure Table1OnlyMaintain;
    procedure Table1OnlyApproved;
    procedure Stamp(DS: TDataSet; const UpdatedBy: string);
    function CountPending: Integer;
    function IsAllowedRemoteDataEntryField(const AFieldName: string): Boolean;
  end;

var
  DMNexus: TDMNexus;

const
  cManPrefDatabase='ManPrefDatabase';

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  DBConsts,  //Copy and Flush Tables
  ucCodeSiteInterface, ucMsTime, ucPos,
  webApp, htWebApp, whdemo_ViewSource, DPrefix_dmWhActions;


{ TDMNexus }

procedure TDMNexus.CopyTable(srcTbl: TnxTable; const Destination: string);
//!!!var
  //!!!szCopyFrom,
  //!!!szCopyTo: DBITBLNAME;
begin
(*!!!  with srcTbl do begin
    if State = dsInactive then
      DatabaseError(SDataSetClosed);
    LockTable(ltReadLock);
    try
      AnsiToNative(Locale, AnsiString(Destination), szCopyTo,
        sizeof(szCopyTo)-1);
      AnsiToNative(Locale, AnsiString(TableName), szCopyFrom,
        sizeof(szCopyFrom)-1);
      Check(DbiCopyTable(Database.Handle, True, szCopyFrom, nil, szCopyTo));
    finally
      UnLockTable(ltReadLock);
      end;
    end;
     *)
end;

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
  Result := PosCI(AFieldName, 'MpfID;Mpf Prefix;' +
    ';UpdatedBy;UpdatedOnAt;UpdateCounter;' +
    'Mpf Status;MpfFirstLetter;Mpf EMail;' +
    'MpfURLStatus;MpfURLTestOnAt;MpfOpenIDOnAt;MpfOpenIDProviderName;' +
    'MpfPassToken;MpfPassUntil;Mpf Date Registered') = 0;
end;

procedure TDMNexus.Stamp(DS: TDataSet; const UpdatedBy: string);
begin
  DS.FieldByName('UpdatedBy').AsString := UpdatedBy;
  DS.FieldByName('UpdatedOnAt').AsDateTime := NowGMT;
  if DS.FieldByName('UpdateCounter').IsNull then
    DS.FieldByName('UpdateCounter').AsInteger := 0
  else
    DS.FieldByName('UpdateCounter').AsInteger :=
      DS.FieldByName('UpdateCounter').AsInteger + 1;
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

procedure TDMNexus.TableFilterEMail(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := (DataSet.FieldByName('Mpf EMail').AsString = pWebApp.StringVar['DPREmail']);
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
