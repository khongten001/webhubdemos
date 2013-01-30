unit whInstantForm_whdmData;

(*
Copyright (c) 1999-2013 HREF Tools Corp.

Permission is hereby granted, on 29-Jan-2013, free of charge, to any person
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
  SysUtils, Classes, Data.DB, Datasnap.DBClient,
  updateOK, tpAction,
  webLink, wdbSSrc, wdbSource, wbdeSource, wdbForm, wdbScan, wbdeGrid, webTypes;

type
  TDMParts = class(TDataModule)
    waPost: TwhWebActionEx;
    grid: TwhbdeGrid;
    WebDataForm1: TwhdbForm;
    WebDataSource1: TwhbdeSource;
    DataSource1: TDataSource;
    Table1: TClientDataSet;
    procedure DataModuleCreate(Sender: TObject);
    procedure gridHotField(Sender: TwhbdeGrid; AField: TField;
      var CellValue: string);
    procedure gridExecute(Sender: TObject);
    procedure waPostExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMParts: TDMParts;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucCodeSiteInterface, ucString,
  webApp, webScan, htWebApp, whMacroAffixes, whdemo_ViewSource;

{ TDMParts }

const
  keyField = 'partno'; // keep lowercase

procedure TDMParts.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  Table1.FileName := getHtDemoDataRoot + 'embSample\' + 'parts.xml';
end;

procedure TDMParts.gridExecute(Sender: TObject);
begin
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

    with WebDataSourceBDE.DataSet do
      webapp.SendString('This table has ' + IntToStr(RecordCount) +
        ' records.<br /><br />');
  end;
end;

procedure TDMParts.gridHotField(Sender: TwhbdeGrid; AField: TField;
  var CellValue: string);
begin
  inherited;
  if CompareText(aField.FieldName, keyField) = 0 then
  begin
    { enable View and Edit with InstantForm }
    CellValue := aField.DataSet.fieldByName(keyField).asString;

    CellValue := MacroStart + 'JUMP|ViewDetail,WebDataForm1.View.' + CellValue +
      '|' +
      MacroStart + 'mcBlueDot' + MacroEnd + MacroEnd + MacroStart +
      'JUMP|EditDetail,WebDataForm1.Edit.' + CellValue + '|' + MacroStart +
      'mcBlackDot'
      + MacroEnd + MacroEnd + ' ' + CellValue;
  end;
end;

function TDMParts.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin

      WebDataForm1.WebDataSource := WebDataSource1;
      grid.WebDataSource := WebDataSource1;
      WebDataSource1.DataSource := DataSource1;
      WebDataSource1.KeyFieldNames := 'PartNo';
      DataSource1.DataSet := Table1;
      grid.Border := '';

      try
        Table1.Open;
      except
        on E: Exception do
        begin
          LogSendException(E, cFn);
          ErrorText := E.Message;
        end;
      end;

      if ErrorText = '' then
        RefreshWebActions(Self);

      if NOT webDataSource1.IsUpdated then
        ErrorText := webDataSource1.ClassName + ' ' + webDataSource1.Name +
          ' unable to update';
      if NOT grid.IsUpdated then
        ErrorText := grid.ClassName + ' ' + grid.Name + ' unable to update';
      if NOT webDataForm1.IsUpdated then
        ErrorText := webDataForm1.ClassName + ' ' + webDataForm1.Name +
          ' unable to update';

      if ErrorText = '' then
      begin

        grid.SetCaptions2004;
        grid.SetButtonSpecs2012;

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

procedure TDMParts.waPostExecute(Sender: TObject);
// This action component takes care of posting the data from DBFIELDS array
// to the current record.  The correct record has already been located by
// this point, due to the %=webdatasource1.execute=% call.  A side effect
// of executing the TwhbdeSource is that it will locate based on the KEYS
// property.
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


procedure TDMParts.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
