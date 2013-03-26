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
  IB_Access, // part of IBObjects 4.9.5 and 4.9.9 but not part of v4.8.6
{$ENDIF}
  webLink, wdbSSrc, wdbScan, wdbIBObjOSource, updateOK, tpAction, webTypes;

type
  TDMMastDet = class(TDataModule)
    ScanMasterDept: TwhdbScan;
    ScanDetailEmployee: TwhdbScan;
    waDeptLocation: TwhWebAction;
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
    procedure waDeptLocationExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    crsLocation: TIB_Cursor;
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
{$IFDEF CodeSite}CodeSiteLogging, {$ENDIF}
  webApp, htWebApp, webSend, webScan,
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
  crsLocation := nil;
end;

procedure TDMMastDet.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(whdsDetEmployee);
  FreeAndNil(whdsMastDept);
  FreeAndNil(dsMastDept);
  FreeAndNil(qMastDept);
  FreeAndNil(dsDetEmployee);
  FreeAndNil(qDetEmployee);
  FreeAndNil(crsLocation);
end;

function TDMMastDet.Init(out ErrorText: string): Boolean;
const
  cFn = 'Init';
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
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
      qDetEmployee.SQL.Text :=
        'select * from Employee where (Dept_No=:Dept_No)';
      qDetEmployee.BeforeOpen := QueryDetailBeforeOpen; // essential

      dsDetEmployee := TDataSource.Create(Self);
      dsDetEmployee.Name := 'dsDetEmployee';
      dsDetEmployee.DataSet := qDetEmployee;

      whdsDetEmployee := TwhdbSourceIBO.Create(Self);
      whdsDetEmployee.Name := 'whdsDetEmployee';
      whdsDetEmployee.DataSource := dsDetEmployee;

      ScanDetailEmployee.WebDataSource := whdsDetEmployee;
      ScanDetailEmployee.PageHeight := 0; // show all employees for department
      ScanDetailEmployee.ControlsWhere := dsNone;  // uses webScan
      ScanDetailEmployee.ButtonsWhere := dsNone;
    end;

    if NOT Assigned(crsLocation) then
    begin
      crsLocation := TIB_Cursor.Create(Self);
      crsLocation.Name := 'crsLocation';
      crsLocation.SQL.Text :=
        'select Location from Department where (Dept_No=:Dept_No)';
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
      RefreshWebActions(Self);
      AddAppUpdateHandler(WebAppUpdate);
      FlagInitDone := qMastDept.Prepared; // if False then TtpProject will stop.
    end;
  end;
  Result := FlagInitDone;

  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

procedure TDMMastDet.QueryDetailBeforeOpen(DataSet: TDataSet);
var
  pk: string; // should be Integer but Embarcadero Department Dept_No is string!
begin
  pk := pWebApp.StringVar['radioDept']; // default -1
  if pk = '' then
    pk := '-1';

  if DataSet is TIBOQuery then
    with TIBOQuery(DataSet) do
    begin
      IB_Connection := gEmployee_Conn;
      IB_Transaction := gEmployee_Tr;
      IB_Session := gEmployee_Sess;
      Params[0].AsString := pk;
    end;
end;

procedure TDMMastDet.QueryMasterBeforeOpen(DataSet: TDataSet);
begin
  if DataSet is TIBOQuery then
    with TIBOQuery(DataSet) do
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
    webApp.SendDroplet('drDetailEmployeeTable', drBeforeWhrow);
  end;
end;

procedure TDMMastDet.ScanDetailEmployeeFinish(Sender: TObject);
begin
  with TwhdbScan(Sender) do
  begin
    webApp.SendDroplet('drDetailEmployeeTable', drAfterWhrow);
  end;
end;

procedure TDMMastDet.ScanDetailEmployeeRowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
begin
  { demonstrate relying on the FIELD macro to load data from active record. }
  with TwhdbScan(Sender) do
  begin
    webApp.SendDroplet('drDetailEmployeeTable', drWithinWhrow);
  end;
end;

procedure TDMMastDet.ScanMasterDeptBeginTable(Sender: TObject);
var
  topPk: string;
begin
  with TwhdbScan(Sender) do
  begin
    webApp.SendDroplet('drDisplayDepartmentTable', drBeforeWhrow);
    // default to pk of top record
    topPk :=
      TwhdbSourceIBO(WebDataSource).DataSource.DataSet.FieldByName('Dept_No')
        .AsString;
    pWebApp.StringVar['radioDept'] := topPk;
    pWebApp.Response.SendComment('Default radioDept is ' + topPK);
  end;

end;

procedure TDMMastDet.ScanMasterDeptFinish(Sender: TObject);
begin
  with TwhdbScan(Sender) do
  begin
    webApp.SendDroplet('drDisplayDepartmentTable', drAfterWhrow);
  end;
end;

procedure TDMMastDet.ScanMasterDeptRowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
var
  i: Integer;
  DS: TDataSet;
  s1: string;
begin
  { demonstrate pre-loading all field values for current record into stringvars
    for use from WHTEKO within the <whrow_tag> }
  DS := TwhdbSourceIBO(aWebDataSource).DataSource.DataSet;
  for i := 0 to Pred(DS.FieldCount) do
  begin
    s1 := Trim(DS.Fields[i].AsString);
    if (s1='') then
    begin
      if (DS.Fields[i].DataType <> ftString) then
        s1 := '(empty)'
      else
        s1 := ' ';
    end;

    pWebApp.StringVar['Department_' + DS.Fields[i].FieldName] := s1;
  end;
  with TwhdbScan(Sender) do
  begin
    webApp.SendDroplet('drDisplayDepartmentTable', drWithinWhrow);
  end;
end;

procedure TDMMastDet.waDeptLocationExecute(Sender: TObject);
var
  s1: string;
begin
  crsLocation.Close;
  s1 := pWebApp.StringVar['radioDept'];
  crsLocation.Params[0].AsString := s1;
  crsLocation.Open;
  if crsLocation.EOF then
    pWebApp.StringVar['maploc'] := 'Error: location not found for ' + s1
  else
    pWebApp.StringVar['maploc'] := crsLocation.Fields[0].AsString;
  crsLocation.Close;
end;

procedure TDMMastDet.WebAppUpdate(Sender: TObject);
const
  cFn = 'WebAppUpdate';
begin
{$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn); {$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
{$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn); {$ENDIF}
end;

end.
