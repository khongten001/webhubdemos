unit admindm;

// Administration = Data entry.

interface

uses
  SysUtils, Classes, Forms, DB, Datasnap.DBClient,
  updateOk, tpAction,
  webTypes, webLink, wdbScan, webScan, wdbGrid, wbdeGrid{bde}, webPage, webPHub,
  wdbSSrc, wdbSource, wbdeSource, wdbLink;

type
  TDataModuleAdmin = class(TDataModule)
    gfAdmin: TwhbdeGrid;
    wdsAdmin: TwhbdeSource;
    DataSourceFishCost: TDataSource;
    TableFishCost: TClientDataSet;
    waPostPrice: TwhWebAction;
    procedure TableFishCostBeforePost(DataSet: TDataSet);
    procedure gfAdminHotField(Sender: TwhdbGrid; aField: TField;
      var s: string);
    procedure waPostPriceExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  published
  end;

var
  DataModuleAdmin: TDataModuleAdmin;

implementation

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucString, ucCodeSiteInterface,
  webApp, whMacroAffixes,
  whdemo_ViewSource,
  whFishStore_fmWhPanel, tFish, whFishStore_dmwhBiolife, whdemo_Extensions;

{$R *.DFM}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

function TDataModuleAdmin.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
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
    end
    else
      ErrorText := gfAdmin.ClassName + ' gfAdmin is not usable';
  end;
  Result := (ErrorText = '');
  {$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

{------------------------------------------------------------------------------}

procedure TDataModuleAdmin.TableFishCostBeforePost(DataSet: TDataSet);
const cFn = 'TableFishCostBeforePost';
var
  Allow: Boolean;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  with TableFishCost do
  begin
    Allow := DemoExtensions.IsSuperUser(pWebApp.Request.RemoteAddress) or
      (FieldByName('Password').AsString='') or
      (pWebApp.StringVar['Password']= FieldByName('Password').AsString);
    CSSend('Allow', S(Allow));
    if NOT Allow then
    begin
      DataSet.Cancel;
      with pWebApp.Response do
      begin
        SendHdr('2','Invalid Password');
        Send( 'Please try again. ' + MacroStart + 'JUMP|admin|Admin page' +
          MacroEnd );
        Close;
      end;
      LogSendWarning('Invalid password', cFn);
    end
    else
      begin
        FieldByName('UpdatedOn').AsDateTime := Now;
        FieldByName('UpdatedBy').AsString := pWebApp.StringVar['SurferName'];
      end
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDataModuleAdmin.waPostPriceExecute(Sender: TObject);
const cFn = 'waPostPriceExecute';
var
  iKey: Double;
  dPrice: Currency;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}

  if pos('post',lowercase(TwhPage(Sender).WebApp.Command))>0 then
  begin
    {post items to table}

    {be careful not to trigger the edit verb built into
     the tpUpdate component decendants from a cgi-call!}

    with TwhPage(Sender).WebApp do
    begin
      iKey := TFishSessionVars(Session.Vars).currentFish;
      with TableFishCost do
      begin
        if FindKey([iKey]) then
        begin
          dPrice := StrToFloatDef(StringVar['Price'], -999);
          if dPrice <> -999 then
          begin
            TableFishCost.Edit;   {be careful! The Edit method applies to both the app & the table.}
            FieldByName('Price').AsCurrency := dPrice;
            FieldByName('ShippingNotes').AsString :=
              Session.TxtVars.List['txtShippingNotes'].Text;
            if FieldByName('Password').AsString = '' then
              FieldByName('Password').AsString  := StringVar['Password'];
            Post;
          end
          else
            LogSendWarning('Invalid price: ' + StringVar['Price'], cFn);
        end
        else
          LogSendWarning('Invalid primary key: ' + FloatToStr(iKey));
      end;
    end;
  end;

  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

{------------------------------------------------------------------------------}

procedure TDataModuleAdmin.gfAdminHotField(Sender: TwhdbGrid; aField: TField;
  var s: string);
const cFn = 'gfAdminHotField';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  CSSend('aField.FieldName', aField.FieldName);
  s:=MacroStart + 'JUMP|AdminP,'+aField.asString+'|'+aField.asString+MacroEnd;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.


