unit GoogleAs_fmChromium;

{$I hrefdefines.inc}

interface

uses
  Windows, Messages, Graphics, Controls, Menus, Forms, StdCtrls, ExtCtrls,
  SysUtils, Variants, Classes,
  cefvcl, ceflib, cefgui, ceferr;

type

  // https://groups.google.com/forum/#!topic/delphichromiumembedded/F5PnymYBLww
  TfmChromiumWrapper = class(TForm)
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    miExit: TMenuItem;
    miBookmarks: TMenuItem;
    miTestVideo1: TMenuItem;
    miGoogle: TMenuItem;
    N1: TMenuItem;
    QuickLogin1: TMenuItem;
    Panel1: TPanel;
    Help1: TMenuItem;
    miAbout: TMenuItem;
    GooglePlus1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure TestVideo1Click(Sender: TObject);
    procedure miGoogleClick(Sender: TObject);
    procedure misureTreatClick(Sender: TObject);
    procedure QuickLogin1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure GooglePlus1Click(Sender: TObject);
  strict private
    { Private declarations }
    FZoomWhenMaximized, FZoomWhenNormal: Double;
    FChromium1: TChromium;
    FFlagInitOnce: Boolean;
    FActiveTitle: string;
    FStartURL: string;
  strict private
    Label1: TLabel;
    procedure CreateLabel;
  strict private
    procedure crmAddressChange(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring);
    procedure Chromium1KeyEvent(Sender: TObject; const browser: ICefBrowser;
      event: TCefHandlerKeyEventType; code, modifiers: Integer;
      isSystemKey, isAfterJavaScript: Boolean; out Result: Boolean);
    procedure Chromium1ContentsSizeChange(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      width, height: Integer);
    procedure Chromium1TitleChange(Sender: TObject; const browser: ICefBrowser;
      const title: ustring; out Result: Boolean);
    // procedure OnPressEvent(const AEvent: ICefDomEvent);
    // procedure OnExploreDOM(const ADocument: ICefDomDocument);
    procedure Chromium1LoadStart(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame);
    procedure Chromium1LoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer; out Result: Boolean);
  strict private
    procedure MakeWindowFullScreen;  // F11
    procedure MakeWindowNormal;      // Escape or F11 toggle-back
  protected
    procedure ForceColor;
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
    property Chromium1: TChromium read FChromium1;
  end;

var
  fmChromiumWrapper: TfmChromiumWrapper;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  TypInfo,
  uCode, ucDlgs, ucCodeSiteInterface;

procedure TfmChromiumWrapper.Chromium1ContentsSizeChange(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; width, height: Integer);
begin
  //MsgInfoOk(Format('Width %d height %d', [width, height]));
end;

procedure TfmChromiumWrapper.MakeWindowFullScreen;  // F11
const cFn = 'MakeWindowFullScreen';
begin
  CSEnterMethod(Self, cFn);
  Self.WindowState := wsMaximized;
  FChromium1.browser.ZoomLevel := FZoomWhenMaximized;  // default 100%
  Self.Menu := nil;
  FreeAndNil(Label1);
  Self.BorderStyle := bsNone;
  Self.Update;
  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.MakeWindowNormal; // Escape or F11 toggle-back
const cFn = 'MakeWindowNormal';
begin
  CSEnterMethod(Self, cFn);
  Self.WindowState := wsNormal;
  Self.BorderStyle := bsSizeable;
  CreateLabel;
  Self.Menu := MainMenu1;
  CSSend('MainMenu1 Assigned', S(Assigned(MainMenu1)));
  CSSend('Self.Menu Assigned', S(Assigned(Self.Menu)));
  Label1.Caption := FActiveTitle;
  FChromium1.browser.ZoomLevel := FZoomWhenNormal;
  //Self.Update;
  Application.ProcessMessages;
  CSExitMethod(Self, cFn);
end;

var
  bLogKeystrokes: Boolean = True;

procedure TfmChromiumWrapper.Chromium1KeyEvent(Sender: TObject; const browser: ICefBrowser;
  event: TCefHandlerKeyEventType; code, modifiers: Integer; isSystemKey,
  isAfterJavaScript: Boolean; out Result: Boolean);
