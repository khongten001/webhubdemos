unit WHBridge2EditPad_uBookmark;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2014-2017 HREF Tools Corp.                                 * }
{ *                                                                          * }
{ * This source code file is part of the WebHub plug-in for EditPad Pro.     * }
{ *                                                                          * }
{ * This file is licensed under a Creative Commons Attribution 2.5 License.  * }
{ * http://creativecommons.org/licenses/by/2.5/                              * }
{ * If you use this file, please keep this notice intact.                    * }
{ *                                                                          * }
{ * Author: Ann Lynnworth                                                    * }
{ *                                                                          * }
{ * Refer friends and colleagues to www.href.com/whvcl. Thanks!              * }
{ ---------------------------------------------------------------------------- }

interface

function WHBridgeDataPath: string;

function StackPushLocation(const InFilespec: string; const APosition: string): Boolean;
function StackPopLocation(out TheFilespec, ThePosition: string): Boolean;
function LaunchEPPAgainst(const InFilespec, APosition: string): Boolean;
function WHBridgeDataFilespec: string;

implementation

uses
  Classes, SysUtils,
  ucLogFil, uCode, ucShell, ucString, ZM_CodeSiteInterface;

function WHBridgeDataPath: string;
var
  AppDataPath: string;
begin
  AppDataPath := GetEnvironmentVariable('APPDATA');
  Result := IncludeTrailingPathDelimiter(AppDataPath) + 'HREFTools' +
    PathDelim + 'WebHub' + PathDelim;
end;

function WHBridgeDataFilespec: string;
begin
  Result := WHBridgeDataPath + 'WHBridge2EditPad.bookmarks';
end;

function StackPushLocation(const InFilespec: string; const APosition: string): Boolean;
const cFn = 'StackPushLocation';
begin
  CSEnterMethod(nil, cFn);
  ForceDirectories(ExcludeTrailingPathDelimiter(WHBridgeDataPath));
  StringAppendToFile(WHBridgeDataFilespec, InFilespec + #9 + APosition + sLineBreak);
  Result := True;
  CSExitMethod(nil, cFn);
end;

function StackPopLocation(out TheFilespec, ThePosition: string): Boolean;
const cFn = 'StackPopLocation';
var
  y: TStringList;
  n: Integer;
begin
  CSEnterMethod(nil, cFn);
  y := nil;
  TheFilespec := '';
  ThePosition := '';
  Result := False;
  try
    y := TStringList.Create;
    if FileExists(WHBridgeDataFilespec) then
    begin
      y.LoadFromFile(WHBridgeDataFilespec);
      LogToCodeSiteKeepCRLF('y', y.Text);
    end;
    if y.Count > 0 then
    begin
      n := Pred(y.Count);
      if SplitString(y[n], #9, TheFilespec, ThePosition) then
      begin
        CSSend('TheFilename', TheFilespec);
        CSSend('ThePosition', ThePosition);
        y.Delete(n);
        if n > 0 then
          y.SaveToFile(WHBridgeDataFilespec)
        else
          DeleteFile(WHBridgeDataFilespec);
        Result := True;
      end;
    end
    else
      CSSendWarning('0 bookmarks');
  finally
    FreeAndNil(y);
  end;
  CSSend('Result', S(Result));
  CSExitMethod(nil, cFn);
end;

function LaunchEPPAgainst(const InFilespec, APosition: string): Boolean;
const cFn = 'LaunchEPPAgainst';
var
  ExeFile: string;
  ErrorText: string;
  ACommandStr: string;
begin
  CSEnterMethod(nil, cFn);
  Result := False;
  ExeFile := ParamString('-exe');
  CSSend('ExeFile', ExeFile);
  if FileExists(ExeFile) and FileExists(InFilespec) then
  begin
    ACommandStr := '"' + InFilespec + '" /c' + APosition;
    CSSend('ACommandStr', ACommandStr);
    Launch(ExtractFileName(ExeFile),
      ACommandStr,
      ExtractFilepath(ExeFile), True, 0,
      ErrorText);
    Result := ErrorText = '';
    if NOT Result then
      CSSendError(cFn + ': ' + ErrorText);
  end;
  CSExitMethod(nil, cFn);
end;

end.
