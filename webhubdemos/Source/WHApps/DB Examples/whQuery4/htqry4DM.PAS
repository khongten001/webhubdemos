unit htqry4dm;

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

// This is the code for the "left" grid which selects by department.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, DB, 
  UpdateOk, tpAction, 
  WebTypes, wbdeSource, wbdeForm, 
  WebLink, WdbLink, WdbScan, wbdeGrid, WebSend, webScan;

type
  TDataModuleHTQ4 = class(TDataModule)
    grid1: TwhbdeGrid;
    WebDataSource1: TwhbdeSource;
    DataSource1: TDataSource;
    Query1: TQuery;
    WebDataForm1: TwhbdeForm;
    WebDataSourceEmp: TwhbdeSource;
    DataSourceEmp: TDataSource;
    TableEmp: TTable;
    WebAction1: TwhWebAction;
    procedure grid1HotField(Sender: TwhdbScan; aField: TField;
      var s: string);
    procedure WebAction1Execute(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init;
    procedure WebAppUpdate(Sender: TObject);
  end;

var
  DataModuleHTQ4: TDataModuleHTQ4;

implementation

uses 
  webApp, htWebApp, whdemo_ViewSource, whMacroAffixes, grid2DM;

{$R *.DFM}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

procedure TDataModuleHTQ4.Init;
begin
  Query1.Databasename := getHtDemoDataRoot + 'whQuery4\';
  TableEmp.Databasename := getHtDemoDataRoot + 'whQuery4\';
  RefreshWebActions(DataModuleHTQ4);

  WebDataSource1.MaxOpenDataSets := 20;
  WebDataSource1.BendPointers := False;
  grid1.Border := '';
  grid1.SetCaptions2004;
  grid1.SetButtonSpecs2012;
  grid1.Captions.Values['Redraw'] := '<input type="submit" value="X">';

  if assigned(pWebApp) then
  begin
    AddAppUpdateHandler(WebAppUpdate);
    WebAppUpdate(pWebApp);
  end;
end;

//------------------------------------------------------------------------------

procedure TDataModuleHTQ4.WebAppUpdate(Sender: TObject);
begin
  {Set the list of EventMacros here, rather than loading them from the
   application-level INI file. 31-May-2004}
  with pWebApp.EventMacros do
  begin
    Clear;
    Add('evLocate=x');
  end;
end;

//------------------------------------------------------------------------------

procedure TDataModuleHTQ4.Query1BeforeOpen(DataSet: TDataSet);
begin
  with TQuery(DataSet) do
  begin
    SQL.Text := 'select * from employee where Department=''' +
      pWebApp.StringVar['Dept'] + '''';
  end;
end;

//------------------------------------------------------------------------------

procedure TDataModuleHTQ4.grid1HotField(Sender: TwhdbScan;
  aField: TField; var s: string);
begin
  if comparetext(aField.fieldname,'empno')=0 then
  begin
    {This just drops a graphic into the 'hot' field for each record.
     We are requesting the macro 'mcHotGif' which will get expanded
     based on its definition.  Of course we could also put the HTML
     in here directly, but the idea is to keep as much of the OUTSIDE
     the Delphi project as possible, to cut down on the need to recompile.}
    s:=MacroStart + 'mcHotGif' + MacroEnd + s;
  end
  else
  if comparetext(aField.fieldname,'lastname')=0 then
  begin
    s:=DataModuleGrid2.getLastnameJump(aField);
  end;
end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// demonstration of reserved pageid "DO"
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
procedure TDataModuleHTQ4.WebAction1Execute(Sender: TObject);
begin
  { This demonstrates the reserved pageid called 'DO' which runs
    components by name if they are passed as the command.

    TwhWebActionEx.DirectCallOk must be True for this to work. It is False by
    default.

    Test with: http://localhost/scripts/runisa.dll?HTQ4:DO::webaction1.ok}
  with TwhWebAction(Sender) do
    Response.Send( 'DO command demonstration. Hello from ' + name + '.' +
      command);
end;

end.
