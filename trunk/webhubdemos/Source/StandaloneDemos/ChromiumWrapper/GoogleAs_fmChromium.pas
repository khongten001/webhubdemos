unit GoogleAs_fmChromium;

(*
Permission is hereby granted, on 14-Jul-2017, free of charge, to any person
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

Author: Ann Lynnworth at HREF Tools Corp.
*)

interface

uses
  Windows, Graphics, Controls, Menus, Forms, StdCtrls, ExtCtrls,
  SysUtils, Variants, Classes,
  cefvcl, ceflib, cefgui, ceferr, GoogleAs_uBookmark;

type
  // https://groups.google.com/forum/#!topic/delphichromiumembedded/F5PnymYBLww
  TfmChromiumWrapper = class(TForm)
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    miExit: TMenuItem;
    miBookmarks: TMenuItem;
    N1: TMenuItem;
    Panel1: TPanel;
    Help1: TMenuItem;
    miAbout: TMenuItem;
    miEnterURL: TMenuItem;
    View1: TMenuItem;
    miURL: TMenuItem;
    PanelURL: TPanel;
    MemoURL: TMemo;
    miTest: TMenuItem;
    estVideo1: TMenuItem;
    SlowPageTest1: TMenuItem;
    LargePageTest1: TMenuItem;
    estJavaScriptAlert1: TMenuItem;
    N2: TMenuItem;
    miPrintPdf: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miEnterURLClick(Sender: TObject);
    procedure miURLClick(Sender: TObject);
    procedure miTestAlertClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure TestVideo1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SlowPageTest1Click(Sender: TObject);
    procedure LargePageTest1Click(Sender: TObject);
    procedure miPrintPdfClick(Sender: TObject);
  strict private
    procedure OnPDFPrintComplete(const path: ustring; ok: Boolean);
  strict private
    FCurrentWebSite: string;
    FBookmarkList: TGoogleAsBookmarkList;
    procedure miBookmarkClick(Sender: TObject);
    procedure LoginInputPatternAll(Sender: TObject);
    procedure AutoFillIndividualField(Sender: TObject);
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
    procedure Chromium3KeyEvent(Sender: TObject; const browser: ICefBrowser;
      const event: PCefKeyEvent;  osEvent: TCefEventHandle; out Result: Boolean);
    procedure Chromium1TitleChange(Sender: TObject; const browser: ICefBrowser;
      const title: ustring);
    // procedure OnPressEvent(const AEvent: ICefDomEvent);
    // procedure OnExploreDOM(const ADocument: ICefDomDocument);
    procedure Chromium1LoadStart(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame);
    procedure Chromium1LoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer );
  strict private
    procedure MakeWindowFullScreen;  // F11
    procedure MakeWindowNormal;
  private
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
  TypInfo, Dialogs, DateUtils,
  uCode, ucDlgs, ZM_CodeSiteInterface, ucShell,
  GoogleAs_uCEF3_Init;

procedure TfmChromiumWrapper.MakeWindowFullScreen;  // F11
const cFn = 'MakeWindowFullScreen';
begin
  CSEnterMethod(Self, cFn);
  Self.WindowState := wsMaximized;
  FChromium1.Browser.Host.ZoomLevel := FZoomWhenMaximized;  // default 100%
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
  FChromium1.Browser.Host.ZoomLevel := FZoomWhenMaximized;  // default 100%
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

  browser.Host.ZoomLevel := browser.Host.ZoomLevel - 0.2;
  x := browser.Host.ZoomLevel;

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

  browser.Host.ZoomLevel := browser.Host.ZoomLevel + 0.2;
  x := browser.Host.ZoomLevel;

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

  browser.Host.ZoomLevel := 1.0;
  x := browser.Host.ZoomLevel;

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

procedure TfmChromiumWrapper.Chromium1TitleChange(Sender: TObject;
  const browser: ICefBrowser; const title: ustring );
begin
  FActiveTitle := Title;
  if Assigned(Label1) then
    Label1.Caption := Title;
end;

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

procedure TfmChromiumWrapper.miTestAlertClick(Sender: TObject);
begin
  if FChromium1.Browser <> nil then
    FChromium1.Browser.MainFrame.ExecuteJavaScript(
      'alert(''JavaScript execute works!'');', 'about:blank', 0);
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

procedure TfmChromiumWrapper.OnPDFPrintComplete(const path: ustring;
  ok: Boolean);
