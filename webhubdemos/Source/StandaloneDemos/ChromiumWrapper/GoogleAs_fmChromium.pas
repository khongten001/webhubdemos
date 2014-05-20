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
    SlowPageTest1: TMenuItem;
    N2: TMenuItem;
    LargePageTest1: TMenuItem;
    miGoogleCalendar1: TMenuItem;
    miGoogleWebmasterTools: TMenuItem;
    miEnterURL: TMenuItem;
    GoogleAdsense1: TMenuItem;
    GoogleMail1: TMenuItem;
    N3: TMenuItem;
    View1: TMenuItem;
    miURL: TMenuItem;
    PanelURL: TPanel;
    MemoURL: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure TestVideo1Click(Sender: TObject);
    procedure miGoogleClick(Sender: TObject);
    procedure QuickLogin1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure GooglePlus1Click(Sender: TObject);
    procedure SlowPageTest1Click(Sender: TObject);
    procedure LargePageTest1Click(Sender: TObject);
    procedure miGoogleCalendar1Click(Sender: TObject);
    procedure miGoogleWebmasterToolsClick(Sender: TObject);
    procedure miEnterURLClick(Sender: TObject);
    procedure GoogleAdsense1Click(Sender: TObject);
    procedure GoogleMail1Click(Sender: TObject);
    procedure miURLClick(Sender: TObject);
  strict private
    { Private declarations }
    FZoomWhenMaximized, FZoomWhenNormal: Double;
    FChromium1: TChromium;
    FFlagInitOnce: Boolean;
    FShowTitleInfo: Boolean;
    FActiveTitle: string;
    FStartURL: string;
    FLastF11OnAt: TDateTime;
    procedure NoteNewURL(const InURL: string);
    function IsMain(const b: ICefBrowser; const f: ICefFrame): Boolean;
    procedure ShowPopupMenu;
  strict private
    Label1: TLabel;
    procedure CreateLabel;
    procedure ProcessKey_Esc;
    procedure ProcessKey_F11;
    procedure ProcessKey_F12;
    procedure ProcessKey_CtrlPlus(const browser: ICefBrowser);
    procedure ProcessKey_CtrlMinus(const browser: ICefBrowser);
    procedure ProcessKey_CtrlZero(const browser: ICefBrowser);
  strict private
    procedure crmAddressChange(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring);
    {$IFDEF CEF3}
    procedure Chromium3KeyEvent(Sender: TObject; const browser: ICefBrowser;
      const event: PCefKeyEvent;  osEvent: TCefEventHandle; out Result: Boolean);
    {$ELSE}
    procedure Chromium1KeyEvent(Sender: TObject; const browser: ICefBrowser;
      event: TCefHandlerKeyEventType; code, modifiers: Integer;
      isSystemKey, isAfterJavaScript: Boolean; out Result: Boolean);
    procedure Chromium1ContentsSizeChange(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      width, height: Integer);
    {$ENDIF}
    procedure Chromium1TitleChange(Sender: TObject; const browser: ICefBrowser;
      const title: ustring {$IFNDEF CEF3}; out Result: Boolean{$ENDIF});
    // procedure OnPressEvent(const AEvent: ICefDomEvent);
    // procedure OnExploreDOM(const ADocument: ICefDomDocument);
    procedure Chromium1LoadStart(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame);
    procedure Chromium1LoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer {$IFNDEF CEF3}; out Result: Boolean{$ENDIF});
  strict private
    procedure MakeWindowFullScreen;  // F11
    procedure MakeWindowNormal;
  private
    {$IFNDEF CEF3}
    procedure Chromium1ContentsSizeChange(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame; width,
      height: Integer);
    {$ENDIF}
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
  TypInfo, Dialogs, DateUtils,
  uCode, ucDlgs, ucCodeSiteInterface, GoogleAs_uCEF3_Init;

{$IFNDEF CEF3}
procedure TfmChromiumWrapper.Chromium1ContentsSizeChange(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; width, height: Integer);
begin
  //MsgInfoOk(Format('Width %d height %d', [width, height]));
end;
{$ENDIF}

