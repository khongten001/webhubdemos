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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ComCtrls,
  ExtCtrls, StdCtrls,
  utPanFrm, tpStatus, UpdateOk, tpAction, Toolbar, {}tpCompPanel,
  webLink, webTypes;

type
  TfmHTFSPanel = class(TutParentForm)
    tpToolBar2: TtpToolBar;
    tpComponentPanel2: TtpComponentPanel;
    Image1: TImage;
    tpStatusBar1: TtpStatusBar;
    waFishPhoto: TwhWebActionEx;
    Label1: TLabel;
    procedure waFishPhotoExecute(Sender: TObject);
  private
    { Private declarations }
  protected
  public
    { Public declarations }
    function Init: boolean; override;
  end;

var
  fmHTFSPanel: TfmHTFSPanel;

implementation

{$R *.DFM}

uses
  webApp, whConst, whJPEG, whdemo_ViewSource,
  AdminDM, tfish, dmFishAp, uTranslations, whFireStore_dmwhBiolife;


//------------------------------------------------------------------------------
//                          INITIALIZATION CODE
//------------------------------------------------------------------------------

function TfmHTFSPanel.Init: boolean;
begin
  Result:= inherited Init;
  if Result then
  begin
    waFishPhoto.Refresh; // required
    Result := waFishPhoto.IsUpdated;
  end;
end;

{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{                          CODE FOR THE DETAIL PAGE                            }
{------------------------------------------------------------------------------}

procedure TfmHTFSPanel.waFishPhotoExecute(Sender: TObject);
var
  shortFile, filespec: string;
begin
  //
  // We are already on the right record. See call to web action component
  // on the detail page, prior to displaying image.
  //
  // We need to create the graphics file in a directory which is visible
  // to the web server, so that <img src=/htdemo/htfs/dynfish... will work.
  shortFile:='fish'+
    DMFishStoreBiolife.TableBiolife.fieldByName( FishKeyField ).asString+'.jpg';  // e.g. fish60030.jpg
  filespec := getHtDemoWWWRoot + 'webhub\demos\whFishStore\dynfish\';
  if NOT DirectoryExists(filespec) then
    ForceDirectories(filespec);
  filespec := filespec + shortFile;   // now fullFile equals full path plus filename

  // Create the graphics file.
  if NOT fileExists(filespec) then
  begin
    // make a TPicture object and load it with data from BIOLIFE.Graphic
    image1.picture.assign( DMFishStoreBiolife.TableBiolife.fieldByName( 'Graphic' ) );
    // translate the graphic to the file, unless it has already been created!
    Bmp2JPEGFile(image1.picture.bitmap.handle, filespec);
  end;
  // Generate an IMG SRC tag referencing the file.
  with TwhWebActionEx(Sender).Response,WebApp do
  begin
    SendLine( Format(
      '<img src="/webhub/demos/whFishStore/dynfish/%s " alt="%s" />',
      [ShortFile,
       Format(FishTraduko(lgvBitmapImageConverted), [ShortFile])]) );
    SendComment(Format(FishTraduko(lgvFileGraphicStored), [filespec]));
    end;
end;

end.

