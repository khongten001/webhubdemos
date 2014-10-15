unit DPrefix_Client_uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Edit,
  FMX.WebBrowser, FMX.Layouts, FMX.Controls.Presentation, System.Sensors,
  System.Sensors.Components, FMX.Memo, System.Android.Sensors;

const
  cSurferLingvo = 'por';  // or 'por' for Brazil

type
  TWebBrowserForm = class(TForm)
    WebBrowser1: TWebBrowser;
    btnGO: TButton;
    btnBack: TButton;
    btnForward: TButton;
    ToolBar1: TToolBar;
    StatusBar1: TStatusBar;
    btnExit: TButton;
    SpeedHide: TSpeedButton;
    LocationSensor1: TLocationSensor;
    edtURL: TEdit;
    procedure btnGOClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnForwardClick(Sender: TObject);
    procedure edtURLKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure SpeedHideClick(Sender: TObject);
    procedure WebBrowser1DidFinishLoad(ASender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
    procedure WebBrowser1DidStartLoad(ASender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FLatestLat, FLatestLon: Double;
    FLatestAddress: TCivicAddress;
    FGeocoder: TGeocoder;
    procedure OnGeocodeReverseEvent(const Address: TCivicAddress);  public
    procedure LoadWelcomeImage;
    procedure LoadGoodbyeImage;
    { Public declarations }
  end;

var
  WebBrowserForm: TWebBrowserForm;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.Macintosh.fmx _MACOS}

uses DPrefix_Client_uInitialize;

{Android: The required permissions have been set under Project-Options}

procedure TWebBrowserForm.btnGOClick(Sender: TObject);
begin
  { Passing the URL entered in the edit-box to the Web Browser component. }
  WebBrowser1.EnableCaching := False;
  WebBrowser1.URL := edtURL.Text;
end;

procedure TWebBrowserForm.Button2Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TWebBrowserForm.edtURLKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    { navigate and hide the virtual keyboard when setting focus to GO button }
    WebBrowser1.URL := edtURL.Text;
    btnGO.SetFocus;
  end;
end;

var
  AlreadyActivated: Boolean = False;

procedure TWebBrowserForm.FormActivate(Sender: TObject);
var
  S1: string;
begin
  if NOT AlreadyActivated then
  begin
    LoadWelcomeImage;
    AlreadyActivated := True;
    LocationSensor1.Active := True;
    EdtURL.Text :=
      'http://delphiprefix.modulab.com/win64/runisa_x_d21_win64.dll?dpr:pgmobile';
    if High(DPR_API_TradukoList_Rec.TradukiList) > 0 then
    begin
      S1 := Translate(btnGo.Name, cSurferLingvo);
      btnGO.Text := S1;
      S1 := Translate(btnExit.Name, cSurferLingvo);
      btnExit.Text := S1;
    end;
    WebBrowser1.Navigate(edtURL.Text);
  end;
end;

procedure TWebBrowserForm.FormCreate(Sender: TObject);
begin
  WebBrowser1.EnableCaching := False;  // feature works if set at runtime
end;

procedure TWebBrowserForm.LoadGoodbyeImage;
var
  GoodbyeSVG: string;
  sb: TStringList;
begin
  sb := nil;

  if High(DPR_API_ImageList_Rec.ImageList) >= 1 then
  try
    sb := TStringList.Create;
    sb.LoadFromFile(DPR_API_ImageList_Rec.ImageList[1].LocalFilespec);
    if sb.Count > 0 then
    begin
      GoodbyeSVG := sb.Text;
      WebBrowser1.LoadFromStrings(GoodbyeSVG, 'file:///' +
        DPR_API_ImageList_Rec.ImageList[1].LocalFilespec);
    end;
  finally
    FreeAndNil(sb);
  end;

end;

procedure TWebBrowserForm.LoadWelcomeImage;
var
  WelcomeSVG: string;
  sb: TStringList;
  ErrorText: string;
begin
  sb := nil;
  Client_Init(ErrorText);
  if (ErrorText = '') then
  begin
    if High(DPR_API_ImageList_Rec.ImageList) >= 0 then
    try
      sb := TStringList.Create;
      sb.LoadFromFile(DPR_API_ImageList_Rec.ImageList[0].LocalFilespec);
      if sb.Count > 0 then
      begin
        WelcomeSVG := sb.Text;
        WebBrowser1.LoadFromStrings(WelcomeSVG, 'file:///' +
          DPR_API_ImageList_Rec.ImageList[0].LocalFilespec);
      end;
    finally
      FreeAndNil(sb);
    end;
  end;
end;

procedure TWebBrowserForm.LocationSensor1LocationChanged(Sender: TObject;
  const OldLocation, NewLocation: TLocationCoord2D);
begin
  FLatestLat := NewLocation.Latitude;
  FLatestLon := NewLocation.Longitude;

 // Setup an instance of TGeocoder
  if not Assigned(FGeocoder) then
  begin
    if Assigned(TGeocoder.Current) then
      FGeocoder := TGeocoder.Current.Create;
    if Assigned(FGeocoder) then
      FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
  end;

  // Translate location to address
  if Assigned(FGeocoder) and not FGeocoder.Geocoding then
  try
    FGeocoder.GeocodeReverse(NewLocation);
  except
    on E: Exception do
    begin
      // forget about it!
    end;

  end;
end;

procedure TWebBrowserForm.OnGeocodeReverseEvent(const Address: TCivicAddress);
begin
  FLatestAddress := Address;
  //edtURL.Text := edtURL.Text + Address.CountryName;
  {
  ListBoxItemAdminArea.ItemData.Detail       := Address.AdminArea;
  ListBoxItemCountryCode.ItemData.Detail     := Address.CountryCode;
  ListBoxItemCountryName.ItemData.Detail     := Address.CountryName;
  ListBoxItemFeatureName.ItemData.Detail     := Address.FeatureName;
  ListBoxItemLocality.ItemData.Detail        := Address.Locality;
  ListBoxItemPostalCode.ItemData.Detail      := Address.PostalCode;
  ListBoxItemSubAdminArea.ItemData.Detail    := Address.SubAdminArea;
  ListBoxItemSubLocality.ItemData.Detail     := Address.SubLocality;
  ListBoxItemSubThoroughfare.ItemData.Detail := Address.SubThoroughfare;
  ListBoxItemThoroughfare.ItemData.Detail    := Address.Thoroughfare;
  }
end;

procedure TWebBrowserForm.SpeedHideClick(Sender: TObject);
begin
  Toolbar1.Visible := NOT Toolbar1.Visible;
end;

procedure TWebBrowserForm.WebBrowser1DidFinishLoad(ASender: TObject);
begin
  edtURL.Text := WebBrowser1.URL;
end;

procedure TWebBrowserForm.WebBrowser1DidStartLoad(ASender: TObject);
var
  AURL: string;
begin
  AURL := TWebBrowser(ASender).URL;
  if (Pos('pgDonate', AURL) > 0) then
  begin
    if (Pos(':country=', AURL) = 0) then
    begin
      if Assigned(FLatestAddress) then
        TWebBrowser(ASender).URL := AURL + ':country=' +
          FLatestAddress.CountryCode;
    end;
  end;
end;

procedure TWebBrowserForm.btnBackClick(Sender: TObject);
begin
  { move back one page in the history }
  WebBrowser1.GoBack;
end;

procedure TWebBrowserForm.btnExitClick(Sender: TObject);
begin
  EdtURL.Visible := False;
  LoadGoodbyeImage;
  Sleep(1500);
  Self.Close;
end;

procedure TWebBrowserForm.btnForwardClick(Sender: TObject);
begin
  { move forward one page in the history }
  WebBrowser1.GoForward;
end;

end.
