// ************************************************************************
// ***************************** CEF4Delphi *******************************
// ************************************************************************
//
// CEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to CEF4Delphi.
//
// For more information about CEF4Delphi visit :
//         https://www.briskbard.com/index.php?lang=en&pageid=cef
//
//        Copyright © 2018 Salvador Díaz Fau. All rights reserved.
//
// ************************************************************************
// ************ vvvv Original license and comments below vvvv *************
// ************************************************************************
(*
 *                       Delphi Chromium Embedded 3
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Unit owner : Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

unit CleanEntrance_fmMiniBrowser;

(* CleanEntrance_fmMiniBrowser inspired by
   CEF4\demos\MiniBrowser\uMiniBrowser.pas

   Features from the prior CEF3 "GoogleAs" demo in the WebHubDemos project on
   sf.net were merged here, Mar-Apr 2018, by Ann Lynnworth @HREF Tools Corp.
*)

{$I cef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Menus,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Types, Vcl.ComCtrls, Vcl.ClipBrd,
  System.UITypes, Vcl.AppEvnts, Winapi.ActiveX, Winapi.ShlObj,
  {$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Menus,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Types, ComCtrls, ClipBrd, AppEvnts, ActiveX, ShlObj,
  {$ENDIF}
  uCEFChromium, uCEFWindowParent, uCEFInterfaces, uCEFApplication, uCEFTypes,
  uCEFConstants,
  ZM_CodeSiteInterface,
  uCode;

const
  MINIBROWSER_SHOWDEVTOOLS    = WM_APP + $101;
  MINIBROWSER_HIDEDEVTOOLS    = WM_APP + $102;
  MINIBROWSER_COPYHTML        = WM_APP + $103;
  MINIBROWSER_SHOWRESPONSE    = WM_APP + $104;
  MINIBROWSER_COPYFRAMEIDS    = WM_APP + $105;
  MINIBROWSER_COPYFRAMENAMES  = WM_APP + $106;
  MINIBROWSER_SAVEPREFERENCES = WM_APP + $107;
  MINIBROWSER_COPYALLTEXT     = WM_APP + $108;
  MINIBROWSER_TAKESNAPSHOT    = WM_APP + $109;

  MINIBROWSER_HOMEPAGE = 'https://www.google.com';

  MINIBROWSER_CONTEXTMENU_SHOWDEVTOOLS    = MENU_ID_USER_FIRST + 1;
  MINIBROWSER_CONTEXTMENU_HIDEDEVTOOLS    = MENU_ID_USER_FIRST + 2;
  MINIBROWSER_CONTEXTMENU_COPYHTML        = MENU_ID_USER_FIRST + 3;
  MINIBROWSER_CONTEXTMENU_JSWRITEDOC      = MENU_ID_USER_FIRST + 4;
  MINIBROWSER_CONTEXTMENU_JSPRINTDOC      = MENU_ID_USER_FIRST + 5;
  MINIBROWSER_CONTEXTMENU_SHOWRESPONSE    = MENU_ID_USER_FIRST + 6;
  MINIBROWSER_CONTEXTMENU_COPYFRAMEIDS    = MENU_ID_USER_FIRST + 7;
  MINIBROWSER_CONTEXTMENU_COPYFRAMENAMES  = MENU_ID_USER_FIRST + 8;
  MINIBROWSER_CONTEXTMENU_SAVEPREFERENCES = MENU_ID_USER_FIRST + 9;
  MINIBROWSER_CONTEXTMENU_COPYALLTEXT     = MENU_ID_USER_FIRST + 10;
  MINIBROWSER_CONTEXTMENU_TAKESNAPSHOT    = MENU_ID_USER_FIRST + 11;

type
  TMiniBrowserFrm = class(TForm)
    NavControlPnl: TPanel;
    NavButtonPnl: TPanel;
    URLEditPnl: TPanel;
    BackBtn: TButton;
    ForwardBtn: TButton;
    ReloadBtn: TButton;
    StopBtn: TButton;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    URLCbx: TComboBox;
    ConfigPnl: TPanel;
    ConfigBtn: TButton;
    PopupMenu1: TPopupMenu;
    DevTools1: TMenuItem;
    N1: TMenuItem;
    Preferences1: TMenuItem;
    GoBtn: TButton;
    N2: TMenuItem;
    PrintinPDF1: TMenuItem;
    Print1: TMenuItem;
    N3: TMenuItem;
    Zoom1: TMenuItem;
    Inczoom1: TMenuItem;
    Deczoom1: TMenuItem;
    Resetzoom1: TMenuItem;
    SaveDialog1: TSaveDialog;
    ApplicationEvents1: TApplicationEvents;
    OpenDialog1: TOpenDialog;
    N4: TMenuItem;
    Openfile1: TMenuItem;
    Resolvehost1: TMenuItem;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure ForwardBtnClick(Sender: TObject);
    procedure ReloadBtnClick(Sender: TObject);
    procedure Chromium1AfterCreated(Sender: TObject;
      const browser: ICefBrowser);
    procedure Chromium1LoadingStateChange(Sender: TObject;
      const browser: ICefBrowser; isLoading, canGoBack,
      canGoForward: Boolean);
    procedure Chromium1TitleChange(Sender: TObject;
      const browser: ICefBrowser; const title: ustring);
    procedure Chromium1AddressChange(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const url: ustring);
    procedure Chromium1BeforeContextMenu(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel);
    procedure Chromium1StatusMessage(Sender: TObject;
      const browser: ICefBrowser; const value: ustring);
    procedure Chromium1TextResultAvailable(Sender: TObject;
      const aText: string);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure DevTools1Click(Sender: TObject);
    procedure Preferences1Click(Sender: TObject);
    procedure ConfigBtnClick(Sender: TObject);
    procedure GoBtnClick(Sender: TObject);
    procedure PrintinPDF1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Inczoom1Click(Sender: TObject);
    procedure Deczoom1Click(Sender: TObject);
    procedure Resetzoom1Click(Sender: TObject);
    procedure Chromium1FullScreenModeChange(Sender: TObject;
      const browser: ICefBrowser; fullscreen: Boolean);
    procedure Chromium1PreKeyEvent(Sender: TObject;
      const browser: ICefBrowser; const event: PCefKeyEvent; osEvent: PMsg;
      out isKeyboardShortcut, Result: Boolean);
    procedure Chromium1KeyEvent(Sender: TObject;
      const browser: ICefBrowser; const event: PCefKeyEvent; osEvent: PMsg;
      out Result: Boolean);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure Openfile1Click(Sender: TObject);
    procedure Chromium1ContextMenuCommand(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: Cardinal; out Result: Boolean);
    procedure Chromium1PdfPrintFinished(Sender: TObject;
      aResultOK: Boolean);
    procedure Chromium1ResourceResponse(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse;
      out Result: Boolean);
    procedure StopBtnClick(Sender: TObject);
    procedure Resolvehost1Click(Sender: TObject);
    procedure Chromium1ResolvedHostAvailable(Sender: TObject;
      result: Integer; const resolvedIps: TStrings);
    procedure Timer1Timer(Sender: TObject);
    procedure Chromium1PrefsAvailable(Sender: TObject; aResultOK: Boolean);
    procedure Chromium1BeforeDownload(Sender: TObject;
      const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const suggestedName: ustring;
      const callback: ICefBeforeDownloadCallback);
    procedure Chromium1DownloadUpdated(Sender: TObject;
      const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const callback: ICefDownloadItemCallback);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Chromium1BeforeResourceLoad(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const callback: ICefRequestCallback;
      out Result: TCefReturnValue);
    procedure Exit1Click(Sender: TObject);

  strict private
    CEFWindowParent1: TCEFWindowParent;
    FChromium1: TChromium;
    DevTools: TCEFWindowParent;
  protected
    FResponse : TStringList;
    FRequest  : TStringList;

    procedure AddURL(const aURL : string);

    procedure ShowDevTools(aPoint : TPoint); overload;
    procedure ShowDevTools; overload;
    procedure HideDevTools;

    procedure HandleKeyUp(const aMsg : TMsg; var aHandled : boolean);
    procedure HandleKeyDown(const aMsg : TMsg; var aHandled : boolean);

    procedure InspectRequest(const aRequest : ICefRequest);
    procedure InspectResponse(const aResponse : ICefResponse);

    procedure BrowserCreatedMsg(var aMessage : TMessage); message CEF_AFTERCREATED;
    procedure ShowDevToolsMsg(var aMessage : TMessage); message MINIBROWSER_SHOWDEVTOOLS;
    procedure HideDevToolsMsg(var aMessage : TMessage); message MINIBROWSER_HIDEDEVTOOLS;
    procedure CopyAllTextMsg(var aMessage : TMessage); message MINIBROWSER_COPYALLTEXT;
    procedure CopyHTMLMsg(var aMessage : TMessage); message MINIBROWSER_COPYHTML;
    procedure CopyFramesIDsMsg(var aMessage : TMessage); message MINIBROWSER_COPYFRAMEIDS;
    procedure CopyFramesNamesMsg(var aMessage : TMessage); message MINIBROWSER_COPYFRAMENAMES;
    procedure ShowResponseMsg(var aMessage : TMessage); message MINIBROWSER_SHOWRESPONSE;
    procedure SavePreferencesMsg(var aMessage : TMessage); message MINIBROWSER_SAVEPREFERENCES;
    procedure TakeSnapshotMsg(var aMessage : TMessage); message MINIBROWSER_TAKESNAPSHOT;
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;

  public
    procedure ShowStatusText(const aText : string);
    property Chromium1: TChromium read FChromium1;

  end;

var
  MiniBrowserFrm : TMiniBrowserFrm;

function Init_Global_CEF: Boolean;

implementation

{$R *.dfm}

uses
  ucDlgs,
  uPreferences, uCefStringMultimap, uSimpleTextViewer,
  GoogleAs_uCEF3_Init,
  CleanEntrance_dmMainMenu;

procedure TMiniBrowserFrm.BackBtnClick(Sender: TObject);
begin
  FChromium1.GoBack;
end;

procedure TMiniBrowserFrm.ForwardBtnClick(Sender: TObject);
begin
  FChromium1.GoForward;
end;

procedure TMiniBrowserFrm.GoBtnClick(Sender: TObject);
begin
  FChromium1.LoadURL(URLCbx.Text);
end;

procedure TMiniBrowserFrm.ReloadBtnClick(Sender: TObject);
begin
  FChromium1.Reload;
end;

procedure TMiniBrowserFrm.Resetzoom1Click(Sender: TObject);
begin
  FChromium1.ResetZoomStep;
end;

procedure TMiniBrowserFrm.Resolvehost1Click(Sender: TObject);
var
  TempURL : string;
begin
  TempURL := inputbox('Resolve host', 'URL :', 'http://google.com');
  if (length(TempURL) > 0) then FChromium1.ResolveHost(TempURL);
end;

procedure TMiniBrowserFrm.Chromium1AddressChange(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const url: ustring);
begin
  if FChromium1.IsSameBrowser(browser) then AddURL(url);
end;

procedure TMiniBrowserFrm.Chromium1AfterCreated(Sender: TObject; const browser: ICefBrowser);
begin
  if FChromium1.IsSameBrowser(browser) then
    PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure TMiniBrowserFrm.Chromium1BeforeContextMenu(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  if not(FChromium1.IsSameBrowser(browser)) then exit;

  model.AddSeparator;
  model.AddItem(MINIBROWSER_CONTEXTMENU_TAKESNAPSHOT,    'Take snapshot...');
  model.AddSeparator;
  model.AddItem(MINIBROWSER_CONTEXTMENU_COPYALLTEXT,     'Copy displayed text to clipboard');
  model.AddItem(MINIBROWSER_CONTEXTMENU_COPYHTML,        'Copy HTML to clipboard');
  model.AddItem(MINIBROWSER_CONTEXTMENU_COPYFRAMEIDS,    'Copy HTML frame identifiers to clipboard');
  model.AddItem(MINIBROWSER_CONTEXTMENU_COPYFRAMENAMES,  'Copy HTML frame names to clipboard');
  model.AddSeparator;
  model.AddItem(MINIBROWSER_CONTEXTMENU_SAVEPREFERENCES, 'Save preferences as...');
  model.AddSeparator;
  model.AddItem(MINIBROWSER_CONTEXTMENU_JSWRITEDOC,      'Modify HTML document');
  model.AddItem(MINIBROWSER_CONTEXTMENU_JSPRINTDOC,      'Print using Javascript');
  model.AddItem(MINIBROWSER_CONTEXTMENU_SHOWRESPONSE,    'Show server headers');

  if DevTools.Visible then
    model.AddItem(MINIBROWSER_CONTEXTMENU_HIDEDEVTOOLS, 'Hide DevTools')
   else
    model.AddItem(MINIBROWSER_CONTEXTMENU_SHOWDEVTOOLS, 'Show DevTools');
end;

procedure TMiniBrowserFrm.Chromium1BeforeDownload(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const suggestedName: ustring;
  const callback: ICefBeforeDownloadCallback);
const cFn = 'Chromium1BeforeDownload';
var
  TempMyDocuments, TempFullPath, TempName : string;
  bContinue: Boolean;
begin
  CSEnterMethod(Self, cFn);
  CSSend('FChromium1.IsSameBrowser(browser)', S(FChromium1.IsSameBrowser(browser)));
  CSSend('downloadItem', S(Assigned(downloadItem)));
  if Assigned(downloadItem) then
    CSSend('downloadItem.IsValid', S(downloadItem.IsValid));

  bContinue := (FChromium1.IsSameBrowser(browser)) and
     Assigned(downloadItem) and
     downloadItem.IsValid;
  CSSend('bContinue', S(bContinue));
  CSSend('DownloadDir', DataModuleBrowserMenu.DownloadDir);

  CSSend('suggestedName', suggestedName);

  if bContinue then
  begin

    TempMyDocuments := DataModuleBrowserMenu.DownloadDir;

    if (length(suggestedName) > 0) then
      TempName := suggestedName
     else
      TempName := 'DownloadedFile';

    if (length(TempMyDocuments) > 0) then
      TempFullPath := IncludeTrailingPathDelimiter(TempMyDocuments) + TempName
     else
      TempFullPath := TempName;

    CSSend('TempFullPath', TempFullPath);
    callback.cont(TempFullPath, False);
  end;
  CSExitMethod(Self, cFn);
end;

procedure TMiniBrowserFrm.Chromium1BeforeResourceLoad(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; const callback: ICefRequestCallback;
  out Result: TCefReturnValue);
begin
  Result := RV_CONTINUE;

  if FChromium1.IsSameBrowser(browser) and
     (frame <> nil) and
     frame.IsMain then
    InspectRequest(request);
end;

procedure TMiniBrowserFrm.Chromium1ContextMenuCommand(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: Cardinal; out Result: Boolean);
var
  TempParam : WParam;
begin
  Result := False;

  if not(FChromium1.IsSameBrowser(browser)) then exit;

  case commandId of
    MINIBROWSER_CONTEXTMENU_HIDEDEVTOOLS :
      PostMessage(Handle, MINIBROWSER_HIDEDEVTOOLS, 0, 0);

    MINIBROWSER_CONTEXTMENU_SHOWDEVTOOLS :
      begin
        TempParam := ((params.XCoord and $FFFF) shl 16) or (params.YCoord and $FFFF);
        PostMessage(Handle, MINIBROWSER_SHOWDEVTOOLS, TempParam, 0);
      end;

    MINIBROWSER_CONTEXTMENU_COPYALLTEXT :
      PostMessage(Handle, MINIBROWSER_COPYALLTEXT, 0, 0);

    MINIBROWSER_CONTEXTMENU_COPYHTML :
      PostMessage(Handle, MINIBROWSER_COPYHTML, 0, 0);

    MINIBROWSER_CONTEXTMENU_COPYFRAMEIDS :
      PostMessage(Handle, MINIBROWSER_COPYFRAMEIDS, 0, 0);

    MINIBROWSER_CONTEXTMENU_COPYFRAMENAMES :
      PostMessage(Handle, MINIBROWSER_COPYFRAMENAMES, 0, 0);

    MINIBROWSER_CONTEXTMENU_SHOWRESPONSE :
      PostMessage(Handle, MINIBROWSER_SHOWRESPONSE, 0, 0);

    MINIBROWSER_CONTEXTMENU_SAVEPREFERENCES :
      PostMessage(Handle, MINIBROWSER_SAVEPREFERENCES, 0, 0);

    MINIBROWSER_CONTEXTMENU_TAKESNAPSHOT :
      PostMessage(Handle, MINIBROWSER_TAKESNAPSHOT, 0, 0);

    MINIBROWSER_CONTEXTMENU_JSWRITEDOC :
      if (browser <> nil) and (browser.MainFrame <> nil) then
        browser.MainFrame.ExecuteJavaScript(
          'var css = ' + chr(39) + '@page {size: A4; margin: 0;} @media print {html, body {width: 210mm; height: 297mm;}}' + chr(39) + '; ' +
          'var style = document.createElement(' + chr(39) + 'style' + chr(39) + '); ' +
          'style.type = ' + chr(39) + 'text/css' + chr(39) + '; ' +
          'style.appendChild(document.createTextNode(css)); ' +
          'document.head.appendChild(style);',
          'about:blank', 0);

    MINIBROWSER_CONTEXTMENU_JSPRINTDOC :
      if (browser <> nil) and (browser.MainFrame <> nil) then
        browser.MainFrame.ExecuteJavaScript('window.print();', 'about:blank', 0);
  end;
end;

procedure TMiniBrowserFrm.Chromium1DownloadUpdated(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const callback: ICefDownloadItemCallback);
const cFn = 'Chromium1DownloadUpdated';
var
  TempString : string;
  bContinue: Boolean;
begin
  CSEnterMethod(Self, cFn);
  bContinue := not(FChromium1.IsSameBrowser(browser));
  if bContinue then
  begin

    if downloadItem.IsComplete then
      ShowStatusText(downloadItem.FullPath + ' completed')
     else
      if downloadItem.IsCanceled then
        ShowStatusText(downloadItem.FullPath + ' canceled')
       else
        if downloadItem.IsInProgress then
          begin
            if (downloadItem.PercentComplete >= 0) then
              TempString := downloadItem.FullPath + ' : ' + inttostr(downloadItem.PercentComplete) + '%'
             else
              TempString := downloadItem.FullPath + ' : ' + inttostr(downloadItem.ReceivedBytes) + ' bytes received';

            ShowStatusText(TempString);
          end;
  end;
  CSExitMethod(Self, cFn);
end;

procedure TMiniBrowserFrm.Chromium1FullScreenModeChange(Sender: TObject;
  const browser: ICefBrowser; fullscreen: Boolean);
begin                    
  if not(FChromium1.IsSameBrowser(browser)) then exit;

  // This event is executed in a CEF thread and this can cause problems when
  // you change the 'Enabled' and 'Visible' properties from VCL components.
  // It's recommended to change the 'Enabled' and 'Visible' properties
  // in the main application thread and not in a CEF thread.
  // It's much safer to use PostMessage to send a message to the main form with
  // all this information and update those properties in the procedure handling
  // that message.

  if fullscreen then
    begin
      NavControlPnl.Visible := False;
      StatusBar1.Visible    := False;

      if (WindowState = wsMaximized) then WindowState := wsNormal;

      BorderIcons := [];
      BorderStyle := bsNone;
      WindowState := wsMaximized;
    end
   else
    begin
      BorderIcons := [biSystemMenu, biMinimize, biMaximize];
      BorderStyle := bsSizeable;
      WindowState := wsNormal;

      NavControlPnl.Visible := True;
      StatusBar1.Visible    := True;
    end;
end;

procedure TMiniBrowserFrm.Chromium1KeyEvent(Sender: TObject;
  const browser: ICefBrowser; const event: PCefKeyEvent; osEvent: PMsg;
  out Result: Boolean);
var
  TempMsg : TMsg;
begin
  Result := False;

  if not(FChromium1.IsSameBrowser(browser)) then exit;

  if (event <> nil) and (osEvent <> nil) then
    case osEvent.Message of
      WM_KEYUP :
        begin
          TempMsg := osEvent^;

          HandleKeyUp(TempMsg, Result);
        end;

      WM_KEYDOWN :
        begin
          TempMsg := osEvent^;

          HandleKeyDown(TempMsg, Result);
        end;
    end;
end;

procedure TMiniBrowserFrm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
  case Msg.message of
    WM_KEYUP   : HandleKeyUp(Msg, Handled);
    WM_KEYDOWN : HandleKeyDown(Msg, Handled);
  end;
end;

procedure TMiniBrowserFrm.HandleKeyUp(const aMsg : TMsg; var aHandled : boolean);
var
  TempMessage : TMessage;
  TempKeyMsg  : TWMKey;
begin
  TempMessage.Msg     := aMsg.message;
  TempMessage.wParam  := aMsg.wParam;
  TempMessage.lParam  := aMsg.lParam;
  TempKeyMsg          := TWMKey(TempMessage);

  if (TempKeyMsg.CharCode = VK_F12) then
    begin
      aHandled := True;

      if DevTools.Visible then
        PostMessage(Handle, MINIBROWSER_HIDEDEVTOOLS, 0, 0)
       else
        PostMessage(Handle, MINIBROWSER_SHOWDEVTOOLS, 0, 0);
    end;
end;

procedure TMiniBrowserFrm.HandleKeyDown(const aMsg : TMsg; var aHandled : boolean);
var
  TempMessage : TMessage;
  TempKeyMsg  : TWMKey;
begin
  TempMessage.Msg     := aMsg.message;
  TempMessage.wParam  := aMsg.wParam;
  TempMessage.lParam  := aMsg.lParam;
  TempKeyMsg          := TWMKey(TempMessage);

  if (TempKeyMsg.CharCode = VK_F12) then aHandled := True;
end;

procedure TMiniBrowserFrm.Chromium1LoadingStateChange(Sender: TObject;
  const browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean);
begin
  if not(FChromium1.IsSameBrowser(browser)) then exit;

  // This event is executed in a CEF thread and this can cause problems when
  // you change the 'Enabled' and 'Visible' properties from VCL components.
  // It's recommended to change the 'Enabled' and 'Visible' properties
  // in the main application thread and not in a CEF thread.
  // It's much safer to use PostMessage to send a message to the main form with
  // all this information and update those properties in the procedure handling
  // that message.

  BackBtn.Enabled    := canGoBack;
  ForwardBtn.Enabled := canGoForward;

  if isLoading then
    begin
      StatusBar1.Panels[0].Text := 'Loading...';
      ReloadBtn.Enabled         := False;
      StopBtn.Enabled           := True;
    end
   else
    begin
      StatusBar1.Panels[0].Text := 'Finished';
      ReloadBtn.Enabled         := True;
      StopBtn.Enabled           := False;
    end;
end;

procedure TMiniBrowserFrm.Chromium1PdfPrintFinished(Sender: TObject; aResultOK: Boolean);
begin
  if aResultOK then
    showmessage('The PDF file was generated successfully')
   else
    showmessage('There was a problem generating the PDF file.');
end;

procedure TMiniBrowserFrm.Chromium1PrefsAvailable(Sender: TObject; aResultOK: Boolean);
begin
  if aResultOK then
    showmessage('The preferences file was generated successfully')
   else
    showmessage('There was a problem generating the preferences file.');
end;

procedure TMiniBrowserFrm.Chromium1PreKeyEvent(Sender: TObject;
  const browser: ICefBrowser; const event: PCefKeyEvent; osEvent: PMsg;
  out isKeyboardShortcut, Result: Boolean);
begin
  Result := False;

  if FChromium1.IsSameBrowser(browser) and
     (event <> nil) and
     (event.kind in [KEYEVENT_KEYDOWN, KEYEVENT_KEYUP]) and
     (event.windows_key_code = VK_F12) then
    isKeyboardShortcut := True;
end;

procedure TMiniBrowserFrm.Chromium1ResolvedHostAvailable(Sender: TObject;
  result: Integer; const resolvedIps: TStrings);
begin
  if (result = ERR_NONE) then
    showmessage('Resolved IPs : ' + resolvedIps.CommaText)
   else
    showmessage('There was a problem resolving the host.' + CRLF +
                'Error code : ' + inttostr(result));
end;

procedure TMiniBrowserFrm.InspectRequest(const aRequest : ICefRequest);
var
  TempHeaderMap : ICefStringMultimap;
  i, j : integer;
begin
  if (aRequest <> nil) then
    begin
      FRequest.Clear;

      TempHeaderMap := TCefStringMultimapOwn.Create;
      aRequest.GetHeaderMap(TempHeaderMap);

      i := 0;
      j := TempHeaderMap.Size;

      while (i < j) do
        begin
          FRequest.Add(TempHeaderMap.Key[i] + '=' + TempHeaderMap.Value[i]);
          inc(i);
        end;
    end;
end;

procedure TMiniBrowserFrm.InspectResponse(const aResponse : ICefResponse);
var
  TempHeaderMap : ICefStringMultimap;
  i, j : integer;
begin
  if (aResponse <> nil) then
    begin
      FResponse.Clear;

      TempHeaderMap := TCefStringMultimapOwn.Create;
      aResponse.GetHeaderMap(TempHeaderMap);

      i := 0;
      j := TempHeaderMap.Size;

      while (i < j) do
        begin
          FResponse.Add(TempHeaderMap.Key[i] + '=' + TempHeaderMap.Value[i]);
          inc(i);
        end;
    end;
end;

procedure TMiniBrowserFrm.Chromium1ResourceResponse(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; const response: ICefResponse;
  out Result: Boolean);
begin
  Result := False;

  if FChromium1.IsSameBrowser(browser) and
     (frame <> nil) and
     frame.IsMain then
    InspectResponse(response);
end;

procedure TMiniBrowserFrm.ShowStatusText(const aText : string);
begin
  StatusBar1.Panels[1].Text := aText;
end;

procedure TMiniBrowserFrm.StopBtnClick(Sender: TObject);
begin
  FChromium1.StopLoad;
end;

procedure TMiniBrowserFrm.Chromium1StatusMessage(Sender: TObject;
  const browser: ICefBrowser; const value: ustring);
begin
  if FChromium1.IsSameBrowser(browser) then ShowStatusText(value);
end;

procedure TMiniBrowserFrm.Chromium1TextResultAvailable(Sender: TObject; const aText: string);
begin
  clipboard.AsText := aText;
end;

function PathToMyDocuments : string;
var
  Allocator : IMalloc;
  Path      : pchar;
  idList    : PItemIDList;
begin
  Result   := '';
  Path     := nil;
  idList   := nil;

  try
    if (SHGetMalloc(Allocator) = S_OK) then
      begin
        GetMem(Path, MAX_PATH);
        if (SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, idList) = S_OK) and
           SHGetPathFromIDList(idList, Path) then
          Result := string(Path);
      end;
  finally
    if (Path   <> nil) then FreeMem(Path);
    if (idList <> nil) then Allocator.Free(idList);
  end;
end;

procedure TMiniBrowserFrm.Chromium1TitleChange(Sender: TObject;
  const browser: ICefBrowser; const title: ustring);
begin
  if not(FChromium1.IsSameBrowser(browser)) then exit;

  if (title <> '') then
    caption := 'CleanEntrance - ' + title
   else
    caption := 'CleanEntrance';
end;

procedure TMiniBrowserFrm.FormCreate(Sender: TObject);
begin
  ReloadBtn.Caption := ' ' + #$2672 + ' '; // Unicode symbol for Recycle
  FResponse := TStringList.Create;
  FRequest  := TStringList.Create;

  // create these at runtime to avoid installing the CEF4 components
  FChromium1 := TChromium.Create(Self);
  FChromium1.Name := 'Chromium1';

  FChromium1.OnTextResultAvailable := Chromium1TextResultAvailable;
  FChromium1.OnPdfPrintFinished := Chromium1PdfPrintFinished;
  FChromium1.OnPrefsAvailable := Chromium1PrefsAvailable;
  FChromium1.OnResolvedHostAvailable := Chromium1ResolvedHostAvailable;
  FChromium1.OnLoadingStateChange := Chromium1LoadingStateChange;
  FChromium1.OnBeforeContextMenu := Chromium1BeforeContextMenu;
  FChromium1.OnContextMenuCommand := Chromium1ContextMenuCommand;
  FChromium1.OnPreKeyEvent := Chromium1PreKeyEvent;
  FChromium1.OnKeyEvent := Chromium1KeyEvent;
  FChromium1.OnAddressChange := Chromium1AddressChange;
  FChromium1.OnTitleChange := Chromium1TitleChange;
  FChromium1.OnFullScreenModeChange := Chromium1FullScreenModeChange;
  FChromium1.OnStatusMessage := Chromium1StatusMessage;
  FChromium1.OnBeforeDownload := Chromium1BeforeDownload;
  FChromium1.OnDownloadUpdated := Chromium1DownloadUpdated;
  FChromium1.OnAfterCreated := Chromium1AfterCreated;
  FChromium1.OnBeforeResourceLoad := Chromium1BeforeResourceLoad;
  FChromium1.OnResourceResponse := Chromium1ResourceResponse;

  CEFWindowParent1 := TCEFWindowParent.Create(Self);
  CEFWindowParent1.Name := 'CEFWindowParent1';
  CEFWindowParent1.Parent := Self;
  CEFWindowParent1.Left := 0;
  CEFWindowParent1.Top := 41;
  CEFWindowParent1.Width := 1179;
  CEFWindowParent1.Height := 652;
  CEFWindowParent1.Align := alClient;
  CEFWindowParent1.TabOrder := 1;

  DevTools := TCEFWindowParent.Create(Self);
  DevTools.Name := 'DevTools';
  DevTools.Parent := Self;
  DevTools.Left := 1184;
  DevTools.Top := 41;
  DevTools.Width := 0;
  DevTools.Height := 652;
  DevTools.Align := alRight;
  DevTools.TabOrder := 2;
  DevTools.Visible := False;

  Self.Menu := nil;

  if Assigned(DataModuleBrowserMenu) and
    Assigned(DataModuleBrowserMenu.MainMenu1) then
  begin
    CSSend('DataModuleBrowserMenu.MainMenu1.Items.Count',
      S(DataModuleBrowserMenu.MainMenu1.Items.Count));
    if (DataModuleBrowserMenu.MainMenu1.Items.Count > 3)
    then
    begin
      Self.Menu := DataModuleBrowserMenu.MainMenu1;
    end;
  end;

end;

procedure TMiniBrowserFrm.FormDestroy(Sender: TObject);
begin
  FResponse.Free;
  FRequest.Free;
end;

procedure TMiniBrowserFrm.FormShow(Sender: TObject);
begin
  ShowStatusText('Initializing browser. Please wait...');

  // WebRTC's IP leaking can lowered/avoided by setting these preferences
  // To test this go to https://www.browserleaks.com/webrtc
  FChromium1.WebRTCIPHandlingPolicy := hpDisableNonProxiedUDP;
  FChromium1.WebRTCMultipleRoutes   := STATE_DISABLED;
  FChromium1.WebRTCNonproxiedUDP    := STATE_DISABLED;

  // GlobalCEFApp.GlobalContextInitialized has to be TRUE before creating any browser
  // If it's not initialized yet, we use a simple timer to create the browser later.
  if not(FChromium1.CreateBrowser(CEFWindowParent1, '')) then Timer1.Enabled := True;
end;

procedure TMiniBrowserFrm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if not(FChromium1.CreateBrowser(CEFWindowParent1, '')) and not(FChromium1.Initialized) then
    Timer1.Enabled := True;
end;

procedure TMiniBrowserFrm.BrowserCreatedMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.UpdateSize;
  NavControlPnl.Enabled := True;
  if Assigned(DataModuleBrowserMenu) and (DataModuleBrowserMenu.StartURL <> '')
  then
  begin
    CSSend('opening', DataModuleBrowserMenu.StartURL);
    AddURL(DataModuleBrowserMenu.StartURL);
    FChromium1.LoadURL(DataModuleBrowserMenu.StartURL);
  end
  else
  begin
    AddURL(MINIBROWSER_HOMEPAGE);
    FChromium1.LoadURL(MINIBROWSER_HOMEPAGE);
  end;
end;

procedure TMiniBrowserFrm.AddURL(const aURL : string);
begin
  if (URLCbx.Items.IndexOf(aURL) < 0) then URLCbx.Items.Add(aURL);

  URLCbx.Text := aURL;
end;

procedure TMiniBrowserFrm.ShowDevToolsMsg(var aMessage : TMessage);
var
  TempPoint : TPoint;
begin
  TempPoint.x := (aMessage.wParam shr 16) and $FFFF;
  TempPoint.y := aMessage.wParam and $FFFF;
  ShowDevTools(TempPoint);
end;

procedure TMiniBrowserFrm.HideDevToolsMsg(var aMessage : TMessage);
begin
  HideDevTools;
end;

procedure TMiniBrowserFrm.Inczoom1Click(Sender: TObject);
begin
  FChromium1.IncZoomStep;
end;

function Init_Global_CEF: Boolean;
const cFn = 'Init_Global_CEF';
var
  bWishEraseCache: Boolean;
begin
  CSEnterMethod(nil, cFn);
  Result := True;

  // CSSend('GlobalCEFApp.Cache before adjustment', GlobalCEFApp.Cache); // always a blank string

  CSSend('menu module available for use now?', S(DataModuleBrowserMenu <> nil));

  GlobalCEFApp.Cache := CacheFolderRoot;

  bWishEraseCache := NOT HaveParam('/NoEraseCache');
  CSSend('bWishEraseCache', S(bWishEraseCache));
  GlobalCEFApp.DeleteCache := bWishEraseCache;
  GlobalCEFApp.DeleteCookies := bWishEraseCache;


  try
    ForceDirectories(GlobalCEFApp.Cache);
  except
    on E: Exception do
    begin
      CSSend('Cache', GlobalCEFApp.Cache);
      CSSendException(nil, cFn, E);
      Result := False;
    end;
  end;

  if Result then
  begin
    GlobalCEFApp.ProductVersion := '';
    GlobalCEFApp.Locale := '';
    GlobalCEFApp.LogFile := '';
    GlobalCEFApp.BrowserSubprocessPath := '';
    GlobalCEFApp.JavaScriptFlags := ''; // --touch-events=enabled
    GlobalCEFApp.ResourcesDirPath := '';
    GlobalCEFApp.LocalesDirPath := '';
    //GlobalCEFApp.FlagSingleProcess := False;  // single process does not work
    GlobalCEFApp.CommandLineArgsDisabled := True;
    GlobalCEFApp.PackLoadingDisabled := False;
    GlobalCEFApp.RemoteDebuggingPort := 0;
    GlobalCEFApp.UncaughtExceptionStackSize := 0;
    //??GlobalCEFApp.ContextSafetyImplementation := 0;

    GlobalCEFApp.PersistSessionCookies := (HaveParam('/NoEraseCache'));
    CSSend(cFn + ': PersistSessionCookies', S(GlobalCEFApp.PersistSessionCookies));
    GlobalCEFApp.IgnoreCertificateErrors := False;
    GlobalCEFApp.NoSandbox := False;
    GlobalCEFApp.WindowsSandboxInfo := nil;
    GlobalCEFApp.WindowlessRenderingEnabled := True;
    GlobalCEFApp.UserDataPath := StringReplace(GlobalCEFApp.Cache,
      PathDelim + 'cache' + PathDelim,
      PathDelim + 'UserDataPath' + PathDelim, []);
    CSSend(cFn + ': UserDataPath', GlobalCEFApp.UserDataPath);
    ForceDirectories(GlobalCEFApp.UserDataPath);
    GlobalCEFApp.AcceptLanguageList := ''; // use default
  end;
  CSExitMethod(nil, cFn);
end;

procedure TMiniBrowserFrm.Openfile1Click(Sender: TObject);
begin
  // This is a quick solution to load files. The file URL should be properly encoded.
  if OpenDialog1.Execute then FChromium1.LoadURL('file:///' + OpenDialog1.FileName);
end;

procedure TMiniBrowserFrm.PopupMenu1Popup(Sender: TObject);
begin
  if DevTools.Visible then
    DevTools1.Caption := 'Hide DevTools'
   else
    DevTools1.Caption := 'Show DevTools';
end;

procedure TMiniBrowserFrm.Preferences1Click(Sender: TObject);
begin
  case FChromium1.ProxyScheme of
    psSOCKS4 : PreferencesFrm.ProxySchemeCb.ItemIndex := 1;
    psSOCKS5 : PreferencesFrm.ProxySchemeCb.ItemIndex := 2;
    else       PreferencesFrm.ProxySchemeCb.ItemIndex := 0;
  end;

  PreferencesFrm.ProxyTypeCbx.ItemIndex  := FChromium1.ProxyType;
  PreferencesFrm.ProxyServerEdt.Text     := FChromium1.ProxyServer;
  PreferencesFrm.ProxyPortEdt.Text       := inttostr(FChromium1.ProxyPort);
  PreferencesFrm.ProxyUsernameEdt.Text   := FChromium1.ProxyUsername;
  PreferencesFrm.ProxyPasswordEdt.Text   := FChromium1.ProxyPassword;
  PreferencesFrm.ProxyScriptURLEdt.Text  := FChromium1.ProxyScriptURL;
  PreferencesFrm.ProxyByPassListEdt.Text := FChromium1.ProxyByPassList;
  PreferencesFrm.HeaderNameEdt.Text      := FChromium1.CustomHeaderName;
  PreferencesFrm.HeaderValueEdt.Text     := FChromium1.CustomHeaderValue;

  if (PreferencesFrm.ShowModal = mrOk) then
    begin
      FChromium1.ProxyType         := PreferencesFrm.ProxyTypeCbx.ItemIndex;
      FChromium1.ProxyServer       := PreferencesFrm.ProxyServerEdt.Text;
      FChromium1.ProxyPort         := strtoint(PreferencesFrm.ProxyPortEdt.Text);
      FChromium1.ProxyUsername     := PreferencesFrm.ProxyUsernameEdt.Text;
      FChromium1.ProxyPassword     := PreferencesFrm.ProxyPasswordEdt.Text;
      FChromium1.ProxyScriptURL    := PreferencesFrm.ProxyScriptURLEdt.Text;
      FChromium1.ProxyByPassList   := PreferencesFrm.ProxyByPassListEdt.Text;
      FChromium1.CustomHeaderName  := PreferencesFrm.HeaderNameEdt.Text;
      FChromium1.CustomHeaderValue := PreferencesFrm.HeaderValueEdt.Text;

      case PreferencesFrm.ProxySchemeCb.ItemIndex of
        1  : FChromium1.ProxyScheme := psSOCKS4;
        2  : FChromium1.ProxyScheme := psSOCKS5;
        else FChromium1.ProxyScheme := psHTTP;
      end;

      FChromium1.UpdatePreferences;
    end;
end;

procedure TMiniBrowserFrm.Print1Click(Sender: TObject);
begin
  FChromium1.Print;
end;

procedure TMiniBrowserFrm.PrintinPDF1Click(Sender: TObject);
begin
  SaveDialog1.DefaultExt := 'pdf';
  SaveDialog1.Filter     := 'PDF files (*.pdf)|*.PDF';

  if SaveDialog1.Execute and (length(SaveDialog1.FileName) > 0) then
    FChromium1.PrintToPDF(SaveDialog1.FileName, FChromium1.DocumentURL, FChromium1.DocumentURL);
end;

procedure TMiniBrowserFrm.ConfigBtnClick(Sender: TObject);
var
  TempPoint : TPoint;
begin
  TempPoint.x := ConfigBtn.left;
  TempPoint.y := ConfigBtn.top + ConfigBtn.Height;
  TempPoint   := ConfigPnl.ClientToScreen(TempPoint);

  PopupMenu1.Popup(TempPoint.x, TempPoint.y);
end;

procedure TMiniBrowserFrm.CopyHTMLMsg(var aMessage : TMessage);
begin
  FChromium1.RetrieveHTML;
end;

procedure TMiniBrowserFrm.CopyAllTextMsg(var aMessage : TMessage);
begin
  FChromium1.RetrieveText;
end;

procedure TMiniBrowserFrm.CopyFramesIDsMsg(var aMessage : TMessage);
var
  i          : NativeUInt;
  TempCount  : NativeUInt;
  TempArray  : TCefFrameIdentifierArray;
  TempString : string;
begin
  TempCount := FChromium1.FrameCount;

  if FChromium1.GetFrameIdentifiers(TempCount, TempArray) then
    begin
      TempString := '';
      i          := 0;

      while (i < TempCount) do
        begin
          TempString := TempString + inttostr(TempArray[i]) + CRLF;
          inc(i);
        end;

      clipboard.AsText := TempString;
    end;
end;

procedure TMiniBrowserFrm.CopyFramesNamesMsg(var aMessage : TMessage);
var
  TempSL : TStringList;
begin
  try
    TempSL := TStringList.Create;

    if FChromium1.GetFrameNames(TStrings(TempSL)) then clipboard.AsText := TempSL.Text;
  finally
    FreeAndNil(TempSL);
  end;
end;

procedure TMiniBrowserFrm.ShowResponseMsg(var aMessage : TMessage);
begin
  SimpleTextViewerFrm.Memo1.Lines.Clear;

  SimpleTextViewerFrm.Memo1.Lines.Add('--------------------------');
  SimpleTextViewerFrm.Memo1.Lines.Add('Request headers : ');
  SimpleTextViewerFrm.Memo1.Lines.Add('--------------------------');
  if (FRequest <> nil) then SimpleTextViewerFrm.Memo1.Lines.AddStrings(FRequest);

  SimpleTextViewerFrm.Memo1.Lines.Add('');

  SimpleTextViewerFrm.Memo1.Lines.Add('--------------------------');
  SimpleTextViewerFrm.Memo1.Lines.Add('Response headers : ');
  SimpleTextViewerFrm.Memo1.Lines.Add('--------------------------');
  if (FResponse <> nil) then SimpleTextViewerFrm.Memo1.Lines.AddStrings(FResponse);

  SimpleTextViewerFrm.ShowModal;
end;

procedure TMiniBrowserFrm.SavePreferencesMsg(var aMessage : TMessage);
begin
  SaveDialog1.DefaultExt := 'txt';
  SaveDialog1.Filter     := 'Text files (*.txt)|*.TXT';

  if SaveDialog1.Execute and (length(SaveDialog1.FileName) > 0) then
    FChromium1.SavePreferences(SaveDialog1.FileName);
end;

procedure TMiniBrowserFrm.TakeSnapshotMsg(var aMessage : TMessage);
var
  TempBitmap : TBitmap;
begin
  TempBitmap := nil;

  try
    SaveDialog1.DefaultExt := 'bmp';
    SaveDialog1.Filter     := 'Bitmap files (*.bmp)|*.BMP';

    if SaveDialog1.Execute and
       (length(SaveDialog1.FileName) > 0) and
       FChromium1.TakeSnapshot(TempBitmap) then
      TempBitmap.SaveToFile(SaveDialog1.FileName);
  finally
    if (TempBitmap <> nil) then FreeAndNil(TempBitmap);
  end;
end;

procedure TMiniBrowserFrm.WMMove(var aMessage : TWMMove);
begin
  inherited;

  if (FChromium1 <> nil) then FChromium1.NotifyMoveOrResizeStarted;
end;

procedure TMiniBrowserFrm.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (FChromium1 <> nil) then FChromium1.NotifyMoveOrResizeStarted;
end;

procedure TMiniBrowserFrm.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := True;
end;

procedure TMiniBrowserFrm.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := False;
end;

procedure TMiniBrowserFrm.Deczoom1Click(Sender: TObject);
begin
  FChromium1.DecZoomStep;
end;

procedure TMiniBrowserFrm.DevTools1Click(Sender: TObject);
begin
  if DevTools.Visible then
    HideDevTools
   else
    ShowDevTools;
end;

procedure TMiniBrowserFrm.Exit1Click(Sender: TObject);
begin
  FChromium1.StopLoad;
  FreeAndNil(FChromium1);
  Self.Close;
end;

procedure TMiniBrowserFrm.ShowDevTools(aPoint : TPoint);
begin
  Splitter1.Visible := True;
  DevTools.Visible  := True;
  DevTools.Width    := Width div 4;
  FChromium1.ShowDevTools(aPoint, DevTools);
end;

procedure TMiniBrowserFrm.ShowDevTools;
var
  TempPoint : TPoint;
begin
  TempPoint.x := low(integer);
  TempPoint.y := low(integer);
  ShowDevTools(TempPoint);
end;

procedure TMiniBrowserFrm.HideDevTools;
begin
  FChromium1.CloseDevTools(DevTools);
  Splitter1.Visible := False;
  DevTools.Visible  := False;
  DevTools.Width    := 0;
end;

end.
