unit CleanEntrance_dmMainMenu;

interface

uses
  System.SysUtils, System.Classes, Vcl.Menus,
  GoogleAs_uBookmark;

type
  TDataModuleBrowserMenu = class(TDataModule)
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    miPrintPdf: TMenuItem;
    miExit: TMenuItem;
    miBookmarks: TMenuItem;
    miEnterURL: TMenuItem;
    N1: TMenuItem;
    miTest: TMenuItem;
    miTestVideo: TMenuItem;
    SlowPageTest1: TMenuItem;
    LargePageTest1: TMenuItem;
    N2: TMenuItem;
    estJavaScriptAlert1: TMenuItem;
    View1: TMenuItem;
    miURL: TMenuItem;
    Help1: TMenuItem;
    miAbout: TMenuItem;
    procedure miPrintPdfClick(Sender: TObject);
    procedure miEnterURLClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure LargePageTest1Click(Sender: TObject);
    procedure SlowPageTest1Click(Sender: TObject);
    procedure miTestVideoClick(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  strict private
    FFlagInitOnce: Boolean;
    //FCurrentWebSite: string;
    FStartURL: string;
    FBookmarkList: TGoogleAsBookmarkList;
    procedure miBookmarkClick(Sender: TObject);
  strict private
    FFrameworkDir: string;
    FDownloadDir: string;
  strict private
    procedure AutoFillIndividualField(Sender: TObject);
    function JavaScript_AutoFill(const htmlAttr, key, value: string;
      const parentElementID: string = ''): string;
    procedure LoginInputPatternAll(Sender: TObject);
  public
    { Public declarations }
    function Load_Menu(out ErrorText: string): Boolean;
    property StartURL: string read FStartURL write FStartURL;
    property DownloadDir: string read FDownloadDir write FDownloadDir;
    property FrameworkDir: string read FFrameworkDir write FFrameworkDir;
  end;

var
  DataModuleBrowserMenu: TDataModuleBrowserMenu;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Vcl.Dialogs,
  ZM_CodeSiteInterface,
  uCode, ucDlgs,
  CleanEntrance_fmMiniBrowser;

procedure TDataModuleBrowserMenu.miTestVideoClick(Sender: TObject);
const
  //cTestVideo = 'http://techslides.com/sample-webm-ogg-and-mp4-video-files-for-html5/';
  cTestQuickTime =
    'http://www.oit.uci.edu/computing/stream/samples/index.html';
begin
  MiniBrowserFrm.Caption := cTestQuickTime;
  MiniBrowserFrm.Chromium1.LoadURL(cTestQuickTime);
end;

procedure TDataModuleBrowserMenu.AutoFillIndividualField(Sender: TObject);
const
  cFn = 'AutoFillIndividualField';
var
  JSText: string;
  values: array of string;
  mi: TMenuItem;
  mark: TGoogleAsBookmark;
  I: Integer;
  InfoMsg: string;
begin
  CSEnterMethod(Self, cFn);
  mi := TMenuItem(Sender);
  //CSSend('mi.Name', mi.Name); // Example: mi.Name = miBloggerGSuiteField0
  CSSend('ParamCount', S(ParamCount));

  if ParamCount > 1 then
  begin

    for mark in FBookmarkList do
    begin
      if Pos(('mi' + mark.id + 'Field'), mi.Name) = 1 then
      begin

        CSSend(csmLevel4, 'match on mark.id', mark.id);
        //FCurrentWebSite := mark.id;
        if ParamCount >= Length(mark.htmlFields) + 1 then
        begin

          SetLength(values, Length(mark.htmlFields));
          for I := 0 to High(mark.htmlFields) do
          begin
            values[I] := ParamStr(I+2); // email, password, etc.
            CSSend(cFn + ': ' + mark.htmlFields[I].htmlID, values[I]);

            JSText := JavaScript_AutoFill(mark.htmlFields[I].htmlAttr,
              mark.htmlFields[I].htmlID, values[I],
              mark.htmlFields[I].parentElementID);
            //CSSend('JSText', JSText);

            MiniBrowserFrm.Chromium1.Browser.MainFrame.ExecuteJavaScript(
              JSText, '', 0);
          end;
        end
        else
        begin
          CSSendError('insufficient params to login to ' + mark.id);
          for I := 0 to High(mark.htmlFields) do
            CSSendNote(mark.htmlFields[i].htmlID);
        end;
        break;
      end
      else
        //CSSend('no match on mark.id', mark.id)
        ;
    end


  end
  else
  begin
    InfoMsg := 'command line parameters are required for Quick Login';
    CSSendError(InfoMsg);
    MsgErrorOk(InfoMsg);
  end;

  CSExitMethod(Self, cFn);
end;

procedure TDataModuleBrowserMenu.DataModuleCreate(Sender: TObject);
begin
  FBookmarkList := nil;
  //FCurrentWebSite := '';
  FFlagInitOnce := False;
end;

procedure TDataModuleBrowserMenu.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FBookmarkList);
end;