const cFn = 'OnPDFPrintComplete';
var
  bFileExists: Boolean;
  InfoMsg: string;
begin
  CSEnterMethod(Self, cFn);
  bFileExists := FileExists(path);
  CSSend('bFileExists', S(bFileExists));

  if NOT bFileExists then
  begin
    InfoMsg := cFn + ': File does not exist: ' + path;
    CSSendError(InfoMsg);
    MsgErrorOk(InfoMsg);
  end
  else
  begin
    (*
    https://www.adobe.com/devnet-docs/acrobatetk/tools/AdminGuide/pdfviewer.html

    Setting the Default PDF Viewer

    Since 10.x, it has been possible to have both Acrobat and Reader on the same machine.

    The default handler can be set in the following ways:

    For 10.0 and later, the product allows the user to specify the default PDF handler on first launch if a default handler is not already set.
    For 11.0 and later, by default, Acrobat will wrest ownership from an existing Reader install. You can change this behavior by setting LEAVE_PDFOWNERSHIP to YES.
    Preset that choice via a registry preference stored at HKLM\SOFTWARE\Adobe\Installer\{product GUID}\DEFAULT_VERB.
    Configure the installer prior to deployment via the Wizard, command line, or registry.
    Via the user interface by choosing Preferences > General > Select Default PDF Handler.
   *)
    if AskQuestionYesNo('View ' + path + ' now?') then
      WinShellOpen(path);
  end;

  CSExitMethod(Self, cFn);
end;

(*procedure TfmChromiumWrapper.OnPdfPrintFinished(const path: ustring;
  ok: Boolean);
  const cFn = 'OnPdfPrintFinished';
begin
  CSEnterMethod(Self, cFn);
  //
  CSExitMethod(Self, cFn);
end; *)

procedure TfmChromiumWrapper.miAboutClick(Sender: TObject);
var
  Delphi: string;
begin
  Delphi := 'Delphi ' + PascalCompilerCode;
  MsgInfoOk('Compiled with ' + Delphi + sLineBreak + sLineBreak +
    'and TChromium (CEF3)' +
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
begin
  CSEnterMethod(Self, cFn);
  FFlagInitOnce := False;
  FShowTitleInfo := False;
  PanelURL.Visible := False;
  MemoURL.Clear;
  MemoURL.WordWrap := False;
  miURL.Checked := False;
  Self.Top := 10;
  Self.Left := 150;
  Self.Height := 768 + 120;
  Self.Width := 1024 + 120;
  Application.Title := 'Chromium Embedded Framework 3';
  if (ParamCount >= 2) then
    Self.Caption := ParamStr(2) // email address or username, usually.
  else
    Self.Caption := 'GoogleAs';
  FActiveTitle := Application.Title;
  //FStartURL := 'https://plus.google.com';
  FChromium1 := nil;
  CreateLabel;
  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FChromium1);
  if Assigned(FBookmarkList) then
    FBookmarkList.Clear;
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

procedure TfmChromiumWrapper.AutoFillIndividualField(Sender: TObject);
const
  cFn = 'AutoFillIndividualField';
var
  mi: TMenuItem;
  mark: TGoogleAsBookmark;
  temp: string;
  II: Integer;
  bContinue: Boolean;
  JSText: string;
begin
  CSEnterMethod(Self, cFn);
  mi := TMenuItem(Sender);
  CSSend('Sender.Name', mi.Name);
  bContinue := True;

  for mark in FBookmarkList do
  begin
    if NOT bContinue then break;
    for II := 0 to High(mark.htmlFields) do
    begin
      temp := 'mi' + mark.id + 'Field' + S(mark.htmlFields[II].guiNum);
      CSSend(temp);
      if temp = mi.Name then
      begin
        FCurrentWebSite := mark.id;
        CSSend('mark.id', mark.id);
        //CSSend('tag', S(mi.Tag));

        if mi.Tag <> II then
        begin
          CSSendWarning('guiNum=' + S(mark.htmlFields[II].guiNum));
          CSSendWarning('Tag=' + S(mi.Tag));
        end;
        //CSSend('ParamCount', S(ParamCount));

        if ParamCount >= II+2 then
        begin

          CSSend(mark.htmlFields[II].htmlID, ParamStr(II+2));

          JSText := Format('document.getElementById("%s").value = "%s";',
            [mark.htmlFields[II].htmlID, ParamStr(II+2)]);
          CSSend('JSText going to CEF library', JSText);
          FChromium1.Browser.MainFrame.ExecuteJavaScript(JSText, '', 0);
        end
        else
          CSSendError('ParamCount should be at least ' + S(II+2));
        bContinue := False;
        break;
      end;
    end;
  end;
  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.miBookmarkClick(Sender: TObject);
