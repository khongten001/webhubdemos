unit whJPEG; {

Copyright (c) 1995-99 HREF Tools Corp.  All Rights Reserved.

This component enables you render a tPicture containing a tBitmap image
into a JPEG which is streamed directly to the web.
Requires the Delphi JPEG unit, see \extras\jpeg on your CD.


public properties:

  Picture: TPicture; // pointer to the TImage/tdbImage/tOleImage picture
  Percent: Integer;  // percentage relation of picture to output
  whJPEGImage: TwhJPEGImage; // internal, TwhResponseSimple-aware TJPEGImage


example code:
pretty much everthing you need is done bwo the onupdate event:

  procedure TForm1.waBMPUpdate(Sender: TObject);
  begin
    //YOU MUST .. assign the picture property at runtime.
    if assigned(dbImage) then
      waJPEG.Picture:= dbImage.Picture;
    //optionally you can customize jpeg encoding options:
    waJPEG.whJPEGImage.Grayscale:=True;
    waJPEG.whJPEGImage.ProgressiveEncoding:=True;
    waJPEG.whJPEGImage.CompressionQuality:=70;
  end;


example whtml showing thumbnails and linking to the full image:

  <h1>-Page:ShowDbBMP</h1>
  %=expires|-1=%
  %=JUMP|do,waJPEG|<IMG SRC="%=ACTION|do,waJPEG.50=%" %=waJPEG|dimensions=%>=%
  %=JUMP|do,waJPEG|<IMG SRC="%=ACTION|do,waJPEG.20=%" %=waJPEG|dimensions=%>=%<br>
  %=JUMP|do,waJPEG|<IMG SRC="%=ACTION|do,waJPEG=%" %=waJPEG|dimensions=%>=%


note:

  * using the command you can affect the 'Percent' property over the web
  in order to produce thumnails!

  * using the htmlparam 'dimensions' you can have the component produce
  the dimension portion of an image tag!

  * graphic palettes puzzle me still. if you know how to make them right
  for small images, please let me know!  Michael Ax <ax@href.com>

}

interface

uses
  Classes,
  Windows,
  Graphics,
  SysUtils,
  WebLink,
  JPEG;

type
  TwhJPEGImage= class(TJPEGImage)
  public
    procedure LoadFromBitMap(ahBitMap:hBitmap);
    procedure Send;
    //these are the relevant compression/ encoding options:
    //  property Grayscale: Boolean;
    //  property ProgressiveEncoding: Boolean;
    //  property CompressionQuality: TJPEGQualityRange;
    //    TJPEGQualityRange=1..100; //100=best, 25=pretty awful
    end;

type
  TwhJPEG= class(TwhWebActionEx)
  private
    fPercent: Integer;
    fPicture: TPicture;
    fwhJPEGImage: TwhJPEGImage;
  protected
    procedure DoExecute; override;
    procedure SetCommand(const Value:String); override;
  private
    procedure SendScaled;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    //
    property Percent: Integer read fPercent write fPercent;
    property Picture: TPicture read fPicture write fPicture;
    property whJPEGImage: TwhJPEGImage read fwhJPEGImage;
    //
  published
    end;


//helper functions
//these are not actually used by the component class and
//they can be used 'stand-alone'.
procedure Bmp2JPEGStream(ahBitMap:hBitmap;Stream:TStream);
procedure Bmp2JPEGFile(ahBitMap:hBitmap;const FileName:string);

implementation

uses
  WebApp, HtmlBase, ucString;

//----------------------------------------------------------------------

procedure Bmp2JPEGStream(ahBitMap:hBitmap;Stream:TStream);
begin
  with TwhJPEGImage.Create do try
    LoadFromBitMap(ahBitMap);
    CompressionQuality:= 100;
    SaveToStream(Stream);
  finally
    Free;
    end;
end;

procedure Bmp2JPEGFile(ahBitMap:hBitmap;const FileName:string);
var
  Stream:TStream;
begin
  Stream:= TFileStream.Create(FileName, fmCreate OR fmShareDenyWrite);
  try
    Bmp2JPEGStream(ahBitMap,Stream);
  finally
    Stream.Free;
    end;
end;

//----------------------------------------------------------------------

procedure TwhJPEGImage.Send;
begin
  with pWebApp.Response do begin
    //make sure that the output stream that it's empty by using flush.
    //do not use close here as close would send the page to the runner.
    Flush;
    //customize the PrologueMode so that we dont need to adjust the headers later.
    ContentType:='image/jpeg';
    //opening the stream insures an empty outputstream
    //AND sets the Response headers. these are two separate places
    //merged (and the content length is set) when the page is closed.
    Open;
    //write the image to the stream
    Self.SaveToStream({Response.}Stream);
    //close the output stream and send the page to the runner.
    Close;
    end;
end;

procedure TwhJPEGImage.LoadFromBitMap(ahBitMap:hBitmap);
var
  b: TBitMap;
begin
  b:=TBitMap.Create;
  try
    b.Handle:=ahBitMap;
    Assign(b);
  finally
    b.free;
    end;
end;

//----------------------------------------------------------------------

constructor TwhJPEG.Create(AOwner: TComponent);
begin
  inherited Create(aOwner);
  DirectCallOk:= True;
  fwhJPEGImage:= TwhJPEGImage.Create;
  fPercent:=100;
end;

destructor TwhJPEG.Destroy;
begin
  fwhJPEGImage.Free;
  inherited Destroy;
end;

procedure TwhJPEG.SetCommand(const Value:String);
//get the ratio brought in by the command
begin
  inherited SetCommand(Value);
  if Command<>'' then
    Percent:=StrToIntDef(Command,100);
end;

procedure TwhJPEG.SendScaled;
var
  Rect:TRect;
  Scaled: TBitmap;
begin
  if assigned(Picture)
  and assigned(Picture.Bitmap) then
    with Picture do begin
      with Rect do begin
        Top:=0;
        Left:=0;
        Right:=(Bitmap.Width* Percent) div 100;
        Bottom:=(Bitmap.Height* Percent) div 100;
        end;
      Scaled:= TBitmap.Create;
      try
        Scaled.Width:=Rect.Right;
        Scaled.Height:=Rect.Bottom;
        Scaled.Canvas.StretchDraw(Rect, Picture.Graphic);
        with fwhJPEGImage do begin
          Assign(Scaled);
          Send;
          end;
      finally
        Scaled.Free;
        end;
      end;
end;

procedure TwhJPEG.DoExecute;
//process the request
begin
  inherited DoExecute;
  if Command='' then
    Percent:=100;
  if assigned(Picture)
  and assigned(Picture.Bitmap) then
    with Picture do
      if isEqual(HtmlParam,'dimensions') then
        with Bitmap do
          Response.Send('HEIGHT='+IntToStr((Height * Percent) div 100)
                        +' WIDTH='+IntToStr((Width * Percent) div 100))
      else
        with fwhJPEGImage do
          if Percent=100 then begin
            Assign(Picture.Bitmap);
            Send;
            end
          else
            SendScaled
  else
    Response.SendComment('No Bitmap');
end;

//----------------------------------------------------------------------
end.

