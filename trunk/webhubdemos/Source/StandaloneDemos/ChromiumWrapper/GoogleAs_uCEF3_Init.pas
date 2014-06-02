unit GoogleAs_uCEF3_Init;

interface

{$I hrefdefines.inc}

uses
  SysUtils,
  tpShareB,
  ucCodeSiteInterface,
  ceflib;

function CacheFolderRoot: string;
procedure ConditionalStartup(const Flag: Boolean);
procedure EraseCacheFiles;
procedure InitCEF_GoogleAs(out IsFirstInit: Boolean);

var
  SharedFlag: TSharedStr = nil;
  SharedCache: TSharedStr = nil;
  {$IFDEF CEF3}
  SharedInstanceCount: TSharedInt = nil;
  {$ENDIF}

implementation

uses
  {$IFDEF Delphi15}Windows,{$ENDIF}
  Forms, IOUtils
  {$IFDEF Delphi16UP}
  ,
  System.Types,
  System.UITypes
  {$ENDIF}
  , ucString, ucShellProcessCntrl, uCode,
  GoogleAs_fmChromium;

function IsPrimaryProcess: Boolean;
const cFn = 'IsPrimaryProcess';
begin
  CSEnterMethod(nil, cFn);
  Result := ParamCount = 0;
  if (ParamCount >= 1) then
    Result := Copy(ParamStr(1), 1, 6) <> '--type';
  CSSend(cFn + ': Result', S(Result));
  CSExitMethod(nil, cFn);
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

function CacheFolderRoot: string;
const cFn = 'CacheFolderRoot';
var
  Extra: string;
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
    Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
      'cache' + Extra;
  end
  else
  begin
    CSSendError('should not call this way');
    if Assigned(SharedCache) then
    begin
      CSSend('SharedCache exists');
      Result := string(SharedCache.GlobalUTF8String);
    end
    else
    begin
      CSSendWarning('SharedCache does not exist');
      Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
        'cache';
    end;
  end;
  CSSend(cFn + ': Result', Result);
  CSExitMethod(nil, cFn);
end;

procedure InitCEF_GoogleAs(out IsFirstInit: Boolean);
const cFn = 'InitCEF_GoogleAs';
{$IFDEF CEF3}
var
  ErrorText: string;
  DivName: string;
  Cache, UserAgent, ProductVersion, Locale, LogFile, BrowserSubprocessPath: ustring;
  //LogSeverity: TCefLogSeverity;
  JavaScriptFlags, ResourcesDirPath, LocalesDirPath: ustring;
  FlagSingleProcess, CommandLineArgsDisabled, PackLoadingDisabled: Boolean;
  RemoteDebuggingPort: Integer;
  ReleaseDCheck: Boolean; UncaughtExceptionStackSize: Integer;
  ContextSafetyImplementation: Integer;
  PersistSessionCookies: Boolean; IgnoreCertificateErrors: Boolean;
  i: Integer;
{$ENDIF}
begin
  CSEnterMethod(nil, cFn);

  for i := 1 to ParamCount do
    CSSend('ParamStr(' + S(i) +')', ParamStr(i));

  {$IFDEF CEF3}
  SharedInstanceCount := TSharedInt.Create(nil);
  SharedInstanceCount.Name := 'SharedInstanceCount';
  {$ENDIF}

  SharedFlag := TSharedStr.Create(nil);
  SharedFlag.Name := 'SharedFlag';

  SharedCache := TSharedStr.Create(nil);
  SharedCache.Name := 'SharedCache';

  {$IFDEF CEF3}
  SharedInstanceCount.GlobalName := ExtractFilename(ParamStr(0));
  SharedInstanceCount.GlobalInteger := SharedInstanceCount.GlobalInteger + 1;
  CSSend('SharedInstanceCount.GlobalInteger',
    S(SharedInstanceCount.GlobalInteger));
  {$ENDIF}

  SharedFlag.GlobalName := 'GoogleAsStartup';
  {$IFDEF CEF3}
  SharedFlag.IgnoreOwnChanges := True;   // dual process !!
  {$ELSE}
  SharedFlag.IgnoreOwnChanges := False;  // single process !!
  {$ENDIF}

  CSSend('about to figure DivName');
  DivName := 'GoogleAs_' + IntToStr(PrimaryProcessPID);
  CSSend('DivName', DivName);
  SharedCache.GlobalName := DivName;
  SharedCache.IgnoreOwnChanges := True;

  {$IFDEF CEF3}
  if IsPrimaryProcess then
  begin
    Cache := CacheFolderRoot;
    CSSend('Cache', Cache);
    SharedCache.GlobalUTF8String := UTF8String(Cache);
    EraseCacheFiles;  // First CEF3 instance erase cache prior to loading DLLs
  end
  else
  begin
    if Assigned(SharedCache) then
      Cache := string(SharedCache.GlobalUTF8String)
    else
    begin
      CSSendWarning('SharedCache nil');
      Cache := CacheFolderRoot;
    end;
    CSSend('Cache', Cache);
  end;

  // CefLoadLibDefault is not enough when you want to control the startup
  // settings. So use CefLoadLib below.

  ForceDirectories(Cache);
  //UserAgent := ''; // if overridden, default value is lost.
  UserAgent :=
    'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.73 Safari/537.36';
  ProductVersion := '';
  Locale := '';
  LogFile := '';
  BrowserSubprocessPath := '';
  JavaScriptFlags := '';
  ResourcesDirPath := '';
  LocalesDirPath := '';
  FlagSingleProcess := False;  // single process does not work
  CommandLineArgsDisabled := True;
  PackLoadingDisabled := False;
  RemoteDebuggingPort := 0;
  ReleaseDCheck := False;  // easier debugging even after release
  UncaughtExceptionStackSize := 0;
  ContextSafetyImplementation := 0;
  PersistSessionCookies := False;
  IgnoreCertificateErrors := False;

  IsFirstInit := CefLoadLib(cache, UserAgent, ProductVersion, Locale, LogFile,
    BrowserSubprocessPath, LOGSEVERITY_DISABLE,
    JavaScriptFlags, ResourcesDirPath, LocalesDirPath,
    FlagSingleProcess, CommandLineArgsDisabled, PackLoadingDisabled,
    RemoteDebuggingPort, ReleaseDCheck, UncaughtExceptionStackSize,
    ContextSafetyImplementation,
    PersistSessionCookies, IgnoreCertificateErrors
    );
  if IsFirstInit then
  begin
    //
  end
  else
  begin
    ErrorText := 'Unable to load CEF3 DLL library files';
    CSSendError(ErrorText);
  end;

  CSSend('IsFirstInit', S(IsFirstInit));
  {$ELSE}
     IsFirstInit := True; // CEF1 does it elsewhere in unit initialization
  {$ENDIF}

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
begin
  if Flag then
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;

    Application.CreateForm(TfmChromiumWrapper, fmChromiumWrapper);

    CSSendNote('About to call Application.Run');
    Application.Run;
  end
  else
  begin
    {$IFDEF CEF3}
    CSSendError('FYI: nested process for CEF3 rendering and WebKit call-backs');
    {$ENDIF}
  end;
end;

initialization
finalization
  FreeAndNil(SharedFlag);
  {$IFDEF CEF3}
  FreeAndNil(SharedInstanceCount);
  {$ENDIF}
  FreeAndNil(SharedCache);

end.
