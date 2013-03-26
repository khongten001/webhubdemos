unit whFirebird_dmwhMasterDetail;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

{$I hrefdefines.inc}
{$I IB_Directives.INC} // IbObjects source\common

uses
  SysUtils, Classes, DB,
  IB_Components, IBODataset,
{$IFDEF IBO_49_OR_GREATER}
  IB_Access,  // part of IBObjects 4.9.5 and 4.9.9 but not part of v4.8.6
{$ENDIF}
  webLink, wdbSSrc, wdbScan, wdbIBObjOSource, updateOK, tpAction, webTypes;

type
  TDMMastDet = class(TDataModule)
    ScanMasterDept: TwhdbScan;
    ScanDetailEmployee: TwhdbScan;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ScanDetailEmployeeBeginTable(Sender: TObject);
    procedure ScanMasterDeptBeginTable(Sender: TObject);
    procedure ScanMasterDeptRowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure ScanMasterDeptFinish(Sender: TObject);
    procedure ScanDetailEmployeeRowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure ScanDetailEmployeeFinish(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
    procedure QueryMasterBeforeOpen(DataSet: TDataSet);
    procedure QueryDetailBeforeOpen(DataSet: TDataSet);
  public
    { Public declarations }
    whdsDetEmployee: TwhdbSourceIBO;
    whdsMastDept: TwhdbSourceIBO;
    dsMastDept: TDataSource;
    qMastDept: TIBOQuery;
    dsDetEmployee: TDataSource;
    qDetEmployee: TIBOQuery;
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMMastDet: TDMMastDet;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp, htWebApp, webSend,
  ucCodeSiteInterface,
  uFirebird_Connect_Employee, ucIBObjPrepare;

{ TDMMastDet }

procedure TDMMastDet.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  whdsDetEmployee := nil;
    whdsMastDept := nil;
    dsMastDept := nil;
    qMastDept := nil;
    dsDetEmployee := nil;
    qDetEmployee := nil;
end;

procedure TDMMastDet.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(whdsDetEmployee);
  FreeAndNil(whdsMastDept);
  FreeAndNil(dsMastDept);
  FreeAndNil(qMastDept);
  FreeAndNil(dsDetEmployee);
  FreeAndNil(qDetEmployee);
end;

function TDMMastDet.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if NOT Assigned(qMastDept) then
    begin
      qMastDept := TIBOQuery.Create(Self);
      qMastDept.Name := 'qMastDept';
      qMastDept.SQL.Text := 'select * from Department order by Dept_No';
      qMastDept.BeforeOpen := QueryMasterBeforeOpen; // essential

      dsMastDept := TDataSource.Create(Self);
      dsMastDept.Name := 'dsMastDept';
      dsMastDept.DataSet := qMastDept;

      whdsMastDept := TwhdbSourceIBO.Create(Self);
      whdsMastDept.Name := 'whdsMastDept';
      whdsMastDept.DataSource := dsMastDept;

      ScanMasterDept.WebDataSource := whdsMastDept;
    end;

    if NOT Assigned(qDetEmployee) then
    begin
      qDetEmployee := TIBOQuery.Create(Self);
      qDetEmployee.Name := 'qDetEmployee';
      qDetEmployee.SQL.Text := 'select * from Employee where (Dept_No=:Dept_No)';
      qDetEmployee.BeforeOpen := QueryDetailBeforeOpen; // essential

      dsDetEmployee := TDataSource.Create(Self);
      dsDetEmployee.Name := 'dsDetEmployee';
      dsDetEmployee.DataSet := qDetEmployee;

      whdsDetEmployee := TwhdbSourceIBO.Create(Self);
      whdsDetEmployee.Name := 'whdsDetEmployee';
      whdsDetEmployee.DataSource := dsDetEmployee;

      ScanDetailEmployee.WebDataSource := whdsDetEmployee;
    end;

    if qMastDept.IB_Connection = nil then
    try
      IbObj_PrepareAllQueriesAndProcs(Self, gEmployee_Conn, gEmployee_Tr,
        gEmployee_Sess);
    except
      on E: Exception do
      begin
        ErrorText := 'An error here probably indicates invalid SQL.Text' +
          sLineBreak + E.Message;
      end;
    end;

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      // Call RefreshWebActions here only if it is not called within a TtpProject event
      // RefreshWebActions(Self);

      // helpful to know that WebAppUpdate will be called whenever the
      // WebHub app is refreshed.
      AddAppUpdateHandler(WebAppUpdate);
      FlagInitDone := qMastDept.Prepared;  // if False then TtpProject will stop.
    end;
  end;
  Result := FlagInitDone;
  {$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMMastDet.QueryDetailBeforeOpen(DataSet: TDataSet);
var
  pk: Integer;
begin
  pk := pWebApp.StringVarInt['radioDept'];  // default -1
  if pk = -1 then
    pk := 115; // Japan -- sample data

  if Dataset is TIBOQuery then
  with TIBOQuery(Dataset) do
  begin
    IB_Connection := gEmployee_Conn;
    IB_Transaction := gEmployee_Tr;
    IB_Session := gEmployee_Sess;
    Params[0].AsInteger := pk;
  end;
end;

procedure TDMMastDet.QueryMasterBeforeOpen(DataSet: TDataSet);
begin
  if Dataset is TIBOQuery then
  with TIBOQuery(Dataset) do
  begin
    IB_Connection := gEmployee_Conn;
    IB_Transaction := gEmployee_Tr;
    IB_Session := gEmployee_Sess;
  end;
end;

procedure TDMMastDet.ScanDetailEmployeeBeginTable(Sender: TObject);
begin
  with TwhdbScan(Sender) do
  begin
    WebApp.SendDroplet('drDetailEmployeeTable', drBeforeWhrow);
  end;
end;

procedure TDMMastDet.ScanDetailEmployeeFinish(Sender: TObject);
begin
  with TwhdbScan(Sender) do
  begin
    WebApp.SendDroplet('drDetailEmployeeTable', drAfterWhrow);
  end;
end;

procedure TDMMastDet.ScanDetailEmployeeRowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
begin
  with TwhdbScan(Sender) do
  begin
    WebApp.SendDroplet('drDetailEmployeeTable', drWithinWhrow);
  end;
end;

procedure TDMMastDet.ScanMasterDeptBeginTable(Sender: TObject);
begin
  with TwhdbScan(Sender) do
  begin
    WebApp.SendDroplet('drDisplayDepartmentTable', drBeforeWhrow);
  end;
end;

procedure TDMMastDet.ScanMasterDeptFinish(Sender: TObject);
begin
  with TwhdbScan(Sender) do
  begin
    WebApp.SendDroplet('drDisplayDepartmentTable', drAfterWhrow);
  end;
end;

procedure TDMMastDet.ScanMasterDeptRowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
var
  i: Integer;
  DS: TDataSet;
begin
  DS := TwhdbSourceIBO(aWebdataSource).DataSource.DataSet;
  for i := 0 to Pred(DS.FieldCount) do
  begin
    pWebApp.StringVar['Department_' + DS.Fields[i].FieldName] :=
      DS.Fields[i].AsString;
  end;
  with TwhdbScan(Sender) do
  begin
    WebApp.SendDroplet('drDisplayDepartmentTable', drWithinWhrow);
  end;
end;

procedure TDMMastDet.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