const cFn = 'Chromium1KeyEvent';
begin
  if bLogKeystrokes then
  begin
    CSEnterMethod(Self, cFn);
    CSSend(Format('Code %d Modifiers %d IsSystemKey %s, IsAfterJS %s',
      [Code, Modifiers, BoolToStr(IsSystemKey, True),
      BoolToStr(IsAfterJavaScript, True)]));
  end;

  case code of
    27:   // Esc
    begin
      if Modifiers = 0 then
      begin
        if Self.WindowState = wsMaximized then
          MakeWindowNormal;
        Result := True;
      end;
    end;
    48:
    begin
      if Modifiers = 2 then  // Ctrl 0
      begin
        browser.ZoomLevel := 1.0;  // default 100%
        if WindowState = wsMaximized then
          FZoomWhenMaximized := browser.ZoomLevel
        else
          FZoomWhenNormal := browser.ZoomLevel;
        Result := True;
      end;
    end;
    187:
    begin
      if Modifiers = 2 then  // Ctrl +
      begin
        browser.ZoomLevel := browser.ZoomLevel + 0.2;
        if WindowState = wsMaximized then
          FZoomWhenMaximized := browser.ZoomLevel
        else
          FZoomWhenNormal := browser.ZoomLevel;
        Result := True;
      end;
    end;
    189:
    begin
      if Modifiers = 2 then  // Ctrl -
      begin
        browser.ZoomLevel := browser.ZoomLevel - 0.2;
        if WindowState = wsMaximized then
          FZoomWhenMaximized := browser.ZoomLevel
        else
          FZoomWhenNormal := browser.ZoomLevel;
        Result := True;
      end;
    end;
    122:  // F11
    begin
      CSSend('WindowState', GetEnumName(TypeInfo(TWindowState),
        Ord(Self.WindowState)));
      if Self.WindowState = wsMaximized then
      begin
        MakeWindowNormal;
      end
      else
      begin
        MakeWindowFullScreen;
      end;
      Result := False;
    end;
    else
      Result := False;
  end;
  if bLogKeystrokes then CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.Chromium1TitleChange(Sender: TObject;
  const browser: ICefBrowser; const title: ustring; out Result: Boolean);
begin
  FActiveTitle := Title;
  if Assigned(Label1) then
    Label1.Caption := Title;
  Result := True;
end;

procedure TfmChromiumWrapper.CreateLabel;
begin
  if NOT Assigned(Label1) then
  begin
    Label1 := TLabel.Create(Self);
    Label1.Name := 'Label1';
    Label1.Parent := Self;
    Label1.Align := alTop;
    Label1.Caption := 'Loading...';
    Label1.Color := clInactiveCaption;
  end;
end;

procedure TfmChromiumWrapper.crmAddressChange(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const url: ustring);
const cFn = 'crmAddressChange';
begin
  if (browser.GetWindowHandle = FChromium1.BrowserHandle) and
    ((frame = nil) or (frame.IsMain)) then
  begin
    //CSSend(cFn + ': url', url);
    Self.Caption := url;
  end;
end;

procedure TfmChromiumWrapper.Chromium1LoadStart(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame);
const cFn = 'Chromium1LoadStart';
begin
  CSEnterMethod(Self, cFn);
  // placeholder
  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.TestVideo1Click(Sender: TObject);
const
  //cTestVideo = 'http://techslides.com/sample-webm-ogg-and-mp4-video-files-for-html5/';
  cTestQuickTime =
    'http://www.oit.uci.edu/computing/stream/samples/index.html';
begin
  Self.Caption := cTestQuickTime;
  FChromium1.Load(cTestQuickTime);
end;

procedure TfmChromiumWrapper.miAboutClick(Sender: TObject);
var
  Delphi: string;
begin
  Delphi := 'Delphi ' + PascalCompilerCode;
  MsgInfoOk('Compiled with ' + Delphi + sLineBreak + sLineBreak +
    'and TChromium (CEF1)' + sLineBreak + sLineBreak +
    'Pass email and password as command line parameters for Quick Login');
end;

procedure TfmChromiumWrapper.miExitClick(Sender: TObject);
begin
  ModalResult := mrOk;
  Self.Close;
end;

procedure TfmChromiumWrapper.ForceColor;
const
  cTargetColor = $CD5A6A; // 43; //0; // $CD5A6A;
