unit whFishStore_dmwhBiolife;

(* original filename: whsample_DMInit.pas *)
(* no copyright claimed for this WebHub sample file *)

interface

uses
  SysUtils, Classes, DB, DBClient,
  updateOK, tpAction, 
  webLink, webLGrid, wdbScan, wdbGrid, wbdeGrid{bde}, wdbGrid, webTypes, wdbSSrc,
  wdbSource, wbdeSource;

const
  FishKeyField='Species No';

type
  TDMFishStoreBiolife = class(TDataModule)
    DataSourceA1: TDataSource;
    wdsa1: TwhbdeSource;
    gfa1: TwhbdeGrid;
    DataSourceBiolife: TDataSource;
    WebDataSourceBiolife: TwhbdeSource;
    gf: TwhbdeGrid;
    WebListGrid1: TwhListGrid;
    TableBiolife: TClientDataSet;
    TableA1: TClientDataSet;
    waGrabFish: TwhWebAction;
    waSaveCurrentFish: TwhWebActionEx;
    procedure DataModuleCreate(Sender: TObject);
    procedure TableBiolifeAfterOpen(DataSet: TDataSet);
    procedure waGrabFishExecute(Sender: TObject);
    procedure waSaveCurrentFishExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure gfHotField(Sender: TwhdbGrid; aField: TField;
      var CellValue: String);
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMFishStoreBiolife: TDMFishStoreBiolife;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucCodeSiteInterface, ucString,
  webApp, webScan, htWebApp, whMacroAffixes,
  whdemo_ViewSource,
  tfish, uTranslations, AdminDM;

{ TDM001 }

procedure TDMFishStoreBiolife.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMFishStoreBiolife.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin


      gf.WebDataSource := WebDataSourceBiolife;
      gfa1.WebDatasource := wdsa1;

      with TableA1 do
      begin
        FileName := getHtDemoDataRoot + 'embSample\' + 'biolife.xml';
        AfterOpen := TableBiolifeAfterOpen;
        Active := True;
      end;
      DataSourceA1.DataSet := TableA1;

      with TableBiolife do
      begin
        FileName := TableA1.Filename;
        AfterOpen := TableBiolifeAfterOpen;
        Active := True;
      end;

      if ErrorText = '' then
      begin
        // Call RefreshWebActions here only if it is not called within a TtpProject event
        RefreshWebActions(Self);


        {set up some captions and button specs that are easily styled}
        {Do this after refreshing the grids, otherwise default captions are reset.}
        if gf.IsUpdated then
        begin
          gf.SetCaptions2004;
          gf.SetButtonSpecs2012;
          gfa1.ButtonsWhere := dsBelow;
          gfa1.ControlsWhere := dsBelow;
        end
        else
          raise Exception.Create('gf not updated');

        if gfa1.IsUpdated then
        begin
          gfa1.SetCaptions2004;
          gfa1.SetButtonSpecs2012;
          gfa1.ButtonsWhere := dsAbove;
          gfa1.ControlsWhere := dsBelow;
        end;

        {make sure that the event is hooked up for the hot field (in case someone
         changed the DFM after receiving the demo source)}
        gf.OnHotField := gfHotField;
        gfa1.OnHotField := gfHotField;


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

procedure TDMFishStoreBiolife.TableBiolifeAfterOpen(DataSet: TDataSet);
begin
  with Dataset do
  begin
    // Override the default display labels for these fields, such that they
    // will be translated
    FieldByName( FishKeyField ).DisplayLabel := '(~~LabelSpeciesNumber~)';
    FieldByName( 'Graphic' ).DisplayLabel := '(~~LabelGraphic~)';
    FieldByName( 'Category' ).DisplayLabel := '(~~LabelCategory~)';
    FieldByName( 'Common_Name' ).DisplayLabel := '(~~LabelCommonName~)';
  end;
end;

procedure TDMFishStoreBiolife.waGrabFishExecute(Sender: TObject);
{ This procedure is called from the OnSection event on the GRABFISH
  page (TwhPage).  This is it, you are looking at the core idea
  of The Shopping Cart.  Yes, it's simple.  Ok, it's simple because
  WebHub takes care of saving state! }
var
  item: Double;
  Desc: string;
  vp: TFishSessionVars;
