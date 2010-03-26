unit WebEZMap;

interface

uses
  Windows, SysUtils, Classes, Controls, ComObj, graphics, jpeg,
  EzBase, EzLib, EzBaseGis, EzBasicCtrls,
  weblink;

type

  TEzCurrentAction = (caZoomIn, caZoomOut, caPickEntity);

  TWebEZMap = class(TwhWebActionEx)
  private
    FDrawBox        : TEzDrawBox;
    FCurrentAction  : TEzCurrentAction;
    FStackedSelList : TStrings;

    FOnEntityClick: TEzEntityClickEvent;
    FFileURL : string;
    FFileName: string;
    FFilePath: string;

    procedure MyMouseDown(ASender: TObject; const AX: Integer; const AY: Integer);
    Procedure SetDrawBox( Value: TEzDrawBox );
  protected
    procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
    function  DoUpdate : Boolean; override;
    procedure DoExecute; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function    MapHTML : string;  // return HTML tag for map

  published
    property FileName: string read FFileName write FFileName;
    property FilePath: string read FFilePath write FFilePath;
    property FileURL : string read FFileURL write FFileURL;
    property DrawBox : TEzDrawBox read FDrawBox write SetDrawBox;
    property OnEntityClick: TEzEntityClickEvent read FOnEntityClick write FOnEntityClick;
    property CurrentAction: TEzCurrentAction read FCurrentAction write FCurrentAction;
  End;

procedure Register;

implementation

uses
  StdCtrls, WebTypes;
{
procedure Bmp2GIFFile( Bmp : TBitmap; const FileName : String );
var
  Gif    : TBmpToGif;
begin
  Gif := TBmpToGif.Create( nil );
  Bmp.PixelFormat := pf8bit;
  Gif.Bitmap      := Bmp;
  Gif.FileName    := FileName;
  Gif.Convert;
  Gif.Free;
end;
}
procedure Bmp2JPGFile( Bmp : TBitmap; const FileName : String );
var
  Jpg : TJPEGImage;
begin
  Jpg := TJPEGImage.Create;
  try
    Jpg.Assign( Bmp );
    Jpg.SaveToFile( FileName );
  finally
    Jpg.Free;
  end;
end;
{ TWebEZMap }

constructor TWebEZMap.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CurrentAction := caZoomIn;
  //FFilePath := 'C:\Inetpub\wwwroot\webhub\';
  //FFileURL  := 'http://localhost:8000/webhub/';
//  FFileName := 'map.gif';
//  Name      := 'WebEZMap1';
end;

destructor TWebEZMap.Destroy;
begin
  DrawBox:=nil;
  if Assigned( FStackedSelList ) then FStackedSelList.free;
  inherited Destroy;
end;

