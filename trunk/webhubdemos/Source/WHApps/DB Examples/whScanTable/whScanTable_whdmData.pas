unit whScanTable_whdmData;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this file *)

interface

uses
  SysUtils, Classes,
  webLink, wdbScan, Data.DB, Datasnap.DBClient, SimpleDS, updateOK, tpAction,
  webTypes, wdbSSrc, wdbxSource;

type
  TDMData = class(TDataModule)
    wdsDBX: TwhdbxSource;
    sdsScanDemo: TSimpleDataSet;
    DataSource1: TDataSource;
    BrowseScan: TwhdbScan;
    procedure BrowseScanFinish(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure BrowseScanInit(Sender: TObject);
    procedure BrowseScanRowStart(Sender: TwhdbScanBase;
      aWebDataSource: TwhdbSourceBase; var ok: Boolean);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMData: TDMData;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  {Reference http://www.codenewsfast.com/cnf/article/0/waArticleBookmark.7311195
   Exception "unknown driver Firebird" exception is raised if DBXFirebird unit
   omitted from uses clause. }
  DBXFirebird,
  MultiTypeApp,
  ucIbAndFbCredentials, ucCodeSiteInterface,
  htWebApp,
  webApp,    // global pointer pWebApp is in this unit
  webSend,   // declaration of drBeforeTag
  webScan,
  whdemo_ViewSource,  // getHtDemoDataRoot is in this unit.
  wdbSource,
  ucDlgs;  // ucDlgs is part of TPack. msgErrorOk is in this unit.

{ TDMData }

procedure TDMData.BrowseScanFinish(Sender: TObject);
var
  aDropletName: String;
begin
  inherited;
  with TwhdbScan(Sender) do
  begin
    aDropletName := HtmlParam;
    WebApp.SendDroplet(aDropletName, drAfterWhrow);
  end;

end;

procedure TDMData.BrowseScanInit(Sender: TObject);
var
  aDropletName: String;
begin
  inherited;
  { This technique of sending droplets is webmaster-friendly.
    The parameter to the BrowseScan component (e.g. browsescan.execute|drTest)
    provides the name of the droplet whose contents are to be used for
    formatting. }
  with TwhdbScan(Sender) do
  begin
    aDropletName := HtmlParam;
    WebApp.SendDroplet(aDropletName, drBeforeWhrow);
  end;
end;

procedure TDMData.BrowseScanRowStart(Sender: TwhdbScanBase;
  aWebDataSource: TwhdbSourceBase; var ok: Boolean);
var
  aDropletName: String;
begin
  inherited;
  with TwhdbScan(Sender) do
  begin
    // This literal flows into a DYNCHUNK in the HTML. It is used to color code
    // the rows based on file type (PNG, JPG, etc.)
    if TwhdbSource(aWebDataSource).DataSet is TDataSet then
      with TwhdbSource(aWebDataSource).DataSet do
        WebApp.StringVar['litExt'] := FieldByName('FileExt').asString;

    aDropletName := HtmlParam;
    WebApp.SendDroplet(aDropletName, drWithinWhrow);
  end;
end;

procedure TDMData.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMData.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
var
  DBName, DBUser, DBPass: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin

      { Reference restore-whScanTable-to-FirebirdSQL.bat for making yourself a
        local copy of the little graphics database for this demo. }

      sdsScanDemo.Close;  // in case it was left open in the DFM
      ZMLookup_Firebird_Credentials('WebHubDemo-scan', DBName, DBUser, DBPass);
      Assert(DBName <> '', 'blank DBName after ZMLookup');
      CSSend('DBName', DBName);
      CSSend('DBUser', DBUser);
      CSSend('DBPass', DBPass);
      sdsScanDemo.Connection.Params.Values['Database'] := DBName;
      sdsScanDemo.Connection.Params.Values['UserName'] := DBUser;
      sdsScanDemo.Connection.Params.Values['Password'] := DBPass;
      sdsScanDemo.Connection.Params.Values['ServerCharSet'] := 'UTF8';

      with wdsDBX do
      begin
        DataSource := DataSource1;
        UsingIndexFieldNames := True;
        KeyFieldNames := 'FileID';
        Name := 'wdsDBX';
      end;

      { Note. The PageHeight is set to 3 initially, just so that the grid is not
        too large/slow for downloaders on overseas connections. 7-Jun-1998. }
      BrowseScan.PageHeight := 3;
      BrowseScan.ControlsWhere := dsNone;
      BrowseScan.ButtonsWhere := dsNone;

      try
        sdsScanDemo.Open;
        RefreshWebActions(Self);
        AddAppUpdateHandler(WebAppUpdate);
        FlagInitDone := True;
      except
        on E: Exception do
        begin
          LogSendException(E, cFn);
          ErrorText := E.Message;
        end;
      end;
    end;
  end;
  Result := FlagInitDone;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMData.WebAppUpdate(Sender: TObject);
begin
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
end;

end.