begin
  CSSend('FChromium1.Color', GetEnumName(TypeInfo(TColor),
    Ord(FChromium1.Color)));
  FChromium1.Color := 0;
  FChromium1.Color := cTargetColor;
  //FChromium1.Browser.Color := cTargetColor;
  if Assigned(Label1) then
    Label1.Color := clInactiveCaption;
  Panel1.Color := clInActiveCaption;
  Self.Color :=  cTargetColor;
  CSSend('FChromium1.Color', GetEnumName(TypeInfo(TColor),
    Ord(FChromium1.Color)));
end;

procedure TfmChromiumWrapper.FormActivate(Sender: TObject);
var
  ErrorText: string;
begin
  if NOT FFlagInitOnce then
    Init(ErrorText);
end;

procedure TfmChromiumWrapper.FormCreate(Sender: TObject);
//var
//  xTop, xLeft: Integer;
begin
  FFlagInitOnce := False;
  Self.Top := 10; // xTop;
  Self.Left := 150; //xLeft;
  Self.Height := 768 + 120;
  Self.Width := 1024 + 120;
  Application.Title := 'Chromium Embedded Framework 1';
  FActiveTitle := Application.Title;
  FStartURL := 'https://plus.google.com';
  FChromium1 := nil;
  CreateLabel;
end;

procedure TfmChromiumWrapper.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FChromium1);
end;

procedure TfmChromiumWrapper.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const cFn = 'FormKeyDown';
begin
  CSEnterMethod(Self, cFn);
  CSSend('key as integer', S(key));
  case key of
    122: MakeWindowFullScreen;   // F11
  end;
  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.FormResize(Sender: TObject);
const cFn = 'FormResize';
begin
  //This is called much more often than when the user drags the window size.
  //CSEnterMethod(Self, cFn);
  //CSSend('Top', S(Self.Top));
  //CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.GooglePlus1Click(Sender: TObject);
const
  cGooglePlus = 'https://plus.google.com/';
begin
  Self.Caption := cGooglePlus;
  FChromium1.Load(cGooglePlus);
end;

procedure TfmChromiumWrapper.miGoogleClick(Sender: TObject);
const
  cGoogle = 'http://www.google.com/';
begin
  Self.Caption := cGoogle;
  FChromium1.Load(cGoogle);
end;

function TfmChromiumWrapper.Init(out ErrorText: string): Boolean;
begin
  ErrorText := '';

  if NOT FFlagInitOnce then
  begin
    FChromium1 := TChromium.Create(Self);
    FChromium1.Name := 'Chromium1';

    with FChromium1 do
    begin
      Parent := Panel1;
      Align := alClient;
      TabOrder := 0;
      OnContentsSizeChange := Chromium1ContentsSizeChange;
      OnAddressChange := crmAddressChange;
      OnTitleChange := Chromium1TitleChange;
      OnKeyEvent := Chromium1KeyEvent;
      OnLoadStart := Chromium1LoadStart;
      OnLoadEnd := Chromium1LoadEnd;
      Options.HistoryDisabled := True;
      Options.EncodingDetectorEnabled := True;
      Options.HyperlinkAuditingDisabled := True;
      Options.LocalStorageDisabled := True;
      Options.DatabasesDisabled := True;
      Options.FullscreenEnabled := True;
      Options.AcceleratedPaintingDisabled := False;
      Options.AcceleratedFiltersDisabled := False;
      Options.AcceleratedPluginsDisabled := False;
      DefaultUrl := 'about:blank';
      //UserStyleSheetLocation := CSSHeader + CSSBase64;
      //Options.UserStyleSheetEnabled := True;
      //ReCreateBrowser('about:blank');
    end;

    ForceColor;

    if Assigned(FChromium1) and Assigned(FChromium1.Browser) then
      CSSend('Default FChromium1.Browser.ZoomLevel',
        FloatToStr(FChromium1.Browser.ZoomLevel));

    CSSendNote('TCefRTTIExtension.Register');

    FChromium1.Load(FStartURL);

    FFlagInitOnce := True;
  end;
  Result := FFlagInitOnce;
end;

(*
procedure TfmChromiumWrapper.OnPressEvent(const AEvent: ICefDomEvent);
const cFn = 'OnPressEvent';
begin
  CSEnterMethod(Self, cFn);
  //ShellExecute(Form1.Handle, nil, 'notepad.exe', nil, nil, SW_SHOWNORMAL);

  CSExitMethod(Self, cFn);
end;
*)