{ for actions that requires only single mouse click }
procedure TWebEZMap.MyMouseDown(ASender: TObject; const AX, AY: Integer);
var
  WX, WY: Double;
  CurrPoint, OldPoint, NewPoint: TEzPoint;

  Procedure DoPickEntity;
  var
    Extension: TEzRect;
    TmpLayer, PrevLayer: TEzBaseLayer;
    PickedPoint, I, TmpRecNo, PrevRecno, PrevSelCount, N: Integer;
    Picked, Processed: Boolean;
  Begin
    with FDrawBox do
    begin
      If StackedSelect Then
      Begin
        If FStackedSelList = Nil Then
          FStackedSelList := TStringList.Create
        Else
          FStackedSelList.Clear;
        PrevSelCount := Selection.NumSelected;
        If PrevSelCount = 1 Then
        Begin
          PrevLayer := Selection[0].Layer;
          PrevRecno := Selection[0].SelList[0];
        End;
      End
      Else If FStackedSelList <> Nil Then
        FreeAndNil( FStackedSelList );

      Picked := PickEntity( CurrPoint.X, CurrPoint.Y, 4,
        '', TmpLayer, TmpRecNo, PickedPoint, FStackedSelList );

      If Selection.Count > 0 Then
      Begin
        { repintar el area seleccionada }
        Extension := Selection.GetExtension;
        Selection.Clear;
        RepaintRect( Extension );
      End;

      If Picked Then
      Begin
        If ( FStackedSelList <> Nil ) And ( PrevSelCount = 1 ) And ( FStackedSelList.Count > 1 ) Then
        Begin
          For I := 0 To FStackedSelList.Count - 1 Do
          Begin
            If ( PrevLayer = GIS.Layers.LayerByName( FStackedSelList[I] ) ) And
              ( PrevRecno = Longint( FStackedSelList.Objects[I] ) ) Then
            Begin
              If I < FStackedSelList.Count - 1 Then
                N := I + 1
              Else
                N := 0;
              TmpLayer := GIS.Layers.LayerByName( FStackedSelList[N] );
              TmpRecno := Longint( FStackedSelList.Objects[N] );
              Break;
            End;
          End;
        End;
        Selection.Add( TmpLayer, TmpRecNo );
        If Assigned( OnSelectionChanged ) Then
          OnSelectionChanged( FDrawBox );
        Selection.RepaintSelectionArea;

        If Assigned(Self.FOnEntityClick) then
        Begin
          Processed:= True;
          Self.FOnEntityClick( Self, mbLeft, [], AX, AY, WX, WY, TmpLayer,
                               TmpRecno, Processed );
        End;
      End Else
      Begin
        If Assigned(Self.FOnEntityClick) then
        Begin
          Processed:= True;
          Self.FOnEntityClick( Self, mbLeft, [], AX, AY, WX, WY, Nil, 0, Processed );
        End;
      End;

    end;
  End;

