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
  DB, Bde.DBTables, 
  wdbSource, wbdeSource, wdbLink, wdbScan, wdbGrid, wbdeGrid{bde}, 
  UpdateOk, tpAction,
  WebTypes, WebLink, WebPage, WebPHub, webScan, wdbSSrc;

type
  TDataModuleQ3 = class(TDataModule)
    WebDataGrid1: TwhbdeGrid;
    WebDataSource1: TwhbdeSource;
    DataSource1: TDataSource;
    Query1: TQuery;
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure DataModuleQ3Create(Sender: TObject);
    procedure Query1AfterOpen(DataSet: TDataSet);
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
  ucPos, ucCodeSiteInterface,
  whdemo_ViewSource, webApp;

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

procedure TDataModuleQ3.Query1AfterOpen(DataSet: TDataSet);
var
  HideFieldNum: Integer;
  i: Integer;
begin
  {hide one field from the grid by setting Visible False on the DataSet.}
  HideFieldNum := StrToIntDef(pWebApp.StringVar['inHideFieldNum'], -1);
  if HideFieldNum > -1 then
  begin
    if HideFieldNum < DataSet.FieldCount then
      DataSet.Fields[HideFieldNum].Visible := False;
  end;
  {enable use of OnHotLabel and OnHotField event for all fields even though
   that feature is not currently used in this demo.}
  for i := 0 to Pred(DataSet.FieldCount) do
    DataSet.Fields[i].Tag := HotLabelTag + HotFieldTag;
end;

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
