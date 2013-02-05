unit whShopping_dmShop;

(*
  Copyright (c) 2012 HREF Tools Corp.

  Permission is hereby granted, on 28-Nov-2012, free of charge, to any person
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
  SysUtils, Classes, ADODB, Data.DB,
  updateOK, tpAction,
  webLink, webTypes, wdbLink, wdbScan, wdbGrid, wbdeGrid{bde}, wdbSSrc, wbdeSource;

type
  TDMShop1 = class(TDataModule)
    WebDataGrid1: TwhbdeGrid;
    DataSource1: TDataSource;
    WebActionOrderList: TwhWebActionEx;
    WebActionPostLit: TwhWebActionEx;
    waScrollGrid: TwhWebActionEx;
    ADOConnectionShop1: TADOConnection;
    ADOTable1: TADOTable;
    ADOTable1PartNo: TFloatField;
    ADOTable1VendorNo: TFloatField;
    ADOTable1Description: TWideStringField;
    ADOTable1OnHand: TFloatField;
    ADOTable1OnOrder: TFloatField;
    ADOTable1Cost: TFloatField;
    ADOTable1ListPrice: TFloatField;
    ADOTable1QTY: TSmallintField;
    WebDataSource1: TwhbdeSource;
    procedure Table1QtyGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure WebActionPostLitExecute(Sender: TObject);
    procedure WebActionOrderListExecute(Sender: TObject);
    procedure waScrollGridExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    function CreateTableDefinition(out ErrorText: string): Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    procedure getOrderList(sList: TStringList);
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMShop1: TDMShop1;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucString, ucCodeSiteInterface,
  webApp, htWebApp, webScan,
  whdemo_ViewSource;

{ TDMShop1 }

function TDMShop1.CreateTableDefinition(out ErrorText: string): Boolean;
const cFn = 'CreateTableDefinition';
var
  fld: TField;
  {$IFDEF CodeSite}i: Integer;{$ENDIF}
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';

  try

    ADOTable1PartNo.Alignment := taLeftJustify;
    ADOTable1PartNo.DisplayFormat := 'PN-00000';
    ADOTable1Qty.OnGetText := Table1QtyGetText;

    {Table1VendorNo := TFloatField.Create(Self);
    Table1VendorNo.Name := 'Table1VendorNo';
    Table1VendorNo.DataSet := Table1;

    Table1Description := TStringField.Create(Self);
    Table1Description.Name := 'Table1Description';
    Table1Description.FieldName := 'Description';

    Table1OnHand := TFloatField.Create(Self);
    Table1OnHand.Name := 'Table1OnHand';
    Table1OnHand.FieldName := 'OnHand';

    Table1OnOrder := TFloatField.Create(Self);
    Table1OnOrder.Name := 'Table1OnOrder';
    Table1OnOrder.FieldName := 'OnOrder';

    Table1Cost: TCurrencyField;
    Table1ListPrice: TCurrencyField;}

    DataSource1.DataSet.Open;
    CSSend('DataSource1.DataSet.FieldCount', S(DataSource1.DataSet.FieldCount));
    {$IFDEF CodeSite}
    for I := 0 to Pred(DataSource1.DataSet.FieldCount) do
    begin
      fld := DataSource1.DataSet.Fields[i];
      CSSend(S(I), fld.FieldName);
    end;
    {$ENDIF}

    (*Table1Qty := TSmallintField.Create(TableShop1);
    Table1Qty.Name := 'TableShop1QTY';
    Table1Qty.FieldKind := fkCalculated;
    Table1Qty.FieldName := 'QTY';
    Table1Qty.Calculated := True;
    //Table1Qty.OnGetText := Table1QtyGetText;
    CSSend('TableShop1 FieldCount', S(TableShop1.FieldCount));*)

    fld := DataSource1.DataSet.FieldByName('QTY');
    Result := Assigned(fld);

  except
    on E: Exception do
    begin
      ErrorText := E.Message;
      Result := False;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMShop1.DataModuleCreate(Sender: TObject);
const cFn = 'DataModuleCreate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  FlagInitDone := False;
  {ADOConnectionShop1 := TADOConnection(Self);
  ADOConnectionShop1.Name := 'ADOConnectionShop1';}
  ADOConnectionShop1.LoginPrompt := False;

  //TableShop1 := TADOTable.Create(Self);
  //TableShop1.Name := 'TableShop1';

  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMShop1.DataModuleDestroy(Sender: TObject);
begin
  //FreeAndNil(TableShop1);
  //FreeAndNil(ADOConnectionShop1);
end;

function TDMShop1.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
var
  s1: string;
  FlagFwd: Boolean;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  Result := FlagInitDone;

  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin
    FlagFwd := True;

    ADOConnectionShop1.Connected := False;
    ADOConnectionShop1.Provider := 'Microsoft.Jet.OLEDB.4.0';
    ADOConnectionShop1.Mode := cmShareDenyNone;
    s1 := getHtDemoDataRoot;
    s1 := Uppercase(Copy(getHtDemoDataRoot, 1, 1)) +
      Copy(getHtDemoDataRoot, 2, MaxInt);  // D: not d:
    s1 := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
        'Data Source=' + S1 + 'whShopping\dbdemos.mdb' +
        ';Persist Security Info=False';
    CSSend('S1', S1);
    ADOConnectionShop1.ConnectionString := s1;
    try
      ADOConnectionShop1.Connected := True;
    except
      on E: Exception do
      begin
        LogSendException(E);
        ErrorText := E.Message;
        FlagFwd := False;
      end;
    end;
    if FlagFwd then
    begin
      {TableShop1.Connection := ADOConnectionShop1;
      TableShop1.TableName := 'Parts';
      DataSource1.DataSet := TableShop1;}
      DataSource1.DataSet := ADOTable1;

      FlagFwd := CreateTableDefinition(ErrorText);
    end;

    if FlagFwd then
    begin
      WebDataGrid1.DataScanOptions := [dsbFirst, dsbPrior, dsbNext, dsbLast,
        dsbCheckBoxes, dsbInputFields];
      WebDataGrid1.ControlsWhere := dsNone;
      WebDataGrid1.ButtonsWhere := dsNone;
      WebDataSource1.KeyFieldNames := 'PartNo';
      WebDataSource1.ValidateConfig := True;

      RefreshWebActions(Self);
    end;

  { Other required settings:
    TwhbdeGrid
    datascanoptions        all set to true, except refresh and checkboxes
    buttonsWhere           above
    controlsWhere          none

    TwhbdeSource
    maxOpenDataSets        1 or more
    displaySets            defined in application-level config file

    TTable
    add fields using Delphi field editor
    add calculated field called Qty, type short integer
  }

    if FlagFwd then
    begin
      AddAppUpdateHandler(WebAppUpdate);
      FlagInitDone := WebDataGrid1.IsUpdated;;
      Result := FlagInitDone;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMShop1.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

{ To see what webhub is doing with your data, add (~stringvars~) to the
  bottom of the homepage and/or confirm pages.  That will display some
  essential arrays: Request.dbFields, Request.FormLiterals and Session.StringVars.

  The data entered by the surfer into the webdatagrid is posted to the
  dbFields array.  We need to jump in and copy that to the StringVars array,
  because dbFields is cleared at the end of the page.  Since we don't have
  a real table to post to, we are using the StringVars array as temporary
  storage.  (Yes, you could add a temporary order table and post Qty there.)
}
procedure TDMShop1.WebActionPostLitExecute(Sender: TObject);
const cFn = 'WebActionPostLitExecute';
var
  a1, a2: string;
  i: integer;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // WebDataSource1.Qty@1316=35
  with TwhWebActionEx(Sender).WebApp do
  begin
    for i := 0 to pred(Request.dbFields.count) do
    begin
      SplitString(Request.dbFields[i], '=', a1, a2);
      if a2 <> '' then
        StringVar[a1] := a2; { post single entry to StringVars array }
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

{ ------------------------------------------------------------------------- }

{ Illusion central:
  Make the table act multi-surfer by defining the calculated field as equal to
  the current surfer's StringVars. }
procedure TDMShop1.Table1QtyGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
const cFn = 'Table1QtyGetText';
begin
  Text := pWebApp.StringVar['webdatasource1.Qty@' + Sender.DataSet.FieldByName
    ('PartNo').asString];
  CSSend(cFn + ' Text', Text);
end;


{ Fill a stringlist with the current order.
  Loop thru the StringVars[] array looking for items with @ which come from the
  data entry session. }
procedure TDMShop1.getOrderList(sList: TStringList);
const cFn = 'getOrderList';
var
  a1, a2: string;
  i: integer;
begin
  sList.clear;
  with pWebApp.Session do
  begin
    for i := 0 to pred(StringVars.count) do
    begin
      a1 := LeftOfEqual(StringVars[i]);
      if pos('@', a1) > 0 then
      begin
        // WebDataSource1.Qty@1316=35
        SplitString(StringVars[i], '=', a1, a2);
        // SplitString is in the ucString unit
        sList.add('Qty ' + a2 + ' of Product #' + RightOf('@', a1));
      end;
    end;
  end;
  CSSend(cFn, S(sList));
end;

{ ------------------------------------------------------------------------- }

{ this is one way to echo the current order. }
procedure TDMShop1.WebActionOrderListExecute(Sender: TObject);
const cFn = 'WebActionOrderListExecute';
var
  sList: TStringList;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  sList := nil;
  try
    sList := TStringList.create;
    getOrderList(sList);
    // send out the order, with a <BR> at end of each line
    TwhWebActionEx(Sender).WebApp.Response.SendStringListBR(sList);
  finally
    FreeAndNil(sList);
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMShop1.waScrollGridExecute(Sender: TObject);
const cFn = 'waScrollGridExecute';
var
  a1, a2: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  with TwhWebActionEx(Sender).WebApp do
  begin
    if SplitString(StringVar['BtnShop'], ' ', a1, a2) then // e.g. Next Page
    begin
      if a1 = 'Save' then
        a1 := 'This'; // save but do not scroll anywhere.
      CSSend('a1', a1);
      WebDataGrid1.Command := a1;
      // Make the grid scroll by setting its command, e.g. Next
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
