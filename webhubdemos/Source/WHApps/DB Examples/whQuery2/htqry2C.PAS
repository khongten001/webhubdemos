unit htqry2c;
(*
Copyright (c) 1999 HREF Tools Corp.

Permission is hereby granted, on 04-Jun-2004, free of charge, to any person
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, DB, DBTables, ExtCtrls, StdCtrls, Grids, DBGrids,
  ZaphodsMap,
  UTPANFRM, tpStatus, UpdateOk, tpAction,
  WebPage, WebPHub, WdbLink, WdbScan, wbdeGrid, WebTypes, webScan, WebLink,
  wbdeSource, wdbSSrc, ADODB, wdbxSource, Buttons, toolbar, tpCompPanel;

type
  TfmHTQ2Panel = class(TutParentForm)
    DBGrid1: TDBGrid;
    tpStatusBar1: TtpStatusBar;
    wdsFull: TwhbdeSource;
    DataSourceForFullTable: TDataSource;
    TableComplete: TTable;
    WebDataSource1: TwhbdeSource;
    DataSource1: TDataSource;
    Query1: TQuery;
    grid: TwhbdeGrid;
    WebDataScan1: TwhdbScan;
    DataSource2: TDataSource;
    ADOQuery1: TADOQuery;
    whdbxSource2: TwhdbxSource;
    Toolbar: TtpToolBar;
    tpToolButton1: TtpToolButton;
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure gridHotField(Sender: TwhbdeGrid; aField: TField;
      var CellValue: string);
    procedure gridAfterExecute(Sender: TObject);
    procedure WebDataScan1Init(Sender: TObject);
    procedure WebDataScan1RowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure WebDataScan1Finish(Sender: TObject);
    procedure WebDataScan1EmptyDataSet(Sender: TObject);
    procedure Query2FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tpToolButton1Click(Sender: TObject);
  private
    { Private declarations }
    ZM: TZaphodsMap;
    ZMKey: TZaphodKey;
  protected
    procedure CloseAllDatasets(AWebDataSource: TwhbdeSource);
  public
    { Public declarations }
    function Init: Boolean; override;
    procedure WebAppNewSession(Sender:TObject; Session:Integer;
      const Command:String);
  protected
    procedure loadCustomSettings;
  end;

var
  fmHTQ2Panel: TfmHTQ2Panel = nil;

implementation

{$R *.DFM}

uses
  webApp, webSend, whMacroAffixes, whdemo_ViewSource,
  ucDlgs, ucPos, ucLogFil;

//------------------------------------------------------------------------------

procedure TfmHTQ2Panel.FormCreate(Sender: TObject);
begin
  inherited;
  ZM := TZaphodsMap.Create(Self);
  ZMKey := nil;
end;

procedure TfmHTQ2Panel.FormDestroy(Sender: TObject);
begin
  inherited;
  ZMKey := nil;
  FreeAndNil(ZM);
  fmHTQ2Panel := nil;
end;

//------------------------------------------------------------------------------

function TfmHTQ2Panel.Init:Boolean;
begin
  Result:= inherited Init;
  if not Result then
    Exit;

  ADOQuery1.ConnectionString :=
    'Provider=MSDASQL.1;Persist Security Info=False;' +
    'Data Source=WebHubDemoHTQ2;' +
    'Initial Catalog=' +
    'D:\PROJECTS\WEBHUB DEMOS\LIVE\DATABASE\WHQUERY2' +
    '';

  RefreshWebActions(fmHTQ2Panel);
  grid.SetCaptions2004;
  grid.SetButtonSpecs2004;

  if NOT Assigned(ZMKey) then
  begin
    ZMKey := ZM.ActivateTempKey(ExtractFilePath(pWebApp.ConfigFilespec)
      + 'whQuery2Spec.xml', 'whQuery2Configuration');
    ZMKey.KeyedFile.LoadFile;
  end;
  loadCustomSettings;

  whdbxSource2.KeyFieldNames := 'EmpNo';
  WebDataScan1.PageHeight := 2;
  WebDataScan1.ButtonsWhere := dsBelow;
  ADOQuery1.SQL.Text := 'select * from employee'; // where (0=3)';
end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

procedure TfmHTQ2Panel.WebAppNewSession(Sender:TObject; Session:Integer;
  const Command:String);
begin
  // note this procedure is called from the OnNewSession event in counter.pas

  // The purpose of this is to demonstrate that we can set the pageheight on
  // a per-site-visitor basis.
  // 0 gives all rows, so let's avoid that by adding 1.
  pWebApp.StringVarInt['WebDataScan1.PageHeight'] := Random(14) + 1;
end;

// -----------------------------------------------------------------------------

procedure TfmHTQ2Panel.loadCustomSettings;
var
  S: String;
begin
  // Set the database path...
  // Note: you may override and set this to any database path.
  S:=getHtDemoDataRoot + 'whQuery2\';
  Query1.Databasename := S;
  //Query2.Databasename := S;

  TableComplete.Databasename:=S;
  S := ZMKey.KeyedFile.ZNodeAttr(nil,
    ['QuerySpec/Item', '@name', 'Tablename'], cxOptional, '', 'value');
  if S = '' then
  begin
    msgErrorOk(ZM.KeyLastError);
    FreeAndNil(ZM);
    FreeAndNil(ZMKey);
    Exit;
  end;

  TableComplete.Tablename:=S;
  try
    TableComplete.open;
    WebDataSource1.KeyFieldNames:= ZMKey.KeyedFile.ZNodeAttr(nil,
    ['QuerySpec/Item', '@name', 'PrimaryKeyField'], cxOptional, '', 'value');
    DBGrid1.enabled:=true;
  except on e: Exception do
    msgErrorOk( S + ' failed to open. Error:'+e.message );
  end;

  {do not free the map or the key}
//  FreeAndNil(ZM);
end;

{----------------------------------------------------------------------------}
{----------------------------------------------------------------------------}

procedure TfmHTQ2Panel.Query1BeforeOpen(DataSet: TDataSet);
begin
  inherited;
  with TQuery(Dataset) do
  begin
    sql.text:=ZMKey.KeyedFile.ZNodeAttr(nil,
      ['QuerySpec/Item', '@name', 'SQL'], cxOptional, '', 'value')
      + ' WHERE ('
      + ZMKey.KeyedFile.ZNodeAttr(nil,
      ['QuerySpec/Item', '@name', 'SearchField'], cxOptional, '', 'value')
      + ' LIKE '''+pWebApp.StringVar['FindMe']+'%'')';
  end;
end;

{----------------------------------------------------------------------------}

{Hot field is set by putting :HF after the field name in the
displaySet.  See WebDataSource.displayset -- or just look in the
htqry2.ini file.}
procedure TfmHTQ2Panel.gridHotField(Sender: TwhbdeGrid; aField: TField;
  var CellValue: string);
begin
  inherited;
  {JUMP is a built-in WebHub macro. Syntax is: JUMP|pageId,command|visiblePhrase }
  CellValue:=MacroStart + 'JUMP|detail,wdsFull.'+
     aField.DataSet.fields[0].asString+  {command (4th param on URL)}
     '|'+aField.asString+MacroEnd;  {command is passed to wdsFull which causes it to FindKey.}
end;

{----------------------------------------------------------------------------}
{----------------------------------------------------------------------------}

procedure TfmHTQ2Panel.gridAfterExecute(Sender: TObject);
begin
  inherited;
  // Publish the sql code to the web, after the final page section.
  with WebDataSource1 do
    pWebApp.Summary.Add('SQL for '+DataSet.Name+' is:<BR>'
    +TQuery(dataset).sql.text);
end;

procedure TfmHTQ2Panel.WebDataScan1Init(Sender: TObject);
begin
  inherited;
  pWebApp.SendDroplet(WebDataScan1.HtmlParam, drBeforeWhrow); 
end;

procedure TfmHTQ2Panel.WebDataScan1RowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
begin
  inherited;
  pWebApp.SendString('<tr>'
  +'<td>' + TQuery(TwhbdeSource(aWebDataSource).DataSet).FieldByName('EmpNo').asString
  +'</td>'
  +'<td>' + TQuery(TwhbdeSource(aWebDataSource).DataSet).FieldByName('Firstname').asString
  +'</td>'
  +'<td>' + TQuery(TwhbdeSource(aWebDataSource).DataSet).FieldByName('Lastname').asString
  +'</td>'
  +'</tr>');
end;

procedure TfmHTQ2Panel.WebDataScan1Finish(Sender: TObject);
begin
  inherited;
  pWebApp.SendDroplet(WebDataScan1.HtmlParam, drAfterWhrow);
  if True then
    WebDataScan1.ButtonsWhere := dsBelow
  else
    WebDataScan1.ButtonsWhere := dsNone;
end;

procedure TfmHTQ2Panel.WebDataScan1EmptyDataSet(Sender: TObject);
begin
  inherited;
  {This is here to demonstrate what happens when the result set is empty. The
   SQL for query2 always returns an empty result set.}
  pWebApp.SendString('<tr><td>'
  +'Hey there is no data in this result set!'
  +'</td></tr>');
end;

procedure TfmHTQ2Panel.Query2FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  inherited;
  if posci('e', DataSet.FieldByName('Firstname').asString) > 0 then
    Accept := True // (Random(1) = 1);
  else
    Accept := False;
end;

procedure TfmHTQ2Panel.CloseAllDatasets(AWebDataSource: TwhbdeSource);
var
  n:integer;
begin
  with AWebDataSource do
  begin
    n:=0;   // number of datasets to leave open
    while ComponentCount>n do
      Components[0].free;
  end;
end;

procedure TfmHTQ2Panel.tpToolButton1Click(Sender: TObject);
begin
  inherited;
  DBGrid1.DataSource := DataSource2;
  ADOQuery1.Open;
end;

end.

