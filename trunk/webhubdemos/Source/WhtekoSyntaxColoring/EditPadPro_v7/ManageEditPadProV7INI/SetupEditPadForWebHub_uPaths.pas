unit SetupEditPadForWebHub_uPaths;

interface

const
  cHREFToolsColorsIniFilespec= 'HREFTools-Colors.ini';
  cHREFToolsEPPToolsIniFilespec= 'HREFTools-EPPTools.ini';

function EditPadPlusDataRoot: string;

implementation

uses
  Classes, SysUtils,
  Windows,
  ZM_CodeSiteInterface,
  ucDlgs, ucDlgsGUI, ucString;

function EditPadPlusDataRoot: string;
const cFn = 'EditPadPlusDataRoot';
var
  InfoMsg: string;
begin
  //CSEnterMethod(nil, cFn);
  Result := IncludeTrailingPathDelimiter(GetEnvironmentVariable('AppData')) +
    'JGsoft\EditPad Pro 7';
  {$IFDEF DEBUG}
  CSSend(cFn + ': Result', Result);
  {$ENDIF}
  if NOT DirectoryExists(Result) then
  begin
    InfoMsg := 'The EditPad Pro 7 ' +
    'data directory should exist before using this utility.' + sLineBreak +
    sLineBreak + Result;
    CSSendError(InfoMsg);
    MsgErrorOk(InfoMsg);
  end;
  //CSExitMethod(nil, cFn);
end;

(*
function EditPadPlusProgramInstallRoot: string;
const cFn = 'EditPadPlusProgramInstallRoot';
var
  Reg: TRegistry;
  y: TStringList;
  bFlag: Boolean;
const
  cRegistryKeyPath = 'eppfile\shell\Open\command';
begin
  CSEnterMethod(nil, cFn);
  Result := '';
  try
    try
      Reg := TRegistry.Create;
      y := TStringList.Create;
      Reg.RootKey := HKEY_CLASSES_ROOT;
      //HKEY_CLASSES_ROOT\eppfile\shell\Open\command
      bFlag := Reg.OpenKey(cRegistryKeyPath, False);
      CSSend('bFlag', S(bFlag));
      if bFlag then
      begin
        Result := Reg.ReadString('');
        // y = "D:\Apps\Utilities\EditPadPro7\EditPadPro7.exe" "%1"
        Result := Copy(Result, 2, MaxInt);
        Result := LeftOf('"', Result);
        Result := ExtractFilePath(Result);
        Reg.CloseKey;    // must close key, else subsequent changes end up here!
      end;
    except
      on E: Exception do
      begin
        CSSendException(E);
      end;
    end;
  finally
    FreeAndNil(Reg);
    FreeAndNil(y);
  end;

  if Result = '' then
  begin
    // %ProgramFiles(x86)%JGsoft\EditPad Plus v7\    ???
    Result :=
      IncludeTrailingPathDelimiter(GetEnvironmentVariable('ProgramFiles')) +
      'Just Great Software' + PathDelim + 'EditPad Pro 7';
  end;

  CSSend('Result', Result);
  CSExitMethod(nil, cFn);
end;
*)

end.