function TDataModuleBrowserMenu.JavaScript_AutoFill(const htmlAttr, key, value,
  parentElementID: string): string;
const cFn = 'JavaScript_AutoFill';
begin
  CSEnterMethod(Self, cFn);
  {$IFDEF DEBUG}
  CSSend(csmLevel6, cFn + ': htmlAttr', htmlAttr);
  CSSend(csmLevel6, cFn + ': key', key);
  CSSend(csmLevel6, cFn + ': value', value);
  {$ENDIF}
  if htmlAttr = 'name' then
  begin
    Result :=
      'var' + sLineBreak +
      '  a;' + sLineBreak +
      'a = document.getElementById("%s").getElementsByTagName("input");' +
        sLineBreak +
      ' for (i = 0; i < a.length; i++) {' + sLineBreak +
      ' if ( a[i].name == "%s" ) {' + sLineBreak +
      '  a[i].value = "%s";' + sLineBreak +
      '  break;' + sLineBreak +
      '  }' + sLineBreak +
      '}';
    Result := Format(Result, [parentElementID, key, value]);
  end
  else
    Result := Format('document.getElementById("%s").value = "%s";',
      [key, value]);
  {$IFDEF DEBUG}
  CSSend(csmLevel6, cFn + ': Result', Result);
  {$ENDIF}
  CSExitMethod(Self, cFn);
end;

procedure TDataModuleBrowserMenu.LargePageTest1Click(Sender: TObject);
const
  cSample = 'https://lite.demos.href.com/demos:pgTestLoremIpsum';
begin
  MiniBrowserFrm.Caption := cSample;
  MiniBrowserFrm.Chromium1.LoadURL(cSample);
end;

function TDataModuleBrowserMenu.Load_Menu(out ErrorText: string): Boolean;
const cFn = 'Load_Menu';
var
  mi, mi2: TMenuItem;
  ABookmark: TGoogleAsBookmark;
  I: Integer;
  bHot: Boolean;
  temp1, temp2: string;

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
    FBookmarkList := Load_Bookmarks(temp1, temp2);
    if temp1 <> '' then
      Self.FFrameworkDir := temp1;
    if temp2 <> '' then
      Self.FDownloadDir := temp2;

    for ABookmark in FBookmarkList do
    begin
      //CSSend('ABookmark.Caption_en',ABookmark.Caption_en);
      bHot := (ParamCount >= 1) and (ParamStr(1) = ABookmark.id);
      if bHot then
        AddDividerLineToMenu;
      mi := TMenuItem.Create(miBookmarks);
      mi.Name := 'mi' + ABookmark.id;
      CSSend('mi.Name', mi.Name);
      mi.Caption := ABookmark.Caption_en;
      mi.OnClick := miBookmarkClick;
      miBookmarks.Add(mi);
      if bHot then
      begin
        //FCurrentWebSite := ABookmark.Url;
        FStartURL  := ABookmark.Url;
        CSSend('FStartURL', FStartURL);
        MiniBrowserFrm.Caption := ParamStr(2) + ' on ' + ABookmark.Caption_en;
        if ABookmark.InputPattern = lipAll then
        begin
          mi2 := TMenuItem.Create(mi);
          mi2.Name := 'mi' + ABookmark.id + 'Login';
          CSSend('mi2.Name', mi2.Name);
          mi2.Caption := 'Login to ' + ABookmark.Caption_en;
          mi2.OnClick := LoginInputPatternAll;
          miBookmarks.Add(mi2);
        end
        else
        begin
          for I := 0 to High(ABookmark.HtmlFields) do
          begin
            mi2 := TMenuItem.Create(mi);
            mi2.Tag := I;
            mi2.Name := 'mi' + ABookmark.id + 'Field' + S(mi2.Tag);
            CSSend('mi2.Name', mi2.Name);
            mi2.Caption := 'Auto-Fill ' + ABookmark.Caption_en + ' ' +
              ABookmark.HtmlFields[I].guiPrompt_en;
            mi2.OnClick := AutoFillIndividualField;
            miBookmarks.Add(mi2);
          end;
        end;
        AddDividerLineToMenu;
      end;
    end;
    FFlagInitOnce := True;
  end;
  Result := FFlagInitOnce;
  CSExitMethod(Self, cFn);
