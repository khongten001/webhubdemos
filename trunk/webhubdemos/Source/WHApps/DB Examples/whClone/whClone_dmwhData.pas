unit whClone_dmwhData;

(*
Copyright (c) 1997-2013 HREF Tools Corp.

Permission is hereby granted, on 03-Feb-2013, free of charge, to any person
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
  webLink, Data.DB, wdbScan, wdbSSrc, wdbSource, wbdeSource, Bde.DBTables,
  updateOK, tpAction, webTypes, wbdeGrid;

type
  TDMData2Clone = class(TDataModule)
    WebDataGrid1: TwhbdeGrid;
    Table2: TTable;
    Table2SpeciesNo: TFloatField;
    Table2Category: TStringField;
    Table2Common_Name: TStringField;
    Table2SpeciesName: TStringField;
    Table2Lengthcm: TFloatField;
    Table2Length_In: TFloatField;
    Table2Notes: TMemoField;
    Table2Graphic: TGraphicField;
    DataSource2: TDataSource;
    WebDataSource2: TwhbdeSource;
    Scan2: TwhdbScan;
    Table1: TTable;
    Table1ACCT_NBR: TFloatField;
    Table1SYMBOL: TStringField;
    Table1SHARES: TFloatField;
    Table1PUR_PRICE: TFloatField;
    Table1PUR_DATE: TDateField;
    DataSource1: TDataSource;
    WebDataSource1: TwhbdeSource;
    Scan1: TwhdbScan;
    procedure DataModuleCreate(Sender: TObject);
    procedure ScanOnExecute(Sender: TObject);
    procedure ScanAfterExecute(Sender: TObject);
    procedure ScanInit(Sender: TObject);
    procedure ScanFinish(Sender: TObject);
    procedure WebDataSource1Execute(Sender: TObject);
    procedure Scan2RowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure Scan1RowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure WebDataSource1FindKeys(Sender: TwhdbSourceBase; var Value: string;
      var Handled: Boolean);
    procedure WebDataGrid1AfterExecute(Sender: TObject);
    procedure WebDataGrid1Execute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure PageHeader;
    procedure PageFooter;
    procedure TableHeader(Sender: TObject);
    procedure TableFooter;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMData2Clone: TDMData2Clone;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp, htWebApp, ucCodeSiteInterface, whdemo_ViewSource;

{ TDM001 }

procedure TDMData2Clone.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMData2Clone.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin

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


      // Call RefreshWebActions here only if it is not called within a TtpProject event
      // RefreshWebActions(Self);

      // helpful to know that WebAppUpdate will be called whenever the
      // WebHub app is refreshed.
      AddAppUpdateHandler(WebAppUpdate);
      FlagInitDone := True;
    end;
  end;
  Result := FlagInitDone;
  {$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

//------------------------------------------------------------------------------
//both datascan components deliver roughly the same look and here's the code
//shared by both:

procedure TDMData2Clone.PageFooter;
begin
  pWebApp.SendMacro('drPageFooterHTCL');
end;

procedure TDMData2Clone.PageHeader;
begin
  pWebApp.SendMacro('drPageHeaderHTCL');
end;

procedure TDMData2Clone.ScanInit(Sender: TObject);
begin
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

procedure TDMData2Clone.ScanFinish(Sender: TObject);
begin
  TableFooter;
end;

procedure TDMData2Clone.Scan1RowStart(Sender: TwhdbScanBase;
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

procedure TDMData2Clone.Scan2RowStart(Sender: TwhdbScanBase;
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

procedure TDMData2Clone.ScanAfterExecute(Sender: TObject);
begin
  PageFooter;
end;

procedure TDMData2Clone.ScanOnExecute(Sender: TObject);
begin
  PageHeader;
end;

procedure TDMData2Clone.TableFooter;
begin
  writeln('</table>');
end;

procedure TDMData2Clone.TableHeader(Sender: TObject);
begin
  pWebApp.SendString('<table id="' + Self.Name + '-table" class="' +
    TwhdbScan(Sender).Family + '-table">');
end;

procedure TDMData2Clone.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

//------------------------------------------------------------------------------
//this code is used by both webdatasources as they both demonstrate using
//pre-instantiated fields:

procedure TDMData2Clone.WebDataGrid1AfterExecute(Sender: TObject);
begin
  PageFooter;
end;

procedure TDMData2Clone.WebDataGrid1Execute(Sender: TObject);
begin
  PageHeader;
end;

procedure TDMData2Clone.WebDataSource1Execute(Sender: TObject);
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

procedure TDMData2Clone.WebDataSource1FindKeys(Sender: TwhdbSourceBase;
  var Value: string; var Handled: Boolean);
begin
  //scrolling through the holdings table.
  //we're not supporting 'finding' values here
  //but simply signal that we're scrolling through
  //a cloned table that does not have a unique or primary index.
  //This would be the place to write code to locate items.
  Handled:=true;
end;

end.
