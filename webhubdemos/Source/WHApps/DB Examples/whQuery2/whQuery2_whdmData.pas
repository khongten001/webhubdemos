unit whQuery2_whdmData;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

uses
  SysUtils, Classes,
  webLink, Data.Win.ADODB, wdbxSource, wdbScan, Bde.DBTables, Data.DB, wdbSSrc,
  ZaphodsMap,
  wdbSource, wbdeSource, updateOK, tpAction, webTypes, wbdeGrid;

type
  TDMQuery2 = class(TDataModule)
    grid: TwhbdeGrid;
    WebDataSource1: TwhbdeSource;
    DataSource1: TDataSource;
    Query1: TQuery;
    wdsFull: TwhbdeSource;
    DataSourceForFullTable: TDataSource;
    TableComplete: TTable;
    WebDataScan1: TwhdbScan;
    whdbxSource2: TwhdbxSource;
    DataSource2: TDataSource;
    ADOQuery1: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure gridHotField(Sender: TwhbdeGrid; AField: TField;
      var CellValue: string);
    procedure gridAfterExecute(Sender: TObject);
    procedure WebDataScan1Init(Sender: TObject);
    procedure WebDataScan1RowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
    procedure WebDataScan1Finish(Sender: TObject);
    procedure WebDataScan1EmptyDataSet(Sender: TObject);
    procedure ADOQuery1FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    ZM: TZaphodsMap;
    ZMKey: TZaphodKey;
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  protected
    procedure loadCustomSettings;
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
    procedure WebAppNewSession(Sender:TObject; Session:Integer;
      const Command:String);
  end;

var
  DMQuery2: TDMQuery2;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucCodeSiteInterface, ucPos, ucDlgs,
  whMacroAffixes, webScan, webSend, webApp, htWebApp, whdemo_ViewSource;

{ TDMQuery2 }

procedure TDMQuery2.ADOQuery1FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if posci('e', DataSet.FieldByName('Firstname').asString) > 0 then
    Accept := True // (Random(1) = 1);
  else
    Accept := False;
end;

procedure TDMQuery2.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  ZM := TZaphodsMap.Create(Self);
  ZMKey := nil;
end;

procedure TDMQuery2.DataModuleDestroy(Sender: TObject);
begin
  ZMKey := nil; // do not free this.
  FreeAndNil(ZM);
end;

procedure TDMQuery2.gridAfterExecute(Sender: TObject);
begin
  // Publish the sql code to the web, after the final page section.
  with WebDataSource1 do
    pWebApp.Summary.Add('SQL for '+DataSet.Name+' is:<BR>'
    +TQuery(dataset).sql.text);
end;

{Hot field is set by putting :HF after the field name in the
displaySet.  See WebDataSource.displayset -- or just look in the
htqry2.ini file.}
procedure TDMQuery2.gridHotField(Sender: TwhbdeGrid; AField: TField;
  var CellValue: string);
begin
  {JUMP is a built-in WebHub macro. Syntax is: JUMP|pageId,command|visiblePhrase }
  CellValue:=MacroStart + 'JUMP|detail,wdsFull.'+
     aField.DataSet.fields[0].asString+  {command (4th param on URL)}
     '|'+aField.asString+MacroEnd;  {command is passed to wdsFull which causes it to FindKey.}
end;

function TDMQuery2.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin

      { The following works when compiled with Delphi XE and run on Windows 7.
      Thanks to this web page for the documentation of the ConnectionString
      syntax:
      http://www.codemaker.co.uk/it/tips/ado_conn.htm#ODBCDriverForParadox
      Note that DefaultDir means "working directory" i.e. location of *.db
      and Dbq means "private directory" i.e. location of paradox .net file.}
      ADOQuery1.ConnectionString :=
       'Driver={Microsoft Paradox Driver (*.db )};' +
               'DriverID=538;' +
               'Fil=Paradox 5.X;' +
               'DefaultDir=d:\temp\pdoxnet\;' +
               'Dbq=D:\PROJECTS\WEBHUBDEMOS\LIVE\DATABASE\WHQUERY2\;' +
               'CollatingSequence=ASCII';

      RefreshWebActions(Self);
      if NOT grid.IsUpdated then
        ErrorText := grid.Name + ' failed to update';

      if ErrorText = '' then
      begin
        grid.SetCaptions2004;
        grid.SetButtonSpecs2012;
        grid.PageHeight := 0; // so few records, might as well show ALL.

        if NOT Assigned(ZMKey) then
        begin
          ZMKey := ZM.ActivateTempKey(ExtractFilePath(pWebApp.ConfigFilespec)
            + 'whQuery2Spec.xml', 'whQuery2Configuration');
          ZMKey.KeyedFile.LoadFile;
        end;
        loadCustomSettings;

        whdbxSource2.KeyFieldNames := 'EmpNo';
        WebDataScan1.PageHeight := 2;
        WebDataScan1.ButtonsWhere := dsBelow;
        ADOQuery1.SQL.Text := 'select * from employee';

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