procedure TfmChromiumWrapper.QuickLogin1Click(Sender: TObject);
const cFn = 'QuickLogin1Click';
var
  JSText: string;
  email: string;
  pass: string;
begin
  CSEnterMethod(Self, cFn);
  if ParamCount = 2 then
  begin
    email := ParamStr(1);
    pass := ParamStr(2);
    JSText := 'document.getElementById("Email").value = "' + email + '";';
    //CSSend('JSText', JSText);
    FChromium1.Browser.MainFrame.ExecuteJavaScript(JSText, '', 0);

    JSText := 'document.getElementById("Passwd").value = "' + pass + '";';
    FChromium1.Browser.MainFrame.ExecuteJavaScript(JSText, '', 0);
  end
  else
  begin
    MsgErrorOk('2 command line parameters are required for ' +
    'Quick Login at Google Plus: email and password');
  end;

  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.misureTreatClick(Sender: TObject);
begin
  FChromium1.Load(FStartURL);
end;

(*
procedure TfmChromiumWrapper.OnExploreDOM(const ADocument: ICefDomDocument);
const cFn = 'OnExploreDOM';
var
  DOMNode: ICefDomNode;
begin
  CSEnterMethod(Self, cFn);

  DOMNode := ADocument.GetElementById('btnConfirmDSR');
  if Assigned(DOMNode) then
  begin
    DOMNode.SetElementAttribute('onclick', 'return false;');
    DOMNode.AddEventListenerProc('click', True, OnPressEvent);
    //DOMNode.AddEventListenerProc('touchstart', True, OnPressEvent);
  end;

  CSExitMethod(Self, cFn);
end;
*)

procedure TfmChromiumWrapper.Chromium1LoadEnd(Sender: TObject;
  const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer; out Result: Boolean);
const cFn = 'Chromium1LoadEnd';
var
  FrameUrl: string;
  ZoomShouldBe: Double;
begin
  CSEnterMethod(Self, cFn);
  //Panel1.Visible := True;  // this does not eliminate the flash to blank color
  //FChromium1.Visible := True;
  //Self.Update;

  CSSend('FChromium1.Color', GetEnumName(TypeInfo(TColor),
    Ord(FChromium1.Color)));
  FChromium1.Color := 0;
  FChromium1.Color := $DCDCDC; //$C0C0C0; // clRed;
  CSSend('FChromium1.Color', GetEnumName(TypeInfo(TColor),
    Ord(FChromium1.Color)));

  //FChromium1.UserStyleSheetLocation := CSSHeader + CSSBase64;
  //FChromium1.Options.UserStyleSheetEnabled := True;

  // Control the Zoom Level *after* content has loaded
  CSSend('FChromium1.Browser.ZoomLevel', FloatToStr(FChromium1.Browser.ZoomLevel));
  if WindowState = wsMaximized then
    ZoomShouldBe := FZoomWhenMaximized
  else
    ZoomShouldBe := FZoomWhenNormal;
  if FChromium1.Browser.ZoomLevel <> ZoomShouldBe then
  begin
    FChromium1.Browser.ZoomLevel := ZoomShouldBe;
    CSSend('Adjusted to FChromium1.Browser.ZoomLevel', FloatToStr(FChromium1.Browser.ZoomLevel));
  end;

  if Assigned(frame) then
  begin
    FrameUrl := frame.Url;
    CSSend('frame.Url', FrameUrl);
    (*
    // here you should check the frame.Url to verify if you're on the right URL
    // before you try to search for the element and attach the event if found
    *)
  end;
  Result := True;
  CSExitMethod(Self, cFn);
end;

(*
procedure TMainForm.actPrintExecute(Sender: TObject);
begin
  if FChromium1.Browser <> nil then
    FChromium1.Browser.MainFrame.Print;
end;

procedure TMainForm.actGetSourceExecute(Sender: TObject);
var
  frame: ICefFrame;
  source: ustring;
begin
  if FChromium1.Browser <> nil then
  begin
    frame := FChromium1.Browser.MainFrame;
    source := frame.Source;
    //source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
    //source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
    //source := '<html><body>Source:<pre>' + source + '</pre></body></html>';
    //NB is this how you can load HTML from string into the gui ?
    //frame.LoadString(source, 'http://tests/getsource');
  end;
end;

*)

end.