const
  cFn = 'miBookmarkClick';
var
  mi: TMenuItem;
  mark: TGoogleAsBookmark;
  Addr: string; // = 'https://www.google.com/calendar/';
begin
  CSEnterMethod(Self, cFn);
  Addr := '';

  mi := TMenuItem(Sender);
  for mark in FBookmarkList do
  begin
    if mi.Name = 'mi' + mark.id then
    begin
      Addr := mark.URL;
      CSSend('mark.Caption_en has url', Addr);
      FCurrentWebSite := mark.id;
      break;
    end;
  end;
  if Addr <> '' then
    FChromium1.Load(Addr)
  else
    CSSendError('No URL found for ' + mark.Caption_en);
  CSExitMethod(Self, cFn);
end;


procedure TfmChromiumWrapper.miPrintPdfClick(Sender: TObject);
const
  cFn = 'miPrintPdfClick';
var
  CefPdfPrintSettings: TCefPdfPrintSettings;
  // titleStr: TCefStringUtf16;
  EmptyCefStringUtf16: TCefStringUtf16;
  OutputPDFFilespec: string;
begin
  CSEnterMethod(Self, cFn);

  EmptyCefStringUtf16 := Default (TCefStringUtf16);

  CSSend('IsPrimaryProcess', S(IsPrimaryProcess));
  // recPrintSettings.header_footer_title.str := 'Test Title';
  // recPrintSettings.header_footer_title.length := 10;
  // recPrintSettings.backgrounds_enabled := 0;

  CefPdfPrintSettings.backgrounds_enabled := 1;
  CefPdfPrintSettings.header_footer_enabled := 0;
  CefPdfPrintSettings.header_footer_title := EmptyCefStringUtf16;
  CefPdfPrintSettings.header_footer_url := EmptyCefStringUtf16;
  CefPdfPrintSettings.landscape := 0;
  CefPdfPrintSettings.margin_bottom := 0;
  CefPdfPrintSettings.margin_left := 0;
  CefPdfPrintSettings.margin_right := 0;
  CefPdfPrintSettings.margin_top := 0;
  CefPdfPrintSettings.margin_type := PDF_PRINT_MARGIN_DEFAULT;
  CefPdfPrintSettings.page_height := 0;
  CefPdfPrintSettings.page_width := 0;
  CefPdfPrintSettings.selection_only := 0;

  OutputPDFFilespec := AppDataGoogleAs + 'pdf';
  ForceDirectories(OutputPDFFilespec);
  OutputPDFFilespec := OutputPDFFilespec + PathDelim + 'GoogleAs_' +
    FormatDateTime('yyyy-mm-dd_hhnn', Now) + '.pdf';
  CSSend('OutputPDFFilespec', OutputPDFFilespec);

  // cef_browser_host_t::PrintToPDF
  FChromium1.browser.MainFrame.browser.Host.PrintToPdfProc(OutputPDFFilespec,
    @CefPdfPrintSettings, OnPDFPrintComplete);
  CSExitMethod(Self, cFn);
end;

function TfmChromiumWrapper.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
var
  mi, mi2: TMenuItem;
  ABookmark: TGoogleAsBookmark;
  I: Integer;
  bHot: Boolean;

  procedure AddDividerLineToMenu;
  begin
    mi := TMenuItem.Create(Self);
    mi.Caption := '-';
    miBookmarks.Add(mi);
  end;
