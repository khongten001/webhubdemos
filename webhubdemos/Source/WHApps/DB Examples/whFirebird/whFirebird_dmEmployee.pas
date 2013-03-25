unit whFirebird_dmEmployee;

interface

{$I hrefdefines.inc}
{$I IB_Directives.INC} // IbObjects source\common

uses
  SysUtils, Classes, DB,
  IB_Components, IBODataset,
{$IFDEF IBO_49_OR_GREATER}
  IB_Access,  // part of IBObjects 4.9.5 and 4.9.9 but not part of v4.8.6
{$ENDIF}
  webLink, webTypes, wdbLink, wdbSSrc, wdbScan, wdbIBObjOSource,
  updateOK, tpAction;

type
  TDMEmployeeFire = class(TDataModule)
    ScanEmployee3: TwhdbScan;
    ScanEmployee2: TwhdbScan;
    ScanEmployee1: TwhdbScan;
    procedure DataModuleCreate(Sender: TObject);
    procedure ScanEmployee1Finish(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ScanEmployeeBeginTable(Sender: TObject);
    procedure ScanEmployee1RowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    whdsEmployee: TwhdbSourceIBO;
    dsEmployee: TDataSource;
    qEmployee: TIBOQuery;
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMEmployeeFire: TDMEmployeeFire;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucString, ucLogFil, ucCodeSiteInterface, ucIbObjPrepare,
  webApp, webSend, webScan, htWebApp,
  uFirebird_Connect_Employee, ucIbAndFbCredentials;

{ TDMEmployeeFire }

procedure TDMEmployeeFire.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  whdsEmployee := nil;
  dsEmployee := nil;
  qEmployee := nil;
end;

procedure TDMEmployeeFire.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(whdsEmployee);
  FreeAndNil(dsEmployee);
  FreeAndNil(qEmployee);
end;

function TDMEmployeeFire.Init(out ErrorText: string): Boolean;
var
  DBName, DBUser, DBPass: string;
  b: Boolean;
begin
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin

      ZMLookup_Firebird_Credentials('WebHubDemo-fire', DBName, DBUser, DBPass);
      CreateIfNil(DBName, DBUser, DBPass);
      gEmployee_Conn.Connect;

      qEmployee := TIBOQuery.Create(Self);
      qEmployee.Name := 'qEmployee';
      qEmployee.SQL.Text := 'select * from employee where (SALARY < 80000.0)';

      dsEmployee := TDataSource.Create(Self);
      dsEmployee.Name := 'dsEmployee';

      whdsEmployee := TwhdbSourceIBO.Create(Self);
      whdsEmployee.Name := 'whdsEmployee';
      whdsEmployee.DataSource := dsEmployee;
      whdsEmployee.MaxOpenDataSets := 1;

      ScanEmployee1.WebDataSource := whdsEmployee;
      ScanEmployee1.PageHeight := 3;  {number of records to display initially}
      ScanEmployee1.ButtonsWhere := dsBelow;
      ScanEmployee1.OnBeginTable := ScanEmployeeBeginTable;
      ScanEmployee1.SetDelimiters2012;
      ScanEmployee1.SetCaptions2004;
      ScanEmployee1.SetButtonSpecs2012;

      ScanEmployee2.WebDataSource := whdsEmployee;
      ScanEmployee2.PageHeight := 10;  {number of records to display initially}
      ScanEmployee2.ButtonsWhere := dsBelow;
      ScanEmployee2.OnBeginTable := ScanEmployeeBeginTable;
      ScanEmployee1.SetDelimiters2012;

      ScanEmployee3.WebDataSource := whdsEmployee;
      ScanEmployee3.PageHeight := 10;  {number of records to display initially}
      ScanEmployee3.ButtonsWhere := dsNone;
      ScanEmployee3.OnBeginTable := ScanEmployeeBeginTable;

      try
        IbObj_PrepareAllQueriesAndProcs(Self, gEmployee_Conn,
          gEmployee_Tr, gEmployee_Sess);
        b := qEmployee.Prepared and Assigned(qEmployee.IB_Session);
        if NOT (gEmployee_Conn.IB_Session = gEmployee_Sess) then
          CSSendWarning('NOT (gEmployee_Conn.IB_Session = gEmployee_Sess)');
        dsEmployee.Dataset := qEmployee;
      except
        on E: Exception do
        begin
          b := False;
        end;
      end;

      if b then
      begin
        RefreshWebActions(Self);
        AddAppUpdateHandler(WebAppUpdate);
      end;
      FlagInitDone := b;
    end;
  end;
  Result := FlagInitDone;
end;

procedure TDMEmployeeFire.ScanEmployeeBeginTable(Sender: TObject);
begin
  with TwhdbScan(Sender) do
  begin
    WebApp.SendDroplet('drDisplayEmployeeTable', drBeforeWhrow);
  end;
end;

procedure TDMEmployeeFire.ScanEmployee1Finish(Sender: TObject);
begin
  with TwhdbScan(Sender) do
  begin
    WebApp.SendDroplet('drDisplayEmployeeTable', drAfterWhrow);
  end;
end;

procedure TDMEmployeeFire.ScanEmployee1RowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
begin
  with TwhdbScan(Sender) do
  begin
    WebApp.SendDroplet('drDisplayEmployeeTable', drWithinWhrow);
  end;
end;

procedure TDMEmployeeFire.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

end.
