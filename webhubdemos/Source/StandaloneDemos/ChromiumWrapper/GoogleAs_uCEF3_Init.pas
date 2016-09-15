unit GoogleAs_uCEF3_Init;

interface

{$I hrefdefines.inc}

uses
  SysUtils,
  tpShareB,
  ucCodeSiteInterface,
  ceflib;

function AppDataGoogleAs: string;
function CacheFolderRoot: string;
procedure ConditionalStartup(const Flag: Boolean);
procedure EraseCacheFiles;
procedure InitCEF_GoogleAs(out IsFirstInit: Boolean);
function IsPrimaryProcess: Boolean;

var
  SharedFlag: TSharedStr = nil;
  SharedCache: TSharedStr = nil;
  SharedInstanceCount: TSharedInt = nil;

implementation

uses
  ActiveX, // CoInitialize
  Forms, IOUtils
  {$IFDEF Delphi16UP}
  ,
  System.Types,
  System.UITypes
  {$ENDIF}
  , ucString, ucShellProcessCntrl, uCode, ucDlgs,
  GoogleAs_fmChromium;

function IsPrimaryProcess: Boolean;
const cFn = 'IsPrimaryProcess';
begin
  //CSEnterMethod(nil, cFn);
  Result := ParamCount = 0;
  if (ParamCount >= 1) then
    Result := Copy(ParamStr(1), 1, 6) <> '--type';
  //CSSend(cFn + ': Result', S(Result));
  //CSExitMethod(nil, cFn);
end;

function PrimaryProcessPID: Integer;
const cFn = 'PrimaryProcessPID';
var
  CEF3Channel: string;
begin
  CSEnterMethod(nil, cFn);

  if IsPrimaryProcess then
    Result := GetCurrentProcessID
  else
  begin
    if ParamCount >= 2 then
    begin
      // ParamStr(2) = --channel=5184.0.844380937\1519884606
      CEF3Channel := ParamString('-channel'); // Copy(ParamStr(2), 11, MaxInt);
      CSSend('CEF3Channel', CEF3Channel);
      Result := StrToIntDef(LeftOf('.', CEF3Channel), 0);
    end
    else
      Result := 0;
  end;
  (*if Assigned(SharedInstanceCount) then
  begin
    n := SharedInstanceCount.GlobalInteger - 1;
    CSSend('n', S(n));
    Result := (n Div 3) + 1;
  end
  else*)
  CSSend(cFn + ': Result', S(Result));
  CSExitMethod(nil, cFn);
end;

function AppDataGoogleAs: string;
begin
  // for Windows: write end-user files to the data area (not program files)
  Result :=
    IncludeTrailingPathDelimiter(GetEnvironmentVariable('AppData')) +
      'GoogleAs' + PathDelim;
end;

function CacheFolderRoot: string;
const cFn = 'CacheFolderRoot';
var
  Extra: string;

  function AppDataGoogleAsCache: string;
  begin
    // for Windows: write end-user files to the data area (not program files)
    Result := AppDataGoogleAs + 'cache';
  end;

begin
  CSEnterMethod(nil, cFn);
  if IsPrimaryProcess then
  begin

    Extra := '';
    if ParamCount >= 1 then
    begin

      Extra := Trim(ParamStr(1));
      if Extra <> '' then
      begin
        if Extra[1] = '-' then  // --type=gpu-process
          Extra := ''
        else
        begin
          Extra := StringReplaceAll(Extra, '@', '_');
          Extra := StringReplaceAll(Extra, '.', '_');
          Extra := PathDelim + Extra;
        end;
      end;
    end;
    Result := AppDataGoogleAsCache + Extra;
    try
      ForceDirectories(Result);
    except
      on E: Exception do
      begin
        CSSend(cFn, Result);
        CSSendException(E);
        MsgErrorOk(E.Message + sLineBreak + sLineBreak + Result);
      end;
    end;
  end
  else
  begin
    CSSendError(cFn + ': should not call this way');
    if Assigned(SharedCache) then
    begin
      CSSend('SharedCache exists');
      Result := string(SharedCache.GlobalUTF8String);
    end
    else
    begin
      CSSendWarning('SharedCache does not exist');
      Result := AppDataGoogleAsCache;
    end;
  end;
  CSSend(cFn + ': Result', Result);
  CSExitMethod(nil, cFn);
end;

