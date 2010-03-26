unit whFishStore_fmWhPanel;
(*
Copyright (c) 1995 HREF Tools Corp.

Permission is hereby granted, on 04-Jun-2004, free of charge, to any person
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, TpMemo, tpStatus, UpdateOk,
  tpAction, WebTypes,   WebLink, WebLGrid, Toolbar, {}tpCompPanel,
  Db, DBTables, TpTable, wbdeSource, WdbLink, WdbScan, wbdeGrid,
  ComCtrls, webpage, webphub, wdbSSrc, webScan, Buttons;

type
  TfmHTFSPanel = class(TutParentForm)
    tpToolBar2: TtpToolBar;
    tpComponentPanel2: TtpComponentPanel;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Image1: TImage;
    tpStatusBar1: TtpStatusBar;
    WebListGrid1: TwhListGrid;
    gf: TwhbdeGrid;
    WebDataSourceBiolife: TwhbdeSource;
    DataSourceBiolife: TDataSource;
    TableBiolife: TTable;
    DataSourceA1: TDataSource;
    wdsa1: TwhbdeSource;
    gfa1: TwhbdeGrid;
    waFishPhoto: TwhWebActionEx;
    TableA1: TtpTable;
    waGrabFish: TwhWebAction;
    procedure waFishPhotoExecute(Sender: TObject);
    procedure gfHotField(Sender: TwhbdeGrid; aField: TField;
      var CellValue: String);
    procedure TableBiolifeAfterOpen(DataSet: TDataSet);
    procedure waGrabFishExecute(Sender: TObject);
  private
    { Private declarations }
  protected
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmHTFSPanel: TfmHTFSPanel;

implementation

{$R *.DFM}

uses
  webApp, whConst, whJPEG, whMacroAffixes, whdemo_ViewSource, webCall,
  ucString, ucFile,
  AdminDM, tfish, dmFishAp, uTranslations;

const
  FishKeyField='Species No';

//------------------------------------------------------------------------------
//                          INITIALIZATION CODE
//------------------------------------------------------------------------------

function TfmHTFSPanel.Init:Boolean;
begin
  Result:= inherited Init;
  if not result then
    exit;

  gf.WebDataSource := WebDataSourceBiolife;
  gfa1.WebDatasource := wdsa1;

  with TableA1 do
  begin
    DatabaseName := getHtDemoDataRoot + 'whFishStore\';
    TableName := 'BIOLIFE.DB';
    AfterOpen := TableBiolifeAfterOpen;
    Active := True;
  end;
  DataSourceA1.DataSet := TableA1;

  with TableBiolife do
  begin
    DatabaseName := TableA1.DatabaseName;
    TableName := TableA1.TableName;
    AfterOpen := TableBiolifeAfterOpen;
    Active := True;
  end;

  DataModuleAdmin.initDB;  // do this after ALL the modules in the project have been created.

  {Refresh each web action component once so that it becomes known to TwhCentralInfo.}
  RefreshWebActions(fmHTFSPanel);

  {set up some captions and button specs that are easily styled}
  {Do this after refreshing the grids, otherwise default captions are reset.}
  if gf.IsUpdated then
  begin
    gf.SetCaptions2004;
    gf.SetButtonSpecs2004;
    gfa1.ButtonsWhere := dsBelow;
    gfa1.ControlsWhere := dsBelow;
  end
  else
    raise Exception.Create('gf not updated');

  if gfa1.IsUpdated then
  begin
    gfa1.SetCaptions2004;
    gfa1.SetButtonSpecs2004;
    gfa1.ButtonsWhere := dsAbove;
    gfa1.ControlsWhere := dsBelow;
  end;

  {make sure that the event is hooked up for the hot field (in case someone
   changed the DFM after receiving the demo source)}
  gf.OnHotField := gfHotField;
  gfa1.OnHotField := gfHotField;

end;

{------------------------------------------------------------------------------}

procedure TfmHTFSPanel.TableBiolifeAfterOpen(DataSet: TDataSet);
begin
  with TTable(Dataset) do
  begin
    // Override the default display labels for these fields, such that they
    // will be translated 
    FieldByName( FishKeyField ).DisplayLabel := '(~~LabelSpeciesNumber~)';
    FieldByName( 'Graphic' ).DisplayLabel := '(~~LabelGraphic~)';
    FieldByName( 'Category' ).DisplayLabel := '(~~LabelCategory~)';
    FieldByName( 'Common_Name' ).DisplayLabel := '(~~LabelCommonName~)';
  end;
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
procedure TfmHTFSPanel.gfHotField(Sender: TwhbdeGrid; aField: TField;
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

{------------------------------------------------------------------------------}
{                          CODE FOR THE DETAIL PAGE                            }
{------------------------------------------------------------------------------}

// -----------------------------------------------------------------------------
// fish graphics
// -----------------------------------------------------------------------------
// As of September 1998, we are not creating any dynamic GIF files.  If you want
// to create dynamic GIF files, you may -- see ImageLib for Delphi.

const
  cHrefJpegDll='HrefJPEG.dll';  {HREF recommends ImageLib for conversion to GIF}

procedure Bmp2JPEGFile(BitMap:hBitmap;const FileName:ShortString); external cHrefJpegDll;

procedure TfmHTFSPanel.waFishPhotoExecute(Sender: TObject);
var
  shortFile, fullFile:String;
begin
  //
  // We are already on the right record. See call to web action component
  // on the detail page, prior to displaying image.
  //
  // We need to create the graphics file in a directory which is visible
  // to the web server, so that <img src=/htdemo/htfs/dynfish... will work.
  shortFile:='fish'+TableBiolife.fieldByName( FishKeyField ).asString+'.jpg';  // e.g. fish60030.jpg
  fullFile:=getHtDemoWWWRoot + 'webhub\demos\whFishStore\dynfish\';
  if NOT DirectoryExists(fullFile) then
    ForceDirectories(fullFile);
  fullFile := fullFile + shortFile;   // now fullFile equals full path plus filename

  // Create the graphics file.
  if NOT fileExists(fullFile) then begin
    // make a TPicture object and load it with data from BIOLIFE.Graphic
    image1.picture.assign( TableBiolife.fieldByName( 'Graphic' ) );
    // translate the graphic to the file, unless it has already been created!
    Bmp2JPEGFile(image1.picture.bitmap.handle,fullfile);
    end;
  // Generate an IMG SRC tag referencing the file.
  with TwhWebActionEx(Sender).Response,WebApp do
  begin
    SendLine( Format(
      '<img src="/webhub/demos/whFishStore/dynfish/%s " alt="%s" />',
      [ShortFile,
       Format(Traduko(lgvBitmapImageConverted), [ShortFile])]) );
    SendComment(Format(Traduko(lgvFileGraphicStored), [fullfile]));
    end;
end;

{------------------------------------------------------------------------------}

{ This procedure is called from the OnSection event on the GRABFISH
  page (TwhPage).  This is it, you are looking at the core idea
  of The Shopping Cart.  Yes, it's simple.  Ok, it's simple because
  WebHub takes care of saving state! }
procedure TfmHTFSPanel.waGrabFishExecute(Sender: TObject);
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
  Desc := Format('%s%s %s', [Traduko(lgvFishNumber), FloatToStr(item), Desc]);

  { Put the Fish In the Shopping Cart
    Look at ht\htdemos\codedemo\register\tfish.pas and see where fishList
    is defined... it's a TStringList on the Session object, so it's unique
    for each surfer. }
  vp.fishList.Add(Desc);
end;

end.