procedure TfmChromiumWrapper.MakeWindowFullScreen;  // F11
const cFn = 'MakeWindowFullScreen';
begin
  CSEnterMethod(Self, cFn);
  Self.WindowState := wsMaximized;
  {$IFDEF CEF3}
  FChromium1.Browser.Host.ZoomLevel := FZoomWhenMaximized;  // default 100%
  {$ELSE}
  FChromium1.browser.ZoomLevel := FZoomWhenMaximized;  // default 100%
  {$ENDIF}
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
  {$IFDEF CEF3}
  FChromium1.Browser.Host.ZoomLevel := FZoomWhenMaximized;  // default 100%
  {$ELSE}
  FChromium1.browser.ZoomLevel := FZoomWhenMaximized;
  {$ENDIF}
  //Self.Update;
  Application.ProcessMessages;
  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.ProcessKey_CtrlMinus(const browser: ICefBrowser);
const cFn = 'ProcessKey_CtrlMinus';
var
  x: Extended;
begin
  CSEnterMethod(Self, cFn);

  {$IFDEF CEF3}
  browser.Host.ZoomLevel := browser.Host.ZoomLevel - 0.2;
  x := browser.Host.ZoomLevel;
  {$ELSE}
  browser.ZoomLevel := browser.ZoomLevel - 0.2;
  x := browser.ZoomLevel;
  {$ENDIF}
  if WindowState = wsMaximized then
    FZoomWhenMaximized := x
  else
    FZoomWhenNormal := x;
  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.ProcessKey_CtrlPlus(const browser: ICefBrowser);
const cFn = 'ProcessKey_CtrlPlus';
var
  x: Extended;
begin
  CSEnterMethod(Self, cFn);
  {$IFDEF CEF3}
  browser.Host.ZoomLevel := browser.Host.ZoomLevel + 0.2;
  x := browser.Host.ZoomLevel;
  {$ELSE}
  browser.ZoomLevel := browser.ZoomLevel + 0.2;
  x := browser.ZoomLevel;
  {$ENDIF}
  if WindowState = wsMaximized then
    FZoomWhenMaximized := x
  else
    FZoomWhenNormal := x;
  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.ProcessKey_CtrlZero(const browser: ICefBrowser);
const cFn = 'ProcessKey_CtrlZero';
var
  x: Extended;
begin
  CSEnterMethod(Self, cFn);

  {$IFDEF CEF3}
  browser.Host.ZoomLevel := 1.0;
  x := browser.Host.ZoomLevel;
  {$ELSE}
  browser.ZoomLevel := 1.0;  // default 100%
  x := browser.ZoomLevel;
  {$ENDIF}

  if WindowState = wsMaximized then
    FZoomWhenMaximized := x
  else
    FZoomWhenNormal := x;
  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.ProcessKey_Esc;
const cFn = 'ProcessKey_Esc';
begin
  CSEnterMethod(Self, cFn);
  if Self.BorderStyle = bsNone then
  begin
    MakeWindowNormal;
  end;
  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.ProcessKey_F11;
const cFn = 'ProcessKey_F11';
begin
  CSEnterMethod(Self, cFn);
  CSSend('BorderStyle', GetEnumName(TypeInfo(TBorderStyle),
    Ord(Self.BorderStyle)));
  if DateUtils.MilliSecondSpan(Now, FLastF11OnAt) > 750 then
  begin
    if Self.BorderStyle <> bsNone then
      MakeWindowFullScreen
    else
      MakeWindowNormal;
    FLastF11OnAt := Now;
  end
  else
  begin
    // The F11 key comes through twice for some reason.
    CSSendWarning('F11 too quick - discarded');
  end;
  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.ProcessKey_F12;
const cFn = 'ProcessKey_F12';
begin
  CSEnterMethod(Self, cFn);
  ShowPopupMenu;
  CSExitMethod(Self, cFn);
end;

var
  bLogKeystrokes: Boolean = True;

