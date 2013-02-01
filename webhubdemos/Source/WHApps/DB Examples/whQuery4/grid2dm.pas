unit grid2dm;
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

{This datamodule unit shows how you can isolate the components for a
particular task -- for organization, and for possible re-use in another
project.  Here we have the code for the second grid (search by salary).
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, wbdeSource, UpdateOk, WebTypes, WebLink, WdbLink, webScan,
  WdbScan, wbdeGrid, tpAction, wdbSSrc, wdbSource;

type
  TDataModuleGrid2 = class(TDataModule)
    grid2: TwhbdeGrid;
    WebDataSource2: TwhbdeSource;
    DataSource2: TDataSource;
    Query2: TQuery;
    procedure Query2BeforeOpen(DataSet: TDataSet);
    procedure grid2HotField(Sender: TwhbdeGrid; AField: TField;
      var CellValue: string);
  private
    { Private declarations }
  public
    { Public declarations }
    function  getLastnameJump(aField:TField):string;
    function Init(out ErrorText: string): Boolean;
  end;

var
  DataModuleGrid2: TDataModuleGrid2;

implementation

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucCodeSiteInterface,
  webApp, whMacroAffixes, whdemo_ViewSource;

{$R *.DFM}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

procedure TDataModuleGrid2.grid2HotField(Sender: TwhbdeGrid; AField: TField;
  var CellValue: string);
begin
  {note the comma separating the target PageID (Detail) from the
   optional command string (empno.asString) }
  CellValue := getLastnameJump(aField);
end;

function TDataModuleGrid2.Init(out ErrorText: string): Boolean;
const
  cRecylingHtml = '&#x267b;';
begin
  ErrorText := '';
  Query2.databasename := getHtDemoDataRoot + 'whQuery4\';
  RefreshWebActions(DataModuleGrid2);
  if grid2.IsUpdated then
  begin
    WebDataSource2.MaxOpenDataSets := 20;
    WebDataSource2.BendPointers := False;
    grid2.Border := '';
    grid2.SetCaptions2004;
    grid2.SetButtonSpecs2012;
    grid2.Captions.Values[cCapDraw] := MacroStart + 'mcRedrawSubmit' + MacroEnd;
  end
  else
    ErrorText := grid2.Name + ' unable to update';
  Result := ErrorText = '';
end;

// -----------------------------------------------------------------------------

procedure TDataModuleGrid2.Query2BeforeOpen(DataSet: TDataSet);
begin
  with TQuery(DataSet) do
  begin
    SQL.Text := 'select * from employee';
    if (pWebApp.StringVar['MinSalary'] <> '') then
      SQL.Text := SQL.Text + ' where salary > ' + pWebApp.StringVar['MinSalary'];
  end;
end;

function  TDataModuleGrid2.getLastnameJump(aField:TField):string;
begin
  Result := MacroStart + 'JUMP|detail,' +
    aField.DataSet.FieldByName('EmpNo').asString + '|' + aField.asString +
    MacroEnd;
end;

end.

