unit fmclone;
(*
Copyright (c) 1997 HREF Tools Corp.

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
  UTPANFRM, ExtCtrls, StdCtrls, Toolbar, {}tpCompPanel, UpdateOk,
  tpAction, IniLink,   TpMemo, Restorer, ComCtrls, tpStatus, Db,
  DBTables, wbdeSource, WebTypes, WebLink, WdbLink, WdbScan, wbdeGrid, Grids,
  DBGrids, wdbSSrc;

type
  TfmBendFields = class(TutParentForm)
    ToolBar: TtpToolBar;
    tpComponentPanel2: TtpComponentPanel;
    DBGrid: TDBGrid;
    WebDataGrid1: TwhbdeGrid;
    Scan2: TwhdbScan;
    Scan1: TwhdbScan;
    WebDataSource1: TwhbdeSource;
    WebDataSource2: TwhbdeSource;
    DataSource2: TDataSource;
    DataSource1: TDataSource;
    Table1: TTable;
    Table1ACCT_NBR: TFloatField;
    Table1SYMBOL: TStringField;
    Table1SHARES: TFloatField;
    Table1PUR_PRICE: TFloatField;
    Table1PUR_DATE: TDateField;
    Table2: TTable;
    Table2SpeciesNo: TFloatField;
    Table2Category: TStringField;
    Table2Common_Name: TStringField;
    Table2SpeciesName: TStringField;
    Table2Lengthcm: TFloatField;
    Table2Length_In: TFloatField;
    Table2Notes: TMemoField;
    Table2Graphic: TGraphicField;
    GroupBox2: TGroupBox;
    tpStatusBar1: TtpStatusBar;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox1: TGroupBox;
    procedure WebDataSourceExecute(Sender: TObject);
    procedure Scan2Execute(Sender: TObject);
    procedure WebDataSourceFindKeys(Sender: TwhdbSourceBase;
              var Value: string; var Handled: Boolean);
    procedure ScanAfterExecute(Sender: TObject);
    procedure ScanOnExecute(Sender: TObject);
    procedure Scan2RowStart(Sender: TwhdbScanBase;
              aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure Scan1RowStart(Sender: TwhdbScanBase;
              aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure WebDataGrid1AfterExecute(Sender: TObject);
    procedure WebDataGrid1Execute(Sender: TObject);
    procedure ScanOnFinish(Sender: TObject);
    procedure ScanOnInit(Sender: TObject);
  private
    { Private declarations }
    procedure PageHeader;
    procedure PageFooter;
    procedure TableHeader(Sender: TObject);
    procedure TableFooter;
  public
    { Public declarations }
    function Init: Boolean; override;
    end;

var
  fmBendFields: TfmBendFields;

implementation

{$R *.DFM}

uses
  webApp, whMacroAffixes, whdemo_ViewSource,
  ucHTML;

//------------------------------------------------------------------------------

function TfmBendFields.Init:Boolean;
begin
  Result:= inherited Init;
  if not Result then
    Exit;

  scan1.WebDataSource := WebDataSource1;
  scan1.OnRowStart := Scan1RowStart;

  scan2.WebDataSource := WebDataSource2;
  scan2.OnRowStart := Scan2RowStart;

  WebDataGrid1.WebDataSource := WebDataSource1;

  WebDataSource1.DataSource := DataSource1;
  DataSource1.DataSet := Table1;

  WebDataSource2.DataSource := DataSource2;
  DataSource2.DataSet := Table2;

  with Table1 do
  begin
    DatabaseName := getHtDemoDataRoot + 'whClone\';
    TableName := 'HOLDINGS.DBF';
    Open;
  end;

  with Table2 do
  begin
    DatabaseName := getHtDemoDataRoot + 'whClone\';
    TableName := 'BIOLIFE.DB';
    Open;
  end;

//on startup the grid will take over the form..
//note that both webdatasources use OpenDataSetVisual=True  .. that is not very
//efficient when running over the web, yet it is a great way to SEE what your
//webdatasource sees visually. OpenDataSetVisual=True is of course required if
//you're using RTTI to access the value of database controls on a form, but that's
//where you'd usually use the Field macro, so consider it a debugging property.
//-Michael Ax.
end;

//------------------------------------------------------------------------------
//this code is used by both webdatasources as they both demonstrate using
//pre-instantiated fields:

procedure TfmBendFields.WebDataSourceExecute(Sender: TObject);
//bend existing field-pointers to the clone's fields
begin
{there are THREE CHOICES when bending pointers:
 #1: activate WebDataSource.BendPointers.
     that's whats been done here, and why there is no code.
     there's usually little need to 'straighten' the pointers again,
     but if you need to, call TwhbdeSource(sender).ResetClonePointers.
 #2: call the WebDataSource BendClonePointers method.
     as in: TwhbdeSource(sender).BendClonePointers.
     to undo: TwhbdeSource(sender).ResetClonePointers.
 #3: directly call the ucClonDB utility function responsible:
     as in: with TwhbdeSource(sender) do
              BendDataSetPointers(OriginalDataSet,DataSet);
     to undo call: BendDataSetPointers(OriginalDataSet,nil);}
end;

//------------------------------------------------------------------------------
//both datascan components deliver roughly the same look and here's the code
//shared by both:

procedure TfmBendFields.PageHeader;
begin
  pWebApp.SendMacro('drPageHeaderHTCL');
end;

procedure TfmBendFields.TableHeader(Sender: TObject);
begin
  pWebApp.SendString('<table id="' + Self.Name + '-table" class="' +
    TwhdbScan(Sender).Family + '-table">');
end;

procedure TfmBendFields.TableFooter;
begin
  writeln('</table>');
end;

procedure TfmBendFields.PageFooter;
begin
  pWebApp.SendMacro('drPageFooterHTCL');
end;

procedure TfmBendFields.ScanOnExecute(Sender: TObject);
begin
  inherited;
  PageHeader;
end;

procedure TfmBendFields.ScanOnInit(Sender: TObject);
begin
  inherited;
  TableHeader(Sender);
  if Sender = scan1 then
  begin
  writeln(
     '<tr>'
    +'<th>TableName</th>'
    +'<th>RecNo</th>'
    +'<th>ACCT_NBR</th>'
    +'<th>SYMBOL</th>'
    +'<th>SHARES</th>'
    +'<th>PUR_PRICE</th>'
    +'<th>PUR_DATE</th></tr>');
  end
  else
  begin
  writeln(
     '<tr>'
    +'<th>TableName</th>'
    +'<th>RecNo</th>'
    +'<th>SpeciesNo</th>'
    +'<th>Category</th>'
    +'<th>Common_Name</th></tr>');
  end;
end;

procedure TfmBendFields.ScanOnFinish(Sender: TObject);
begin
  inherited;
  TableFooter;
end;

procedure TfmBendFields.ScanAfterExecute(Sender: TObject);
begin
  inherited;
  PageFooter;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//code for the WebDataScan named "SCAN2"..  scans the "biolife.db" table

procedure TfmBendFields.Scan2Execute(Sender: TObject);
begin
  dbGrid.DataSource :=
    TwhbdeSource(TwhdbScan(Sender).WebDataSource).DataSource;
  ScanOnExecute(Sender);
end;

procedure TfmBendFields.Scan2RowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
begin
  writeln(
     '<tr>'
    +'<td>'
    +Table2.Name+'</td>'                     //  <- notice reference to table2
    +'<td>'
    +IntToStr(Table2.RecNo)+'</td>'             //      when this runs, that pointer
    +'<td>'
    +Table2SpeciesNo.AsString+'</td>'           //      and all the field pointers
    +'<td>'
    +Table2Category.AsString+'</td>'            //      will point to the clones!
    +'<td>'
    +Table2Common_Name.AsString+'</td></tr>');
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//code for the WebDataScan named "SCAN1"..  scans the "holdings.dbf" table

procedure TfmBendFields.Scan1RowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
begin
  writeln(
     '<tr>'
    +'<td>'
    +Table1.Name+'</td>'
    +'<td>'
    +IntToStr(Table1.RecNo)+'</td>'
    +'<td>'
    +Table1ACCT_NBR.AsString+'</td>'
    +'<td>'
    +Table1SYMBOL.AsString+'</td>'
    +'<td>'
    +Table1SHARES.AsString+'</td>'
    +'<td>'
    +Table1PUR_PRICE.AsString+'</td>'
    +'<td>'
    +Table1PUR_DATE.AsString+'</td></tr>');
end;

//------------------------------------------------------------------------------

procedure TfmBendFields.WebDataSourceFindKeys(Sender: TwhdbSourceBase;
  var Value: string; var Handled: Boolean);
begin
  //scrolling through the holdings table.
  //we're not supporting 'finding' values here
  //but simply signal that we're scrolling through
  //a cloned table that does not have a unique or primary index.
  //This would be the place to write code to locate items.
  Handled:=true;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TfmBendFields.WebDataGrid1AfterExecute(Sender: TObject);
begin
  inherited;
  PageFooter;
end;

procedure TfmBendFields.WebDataGrid1Execute(Sender: TObject);
begin
  inherited;
  PageHeader;
end;

end.
