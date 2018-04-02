unit GoogleAs_uCEF3_Init;

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

{$I hrefdefines.inc}

uses
  SysUtils,
  //tpShareB,
  ZM_CodeSiteInterface,
  uCEFLibFunctions;

function  AppDataGoogleAs: string;
function  CacheFolderRoot: string;
//procedure ConditionalStartup(const Flag: Boolean);
procedure EraseCacheFiles;
(*procedure InitCEF_GoogleAs(out IsFirstInit: Boolean);*)
//function  IsPrimaryProcess: Boolean;

{var
  SharedFlag: TSharedStr = nil;
  SharedCache: TSharedStr = nil;
  SharedInstanceCount: TSharedInt = nil;
  SharedPersistSessionCookies: TSharedInt = nil;
}
implementation

uses
  ActiveX, // CoInitialize
  Forms, IOUtils
  {$IFDEF Delphi16UP}
  ,
  System.Types,
  System.UITypes
  {$ENDIF}
  , ZM_LoggingBase, ZaphodsMap
  , ucString, ucShellProcessCntrl, uCode, ucDlgs,
  GoogleAs_uBookmark;
  //GoogleAs_fmChromium;

(*function IsPrimaryProcess: Boolean;
const cFn = 'IsPrimaryProcess';
begin
  //CSEnterMethod(nil, cFn);
  Result := ParamCount = 0;
  if (ParamCount >= 1) then
    Result := Copy(ParamStr(1), 1, 6) <> '--type';
  //CSSend(cFn + ': Result', S(Result));
  //CSExitMethod(nil, cFn);
end;*)

(*function PrimaryProcessPID: Integer;
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
  CSSend(cFn + ': Result', S(Result));
  CSExitMethod(nil, cFn);
end;*)

function AppDataGoogleAs: string;
const cFn = 'AppDataGoogleAs';
var
  ZM: TZaphodsMap;
  ADoc: TZaphodXmlDoc;
begin
  ZM := nil;
  Result := '';

  try
    ZM := TZaphodsMap.CreateForBranch(nil, cGoogleAs_ZMBranch);
    if ZM.BranchKeyboxExists then
    begin
      ADoc := ZM.ActivateKeyDoc(cGoogleAs_ProgramNickname, 'main', cxOptional,
        usrNone,
        cGoogleAs_ProgramNickname,
        cDefaultConfigFilespec
        );

      if ADoc <> nil then
      begin
        Result := ADoc.ZNodeAttr(nil,
            ['Data', 'CacheFolderRoot'], cxOptional, '', 'value');
      end;
    end;
  finally
    ZM.DeactivateAllKeys;
    FreeAndNil(ZM);
  end;

  if Result = '' then
  begin
    // for Windows: write end-user files to the data area (not program files)
    Result :=
      IncludeTrailingPathDelimiter(GetEnvironmentVariable('AppData')) +
        cGoogleAs_ProgramNickname + PathDelim;
  end
  else
    Result := IncludeTrailingPathDelimiter(Result);
  CSSend(cFn + ': Result', Result);
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

  Extra := '';
  if ParamCount >= 1 then
  begin

    Extra := Trim(ParamStr(1)); // bookmark identifier
    if Extra <> '' then
    begin
      if Extra[1] = '-' then  // --type=gpu-process
        Extra := ''
      else
      begin
        Extra := Extra + '_' + Trim(ParamStr(2)); // email address
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
  CSSend(cFn + ': Result', Result);
  CSExitMethod(nil, cFn);
end;

(*
procedure InitCEF_GoogleAs(out IsFirstInit: Boolean);
const cFn = 'InitCEF_GoogleAs';
var
  ErrorText: string;
  DivName: string;
  Cache, UserAgent, ProductVersion, Locale, LogFile: string;
  BrowserSubprocessPath: string;
  JavaScriptFlags, ResourcesDirPath, LocalesDirPath: string;
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
    cGoogleAs_ProgramNickname + 'Startup',
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

  SharedPersistSessionCookies := TSharedInt.CreateNamed(nil,
    'PersistSessionCookies',
    cReadWriteSharedMem,  // not readonly
    cLocalSharedMem);     // no need for global memory

  FlagIsPrimaryProcess := IsPrimaryProcess;

  CSSend('about to figure DivName');
  DivName := cGoogleAs_ProgramNickname + '_' + IntToStr(PrimaryProcessPID);
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
  if (FlagIsPrimaryProcess) then
  begin
    if HaveParam('/NoEraseCache') then
      SharedPersistSessionCookies.GlobalInteger := 1
    else
      SharedPersistSessionCookies.GlobalInteger := 0;
  end;
  PersistSessionCookies := (SharedPersistSessionCookies.GlobalInteger = 1);
  CSSend(cFn + ': PersistSessionCookies', S(PersistSessionCookies));
  IgnoreCertificateErrors := False;
  NoSandbox := False;
  WindowsSandboxInfo := nil;
  WindowlessRenderingEnabled := True;
  UserDataPath := StringReplace(Cache,
    PathDelim + 'cache' + PathDelim,
    PathDelim + 'UserDataPath' + PathDelim, []);
  CSSend(cFn + ': UserDataPath', UserDataPath);
  ForceDirectories(UserDataPath);
  AcceptLanguageList := ''; // use default


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
*)

procedure EraseCacheFiles;
const cFn = 'EraseCacheFiles';
var
  Filespec: string;
  bWishEraseCache: Boolean;
begin
  CSEnterMethod(nil, cFn);
  { As long as the chromium DLLs have not yet loaded, this deletes all files
    from cache. If the DLLs have already loaded, then
    it deletes everything EXCEPT the 4 control files. Therefore
    counter-productive. The 4 control files are locked as long as the CEF
    library is in memory. }

  bWishEraseCache := NOT HaveParam('/NoEraseCache');
  CSSend('bWishEraseCache', S(bWishEraseCache));

  if bWishEraseCache then
  begin

    if DirectoryExists(CacheFolderRoot) then
    begin
      for Filespec in TDirectory.GetFiles(CacheFolderRoot, '*.*') do
      begin
        //{$IFDEF DEBUG}
        LogSendWarning('Deleting ' + Filespec);
        //{$ENDIF}
        SysUtils.DeleteFile(Filespec);
      end;
    end;

  end;
  CSExitMethod(nil, cFn);
end;

(*procedure ConditionalStartup(const Flag: Boolean);
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
    ///////////Application.CreateForm(TfmChromiumWrapper, fmChromiumWrapper);

    CSSend(csmLevel5, 'About to call Application.Run');
    Application.Run;
  end
  else
  begin
    CSSendNote('FYI: nested process for CEF3 rendering and WebKit call-backs');
  end;
  CSExitMethod(nil, cFn);
end;*)

initialization
  CoInitialize(nil);  // for WinShellOpen of PDF files
  {$IFDEF CodeSite}
  {$IF Defined(DEBUG)}
  SetCodeSiteLoggingState([cslAll]); // Developer DEBUG mode
  {$ELSE}
  SetCodeSiteLoggingState([cslInfoType, cslWarning, cslError, cslException]); // default, until configuration is loaded.
  {$IFEND}
  {$ENDIF}

finalization
  try
    //FreeAndNil(SharedFlag);
    //FreeAndNil(SharedInstanceCount);
    //FreeAndNil(SharedCache);
  except
    on E: Exception do
    begin
      CSSendError('detected Exception in finalization of uCEF3_Init.pas');
      CSSendException(E);
    end;
  end;
end.