procedure InitCEF_GoogleAs(out IsFirstInit: Boolean);
const cFn = 'InitCEF_GoogleAs';
var
  ErrorText: string;
  DivName: string;
  Cache, UserAgent, ProductVersion, Locale, LogFile, BrowserSubprocessPath: ustring;
  JavaScriptFlags, ResourcesDirPath, LocalesDirPath: ustring;
  FlagSingleProcess, CommandLineArgsDisabled, PackLoadingDisabled: Boolean;
  RemoteDebuggingPort: Integer;
  //ReleaseDCheck: Boolean;
  UncaughtExceptionStackSize: Integer;
  ContextSafetyImplementation: Integer;
  PersistSessionCookies: Boolean; IgnoreCertificateErrors: Boolean;
  BackgroundCefColor: Cardinal;
  WindowsSandboxInfo: Pointer;
  WindowlessRenderingEnabled: Boolean;
  i: Integer;
  NoSandbox: Boolean;
  UserDataPath, AcceptLanguageList: string;
  FlagIsPrimaryProcess: Boolean;
begin
  CSEnterMethod(nil, cFn);

  BackgroundCefColor := 0;

  for i := 1 to ParamCount do
    CSSend('ParamStr(' + S(i) +')', ParamStr(i));

  SharedFlag := TSharedStr.CreateNamed(nil, 
    'GoogleAsStartup', 
    1024, 
    cReadWriteSharedMem,  // not readonly
    cLocalSharedMem);     // no need for global memory
  SharedFlag.Name := 'SharedFlag';
  SharedFlag.IgnoreOwnChanges := True;   // dual process !!

  SharedInstanceCount := TSharedInt.CreateNamed(nil, 
    ExtractFilename(ParamStr(0)),
    cReadWriteSharedMem,  // not readonly
    cLocalSharedMem);     // no need for global memory

  SharedInstanceCount.GlobalInteger := SharedInstanceCount.GlobalInteger + 1;
  CSSend(SharedInstanceCount.GlobalName + '.GlobalInteger',
    S(SharedInstanceCount.GlobalInteger));

  FlagIsPrimaryProcess := IsPrimaryProcess;

  CSSend('about to figure DivName');
  DivName := 'GoogleAs_' + IntToStr(PrimaryProcessPID);
  CSSend('DivName', DivName);

  {NB: global UTF8 string is not available to additional processes unless the
   shared string is created here with the CreateNamed method. 24.Feb.2015 }
  SharedCache := TSharedStr.CreateNamed(nil, DivName, DefaultSharedBufSize,
    NOT IsPrimaryProcess, // readonly true/false
    cLocalSharedMem,     // no need for global memory
    15 * 1000);
  SharedCache.Name := 'SharedCache';

  if SharedCache.GlobalName <> ('Local\' + DivName) then
    CSSendError(Format('SharedCache.GlobalName %s should be %s',
      [SharedCache.GlobalName, ('Local\' + DivName)]));
  SharedCache.IgnoreOwnChanges := True;

  if (FlagIsPrimaryProcess) then
  begin
    Cache := CacheFolderRoot;
    CSSend('Cache', Cache);
    SharedCache.GlobalUTF8String := UTF8String(Cache);
    CSSend('SharedCache.GlobalUTF8String', string(SharedCache.GlobalUTF8String));
    EraseCacheFiles;  // First CEF3 instance erase cache prior to loading DLLs
  end
  else
  begin
    if Assigned(SharedCache) then
    begin
      Cache := string(SharedCache.GlobalUTF8String);
      if Cache = '' then
      begin
        CSSendError('SharedCache.GlobalUTF8String blank string');
        Cache := CacheFolderRoot;
      end;
    end
    else
    begin
      CSSendWarning('SharedCache nil');
      Cache := CacheFolderRoot;
    end;
    CSSend('Cache', Cache);
  end;

  // CefLoadLibDefault is not enough when you want to control the startup
  // settings. So use CefLoadLib below.

  try
    ForceDirectories(Cache);
  except
    on E: Exception do
    begin
      CSSend('Cache', Cache);
      CSSendException(E);
    end;
  end;
  UserAgent := ''; // if overridden, default value is lost.
  //UserAgent :=
  //  'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.73 Safari/537.36';
  ProductVersion := '';
  Locale := '';
  LogFile := '';
  BrowserSubprocessPath := '';
  JavaScriptFlags := ''; // --touch-events=enabled
  ResourcesDirPath := '';
  LocalesDirPath := '';
  FlagSingleProcess := False;  // single process does not work
  CommandLineArgsDisabled := True;
  PackLoadingDisabled := False;
  RemoteDebuggingPort := 0;
  UncaughtExceptionStackSize := 0;
  ContextSafetyImplementation := 0;
  PersistSessionCookies := False;
  IgnoreCertificateErrors := False;
  NoSandbox := False;
  WindowsSandboxInfo := nil;
  WindowlessRenderingEnabled := True;
  UserDataPath := ''; // use default
  AcceptLanguageList := ''; // use default

(*
CefLoadLib syntax as of 20-Jun-2016:

function CefLoadLib(const Cache, UserDataPath, UserAgent, ProductVersion, Locale, LogFile, BrowserSubprocessPath: ustring;
  LogSeverity: TCefLogSeverity; JavaScriptFlags, ResourcesDirPath, LocalesDirPath: ustring;
  SingleProcess, NoSandbox, CommandLineArgsDisabled, PackLoadingDisabled: Boolean; RemoteDebuggingPort: Integer;
  UncaughtExceptionStackSize: Integer; ContextSafetyImplementation: Integer;
  PersistSessionCookies: Boolean; IgnoreCertificateErrors: Boolean; BackgroundColor: TCefColor;
  const AcceptLanguageList: ustring; WindowsSandboxInfo: Pointer; WindowlessRenderingEnabled: Boolean): Boolean;
*)
  
  //  CSSend('about to call CefLoadLib');
  IsFirstInit := //IsPrimaryProcess and 
    CefLoadLib(cache, 
    UserDataPath, 
    UserAgent, 
    ProductVersion, 
    Locale, 
    LogFile,
    BrowserSubprocessPath,
    LOGSEVERITY_DISABLE, JavaScriptFlags, ResourcesDirPath, LocalesDirPath,
    FlagSingleProcess, NoSandbox, CommandLineArgsDisabled, PackLoadingDisabled,
    RemoteDebuggingPort,
    UncaughtExceptionStackSize, ContextSafetyImplementation,
    PersistSessionCookies, IgnoreCertificateErrors, BackgroundCefColor,
    AcceptLanguageList,
    WindowsSandboxInfo, WindowlessRenderingEnabled
    );
  //CSSend('Done calling CefLoadLib');

  CSSend('FlagIsPrimaryProcess', S(FlagIsPrimaryProcess));
  //CSSend('IsFirstInit', S(IsFirstInit));

  if FlagIsPrimaryProcess and (NOT IsFirstInit) then
  begin
    ErrorText := 'Unable to load CEF3 DLL library files';
    CSSendError(ErrorText);
  end;
  
  CSExitMethod(nil, cFn);
end;

procedure EraseCacheFiles;
const cFn = 'EraseCacheFiles';
var
  Filespec: string;
begin
  CSEnterMethod(nil, cFn);
  { As long as the chromium DLLs have not yet loaded, this deletes all files
    from cache. If the DLLs have already loaded, then
    it deletes everything EXCEPT the 4 control files. Therefore
    counter-productive. The 4 control files are locked as long as the CEF
    library is in memory. }
  if DirectoryExists(CacheFolderRoot) then
  begin
  for Filespec in TDirectory.GetFiles(CacheFolderRoot, '*.*') do
  begin
    CSSendWarning('Deleting ' + Filespec);
    SysUtils.DeleteFile(Filespec);
  end;
  end;
  CSExitMethod(nil, cFn);
end;

procedure ConditionalStartup(const Flag: Boolean);
const cFn = 'ConditionalStartup';
//var
//  TempStr: string;
begin
  CSEnterMethod(nil, cFn);
  if Flag then
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;

    CSSend(csmLevel5, 'Creating TfmChromiumWrapper');
    // must create Chromium wrapper form first -- MainForm
    Application.CreateForm(TfmChromiumWrapper, fmChromiumWrapper);

    CSSend(csmLevel5, 'About to call Application.Run');
    Application.Run;
  end
  else
  begin
    CSSendNote('FYI: nested process for CEF3 rendering and WebKit call-backs');
  end;
  CSExitMethod(nil, cFn);
end;

initialization
  CoInitialize(nil);  // for WinShellOpen of PDF files
  {$IFDEF CodeSite}
  {$IFDEF DEBUG}
  SetCodeSiteLoggingState([cslAll]); // Developer DEBUG mode
  {$ELSE}
  SetCodeSiteLoggingState([cslWarning, cslError, cslException]); // default, until configuration is loaded.
  {$ENDIF}
  {$ENDIF}

finalization
  try
    FreeAndNil(SharedFlag);
    FreeAndNil(SharedInstanceCount);
    FreeAndNil(SharedCache);
  except
    on E: Exception do
    begin
      CSSendError('finalization of uCEF3_Init.pas');
      CSSendException(E);
    end;
  end;
end.
