unit whQuery2_whdmData;

(*
Copyright (c) 1999-2013 HREF Tools Corp.

Permission is hereby granted, on 30-Jan-2013, free of charge, to any person
obtaining a copy of this file (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*)


interface

uses
  SysUtils, Classes,
  webLink, Data.Win.ADODB, wdbxSource, wdbScan, Bde.DBTables, DB,
  ZaphodsMap,
  updateOK, tpAction,
  wdbSSrc, wdbSource, wbdeSource, webTypes, wbdeGrid;

type
  TDMQuery2 = class(TDataModule)
    grid: TwhbdeGrid;
    WebDataSource1: TwhbdeSource;
    DataSource1: TDataSource;
    wdsFull: TwhbdeSource;
    DataSourceFull: TDataSource;
    WebDataScanAll: TwhdbScan;
    Query1: TADOQuery;
    ADOQueryFull: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure gridHotField(Sender: TwhbdeGrid; AField: TField;
      var CellValue: string);
    procedure gridAfterExecute(Sender: TObject);
    procedure WebDataScanAllInit(Sender: TObject);
    procedure WebDataScanAllRowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure WebDataScanAllFinish(Sender: TObject);
    procedure WebDataScanAllEmptyDataSet(Sender: TObject);
    procedure ADOQuery2FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    ZM: TZaphodsMap;
    ZMKey: TZaphodKey;
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  protected
    function loadCustomSettings(out ErrorText: string): Boolean;
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
    procedure WebAppNewSession(Sender:TObject; Session:Integer;
      const Command:String);
  end;

var
  DMQuery2: TDMQuery2;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucCodeSiteInterface, ucPos, ucDlgs,
  whMacroAffixes, webScan, webSend, webApp, htWebApp, whdemo_ViewSource;

{ TDMQuery2 }

procedure TDMQuery2.ADOQuery2FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if posci('e', DataSet.FieldByName('Firstname').asString) > 0 then
    Accept := True // (Random(1) = 1);
  else
    Accept := False;
end;

procedure TDMQuery2.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  ZM := TZaphodsMap.Create(Self);
  ZMKey := nil;
end;

procedure TDMQuery2.DataModuleDestroy(Sender: TObject);
begin
  ZMKey := nil; // do not free this.
  FreeAndNil(ZM);
end;

procedure TDMQuery2.gridAfterExecute(Sender: TObject);
begin
  // Publish the sql code to the web, after the final page section.
  with WebDataSource1 do
  begin
    if DataSet is TADOQuery then
      pWebApp.Summary.Add('SQL for '+DataSet.Name+' is:<br/>' +
        TADOQuery(Dataset).SQL.Text);
  end;
end;

{Hot field is set by putting :HF after the field name in the
displaySet.  See WebDataSource.displayset -- or just look in the
htqry2.ini file.}
procedure TDMQuery2.gridHotField(Sender: TwhbdeGrid; AField: TField;
  var CellValue: string);
begin
  {JUMP is a built-in WebHub macro. Syntax is: JUMP|pageId,command|visiblePhrase }
  CellValue:=MacroStart + 'JUMP|detail,wdsFull.'+
     aField.DataSet.fields[0].asString+  {command (4th param on URL)}
     '|'+aField.asString+MacroEnd;  {command is passed to wdsFull which causes it to FindKey.}
end;

function TDMQuery2.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin

      { The following works when compiled with Delphi XE and run on Windows 7.
      Thanks to this web page for the documentation of the ConnectionString
      syntax:
      http://www.codemaker.co.uk/it/tips/ado_conn.htm#ODBCDriverForParadox
      Note that DefaultDir means "working directory" i.e. location of *.db
      and Dbq means "private directory" i.e. location of paradox .net file.}
      Query1.ConnectionString :=
        'Provider=MSDASQL.1;Persist Security Info=False;' +
        'Extended Properties="'+
        'DBQ=' + getHtDemoDataRoot + 'whQuery2\' +
        'employee.mdb;DefaultDir=' + getHtDemoDataRoot + 'whQuery2;' +
        'Driver={Driver do Microsoft Access (*.mdb)};' +
        'DriverId=25;FIL=MS Access;' +
      //FILEDSN=D:\Projects\webhubdemos\Source\WHApps\DB Examples\whQuery2\employeeADO.dsn;
        'MaxBufferSize=2048;MaxScanRows=8;PageTimeout=5;SafeTransactions=0;' +
        'Threads=3;UID=admin;UserCommitSync=Yes;";Initial Catalog=' +
        getHtDemoDataRoot + 'whQuery2\employee';

      ADOQueryFull.ConnectionString := Query1.ConnectionString;
      ADOQueryFull.SQL.Text := 'select * from employee';
      WebDataScanAll.WebDataSource.KeyFieldNames := 'EmpNo';

      RefreshWebActions(Self);
      if NOT WebDataSource1.IsUpdated then
        ErrorText := WebDataSource1.Name + ' failed to refresh. ';
      if NOT grid.IsUpdated then
        ErrorText := ErrorText + grid.Name + ' failed to refresh. ';
      if NOT WebDataScanAll.IsUpdated then
        ErrorText := ErrorText + WebDataScanAll.Name + ' failed to refresh. ';

      if ErrorText = '' then
      begin
        grid.SetCaptions2004;
        grid.SetButtonSpecs2012;
        grid.PageHeight := 0; // so few records, might as well show ALL.

        if NOT Assigned(ZMKey) then
        begin
          ZMKey := ZM.ActivateTempKey(ExtractFilePath(pWebApp.ConfigFilespec)
            + 'whQuery2Spec.xml', 'whQuery2Configuration');
          ZMKey.KeyedFile.LoadFile;
        end;
        loadCustomSettings(ErrorText);
      end;

      if ErrorText = '' then
      begin
        WebDataScanAll.PageHeight := 2;
        WebDataScanAll.ButtonsWhere := dsBelow;

        // helpful to know that WebAppUpdate will be called whenever the
        // WebHub app is refreshed.
        AddAppUpdateHandler(WebAppUpdate);
        FlagInitDone := True;
      end;
    end;
  end;
  Result := FlagInitDone;
  {$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

function TDMQuery2.loadCustomSettings(out ErrorText: string): Boolean;
var
  S1: string;
begin
  // Note: you may override database path

  ErrorText := '';
  Result := True;
//////  TableComplete.Databasename:=S1;
  S1 := ZMKey.KeyedFile.ZNodeAttr(nil,
    ['QuerySpec/Item', '@name', 'Tablename'], cxOptional, '', 'value');
  if S1 = '' then
  begin
    ErrorText := ZM.KeyLastError;
    Result := False;
  end
  else
  begin

///////    TableComplete.Tablename:=S1;
    try
///////      TableComplete.open;
      WebDataSource1.KeyFieldNames := ZMKey.KeyedFile.ZNodeAttr(nil,
      ['QuerySpec/Item', '@name', 'PrimaryKeyField'], cxOptional, '', 'value');
      CSSend('WebDataSource1.KeyFieldNames', WebDataSource1.KeyFieldNames);
    except on E: Exception do
      begin
        ErrorText := S1 + ' failed to open. Exception:' + E.message;
        Result := False;
      end;
    end;
  end;

  {do not free the map or the key}
end;

procedure TDMQuery2.Query1BeforeOpen(DataSet: TDataSet);
begin
  if Dataset is TADOQuery then
  with TADOQuery(Dataset) do
  begin
    sql.text:=ZMKey.KeyedFile.ZNodeAttr(nil,
      ['QuerySpec/Item', '@name', 'SQL'], cxOptional, '', 'value')
      + ' WHERE ('
      + ZMKey.KeyedFile.ZNodeAttr(nil,
      ['QuerySpec/Item', '@name', 'SearchField'], cxOptional, '', 'value')
      + ' LIKE '''+pWebApp.StringVar['FindMe']+'%'')';
  end
  else
    LogSendWarning(DataSet.ClassName + ' class not supported; SQL not loaded');
end;

procedure TDMQuery2.WebAppNewSession(Sender: TObject; Session: Integer;
  const Command: String);
begin
  // note this procedure is called from the OnNewSession event in counter.pas

  // The purpose of this is to demonstrate that we can set the pageheight on
  // a per-site-visitor basis.
  // 0 gives all rows, so let's avoid that by adding 1.
  pWebApp.StringVarInt['WebDataScan1.PageHeight'] := Random(14) + 1;
end;

procedure TDMQuery2.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMQuery2.WebDataScanAllEmptyDataSet(Sender: TObject);
begin
  {This is here to demonstrate what happens when the result set is empty. The
   SQL for query2 always returns an empty result set.}
  pWebApp.SendString('<tr><td>'
  +'Hey there is no data in this result set!'
  +'</td></tr>');
end;

procedure TDMQuery2.WebDataScanAllFinish(Sender: TObject);
begin
  inherited;
  pWebApp.SendDroplet(WebDataScanAll.HtmlParam, drAfterWhrow);
  if True then
    WebDataScanAll.ButtonsWhere := dsBelow
  else
    WebDataScanAll.ButtonsWhere := dsNone;
end;

procedure TDMQuery2.WebDataScanAllInit(Sender: TObject);
begin
  pWebApp.SendDroplet(WebDataScanAll.HtmlParam, drBeforeWhrow);
end;

procedure TDMQuery2.WebDataScanAllRowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
begin
  inherited;
  pWebApp.SendString('<tr>'
  +'<td>' + TwhdbSource(aWebDataSource).DataSet.FieldByName('EmpNo').asString
  +'</td>'
  +'<td>' + TwhdbSource(aWebDataSource).DataSet.FieldByName('Firstname').asString
  +'</td>'
  +'<td>' + TwhdbSource(aWebDataSource).DataSet.FieldByName('Lastname').asString
  +'</td>'
  +'</tr>');
end;

(*
object TableComplete: TTable
  DatabaseName = 'WebHubDemoData'
  Left = 432
  Top = 324
end
*)

end.
