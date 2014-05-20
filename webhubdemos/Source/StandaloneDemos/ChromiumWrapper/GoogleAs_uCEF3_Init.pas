unit GoogleAs_uCEF3_Init;

interface

{$I hrefdefines.inc}

uses
  SysUtils,
  tpShareB,
  ucCodeSiteInterface,
  ceflib;

procedure ConditionalStartup(const Flag: Boolean);
procedure EraseCacheFiles;
procedure InitCEF_GoogleAs(out IsFirstInit: Boolean);

var
  SharedFlag: TSharedStr = nil;
  SharedInstanceCount: TSharedInt = nil;

implementation

uses
  {$IFDEF Delphi15}Windows,{$ENDIF}
  Forms, IOUtils
  {$IFDEF Delphi16UP}
  ,
  System.Types,
  System.UITypes
  {$ENDIF}
  , GoogleAs_fmChromium;

procedure InitCEF_GoogleAs(out IsFirstInit: Boolean);
const cFn = 'InitCEF_GoogleAs';
{$IFDEF CEF3}
var
  ErrorText: string;
  Cache, UserAgent, ProductVersion, Locale, LogFile, BrowserSubprocessPath: ustring;
  //LogSeverity: TCefLogSeverity;
  JavaScriptFlags, ResourcesDirPath, LocalesDirPath: ustring;
  FlagSingleProcess, CommandLineArgsDisabled, PackLoadingDisabled: Boolean;
  RemoteDebuggingPort: Integer;
  ReleaseDCheck: Boolean; UncaughtExceptionStackSize: Integer;
  ContextSafetyImplementation: Integer;
  PersistSessionCookies: Boolean; IgnoreCertificateErrors: Boolean;
{$ENDIF}
begin
  CSEnterMethod(nil, cFn);

  SharedFlag := TSharedStr.Create(nil);
  SharedFlag.Name := 'SharedFlag';
  SharedFlag.GlobalName := 'GoogleAsStartup';
  {$IFDEF CEF3}
  SharedFlag.IgnoreOwnChanges := True;   // dual process !!
  {$ELSE}
  SharedFlag.IgnoreOwnChanges := False;  // single process !!
  {$ENDIF}
  CSSend('SharedFlag.GlobalAnsiString', string(SharedFlag.GlobalAnsiString));

  {$IFDEF CEF3}
  SharedInstanceCount := TSharedInt.Create(nil);
  SharedInstanceCount.Name := 'SharedInstanceCount';
  SharedInstanceCount.GlobalName := ExtractFilename(ParamStr(0));
  SharedInstanceCount.GlobalInteger := SharedInstanceCount.GlobalInteger + 1;

  if SharedInstanceCount.GlobalInteger = 1 then
    EraseCacheFiles;  // First CEF3 instance erase cache prior to loading DLLs

  begin
    // CefLoadLibDefault is not enough when you want to control the startup
    // settings. So use CefLoadLib below.

    Cache := ExtractFilePath(ParamStr(0)) + PathDelim + 'cache';
    CSSend('Cache directory', Cache);
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
  end
  //else
  //  IsFirstInit := False
  ;

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
  CacheFolderRoot: string;
begin
  CSEnterMethod(nil, cFn);
  { As long as the chromium DLLs have not yet loaded, this deletes all files
    from cache. If the DLLs have already loaded, then
    it deletes everything EXCEPT the 4 control files. Therefore
    counter-productive. The 4 control files are locked as long as the CEF
    library is in memory. }
  CacheFolderRoot := ExtractFilePath(ParamStr(0)) + PathDelim + 'cache';
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
  FreeAndNil(SharedInstanceCount);

end.