{$IFNDEF CEF3}
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
        {$IFDEF CEF3}
        browser.host.ZoomLevel := 1.0;  // default 100%
        {$ELSE}
        browser.ZoomLevel := 1.0;  // default 100%
        {$ENDIF}
        if WindowState = wsMaximized then
          FZoomWhenMaximized := {$IFDEF CEF3}browser.host.ZoomLevel{$ELSE}browser.ZoomLevel{$ENDIF}
        else
          FZoomWhenNormal := {$IFDEF CEF3}browser.host.ZoomLevel{$ELSE}browser.ZoomLevel{$ENDIF};
        Result := True;
      end;
    end;
    187:
    begin
      if Modifiers = 2 then  // Ctrl +
      begin
        {$IFDEF CEF3}
        browser.host.ZoomLevel := browser.host.ZoomLevel + 0.2;
        {$ELSE}
        browser.ZoomLevel := browser.ZoomLevel + 0.2;
        {$ENDIF}
        if WindowState = wsMaximized then
          FZoomWhenMaximized := {$IFDEF CEF3}browser.host.ZoomLevel{$ELSE}browser.ZoomLevel{$ENDIF}
        else
          FZoomWhenNormal := {$IFDEF CEF3}browser.host.ZoomLevel{$ELSE}browser.ZoomLevel{$ENDIF};
        Result := True;
      end;
    end;
    189:
    begin
      if Modifiers = 2 then  // Ctrl -
      begin
        {$IFDEF CEF3}
        browser.host.ZoomLevel := browser.host.ZoomLevel - 0.2;
        {$ELSE}
        browser.ZoomLevel := browser.ZoomLevel - 0.2;
        {$ENDIF}
        if WindowState = wsMaximized then
          FZoomWhenMaximized := {$IFDEF CEF3}browser.host.ZoomLevel{$ELSE}browser.ZoomLevel{$ENDIF}
        else
          FZoomWhenNormal := {$IFDEF CEF3}browser.host.ZoomLevel{$ELSE}browser.ZoomLevel{$ENDIF};
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
{$ENDIF}

procedure TfmChromiumWrapper.Chromium1TitleChange(Sender: TObject;
  const browser: ICefBrowser; const title: ustring {$IFNDEF CEF3};
  out Result: Boolean{$ENDIF});
begin
  FActiveTitle := Title;
  if Assigned(Label1) then
    Label1.Caption := Title;
  {$IFNDEF CEF3}Result := True;{$ENDIF}
end;

{$IFDEF CEF3}
procedure TfmChromiumWrapper.Chromium3KeyEvent(Sender: TObject; const browser: ICefBrowser;
      const event: PCefKeyEvent;  osEvent: TCefEventHandle; out Result: Boolean);
const cFn = 'Chromium3KeyEvent';
begin
  if bLogKeystrokes then
  begin
    CSEnterMethod(Self, cFn);
    if event.windows_key_code <> 17 then
      CSSend(Format('event.windows_key_code=%d; Ctrl Key Down=%s',
        [event.windows_key_code, S(EVENTFLAG_CONTROL_DOWN in event.modifiers)]));
  end;

  case event.windows_key_code of
     27: begin ProcessKey_Esc; Result := True; end;
    122: begin ProcessKey_F11; Result := True; end;
    123: begin ProcessKey_F12; Result := True; end;
     48:
    begin
      if (EVENTFLAG_CONTROL_DOWN in event.modifiers) then  // Ctrl Zero
      begin
        ProcessKey_CtrlZero(browser);
        Result := True;
      end;
    end;
    107, 187:  // regular + and numpad +
    begin
      if (EVENTFLAG_CONTROL_DOWN in event.modifiers) then  // Ctrl Plus
      begin
        ProcessKey_CtrlPlus(browser);
        Result := True;
      end;
    end;
    109, 189:
    begin
      if (EVENTFLAG_CONTROL_DOWN in event.modifiers) then  // Ctrl Minus
      begin
        ProcessKey_CtrlMinus(browser);
        Result := True;
      end;
    end;
  end;

  if bLogKeystrokes then
    CSExitMethod(Self, cFn);
end;
{$ENDIF}

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
  if FShowTitleInfo then
  begin
    if IsMain(browser, frame) then
    begin
      //CSSend(cFn + ': url', url);
      Self.Caption := url;
      NoteNewURL(url);
    end;
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

procedure TfmChromiumWrapper.miURLClick(Sender: TObject);
begin
  miURL.Checked := NOT miURL.Checked;
  PanelURL.Visible := miURL.Checked;
end;

procedure TfmChromiumWrapper.NoteNewURL(const InURL: string);
begin
  while MemoURL.Lines.Count > 7 do
    MemoURL.Lines.Delete(0);
  MemoURL.Lines.Add(InURL);
end;

procedure TfmChromiumWrapper.miAboutClick(Sender: TObject);
var
  Delphi: string;
begin
  Delphi := 'Delphi ' + PascalCompilerCode;
  MsgInfoOk('Compiled with ' + Delphi + sLineBreak + sLineBreak +
    'and TChromium (' + {$IFDEF CEF3}'CEF3'{$ELSE}'CEF1'{$ENDIF} + ')' +
    sLineBreak + sLineBreak +
    'Pass email and password as command line parameters for Quick Login' +
    sLineBreak + sLineBreak +
    'Source code in webhubdemos project' + sLineBreak +
    'c/o HREF Tools Corp.' + sLineBreak +
    'http://lite.demos.href.com/demos');
