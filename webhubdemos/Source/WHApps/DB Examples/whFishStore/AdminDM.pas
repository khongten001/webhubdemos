unit admindm;

// Administration = Data entry.

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, DB, Datasnap.DBClient,
  tpTable, updateOk, tpAction,
  webTypes, webLink, wdbScan, webScan, wbdeGrid, webPage, webPHub,
  wdbSSrc, wdbSource, wbdeSource, wdbLink;

type
  TDataModuleAdmin = class(TDataModule)
    gfAdmin: TwhbdeGrid;
    wdsAdmin: TwhbdeSource;
    DataSourceFishCost: TDataSource;
    waSaveCurrentFish: TwhWebActionEx;
    TableFishCost: TClientDataSet;
    procedure TableFishCostBeforePost(DataSet: TDataSet);
    procedure gfAdminHotField(Sender: TwhbdeGrid; aField: TField;
      var s: string);
    procedure HTFS_ADMINSection(Sender: TObject; Section: Integer;
      var Chunk, Options: string);
    procedure waSaveCurrentFishExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  published
    HTFS_ADMIN: TwhPage;
  end;

var
  DataModuleAdmin: TDataModuleAdmin;

implementation

uses
  ucString, ucCodeSiteInterface,
  webApp, whMacroAffixes,
  whdemo_ViewSource,
  whFishStore_fmWhPanel, tFish, whFireStore_dmwhBiolife;

{$R *.DFM}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

function TDataModuleAdmin.Init(out ErrorText: string): Boolean;
const cFn = 'initDB';
begin
  ErrorText := '';
  gfAdmin.WebDataSource := wdsAdmin;

  with TableFishCost do
  begin
    if Active then Close;
    FileName := getHtDemoDataRoot + 'whFishStore\' + 'fishcost.xml';
    try
      Active := True;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        LogSendException(E, cFn);
      end;
    end;
  end;

  if ErrorText = '' then
  begin
    RefreshWebActions(Self);

    {set up some captions and button specs that are easily styled}
    if gfAdmin.IsUpdated then
    begin
      gfAdmin.SetCaptions2004;
      gfAdmin.SetButtonSpecs2012;
    end;
  end;
  Result := ErrorText = '';
end;

{------------------------------------------------------------------------------}

procedure TDataModuleAdmin.TableFishCostBeforePost(DataSet: TDataSet);
begin
  with TableFishCost do
  begin
    if (FieldByName('Password').AsString<>'') and
       (pWebApp.StringVar['Password']<>FieldByName('Password').AsString) then
    begin
      DataSet.cancel;
      with pWebApp.Response do
      begin
        SendHdr('2','Invalid Password');
        Send( 'Please try again. ' + MacroStart + 'JUMP|admin|Admin page' +
          MacroEnd );
        Close;
      end;
      LogSendError('Invalid password');
    end
    else
      begin
        FieldByName('UpdatedOn').AsDateTime := Now;
        FieldByName('UpdatedBy').AsString := pWebApp.StringVar['SurferName'];
      end
  end;
end;

{------------------------------------------------------------------------------}

procedure TDataModuleAdmin.DataModuleCreate(Sender: TObject);
begin
  HTFS_ADMIN := TwhPage.Create(pWebApp);
  HTFS_ADMIN.Name := 'htfs_ADMIN';
  HTFS_ADMIN.PageID := 'ADMIN';
end;

procedure TDataModuleAdmin.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(HTFS_ADMIN);
end;

procedure TDataModuleAdmin.gfAdminHotField(Sender: TwhbdeGrid; aField: TField;
  var s: string);
begin
  s:=MacroStart + 'JUMP|AdminP,'+aField.asString+'|'+aField.asString+MacroEnd;
end;

procedure TDataModuleAdmin.HTFS_ADMINSection(Sender: TObject;
  Section: Integer; var Chunk, Options: string);
begin
  inherited;
  if section>1 then exit;
  if pos('post',lowercase(TwhPage(Sender).WebApp.Command))>0 then
  begin
    {post items to table}

    {be careful not to trigger the edit verb built into
     the tpUpdate component decendants from a cgi-call!
     at present the code would inadvertently trigger an
     idle event and RE-process the request in progress.}

    with TwhPage(Sender).WebApp do
    begin
      with TableFishCost do
      begin
        FindKey([TFishSessionVars(Session.Vars).currentFish]);
        edit;   {be careful! The Edit method applies to both the app & the table.}
        //todoTableFishCostPrice.asString:=StringVar['Price'];
        //todoTableFishCostShippingNotes.assign(Session.TxtVars.List['txtShippingNotes']);
        post;
      end;
    end;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}

procedure TDataModuleAdmin.waSaveCurrentFishExecute(Sender: TObject);
var
  S: String;
  b: Boolean;
begin
  with TFishApp(TwhWebActionEx(Sender).WebApp) do
  begin
    S := Command;
    TFishSessionVars(Session.Vars).CurrentFish := StrToFloat(S);
    if uppercase(PageID)='DETAIL' then
      b:=dmFishStoreBIOLIFE.TableBiolife.FindKey([S])
    else
      b:=TableFishCost.FindKey([S]);
    if not b then
    begin
      Response.SendComment('Could not locate fish #'+S);
      exit;
    end;
  end;
end;

(*
object TableFishCost: TtpTable
  BeforePost = TableFishCostBeforePost
  TableName = 'FISHCOST.DB'
  TableMode = tmData
  PostBeforeClose = False
  HideLinkingKeys = False
  LeaveOpen = False
  Left = 240
  Top = 160
  object TableFishCostSpeciesNo: TFloatField
    FieldName = 'Species No'
  end
  object TableFishCostPrice: TFloatField
    FieldName = 'Price'
  end
  object TableFishCostUpdatedOn: TDateTimeField
    FieldName = 'UpdatedOn'
  end
  object TableFishCostUpdatedBy: TStringField
    FieldName = 'UpdatedBy'
    Size = 8
  end
  object TableFishCostPassword: TStringField
    FieldName = 'Password'
    Size = 2
  end
  object TableFishCostShippingNotes: TMemoField
    FieldName = 'ShippingNotes'
    BlobType = ftMemo
    Size = 1
  end
end
*)

end.


