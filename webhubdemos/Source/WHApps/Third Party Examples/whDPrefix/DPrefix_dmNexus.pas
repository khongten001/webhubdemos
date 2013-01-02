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
    nxServerEngine1: TnxServerEngine;
    nxSession1: TnxSession;
    procedure Table1FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    nxDatabase1: TnxDatabase;
    Table1: TnxTable;
    TableAdmin: TnxTable;
    procedure CopyTable(srcTbl:TnxTable; const Destination: string);
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMNexus: TDMNexus;

const
  cManPrefDatabase='ManPrefDatabase';

implementation

{$R *.dfm}

uses
  DBConsts,  //Copy and Flush Tables
  webApp, htWebApp, whdemo_ViewSource;


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
    OnFilterRecord := Table1FilterRecord;
    TableName := 'manpref.nx1';
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
      Table1.Open;
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

procedure TDMNexus.Table1FilterRecord(DataSet: TDataSet; var Accept: Boolean);
var
  aStatus: string;
begin
  inherited;
  //improvements to do:
  //get the checked values before the scan (onexecute) and put them into vars.
  //use pre-instantiated fields or get a field pointer ahead of time
  with pWebApp do
  begin
    aStatus := UpperCase(DataSet.FieldByName('Mpf Status').asString);
    if BoolVar['_bAdminMode'] then
      if BoolVar['bShowAll'] then
        Accept:=true
      else
        Accept:=(aStatus='P')  //pending
    else
      Accept:=(aStatus='A');   //approved
  end;
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
