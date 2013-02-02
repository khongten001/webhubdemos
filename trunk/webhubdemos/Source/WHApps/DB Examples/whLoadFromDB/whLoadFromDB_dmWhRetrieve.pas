unit whLoadFromDB_dmWhRetrieve;

interface

uses
  SysUtils, Classes, tpAction, WebTypes,   weblink,
  UpdateOK, IniLink, Db, DBTables;

type
  TWebAction2 = class(TwhWebAction)
  private
    fCurrentDropletKey: String;
  public
    property CurrentDropletKey: String read fCurrentDropletKey;
  end;

type
  TdmWhRetrieve = class(TDataModule)
    waSETLOCAL: TwhWebAction;
    waCLEARLOCAL: TwhWebAction;
    waLOCAL: TwhWebAction;
    procedure waRetrieveExecute(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure waSETLOCALExecute(Sender: TObject);
    procedure waCLEARLOCALExecute(Sender: TObject);
    procedure waLOCALExecute(Sender: TObject);
  private
    { Private declarations }
    fQuery: TQuery;
    waRetrieve: TWebAction2;
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
    function InitGUI(out ErrorText: string): Boolean;
  end;

var
  dmWhRetrieve: TdmWhRetrieve;

implementation

uses
  webApp,
  ucString,
  whLoadFromDB_fmWhAppDBHTML;

{$R *.dfm}

// -----------------------------------------------------------------------------

function TdmWhRetrieve.Init(out ErrorText: string): Boolean;
begin
  ErrorText := '';
  waRetrieve := TWebAction2.Create(Self);
  waRetrieve.Name := 'waRetrieve';
  waRetrieve.OnExecute := waRetrieveExecute;

  fQuery := TQuery.Create(Self);
  fQuery.SQL.Text := ''
  +'SELECT Code, Text '
  +'FROM "whcontent.DB" '
  +'WHERE '
  +'(Identifier = :Identifier) '
  +'AND (Type = ''n/a'')';

  RefreshWebActions(Self);
  Result := waRetrieve.IsUpdated;
  if NOT Result then
    ErrorText := 'Unable to update the waRetrieve component.';
end;

function TdmWhRetrieve.InitGUI(out ErrorText: string): Boolean;
begin
  ErrorText := '';
  Result := Assigned(fmAppDBHTML);
  RefreshWebActions(Self);
end;

procedure TdmWhRetrieve.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(waRetrieve);
  FreeAndNil(fQuery);
end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

procedure TdmWhRetrieve.waRetrieveExecute(Sender: TObject);
var
  saveKey, data: String;
begin
  with TWebAction2(Sender) do
  begin
    saveKey := fCurrentDropletKey;

    with fQuery do
    begin
      if Active then Close; if NOT Prepared then Prepare; // Delphi TQuery
      Params[0].asString := HtmlParam;
      Open;
      fCurrentDropletKey := FieldByName('Code').asString;
      data := FieldByName('Text').asString;
      Close;
    end;

    Response.Send(data);

    WebApp.Session.LocalVars.List[fCurrentDropletKey].Clear;

    fCurrentDropletKey := saveKey;
  end;
end;

procedure TdmWhRetrieve.waSETLOCALExecute(Sender: TObject);
var
  aKey,aValue: String;
begin
  with TwhWebAction(Sender) do
  begin
    if SplitString(HtmlParam,'=',aKey,aValue) then
    begin
      with WebApp.Session.LocalVars do
        List[waRetrieve.CurrentDropletKey].Values[WebApp.MoreIfParentild(aKey)]
          := aValue;
    end;
  end;
end;

procedure TdmWhRetrieve.waCLEARLOCALExecute(Sender: TObject);
var
  i: Integer;
  dropletID: String;
  variableID: String;
begin
  dropletID := waRetrieve.CurrentDropletKey;

  with TwhWebAction(Sender) do
  begin
    if (HtmlParam='') then Exit
    else if (HtmlParam='*') then WebApp.Session.LocalVars.List[dropletID].Clear
    else
    begin
      variableID := WebApp.MoreIfParentild(HtmlParam);
      with WebApp.Session.LocalVars do
      begin
        i := List[dropletID].FindByKey(variableID);
        if i <> -1 then
          List[dropletID].Delete(i);
      end;
    end;
  end;
end;

procedure TdmWhRetrieve.waLOCALExecute(Sender: TObject);
var
  aKey: String;
begin
  with TwhWebAction(Sender) do
  begin
    aKey := WebApp.MoreIfParentild(HtmlParam);
    with WebApp.Session.LocalVars do
      Response.Send(
        RightOfEqual(List[waRetrieve.CurrentDropletKey].Values[aKey]));
  end;
end;

end.
