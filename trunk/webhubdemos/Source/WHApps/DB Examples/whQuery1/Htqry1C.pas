unit htqry1c;
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
  ComCtrls,
  UTPANFRM, ExtCtrls, StdCtrls, TpMemo, Buttons, Toolbar,
  WdbLink, WdbScan, wbdeGrid, UpdateOk, tpAction, WebTypes,  
  WebLink, wbdeSource, webScan, DBTables, DB, tpStatus, wdbSSrc;

type
  TfmHTQ1Panel = class(TutParentForm)
    Table1: TTable;
    DataSource2: TDataSource;
    Query1: TQuery;
    DataSource1: TDataSource;
    WebDataSource1: TwhbdeSource;
    answergrid: TwhbdeGrid;
    CheckBox1: TCheckBox;
    tpToolBar2: TtpToolBar;
    tpStatusBar1: TtpStatusBar;
    procedure Query1AfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmHTQ1Panel: TfmHTQ1Panel;

implementation

{$R *.DFM}

uses
  ucLogFil, ucDlgs,
  webApp, whdemo_ViewSource, whdemo_Initialize;

//------------------------------------------------------------------------------

function TfmHTQ1Panel.Init:Boolean;
begin
  Result:= inherited Init;
  if not result then
    exit;
  {make sure MaxOpenDataSets is 1 because www params are used.
   23-May-2004 v2.034}
  WebDataSource1.MaxOpenDataSets := 1;
  {make sure the key field names are filled in; otherwise scrolling "next" does
   not work beyond page 2.}
  WebDataSource1.KeyFieldNames := 'MemberID;ContractID';
  {set the initial page height to 5 rows}
  answergrid.PageHeight := 5;
  {clear the border property for XHTML compliance}
  answergrid.Border := '';

  //set database directory
  with query1 do
  begin
    DatabaseName := getHtDemoDataRoot + 'whQuery1\';
    SQL.Text := 'SELECT d.MemberID, d.ContractID, d."Contact Name",d1."Name" ' +
      'FROM "Contract.db" d, "Member.db" d1 ' +
      'WHERE(d1.MemberID = d.MemberID) ' +
      'AND (d1.MemberID=:wwwMemberID) ' +
      'AND (d1.Passwd= :wwwPword ) ';
    try
      Prepare;
    except
      on e: exception do
      begin
        {in case the table becomes corrupt or some other unexpected condition
         arises... catch the error and prevent use of the components}
        HREFTestLog('ERROR', 'query1', SQL.Text + sLineBreak + e.Message);
        MsgErrorOk(e.Message);
        FreeAndNil(answergrid);
        FreeAndNil(WebDatasource1);
        FreeAndNil(DataSource1);
      end;
    end;
  end;

  //Always refresh the webactions once as the application starts.
  RefreshWebActions(fmHTQ1Panel);

end;

procedure TfmHTQ1Panel.Query1AfterOpen(DataSet: TDataSet);
begin
  inherited;
  {see the HTML for Page2 to see how this literal is used to
   conditionally bring in page sections.}
  if (DataSet.recordcount = 0) then
    pWebApp.StringVar['flagGotData'] := 'No'
  else
    pWebApp.StringVar['flagGotData'] := 'Yes';

  {use this to output the query syntax for debugging purposes}
  //Any data in the Summary property will automatically be sent at the end
  //of the page.  This is built into WebHub.  You do not need to explicitly
  //request the summary in any way.
  if checkbox1.checked then
  begin
    with pWebApp, TQuery(DataSet) do
    begin
      Summary.Add('<h2>SQL Syntax for query</h2>' );
      Summary.AddStrings(sql);
    end;
  end;
end;


end.