begin
  if FDrawBox.Gis = Nil then Exit;
  { conviert from pixels to map coordinates }
  FDrawBox.DrawBoxToWorld( AX, AY, WX, WY );
  CurrPoint:= Point2d( WX, WY );

  case FCurrentAction of
    caZoomIn:
      begin
        OldPoint := Point2D( WX, WY );
        FDrawBox.Grapher.InUpdate := true; {don't generate two history views}
        FDrawBox.Grapher.Zoom( 0.85 );
        FDrawBox.Grapher.InUpdate := false;
        NewPoint := FDrawBox.Grapher.PointToReal( Point( AX, AY ) );
        With FDrawBox.Grapher.CurrentParams.MidPoint Do
          FDrawBox.Grapher.ReCentre( X + ( OldPoint.X - NewPoint.X ),
                                     Y + ( OldPoint.Y - NewPoint.Y ) );
        FDrawBox.Repaint;
      end;
    caZoomOut:
      begin
        OldPoint := Point2D( WX, WY );
        FDrawBox.Grapher.InUpdate := true; {don't generate two history views}
        FDrawBox.Grapher.Zoom( 1 / 0.85 );
        FDrawBox.Grapher.InUpdate := false;
        NewPoint := FDrawBox.Grapher.PointToReal( Point( AX, AY ) );
        With FDrawBox.Grapher.CurrentParams.MidPoint Do
          FDrawBox.Grapher.ReCentre( X + ( OldPoint.X - NewPoint.X ),
                                     Y + ( OldPoint.Y - NewPoint.Y ) );
        FDrawBox.Repaint;
      end;
    caPickEntity:
      begin
        { detect which entity was picked }

        DoPickEntity;

      end;
  end;

end;

procedure TWebEZMap.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FDrawBox ) Then
    FDrawBox := Nil
end;

procedure TWebEZMap.SetDrawBox(Value: TEzDrawBox);
begin
{$IFDEF LEVEL5}
  if Assigned( FDrawBox ) then FDrawBox.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> FDrawBox Then
  Begin
    FDrawBox := Value;
    if Assigned( FDrawBox ) then FDrawBox.FreeNotification( Self );
  End;
end;

function TWebEZMap.mapHTML : string;
Const
  CountXY = 20;
var
  theRect: TRect;
  TmpEdge, Border: UINT;
  x, y : Integer;
  deltaX, deltaY : Single;
  HREF : string;
begin

  if Assigned( FDrawBox ) then
  begin
//    DeleteFile( FFilePath + FFileName );
//    Inc( UniqNumber );
//    FDrawBox.ScreenBitmap.SaveToFile( FFilePath + FFileName );
    Bmp2JPGFile( FDrawBox.ScreenBitmap, FFilePath + FFileName );
  end;

  result := '<IMG SRC="' + FFileURL + FileName + '?' + CreateClassID + '" BORDER=0' +
            ' ALT="Test Image" USEMAP="#WebEZMap_' + Name + '">' +
            '<MAP NAME="WebEZMap_' + Name + '">';

  deltaX := FDrawBox.ScreenBitmap.Width / CountXY;
  deltaY := FDrawBox.ScreenBitmap.Height / CountXY;
  HREF   := '" HREF="' + WebApp.Where + Name + '.click.';
  for x:=0 to CountXY-1 do
    for y:=0 to CountXY-1 do
      result := result + '<AREA SHAPE="rect" COORDS="' + IntToStr( Round( x*deltaX ) ) + ',' +
                IntToStr( Round( y*deltaY ) ) + ',' +
                IntToStr( Round( (x+1)*deltaX ) ) + ',' +
                IntToStr( Round( (y+1)*deltaY ) ) +
                HREF + IntToStr( Round( (x+0.5)*deltaX ) ) +'.' + IntToStr( Round( (y+0.5)*deltaY ) ) + '">';

  result := result + '</MAP>';


{
  result := '<IMG SRC="' + FFileURL + FileName + '?' + CreateClassID + '" BORDER=0' +
                   '     ALT="Test Image" onclick="location.href=''' +
                   WebApp.Where + Name + '.click.''+event.offsetX+''.''+event.offsetY">';
}
{
  result := '<FORM ACTION="' + WebApp.Where + Name + '" METHOD=get>' +
            '<input name="click" type="image" src="' + FFileURL + FileName + '?' + CreateClassID + '" BORDER=0>' +
            '</FORM>';
}
end;

function TWebEZMap.DoUpdate: Boolean;
var
  s : string;
begin
  Result := inherited DoUpdate;
//  if not result then exit;

  s := '';
  if ( FDrawBox = nil ) then
    s := 'Missing DrawBox property'
  else
  if ( FilePath = '' ) then
    s := 'No path supplied for the output file.'
  else
  if not DirectoryExists( FilePath ) then
    s := 'Invalid path supplied for the output file.';

  if ( FileName = '' ) then
    FileName := copy( Name, 1, 8 ) + '.jpg';


  Result := ( s = '' );
  if not result then
    Response.SendComment( ClassName + ': ' + s );
end;

procedure TWebEZMap.DoExecute;
Var
  s : string;
  x, y, posit : Integer;
begin
//  if not tpUpdated then exit;
  inherited DoExecute;

//  MessageBox( 0, PChar( Command ), '', 0 );
  if ( Command = '' ) then
  begin
    if Assigned( FDrawBox ) then FDrawBox.ZoomToExtension;
  end
  else
  if ( UpperCase( copy( Command, 1, 6 ) ) = 'CLICK.' ) then
  begin
    s := copy( Command, 7, Length( Command ) );
    posit := Pos( '.', s );
    if ( posit > 0 ) then
    begin
      x := StrToIntDef( copy( s, 1, posit-1 ), FDrawBox.Width div 2 );
      y := StrToIntDef( copy( s, posit+1, Length( s ) ), FDrawBox.Height div 2 );
      MyMouseDown( nil, x, y );
    end;
  end;

  Response.Send( MapHTML );
end;

procedure Register;
begin
  RegisterComponents( 'WebHub', [TWebEZMap] );
end;

end.
