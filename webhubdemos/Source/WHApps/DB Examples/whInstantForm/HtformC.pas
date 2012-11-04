unit htformc;

(*
  Copyright (c) 1999-2012 HREF Tools Corp.

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

(*
  The TwhbdeForm component is able to FINDKEY because it is working with
  a TTable.
*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, ExtCtrls, StdCtrls, DB, DBTables, DBGrids, DBCtrls,
  wbdeForm, wbdeSource, WebTypes, wdbSSrc, WebLink, WdbLink, WdbScan,
  wbdeGrid, WebMemo, webScan,
  Toolbar, {} tpCompPanel, Grids,
  TpMemo, TpTable, UpdateOk, tpAction, TxtGrid, tpStatus,
  IniLink, UTPANFRM;

type
  TfmHTFMPanel = class(TutParentForm)
    grid: TwhbdeGrid;
    WebDataSource1: TwhbdeSource;
    DataSource1: TDataSource;
    Table1: TtpTable;
    waPost: TwhWebActionEx;
    WebDataForm1: TwhbdeForm;
    tpStatusBar1: TtpStatusBar;
    tpComponentPanel2: TtpComponentPanel;
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    DBNavigator2: TDBNavigator;
    procedure gridHotField(Sender: TwhbdeGrid; aField: TField; var s: string);
    procedure gridExecute(Sender: TObject);
    procedure waPostExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmHTFMPanel: TfmHTFMPanel;

implementation

{$R *.DFM}

uses
  webapp, // RefreshWebActions
  whMacroAffixes, // MacroStart, MacroEnd
  whdemo_ViewSource, // getHtDemoDataRoot
  ucString; // IsEqual function

const
  keyField = 'partno'; // keep lowercase

function TfmHTFMPanel.Init: Boolean;
begin
  Result := inherited Init;
  if not Result then
    exit;
  grid.WebDataSource := WebDataSource1;
  WebDataSource1.DataSource := DataSource1;
  DataSource1.DataSet := Table1;
  grid.Border := '';

  with Table1 do
  begin
    DatabaseName := getHtDemoDataRoot + 'whInstantForm\';
    Tablename := 'parts.db';
  end;

  RefreshWebActions(fmHTFMPanel);

  grid.SetCaptions2004;
  grid.SetButtonSpecs2012;
end;

procedure TfmHTFMPanel.gridHotField(Sender: TwhbdeGrid; aField: TField;
  var s: string);
begin
  inherited;
  if CompareText(aField.FieldName, keyField) = 0 then
  begin
    { enable View and Edit with InstantForm }
    s := aField.DataSet.fieldByName(keyField).asString;

    s := MacroStart + 'JUMP|ViewDetail,WebDataForm1.View.' + s + '|' +
      MacroStart + 'mcBlueDot' + MacroEnd + MacroEnd + MacroStart +
      'JUMP|EditDetail,WebDataForm1.Edit.' + s + '|' + MacroStart + 'mcBlackDot'
      + MacroEnd + MacroEnd + ' ' + s;
  end;
end;

procedure TfmHTFMPanel.gridExecute(Sender: TObject);
begin
  inherited;
  with TwhbdeGrid(Sender) do
  begin
    if CompareText(HtmlParam, 'bOn') = 0 then
    begin
      grid.buttonsWhere := dsBelow;
      HtmlParam := '';
    end
    else if CompareText(HtmlParam, 'bOff') = 0 then
    begin
      grid.buttonsWhere := dsNone;
      HtmlParam := '';
    end;

    with WebDataSource.DataSet do
      webapp.SendString('This table has ' + IntToStr(RecordCount) +
        ' records.<br /><br />');
  end;
end;

// This action component takes care of posting the data from DBFIELDS array
// to the current record.  The correct record has already been located by
// this point, due to the %=webdatasource1.execute=% call.  A side effect
// of executing the TwhbdeSource is that it will locate based on the KEYS
// property.
procedure TfmHTFMPanel.waPostExecute(Sender: TObject);
var
  a1: string;
  aCurrentDisplaySet: string;
begin
  inherited;
  with Table1, TwhWebActionEx(Sender).webapp do
  begin
    a1 := fieldByName('PartNo').asString;
    Table1.Edit;
    aCurrentDisplaySet := WebDataSource1.displaySet;
    with Request.dbFields do
    begin
      fieldByName('PartNo').asString := Values['WebDataSource1.PartNo@' + a1];
      fieldByName('Description').asString :=
        Values['WebDataSource1.Description@' + a1];
      fieldByName('VendorNo').asString :=
        Values['WebDataSource1.VendorNo@' + a1];
      if IsEqual(aCurrentDisplaySet, 'MoreFields') or
        IsEqual(aCurrentDisplaySet, 'All') then
      begin
        // use JustFloat to strip out the currency $ symbol from the data.
        fieldByName('ListPrice').asString :=
          JustFloat(Values['WebDataSource1.ListPrice@' + a1]);
      end;
      if IsEqual(aCurrentDisplaySet, 'All') then
      begin
        fieldByName('Cost').asString :=
          JustFloat(Values['WebDataSource1.Cost@' + a1]);
        fieldByName('OnHand').asString := Values['WebDataSource1.OnHand@' + a1];
        fieldByName('OnOrder').asString :=
          Values['WebDataSource1.OnOrder@' + a1];
      end;
    end;

    try
      post;
    except
      on E: Exception do
      begin
        // This occurs when surfer tries to change the Part Number.
        cancel;
        with TwhWebActionEx(Sender).Response do
        begin
          SendLine('<b>Error when attempting to post record:</b> ' + E.message);
          SendLine('<p>You may not change the Part Number or Vendor Number fields ');
          SendLine('due to referential integrity rules on the PARTS table.');
          SendLine('Your changes have been cancelled.<hr>| ' + MacroStart +
            'JUMP|HOMEPAGE|Home' + MacroStart + ' |');
          Close; // Stop the page immediately.  This prevents the PAGE macro from
          // bouncing the surfer to the homepage where they would not see the message.
        end;
      end;
    end;
  end;
end;

end.
