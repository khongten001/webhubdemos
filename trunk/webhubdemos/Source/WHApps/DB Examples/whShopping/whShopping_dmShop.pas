unit whShopping_dmShop;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this file *)

interface

uses
  SysUtils, Classes, ADODB, Data.DB,
  updateOK, tpAction,
  webLink, wdbLink, wdbScan, wbdeGrid, webTypes, wdbSSrc, wbdeSource;

type
  TDMShop1 = class(TDataModule)
    WebDataSource1: TwhbdeSource;
    WebDataGrid1: TwhbdeGrid;
    DataSource1: TDataSource;
    WebActionOrderList: TwhWebActionEx;
    WebActionPostLit: TwhWebActionEx;
    waScrollGrid: TwhWebActionEx;
    ADOConnectionShop1: TADOConnection;
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
    //ADOConnectionShop1: TADOConnection;
    TableShop1: TADOTable;
    Table1Qty: TSmallintField;
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
  ActiveX, // CoInitialize
  ucString, ucCodeSiteInterface,
  webApp, htWebApp, webScan,
  whdemo_ViewSource;

{ TDMShop1 }

procedure TDMShop1.DataModuleCreate(Sender: TObject);
const cFn = 'DataModuleCreate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  FlagInitDone := False;
  {ADOConnectionShop1 := TADOConnection(Self);
  ADOConnectionShop1.Name := 'ADOConnectionShop1';}
  ADOConnectionShop1.LoginPrompt := False;

  TableShop1 := TADOTable.Create(Self);
  TableShop1.Name := 'TableShop1';

  (*
  Table1PartNo := TFloatField.Create(Self);
  Table1PartNo.Name := 'Table1PartNo';
  Table1PartNo.DataSet := Table1;

  Table1VendorNo := TFloatField.Create(Self);
  Table1VendorNo.Name := 'Table1VendorNo';
  Table1VendorNo.DataSet := Table1;

  Table1Description := TStringField.Create(Self);
  Table1Description.Name := 'Table1Description';
  Table1Description.DataSet := Table1;

  Table1OnHand := TFloatField.Create(Self);
  Table1OnHand.Name := 'Table1OnHand';
  Table1OnHand.DataSet := Table1;

  Table1OnOrder := TFloatField.Create(Self);
  Table1OnOrder.Name := 'Table1OnOrder';
  Table1OnOrder.DataSet := Table1;
  *)
//    Table1Cost: TCurrencyField;
//    Table1ListPrice: TCurrencyField;
  Table1Qty := TSmallintField.Create(Self);
  Table1Qty.Name := 'Table1Qty';
  Table1Qty.OnGetText := Table1QtyGetText;

  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMShop1.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(TableShop1);
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

    ADOConnectionShop1.Provider := 'Microsoft.Jet.OLEDB.4.0';
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
      TableShop1.Connection := ADOConnectionShop1;
      TableShop1.TableName := 'Parts';
      DataSource1.DataSet := TableShop1;
      Table1Qty.DataSet := TableShop1;
      Table1Qty.Calculated := True;
      Table1Qty.Visible := True;

      WebDataGrid1.DataScanOptions := [dsbFirst, dsbPrior, dsbNext, dsbLast,
        dsbCheckBoxes, dsbInputFields];
      WebDataGrid1.ControlsWhere := dsNone;
      WebDataGrid1.ButtonsWhere := dsAbove;

      RefreshWebActions(Self);
    end;

  { Other required settings:
    TwhbdeGrid
    datascanoptions        all set to true, except refresh and checkboxes
    buttonsWhere           above
    controlsWhere          none

    TwhbdeSource
    maxOpenDataSets        1 (no cloning)
    displaySets            defined in .ini file

    TTable
    add fields using Delphi field editor
    add calculated field called Qty, type integer
  }

    // helpful to know that WebAppUpdate will be called whenever the
    // WebHub app is refreshed.
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

{ To see what webhub is doing with your data, add (~chDebugInfo~) to the
  bottom of the homepage and/or confirm pages.  That will display some
  essential arrays: Request.dbFields, Request.FormLiterals and Session.StringVars.

  The data entered by the surfer into the webdatagrid is posted to the
  dbFields array.  We need to jump in and copy that to the StringVars array,
  because dbFields is cleared at the end of the page.  Since we don't have
  a real table to post to, we are using the StringVars array as temporary
  storage.  (Yes, you could add a temporary order table and post Qty there.)
}
procedure TDMShop1.WebActionPostLitExecute(Sender: TObject);
var
  a1, a2: string;
  i: integer;
begin
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
end;

{ ------------------------------------------------------------------------- }

{ Illusion central:
  Make the table act multi-surfer by defining the calculated field as equal to
  the current surfer's StringVars. }
procedure TDMShop1.Table1QtyGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := pWebApp.StringVar['webdatasource1.Qty@' + Sender.DataSet.FieldByName
    ('PartNo').asString];
end;


{ Fill a stringlist with the current order.
  Loop thru the StringVars[] array looking for items with @ which come from the
  data entry session. }
procedure TDMShop1.getOrderList(sList: TStringList);
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
end;

{ ------------------------------------------------------------------------- }

{ this is one way to echo the current order. }
procedure TDMShop1.WebActionOrderListExecute(Sender: TObject);
var
  sList: TStringList;
begin
  sList := nil;
  try
    sList := TStringList.create;
    getOrderList(sList);
    // send out the order, with a <BR> at end of each line
    TwhWebActionEx(Sender).WebApp.Response.SendStringListBR(sList);
  finally
    FreeAndNil(sList);
  end;
end;

procedure TDMShop1.waScrollGridExecute(Sender: TObject);
var
  a1, a2: string;
begin
  inherited;
  with TwhWebActionEx(Sender).WebApp do
  begin
    SplitString(StringVar['BtnShop'], ' ', a1, a2); // e.g. Next Page
    if a1 = 'Save' then
      a1 := 'This'; // save but do not scroll anywhere.
    WebDataGrid1.Command := a1;
    // Make the grid scroll by setting its command, e.g. Next
  end;
end;


initialization
//  CoInitialize(nil);  // ADO / COM

end.
