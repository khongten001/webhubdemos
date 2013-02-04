unit whClone_dmwhGridsNScans;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

uses
  SysUtils, Classes,
  webLink, wbdeGrid, updateOK, tpAction, webTypes, wdbScan, wdbSource, wdbSSrc;

type
  TDMGridsNScans = class(TDataModule)
    Scan1: TwhdbScan;
    Scan2: TwhdbScan;
    WebDataGrid1: TwhbdeGrid;
    ScanXML: TwhdbScan;
    gridxml: TwhbdeGrid;
    procedure DataModuleCreate(Sender: TObject);
    procedure ScanOnExecutePageHeader(Sender: TObject);
    procedure ScanInit(Sender: TObject);
    procedure ScanFinish(Sender: TObject);
    procedure ScanRowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure ScanAfterExecute(Sender: TObject);
    procedure WebDataGrid1AfterExecute(Sender: TObject);
    procedure WebDataGrid1Execute(Sender: TObject);
    procedure ScanXMLEmptyDataSet(Sender: TObject);
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
  DMGridsNScans: TDMGridsNScans;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  Data.DB, TypInfo,
  ucCodeSiteInterface,
  webApp, htWebApp, wbdeSource, webScan,
  whClone_dmwhData;

{ TDMGridsNScans }

procedure TDMGridsNScans.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMGridsNScans.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      Scan1.DirectCallOk := True;
      Scan1.OnExecute := nil; // when controlled from the form
      Scan1.OnExecute := ScanOnExecutePageHeader;
      scan1.WebDataSource := DMData2Clone.WebDataSource1;
      scan1.OnRowStart := ScanRowStart;

      Scan2.DirectCallOk := True;
      Scan2.OnExecute := nil; // when controlled from the form
      Scan2.OnExecute := ScanOnExecutePageHeader;
      scan2.WebDataSource := DMData2Clone.WebDataSource2;
      scan2.OnRowStart := ScanRowStart;
      Scan2.ControlsWhere := dsBelow;

      WebDataGrid1.DirectCallOk := True;
      WebDataGrid1.WebDataSource := DMData2Clone.WebDataSource1;

      ScanXml.DirectCallOk := True;
      ScanXML.WebDataSource := DMData2Clone.whdbxSourceXML;

      // Call RefreshWebActions here only if it is not called within a TtpProject event
      RefreshWebActions(Self);

      if NOT ScanXML.IsUpdated then
        ErrorText := 'ScanXML would not update';

      if (ErrorText = '') then
      begin
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
//------------------------------------------------------------------------------
//both datascan components deliver roughly the same look and here's the code
//shared by both:

procedure TDMGridsNScans.PageFooter;
begin
  pWebApp.SendMacro('drPageFooterHTCL');
end;

procedure TDMGridsNScans.PageHeader;
begin
  pWebApp.SendMacro('drPageHeaderHTCL');
end;

procedure TDMGridsNScans.ScanAfterExecute(Sender: TObject);
begin
  PageFooter;
end;

procedure TDMGridsNScans.ScanFinish(Sender: TObject);
begin
  TableFooter;
end;

procedure TDMGridsNScans.ScanInit(Sender: TObject);
var
  i: Integer;
begin
  TableHeader(Sender);
  (*if Sender = scan1 then
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
  begin*)
    writeln(
       '<tr>'
      +'<th>DataSet Name</th>');
    with TwhbdeSource(TwhdbScan(Sender).WebDataSource) do
    for i := 0 to Pred(DataSet.FieldCount) do
    begin
      if (DataSet.Fields[i].DataType in
        [ftDate, ftDateTime, ftSmallint, ftInteger, ftFloat, ftString]) then
        WriteLn('<th>' + DataSet.Fields[i].FieldName + '</th>')
      else
        pWebApp.Response.SendComment(DataSet.Fields[i].FieldName + ' is ' +
          GetEnumName(TypeInfo(TFieldType), Ord(DataSet.Fields[i].DataType)));
    end;
    WriteLn('</tr>');
  //end;
  //end;
end;

procedure TDMGridsNScans.ScanRowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
var
  i: Integer;
begin
  writeln(
   '<tr>'
  +'  <td>'
  //  <- notice reference to table2
  +TwhbdeSource(aWebDataSource).DataSet.Name +
  //DMData2Clone.Table2.Name+
  '</td>');
  //      when this runs, that pointer (Table2.RecNo)
  //      and all the field pointers (such as Table2SpeciesNo
  //      will point to the clones!
  with TwhbdeSource(aWebDataSource) do
  for i := 0 to Pred(DataSet.FieldCount) do
  begin
    if (DataSet.Fields[i].DataType in
      [ftDate, ftDateTime, ftSmallint, ftInteger, ftFloat, ftString]) then
      WriteLn('  <td>' + DataSet.Fields[i].AsString + '</td>');
  end;
  WriteLn('</tr>');
end;

procedure TDMGridsNScans.ScanXMLEmptyDataSet(Sender: TObject);
begin
  pWebApp.Response.Send('empty dataset');
end;

procedure TDMGridsNScans.ScanOnExecutePageHeader(Sender: TObject);
begin
  PageHeader;
end;

procedure TDMGridsNScans.TableFooter;
begin
  writeln('</table>');
end;

procedure TDMGridsNScans.TableHeader(Sender: TObject);
const cCSSSuffix = '-table';
var
  s1: string;
begin
  pWebApp.SendStringImm('<h1>' + TwhWebAction(Sender).Name + '</h1>');
  if Sender is TwhdbScan then
    pWebApp.SendStringImm('<h2>DataSet.Owner is ' +
      TwhdbScan(Sender).WebDataSource.Name + '</h2>');
  s1 := TwhWebAction(Sender).Family;
  pWebApp.SendString('<table id="' + Self.Name + cCSSSuffix + '" class="' +
    S1 + cCSSSuffix + '">');
  pWebApp.Response.SendComment('KeyFields = ' +
    TwhdbScan(Sender).WebDataSource.KeyFields);
  pWebApp.Response.SendComment('KeyFieldNames = ' +
    TwhdbScan(Sender).WebDataSource.KeyFieldNames);
end;

procedure TDMGridsNScans.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMGridsNScans.WebDataGrid1AfterExecute(Sender: TObject);
begin
  PageFooter;
end;

//------------------------------------------------------------------------------
//this code is used by both webdatasources as they both demonstrate using
//pre-instantiated fields:

procedure TDMGridsNScans.WebDataGrid1Execute(Sender: TObject);
begin
  PageHeader;
end;

end.