procedure TDMQuery2.loadCustomSettings;
var
  S1: string;
begin
  // Set the database path...
  // Note: you may override and set this to any database path.
  S1:=getHtDemoDataRoot + 'whQuery2\';
  Query1.Databasename := S1;
  //Query2.Databasename := S1;

  TableComplete.Databasename:=S1;
  S1 := ZMKey.KeyedFile.ZNodeAttr(nil,
    ['QuerySpec/Item', '@name', 'Tablename'], cxOptional, '', 'value');
  if S1 = '' then
  begin
    msgErrorOk(ZM.KeyLastError);
    FreeAndNil(ZM);
    FreeAndNil(ZMKey);
    Exit;
  end;

  TableComplete.Tablename:=S1;
  try
    TableComplete.open;
    WebDataSource1.KeyFieldNames:= ZMKey.KeyedFile.ZNodeAttr(nil,
    ['QuerySpec/Item', '@name', 'PrimaryKeyField'], cxOptional, '', 'value');
  except on e: Exception do
    msgErrorOk( S1 + ' failed to open. Error:'+e.message );
  end;

  {do not free the map or the key}
//  FreeAndNil(ZM);
end;

procedure TDMQuery2.Query1BeforeOpen(DataSet: TDataSet);
begin
  with TQuery(Dataset) do
  begin
    sql.text:=ZMKey.KeyedFile.ZNodeAttr(nil,
      ['QuerySpec/Item', '@name', 'SQL'], cxOptional, '', 'value')
      + ' WHERE ('
      + ZMKey.KeyedFile.ZNodeAttr(nil,
      ['QuerySpec/Item', '@name', 'SearchField'], cxOptional, '', 'value')
      + ' LIKE '''+pWebApp.StringVar['FindMe']+'%'')';
  end;
end;

procedure TDMQuery2.WebAppNewSession(Sender: TObject; Session: Integer;
  const Command: String);
begin
  // note this procedure is called from the OnNewSession event in counter.pas

  // The purpose of this is to demonstrate that we can set the pageheight on
  // a per-site-visitor basis.
  // 0 gives all rows, so let's avoid that by adding 1.
  pWebApp.StringVarInt['WebDataScan1.PageHeight'] := Random(14) + 1;
end;

procedure TDMQuery2.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMQuery2.WebDataScan1EmptyDataSet(Sender: TObject);
begin
  {This is here to demonstrate what happens when the result set is empty. The
   SQL for query2 always returns an empty result set.}
  pWebApp.SendString('<tr><td>'
  +'Hey there is no data in this result set!'
  +'</td></tr>');
end;

procedure TDMQuery2.WebDataScan1Finish(Sender: TObject);
begin
  inherited;
  pWebApp.SendDroplet(WebDataScan1.HtmlParam, drAfterWhrow);
  if True then
    WebDataScan1.ButtonsWhere := dsBelow
  else
    WebDataScan1.ButtonsWhere := dsNone;
end;

procedure TDMQuery2.WebDataScan1Init(Sender: TObject);
begin
  pWebApp.SendDroplet(WebDataScan1.HtmlParam, drBeforeWhrow);
end;

procedure TDMQuery2.WebDataScan1RowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
begin
  inherited;
  pWebApp.SendString('<tr>'
  +'<td>' + TQuery(TwhbdeSource(aWebDataSource).DataSet).FieldByName('EmpNo').asString
  +'</td>'
  +'<td>' + TQuery(TwhbdeSource(aWebDataSource).DataSet).FieldByName('Firstname').asString
  +'</td>'
  +'<td>' + TQuery(TwhbdeSource(aWebDataSource).DataSet).FieldByName('Lastname').asString
  +'</td>'
  +'</tr>');
end;

end.