begin
  CSEnterMethod(Self, cFn);
  ErrorText := '';

  if NOT FFlagInitOnce then
  begin
    FCurrentWebSite := 'https://www.google.com/';
    FBookmarkList := Load_Bookmarks;
    for ABookmark in FBookmarkList do
    begin
      CSSend('ABookmark.Caption_en',ABookmark.Caption_en);
      bHot := (ParamCount >= 1) and (ParamStr(1) = ABookmark.id);
      if bHot then
        AddDividerLineToMenu;
      mi := TMenuItem.Create(miBookmarks);
      mi.Name := 'mi' + ABookmark.id;
      mi.Caption := ABookmark.Caption_en;
      mi.OnClick := miBookmarkClick;
      miBookmarks.Add(mi);
      if bHot then
      begin
        FCurrentWebSite := ABookmark.Url;
        FStartURL  := ABookmark.Url;
        Self.Caption := ParamStr(2) + ' on ' + ABookmark.Caption_en;
        if ABookmark.InputPattern = lipAll then
        begin
          mi2 := TMenuItem.Create(mi);
          mi2.Name := 'mi' + ABookmark.id + 'Login';
          mi2.Caption := 'Login to ' + ABookmark.Caption_en;
          mi2.OnClick := LoginInputPatternAll;
          miBookmarks.Add(mi2);
        end
        else
        begin
          for I := 0 to High(ABookmark.HtmlFields) do
          begin
            mi2 := TMenuItem.Create(mi);
            mi2.Tag := ABookmark.HtmlFields[I].guiNum;
            mi2.Name := 'mi' + ABookmark.id + 'Field' + S(mi2.Tag);
            mi2.Caption := 'Auto-Fill ' + ABookmark.Caption_en + ' ' +
              ABookmark.HtmlFields[I].guiPrompt_en;
            mi2.OnClick := AutoFillIndividualField;
            miBookmarks.Add(mi2);
          end;
        end;
        AddDividerLineToMenu;
      end;
    end;

    FChromium1 := TChromium.Create(Self);
    FChromium1.Name := 'Chromium1';

    with FChromium1 do
    begin
      Parent := Panel1;
      Align := alClient;
      TabOrder := 0;

      OnAddressChange := crmAddressChange;
      OnTitleChange := Chromium1TitleChange;

      OnKeyEvent := Chromium3KeyEvent;
      OnLoadStart := Chromium1LoadStart;
      OnLoadEnd := Chromium1LoadEnd;
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
          FChromium1.Browser.Host.ZoomLevel
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
  Result := (b <> nil) and (b.Identifier = FChromium1.BrowserId) and
    ((f = nil) or (f.IsMain));
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

procedure TfmChromiumWrapper.LoginInputPatternAll(Sender: TObject);
const
  cFn = 'LoginInputPatternAll';
var
  JSText: string;
  values: array of string;
  mi: TMenuItem;
  mark: TGoogleAsBookmark;
  I: Integer;
  InfoMsg: string;
begin
  CSEnterMethod(Self, cFn);
  if ParamCount > 1 then
  begin

    mi := TMenuItem(Sender);
    for mark in FBookmarkList do
    begin
      CSSend('mark.id', mark.id);
      CSSend('mi.Name', mi.Name);
      if mi.Name = 'mi' + mark.id + 'Login' then
      begin

        FCurrentWebSite := mark.id;
        if ParamCount >= Length(mark.htmlFields) + 1 then
        begin

          SetLength(values, Length(mark.htmlFields));
          for I := 0 to High(mark.htmlFields) do
          begin
            values[I] := ParamStr(I+2); // email, password, etc.
            CSSend(mark.htmlFields[I].htmlID, values[I]);

            JSText := Format('document.getElementById("%s").value = "%s";',
              [mark.htmlFields[I].htmlID, values[I]]);
            CSSend('JSText', JSText);
            FChromium1.Browser.MainFrame.ExecuteJavaScript(JSText, '', 0);
          end;
        end
        else
        begin
          CSSendError('insufficient params to login to ' + mark.id);
          for I := 0 to High(mark.htmlFields) do
            CSSendNote(mark.htmlFields[i].htmlID);
        end;
        break;
      end;
    end;

  end
  else
  begin
    InfoMsg := 'command line parameters are required for Quick Login';
    CSSendError(InfoMsg);
    MsgErrorOk(InfoMsg);
  end;

  CSExitMethod(Self, cFn);
end;

procedure TfmChromiumWrapper.Chromium1LoadEnd(Sender: TObject;
  const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer
  );
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
    FChromium1.Browser.host.ZoomLevel
  ));

  if WindowState = wsMaximized then
    ZoomShouldBe := FZoomWhenMaximized
  else
    ZoomShouldBe := FZoomWhenNormal;

  if FChromium1.Browser.Host.ZoomLevel <> ZoomShouldBe then
  begin
    FChromium1.Browser.Host.ZoomLevel := ZoomShouldBe;
    CSSend('Adjusted to ZoomLevel',
      FloatToStr(FChromium1.Browser.Host.ZoomLevel));
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
