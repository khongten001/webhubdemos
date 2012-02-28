unit admindm;

// Administration = Data entry.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, DB, TpTable, wbdeSource, UpdateOk, tpAction,
  WebTypes,   WebLink, WdbLink, WdbScan, webScan, wbdeGrid, WebPage, WebPHub,
  IniLink, wdbSSrc;

type
  TDataModuleAdmin = class(TDataModule)
    gfAdmin: TwhbdeGrid;
    wdsAdmin: TwhbdeSource;
    DataSourceFishCost: TDataSource;
    TableFishCost: TtpTable;
    TableFishCostSpeciesNo: TFloatField;
    TableFishCostPrice: TFloatField;
    TableFishCostUpdatedOn: TDateTimeField;
    TableFishCostUpdatedBy: TStringField;
    TableFishCostPassword: TStringField;
    TableFishCostShippingNotes: TMemoField;
    waSaveCurrentFish: TwhWebActionEx;
    HTFS_ADMIN: TwhPage;
    procedure TableFishCostBeforePost(DataSet: TDataSet);
    procedure gfAdminHotField(Sender: TwhbdeGrid; aField: TField;
      var s: string);
    procedure HTFS_ADMINSection(Sender: TObject; Section: Integer;
      var Chunk, Options: string);
    procedure waSaveCurrentFishExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure initDB;
  end;

var
  DataModuleAdmin: TDataModuleAdmin;

implementation

uses WebApp, whdemo_ViewSource, whMacroAffixes,
  ucString,
  whFishStore_fmWhPanel, tFish;

{$R *.DFM}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

procedure TDataModuleAdmin.initDB;
begin
  gfAdmin.WebDataSource := wdsAdmin;

  RefreshWebActions(DataModuleAdmin);

  with TableFishCost do
  begin
    if Active then Close;
    DatabaseName := getHtDemoDataRoot + 'whFishStore\';
    Open;
  end;

  {set up some captions and button specs that are easily styled}
  if gfAdmin.IsUpdated then
  begin
    gfAdmin.SetCaptions2004;
    gfAdmin.SetButtonSpecs2012;
  end;

end;

{------------------------------------------------------------------------------}

procedure TDataModuleAdmin.TableFishCostBeforePost(DataSet: TDataSet);
begin
  if (TableFishCostPassword.Value<>'') and
     (pWebApp.StringVar['Password']<>TableFishCostPassword.Value) then begin
    DataSet.cancel;
    with pWebApp.Response do begin
      SendHdr('2','Invalid Password');
      Send( 'Please try again. ' + MacroStart + 'JUMP|admin|Admin page' +
        MacroEnd );
      Close;
      end;
    //raise exception.create('Invalid password');
    end
  else begin
    TableFishCostUpdatedOn.Value:=now;
    TableFishCostUpdatedBy.Value:=pWebApp.StringVar['SurferName'];
    end
end;

{------------------------------------------------------------------------------}

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
        TableFishCostPrice.asString:=StringVar['Price'];
        TableFishCostShippingNotes.assign(Session.TxtVars.List['txtShippingNotes']);
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
      b:=fmHTFSPanel.TableBiolife.FindKey([S])
    else
      b:=TableFishCost.FindKey([S]);
    if not b then
    begin
      Response.SendComment('Could not locate fish #'+S);
      exit;
    end;
  end;
end;


end.


