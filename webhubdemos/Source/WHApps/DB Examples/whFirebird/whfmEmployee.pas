unit whfmEmployee;
////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995-2012 HREF Tools Corp.  All Rights Reserved Worldwide.  //
//                                                                            //
//  This source code file is part of WebHub v2.1x.  Please obtain a WebHub    //
//  development license from HREF Tools Corp. before using this file, and     //
//  refer friends and colleagues to href.com/webhub for downloading. Thanks!  //
////////////////////////////////////////////////////////////////////////////////

interface

{$I hrefdefines.inc}
{$I IB_Directives.INC} // IbObjects source\common

uses
  SysUtils, Classes,
{$IFDEF LINUX}
  QForms, QControls, QDialogs, QGraphics, QExtCtrls, QStdCtrls,
{$ELSE}
  Forms, Controls, Dialogs, Graphics, ExtCtrls, StdCtrls, ComCtrls,
{$ENDIF}
  IB_Components,
{$IFDEF IBO_49_OR_GREATER} 
  IB_Access,  // part of IBObjects 4.9.5 and 4.9.9 but not part of v4.8.6
{$ENDIF}
  toolbar, utPanFrm, tpMemo, restorer, tpStatus, tpCompPanel, updateOK,
  tpAction,
  webTypes, webLink, wdbLink, wdbSSrc, wdbScan, wdbIBObjNSource;

type
  TfmEmployee = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    ScanEmployee1: TwhdbScan;
    tpStatusBar1: TtpStatusBar;
    waField: TwhWebAction;
    waMoney: TwhWebAction;
    ScanEmployee2: TwhdbScan;
    ScanEmployee3: TwhdbScan;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ScanEmployee1RowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure waFieldExecute(Sender: TObject);
    procedure ScanEmployeeBeginTable(Sender: TObject);
    procedure ScanEmployee1Finish(Sender: TObject);
    procedure waMoneyExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    whdsEmployee: TwhdbSourceIB;
    dsEmployee: TIB_DataSource;
    qEmployee: TIB_Query;
    function Init: Boolean; override;
  end;

var
  fmEmployee: TfmEmployee;

implementation

{$R *.dfm}

uses
  ucString, ucLogFil, ucCodeSiteInterface, ucIbObjPrepare,
  webApp, webSend, webScan,
  uFirebird_Connect_Employee, ucIbAndFbCredentials;

{ TfmAppPanel }

procedure TfmEmployee.FormCreate(Sender: TObject);
begin
  inherited;
  whdsEmployee := nil;
  dsEmployee := nil;
  qEmployee := nil;
end;

procedure TfmEmployee.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(whdsEmployee);
  FreeAndNil(dsEmployee);
  FreeAndNil(qEmployee);
end;

function TfmEmployee.Init: Boolean;
var
  DBName, DBUser, DBPass: string;
begin
  Result := inherited Init;
  if not Result then
    Exit;

  ZMLookup_Firebird_Credentials('WebHubDemo-fire', DBName, DBUser, DBPass);
  CreateIfNil(DBName, DBUser, DBPass);
  gEmployee_Conn.Connect;

  qEmployee := TIB_Query.Create(Self);
  qEmployee.Name := 'qEmployee';
  qEmployee.SQL.Text := 'select * from employee where (SALARY < 80000.0)';

  dsEmployee := TIB_DataSource.Create(Self);
  dsEmployee.Name := 'dsEmployee';

  whdsEmployee := TwhdbSourceIB.Create(Self);
  whdsEmployee.Name := 'wdsEmployee';
  whdsEmployee.DataSource := dsEmployee;
  whdsEmployee.MaxOpenDataSets := 1;

  ScanEmployee1.WebDataSource := whdsEmployee;
  ScanEmployee1.PageHeight := 10;  {number of records to display initially}
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
    Result := qEmployee.Prepared and Assigned(qEmployee.IB_Session);
    if NOT (gEmployee_Conn.IB_Session = gEmployee_Sess) then
      CSSendWarning('NOT (gEmployee_Conn.IB_Session = gEmployee_Sess)');
    dsEmployee.Dataset := qEmployee;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;

  if Result then
    RefreshWebActions(Self);
end;

procedure TfmEmployee.ScanEmployee1RowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
begin
  inherited;
  with TwhdbScan(Sender) do
  begin
    WebApp.SendDroplet('drDisplayEmployeeTable', drWithinWhrow);
  end;
end;

procedure TfmEmployee.waFieldExecute(Sender: TObject);
const
  cFn = 'TfmEmployee.waFieldExecute';
var
  TblName, FldName: string;
  fld: TIB_Column;
begin
  inherited;
  with TwhWebAction(Sender) do
  begin
    SplitString(HtmlParam, '|', TblName, FldName);
    if IsEqual(TblName, 'employee') then
    begin
      with qEmployee do
      begin
        fld := FindField(FldName);
        if Assigned(fld) then
          Response.Send(fld.AsString)
        else
        begin
          LogSendWarning('Invalid fieldname: ' + FldName, cFn);
          Response.Send(FldName);
        end;
      end;
    end;
  end;
end;

procedure TfmEmployee.ScanEmployeeBeginTable(Sender: TObject);
begin
  inherited;
  with TwhdbScan(Sender) do
  begin
    WebApp.SendDroplet('drDisplayEmployeeTable', drBeforeWhrow);
  end;
end;

procedure TfmEmployee.ScanEmployee1Finish(Sender: TObject);
begin
  inherited;
  with TwhdbScan(Sender) do
  begin
    WebApp.SendDroplet('drDisplayEmployeeTable', drAfterWhrow);
  end;
end;

procedure TfmEmployee.waMoneyExecute(Sender: TObject);
var
  m: Double;
begin
  inherited;
  with TwhWebAction(Sender) do
  begin
    if HtmlParam = '' then Exit;
    m := StrToFloat(WebApp.Expand(HtmlParam));
    Response.Send(Format('%m', [m]));
  end;
end;

end.
