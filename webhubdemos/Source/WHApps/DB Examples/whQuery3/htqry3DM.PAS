unit htqry3dm;
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
  DB, DBTables, wbdeSource, WdbLink, WdbScan, wbdeGrid, UpdateOk, tpAction,
  WebTypes,   WebLink, WebPage, WebPHub, webScan;

type
  TDataModuleQ3 = class(TDataModule)
    WebDataGrid1: TwhbdeGrid;
    WebDataSource1: TwhbdeSource;
    DataSource1: TDataSource;
    Query1: TQuery;
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure DataModuleQ3Create(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init;
  end;

var
  DataModuleQ3: TDataModuleQ3;

implementation

uses 
  whdemo_ViewSource, webApp, ucPos;

{$R *.DFM}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

procedure TDataModuleQ3.DataModuleQ3Create(Sender: TObject);
begin
  //Explicitly hook up events (instead of putting connection in the DFM).
  with Query1 do
  begin
    DatabaseName:=getHtDemoDataRoot + 'whQuery3\';
    BeforeOpen:=Query1BeforeOpen;
  end;
end;

procedure TDataModuleQ3.Init;
begin
  RefreshWebActions(DataModuleQ3);
  WebDataGrid1.SetCaptions2004;
  WebDataGrid1.SetButtonSpecs2012;
end;

// -----------------------------------------------------------------------------

procedure TDataModuleQ3.Query1BeforeOpen(DataSet: TDataSet);
var
  S: String;
begin
  inherited;
  S := pWebApp.StringVar['SQL'];
  if posci('delete',S) > 0 then
  begin
    raise Exception.Create('Do not use the word DELETE');
    Exit;
  end;
  with TQuery(Dataset) do
  begin
    //set the query statement based on surfer input.
    sql.text:=S;
  end;
end;

end.