end;

procedure TDataModuleBrowserMenu.LoginInputPatternAll(Sender: TObject);
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
  CSSend('ParamCount', S(ParamCount));
  
  if ParamCount > 1 then
  begin

    mi := TMenuItem(Sender);
    CSSend('mi.Name', mi.Name);
    
    for mark in FBookmarkList do
    begin
      if mi.Name = 'mi' + mark.id + 'Login' then
      begin
        CSSend(csmLevel4, 'match on mark.id', mark.id);

        //FCurrentWebSite := mark.id;
        if ParamCount >= Length(mark.htmlFields) + 1 then
        begin

          SetLength(values, Length(mark.htmlFields));
          for I := 0 to High(mark.htmlFields) do
          begin
            values[I] := ParamStr(I+2); // email, password, etc.
            //CSSend(mark.htmlFields[I].htmlID, values[I]);

            JSText := JavaScript_AutoFill(mark.htmlFields[I].htmlAttr,
              mark.htmlFields[I].htmlID, values[I],
              mark.htmlFields[I].parentElementID);
            //CSSend('JSText', JSText);

            MiniBrowserFrm.Chromium1.Browser.MainFrame.ExecuteJavaScript(JSText,
              '', 0);
          end;
        end
        else
        begin
          CSSendError('insufficient params to login to ' + mark.id);
          for I := 0 to High(mark.htmlFields) do
            CSSendNote(mark.htmlFields[i].htmlID);
        end;
        break;
      end
      else
        CSSend('not match on mark.id', mark.id);
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

procedure TDataModuleBrowserMenu.miAboutClick(Sender: TObject);
var
  Delphi: string;
begin
  Delphi := 'Delphi ' + PascalCompilerCode;
  MsgInfoOk('Compiled with ' + Delphi + sLineBreak + sLineBreak +
    'and TChromium (CEF4)' +
    sLineBreak + sLineBreak +
    'Pass email and password as command line parameters for Quick Login' +
    sLineBreak + sLineBreak +
    'Source code in webhubdemos project' + sLineBreak +
    'on sf.net' + sLineBreak +
    'c/o HREF Tools Corp.' + sLineBreak +
    'https://lite.demos.href.com/demos');
end;

procedure TDataModuleBrowserMenu.miBookmarkClick(Sender: TObject);
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
      CSSend(cFn + ': mark.Caption_en has url', Addr);
      //FCurrentWebSite := mark.id;
      break;
    end;
  end;
  if Addr <> '' then
    MiniBrowserFrm.Chromium1.LoadURL(Addr)
  else
    CSSendError('No URL found for ' + mark.Caption_en);
  CSExitMethod(Self, cFn);

end;

procedure TDataModuleBrowserMenu.miEnterURLClick(Sender: TObject);
var
  AURL: string;
begin
  AURL := InputBox('', 'Enter URL', 'https://');
  if Copy(AURL, 1, 4) = 'http' then
  begin
    MiniBrowserFrm.Caption := AURL;
    MiniBrowserFrm.Chromium1.LoadURL(AURL);
  end;
end;

procedure TDataModuleBrowserMenu.miPrintPdfClick(Sender: TObject);
const
  cFn = 'miPrintPdfClick';
//var
//??  CefPdfPrintSettings: TCefPdfPrintSettings;
  // titleStr: TCefStringUtf16;
//??  EmptyCefStringUtf16: TCefStringUtf16;
//  OutputPDFFilespec: string;
begin
  CSEnterMethod(Self, cFn);

(*
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
  OutputPDFFilespec := OutputPDFFilespec + PathDelim +
    cGoogleAs_ProgramNickname + '_' +
    FormatDateTime('yyyy-mm-dd_hhnn', Now) + '.pdf';
  CSSend('OutputPDFFilespec', OutputPDFFilespec);

  // cef_browser_host_t::PrintToPDF
  FChromium1.browser.MainFrame.browser.Host.PrintToPdfProc(OutputPDFFilespec,
    @CefPdfPrintSettings, OnPDFPrintComplete);
*)
  CSExitMethod(Self, cFn);
end;

procedure TDataModuleBrowserMenu.SlowPageTest1Click(Sender: TObject);
const
  cSample = 'https://lite.demos.href.com/adv:pgSlowPage';
begin
  MiniBrowserFrm.Caption := cSample;
  MiniBrowserFrm.Chromium1.LoadURL(cSample);
end;

end.
