unit SetupEditPadForWebHub_uDownload;

// Copyright 2014 HREF Tools Corp.

interface

function InstallLatestWebHubFiles: Boolean;

function WGetFileNavigation: UTF8String;
function WGetSyntaxScheme: UTF8String;

implementation

uses
  Classes, SysUtils,
  //Registry,
  Windows,
  ucCodeSiteInterface, ucString, ucLogFil, SetupEditPadForWebHub_uPaths;

//const
//  cUserAgent = 'HREF Tools Software Installer';
//  cURLStart = 'http://www.editpadpro.com/cgi-bin';

function GetUTF8Resource(const inResName: string): UTF8String;
const cFn = 'GetUTF8Resource';
var
  res: TResourceStream;
  pTrg: PByte;
begin
  CSEnterMethod(nil, cFn);
  CSSend('inResName', inResName);
  res := nil;
  try
    res := TResourceStream.Create(HInstance, InResName, RT_RCDATA);
    res.Seek(0, soBeginning);
    CSSend('res.Size', S(res.Size));
    SetLength(Result, res.Size);
    pTrg := Addr(Result[1]);
    res.Read(pTrg^, res.Size);
    StripUTF8BOM(Result);
  finally
    FreeAndNil(res);
  end;
  //LogToCodeSiteKeepCRLF('Result', Copy(Result, 1, 1024));
  CSExitMethod(nil, cFn);
end;

function WGetSyntaxScheme: UTF8String;
const cFn = 'WGetSyntaxScheme';
begin
  CSEnterMethod(nil, cFn);
(*
http://www.editpadpro.com/cgi-bin/cscslist4.pl?focus=251
http://www.editpadpro.com/cgi-bin/cscsdl4.pl?id=251
*)

  (*Result := HTTPSGet(cURLStart + '/cscsdl4.pl?id=251',
    ErrorText, cUserAgent,
    cURLStart + '/cscslist4.pl?focus=251', True, True);
  CSSend('Result', Result);

  SplitString(Result, sLineBreak + sLineBreak, Headers, Result);
  if ErrorText <> '' then
  begin
    CSSendError(ErrorText);
    CSSend('HTTP Headers', Headers);
  end;
  *)
  Result := GetUTF8Resource('Resource_JGCSCS');
  //LogToCodeSiteKeepCRLF('Result', Copy(Result, 1, 1024));
  CSExitMethod(nil, cFn);
end;

function WGetFileNavigation: UTF8String;
begin
(*
http://www.editpadpro.com/cgi-bin/fnslist2.pl?focus=72
http://www.editpadpro.com/cgi-bin/fnsdl2.pl?id=72
*)

  (*Result := HTTPSGet(cURLStart + '/fnsdl2.pl?id=72',
    ErrorText, cUserAgent,
    cURLStart + '/fnslist2.pl?focus=72', False, True);
  *)
  Result := GetUTF8Resource('Resource_JGFNS');
end;

function InstallLatestWebHubFiles: Boolean;
const cFn = 'InstallLatestWebHubFiles';
var
  IniFilespec: string;
  LatestStr8: UTF8String;
  BakFilespec, TargetFilespec: string;
begin
  CSEnterMethod(nil, cFn);
  IniFilespec := IncludeTrailingPathDelimiter(EditPadPlusDataRoot) +
    'EditPadPro7.ini';
  Result := FileExists(IniFilespec);
  if Result then
  begin
    LatestStr8 := WGetSyntaxScheme;
    TargetFilespec := IncludeTrailingPathDelimiter(
      EditPadPlusProgramInstallRoot) + 'WebHub_Syntax0214.jgcscs';
    CSSend('TargetFilespec', TargetFilespec);
    //CSSend('LatestStr8', Copy(string(LatestStr8), 1, 24));
    if FileExists(TargetFilespec) then
    begin
      BakFilespec := ChangeFileExt(TargetFilespec, '.bak');
      SysUtils.DeleteFile(BakFilespec);
      RenameFile(TargetFilespec, BakFilespec);
    end;
    UTF8StringWriteToFile(TargetFilespec, LatestStr8);

    TargetFilespec := IncludeTrailingPathDelimiter(
      EditPadPlusProgramInstallRoot) + 'WebHub-FileNavigation.jgfns';
    CSSend('TargetFilespec', TargetFilespec);
    if FileExists(TargetFilespec) then
    begin
      BakFilespec := ChangeFileExt(TargetFilespec, '.bak');
      SysUtils.DeleteFile(BakFilespec);
      RenameFile(TargetFilespec, BakFilespec);
    end;
    LatestStr8 := WGetFileNavigation;
    UTF8StringWriteToFile(TargetFilespec, LatestStr8);

    TargetFilespec := IncludeTrailingPathDelimiter(EditPadPlusDataRoot) +
      cHREFToolsColorsIniFilespec;
    CSSend('TargetFilespec', TargetFilespec);
    if FileExists(TargetFilespec) then
    begin
      BakFilespec := ChangeFileExt(TargetFilespec, '.bak');
      SysUtils.DeleteFile(BakFilespec);
      RenameFile(TargetFilespec, BakFilespec);
    end;
    LatestStr8 := GetUTF8Resource('Resource_Colors_Ini');
    StringWriteToFile(TargetFilespec, AnsiString(LatestStr8));
  end;

  CSExitMethod(nil, cFn);
end;

end.