end;

procedure TfmChromiumWrapper.miEnterURLClick(Sender: TObject);
var
  AURL: string;
begin
  AURL := InputBox('', 'Enter URL', 'http://');
  if Copy(AURL, 1, 4) = 'http' then
  begin
    Self.Caption := AURL;
    FChromium1.Load(AURL);
  end;
end;

procedure TfmChromiumWrapper.miExitClick(Sender: TObject);
begin
  ModalResult := mrOk;
  Self.Close;
end;

procedure TfmChromiumWrapper.ForceColor;
const
  cFn = 'ForceColor';
  cTargetColor = $CD5A6A; // 43; //0; // $CD5A6A;
begin
  CSSend(cFn + ': FChromium1.Color', GetEnumName(TypeInfo(TColor),
    Ord(FChromium1.Color)));
  FChromium1.Color := 0;
  FChromium1.Color := cTargetColor;
  //FChromium1.Browser.Color := cTargetColor;
  if Assigned(Label1) then
    Label1.Color := clInactiveCaption;
  Panel1.Color := clInActiveCaption;
  Self.Color :=  cTargetColor;
  CSSend(cFn + ': FChromium1.Color', GetEnumName(TypeInfo(TColor),
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
const cFn = 'FormCreate';
//var
//  xTop, xLeft: Integer;
begin
  CSEnterMethod(Self, cFn);
  FFlagInitOnce := False;
  FShowTitleInfo := False;
  PanelURL.Visible := False;
  MemoURL.Clear;
  MemoURL.WordWrap := False;
  miURL.Checked := False;
  Self.Top := 10; // xTop;
  Self.Left := 150; //xLeft;
  Self.Height := 768 + 120;
  Self.Width := 1024 + 120;
  Application.Title := 'Chromium Embedded Framework 1';
  FActiveTitle := Application.Title;
  FStartURL := 'https://plus.google.com';
  FChromium1 := nil;
  CreateLabel;
  CSExitMethod(Self, cFn);
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

procedure TfmChromiumWrapper.GoogleAdsense1Click(Sender: TObject);
const
  cGoogleAdsense = 'http://www.google.com/adsense';
begin
  Self.Caption := cGoogleAdsense;
  FChromium1.Load(cGoogleAdsense);
end;

procedure TfmChromiumWrapper.GoogleMail1Click(Sender: TObject);
const
  cGoogle = 'http://mail.google.com/';
begin
  Self.Caption := cGoogle;
  FChromium1.Load(cGoogle);
end;

procedure TfmChromiumWrapper.GooglePlus1Click(Sender: TObject);
const
  cGooglePlus = 'https://plus.google.com/';
begin
  Self.Caption := cGooglePlus;
  FChromium1.Load(cGooglePlus);
end;

procedure TfmChromiumWrapper.miGoogleCalendar1Click(Sender: TObject);
const
  cAddr = 'https://www.google.com/calendar/';
begin
  Self.Caption := cAddr;
  FChromium1.Load(cAddr);
end;

procedure TfmChromiumWrapper.miGoogleClick(Sender: TObject);
const
  cGoogle = 'http://www.google.com/';
begin
  Self.Caption := cGoogle;
  FChromium1.Load(cGoogle);
end;

procedure TfmChromiumWrapper.miGoogleWebmasterToolsClick(Sender: TObject);
const
  cAddr = 'http://www.google.com/webmasters/tools/';
begin
  Self.Caption := cAddr;
  FChromium1.Load(cAddr);
end;

function TfmChromiumWrapper.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  CSEnterMethod(Self, cFn);
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
      {$IFNDEF CEF3}
      OnContentsSizeChange := Chromium1ContentsSizeChange;
      {$ENDIF}
      OnAddressChange := crmAddressChange;
      OnTitleChange := Chromium1TitleChange;
      {$IFDEF CEF3}
      OnKeyEvent := Chromium3KeyEvent;
      {$ELSE}
      OnKeyEvent := Chromium1KeyEvent;
      {$ENDIF}
      OnLoadStart := Chromium1LoadStart;
      OnLoadEnd := Chromium1LoadEnd;
      {$IFNDEF CEF3}
      Options.HistoryDisabled := True;
      Options.EncodingDetectorEnabled := True;
      Options.HyperlinkAuditingDisabled := True;
      Options.LocalStorageDisabled := True;
      Options.DatabasesDisabled := True;
      Options.FullscreenEnabled := True;
      Options.AcceleratedPaintingDisabled := False;
      Options.AcceleratedFiltersDisabled := False;
      Options.AcceleratedPluginsDisabled := False;
      {$ENDIF}
      DefaultUrl := 'about:blank';
      //UserStyleSheetLocation := CSSHeader + CSSBase64;
      //Options.UserStyleSheetEnabled := True;
      //ReCreateBrowser('about:blank');
    end;

    ForceColor;

    if Assigned(FChromium1) and Assigned(FChromium1.Browser) then
    begin
      CSSend('Default ZoomLevel',
        FloatToStr(
      {$IFDEF CEF3}
          FChromium1.Browser.Host.ZoomLevel
      {$ELSE}
          FChromium1.Browser.ZoomLevel
      {$ENDIF}
        ));
    end;

    CSSendNote('TCefRTTIExtension.Register');

    FChromium1.Load(FStartURL);

    FFlagInitOnce := True;
  end;
  Result := FFlagInitOnce;
  CSExitMethod(Self, cFn);
end;

function TfmChromiumWrapper.IsMain(const b: ICefBrowser;
  const f: ICefFrame): Boolean;
begin
  {$IFDEF CEF3}
  Result := (b <> nil) and (b.Identifier = FChromium1.BrowserId) and
    ((f = nil) or (f.IsMain));
  {$ELSE}
  Result := (b <> nil) and (b.GetWindowHandle = FChromium1.BrowserHandle) and
    ((f = nil) or (f.IsMain));
  {$ENDIF}
end;

procedure TfmChromiumWrapper.LargePageTest1Click(Sender: TObject);
const
  cSample = 'http://lite.demos.href.com/demos:pgTestLoremIpsum';
begin
  Self.Caption := cSample;
  FChromium1.Load(cSample);
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

procedure TfmChromiumWrapper.ShowPopupMenu;
const cFn = 'ShowPopupMenu';
begin
  CSEnterMethod(Self, cFn);
  //PopupMenu1.Popup(Self.Left + 150, Self.Top + 150);  // Left, Top coordinates
  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.SlowPageTest1Click(Sender: TObject);
const
  cSample = 'http://lite.demos.href.com/adv:pgSlowPage';
begin
  Self.Caption := cSample;
  FChromium1.Load(cSample);
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
  const frame: ICefFrame; httpStatusCode: Integer
  {$IFNDEF CEF3}; out Result: Boolean{$ENDIF});
const cFn = 'Chromium1LoadEnd';
var
  FrameUrl: string;
  ZoomShouldBe: Double;
begin
  CSEnterMethod(Self, cFn);
  //Panel1.Visible := True;  // this does not eliminate the flash to blank color
  //FChromium1.Visible := True;
  //Self.Update;

  (*This has no impact on the color
  CSSend('FChromium1.Color', GetEnumName(TypeInfo(TColor),
    Ord(FChromium1.Color)));
  FChromium1.Color := 0;
  FChromium1.Color := $DCDCDC; //$C0C0C0; // clRed;
  CSSend('FChromium1.Color', GetEnumName(TypeInfo(TColor),
    Ord(FChromium1.Color)));
  *)

  //FChromium1.UserStyleSheetLocation := CSSHeader + CSSBase64;
  //FChromium1.Options.UserStyleSheetEnabled := True;

  // Control the Zoom Level *after* content has loaded
  CSSend('ZoomLevel', FloatToStr(
    FChromium1.Browser.{$IFDEF CEF3}host.{$ENDIF}ZoomLevel
  ));

  if WindowState = wsMaximized then
    ZoomShouldBe := FZoomWhenMaximized
  else
    ZoomShouldBe := FZoomWhenNormal;

  if FChromium1.Browser.{$IFDEF CEF3}Host.{$ENDIF}ZoomLevel <> ZoomShouldBe then
  begin
    FChromium1.Browser.{$IFDEF CEF3}Host.{$ENDIF}ZoomLevel := ZoomShouldBe;
    CSSend('Adjusted to ZoomLevel',
      FloatToStr(FChromium1.Browser.{$IFDEF CEF3}Host.{$ENDIF}ZoomLevel));
  end;

  if Assigned(frame) then
  begin
    FrameUrl := frame.Url;
    CSSend('frame.Url', FrameUrl);
    NoteNewURL(FrameUrl);
    (*
    // here you should check the frame.Url to verify if you're on the right URL
    // before you try to search for the element and attach the event if found
    *)
  end;
  {$IFNDEF CEF3}Result := True;{$ENDIF}
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