begin
  inherited;

  pWebApp.StringVar['cartStarted']:='yes';

  { make a local copy of the currentFish (numeric ID) }
  vp := TFishApp(pWebApp).FishVars; // TFishSessionVars(TFishApp(pWebApp).Session.Vars);
  item := vp.currentFish;

  { find it and remember the description }
  with TableBiolife do
  begin
    findKey([item]);
    Desc := FieldByName( 'Common_Name' ).asString;
  end;

  { expand the description to something more surfer-friendly }
  Desc := Format('%s%s %s', [FishTraduko(lgvFishNumber), FloatToStr(item), Desc]);

  { Put the Fish In the Shopping Cart
    Look at ht\htdemos\codedemo\register\tfish.pas and see where fishList
    is defined... it's a TStringList on the Session object, so it's unique
    for each surfer. }
  vp.fishList.Add(Desc);
end;


procedure TDMFishStoreBiolife.waSaveCurrentFishExecute(Sender: TObject);
const cFn = 'waSaveCurrentFishExecute';
var
  S1: string;
  b: Boolean;
  AWarning: string;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  with TFishApp(TwhWebActionEx(Sender).WebApp) do
  begin
    S1 := Command;
    CSSend('Command', Command);
    TFishSessionVars(Session.Vars).CurrentFish := StrToFloatDef(S1, 0);
    CSSend('PageID', PageID);
    if SameText(PageID, 'DETAIL') then
      b:=dmFishStoreBIOLIFE.TableBiolife.FindKey([S1])
    else
      b:= DataModuleAdmin.TableFishCost.FindKey([S1]);
    if not b then
    begin
      AWarning := 'Could not locate fish #' + S1;
      CSSendWarning(AWarning);
      Response.SendComment(AWarning);
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

{------------------------------------------------------------------------------}
{                          CODE FOR THE LOOKFISH PAGE                          }
{------------------------------------------------------------------------------}

{ This procedure is called whenever TwhbdeGrid gets to a "hot" field
  in the table.  Hot fields were set above by controlling the .tag
  property of the field in question.  See the webhub.hlp file for all the
  .tag options.
  Our job here is to define variable 'CellValue' such that it will make sense
  when plugged into the overall table syntax.
}
procedure TDMFishStoreBiolife.gfHotField(Sender: TwhdbGrid; aField: TField;
  var CellValue: string);
var
  desc: string;
  g: TwhbdeGrid;
  tc: TDataSet;  // tc stands for Table Cursor
  id: string;
begin
  CellValue := '';
  desc := aField.asString;
  g := TwhbdeGrid(Sender); { so we can reuse this proc for multiple grids }
  tc := aField.DataSet;
  //
  // Reference the desired field by name, not position, because fields[0] might
  // not be the 'zeroth' field due to display set changes invoked by the surfer.
  id := tc.fieldByName( FishKeyField ).asString;
  //
  if IsEqual(aField.FieldName, 'Graphic') then
  begin
    { OK, we're on the graphic hot field and want to create the following:
    1. the thumbnail graphic of the fish, hot linked to the detail page.
    2. a caption below that, giving the fish common_name.
    }
    CellValue :=
      {The graphic links to the Detail page, and there is a caption below it.}
      Format(
     '%sJUMP|DETAIL,%s|<img src="%smcImageDir%sthumbnails/ftn%s.jpg">%s<br/>%s',
     [MacroStart, id, MacroStart, MacroEnd, id, MacroEnd,
     tc.FieldByName( 'Common_Name' ).asString]);
  end
  else
  begin
    { here we are dealing with just the common_name field.  This will
      look ok in <pre> format and you could copy this example for all
      your basic text-only hot-links. }
    if g.preformat then
    begin
      { step 1: shorten to displayWidth }
      desc := copy( desc, 1, aField.displayWidth );
      { step 2: widen to displayWidth-1 ! }
      desc := Format( '%-' + IntToStr( succ( aField.displayWidth ) ) + 's',
        [desc] );
    end;

    { here's the most important line to understand. this will expand to:
      GO|detail,ItemID|fish name which becomes something like
      <A HREF="/cgi-win/webhub.exe?fishapp:detail:####:ItemID">fish name</A>
      By using the GO macro, we get the cgi call, the AppID and session#
      filled in automatically.
    }
    CellValue := CellValue + MacroStart + 'GO|Detail,'+id+'|'+desc+MacroEnd;
  end;
end;



procedure TDMFishStoreBiolife.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;



(*
object TableBiolife: TTable
  TableName = 'BIOLIFE.DB'
  TableType = ttParadox
  Left = 399
  Top = 110
end
object TableA1: TtpTable
  TableMode = tmData
  PostBeforeClose = False
  HideLinkingKeys = False
  LeaveOpen = False
  Left = 400
  Top = 193
end

*)
end.
