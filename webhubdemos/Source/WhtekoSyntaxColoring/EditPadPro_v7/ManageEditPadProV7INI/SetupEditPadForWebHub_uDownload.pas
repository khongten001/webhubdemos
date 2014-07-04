unit SetupEditPadForWebHub_uDownload;

// Copyright 2014 HREF Tools Corp.

interface

function IsWHTekoFileTypeInstalled: Boolean;

function InstallLatestWebHubFiles(const FlagSyntax, FlagFileNav, FlagTools,
  FlagColor: Boolean): Boolean;

function InstallWebHubFileType: Boolean;
function InstallWHBridgeTools: Boolean;

function WGetFileNavigation: UTF8String;
function WGetSyntaxScheme: UTF8String;


implementation

uses
  Classes, SysUtils,
  Windows, IniFiles,
  ucCodeSiteInterface, ucString, ucLogFil, SetupEditPadForWebHub_uPaths;

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

  Result := GetUTF8Resource('Resource_JGCSCS');
  //LogToCodeSiteKeepCRLF('Result', Copy(Result, 1, 1024));
  CSExitMethod(nil, cFn);
end;

function WGetFileNavigation: UTF8String;
begin
  Result := GetUTF8Resource('Resource_JGFNS');
end;

function InstallLatestWebHubFiles(const FlagSyntax, FlagFileNav, FlagTools,
  FlagColor: Boolean): Boolean;
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
    if FlagSyntax then
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
    end;

    if FlagFileNav then
    begin
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
    end;

    if FlagTools then
    begin
      TargetFilespec := IncludeTrailingPathDelimiter(EditPadPlusDataRoot) +
        cHREFToolsEPPToolsIniFilespec;
      CSSend('TargetFilespec', TargetFilespec);
      if FileExists(TargetFilespec) then
      begin
        BakFilespec := ChangeFileExt(TargetFilespec, '.bak');
        SysUtils.DeleteFile(BakFilespec);
        RenameFile(TargetFilespec, BakFilespec);
      end;
      LatestStr8 := GetUTF8Resource('Resource_Tools_Ini');
      StringWriteToFile(TargetFilespec, AnsiString(LatestStr8)); // Ansi
    end;

    if FlagColor then
    begin
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
      StringWriteToFile(TargetFilespec, AnsiString(LatestStr8)); // Ansi
    end;
  end;

  CSExitMethod(nil, cFn);
end;

function IsWHTekoFileTypeInstalled: Boolean;
const cFn = 'IsWHTekoFileTypeInstalled';
var
  IniFilespec: string;
  ini: TIniFile;
  FileTypeCount: Integer;
  FileMasks: string;
begin
  CSEnterMethod(nil, cFn);
  ini := nil;
  IniFilespec := IncludeTrailingPathDelimiter(EditPadPlusDataRoot) +
    'EditPadPro7.ini';
  Result := False;
  if FileExists(IniFilespec) then
  begin
    try
      ini := TIniFile.Create(IniFilespec);
      FileTypeCount := 0;
      while true do
      begin
        FileMasks := ini.ReadString('FT' + IntToStr(FileTypeCount), 'FileMasks',
          '');
        if FileMasks = '' then
          break;
        if Pos('whteko', FileMasks) > 0 then
        begin
          CSSend('FileTypeCount', S(FileTypeCount));
          CSSend('FileMasks', FileMasks);
          Result := True;
          break;
        end;
        Inc(FileTypeCount);
      end;
    finally
      FreeAndNil(ini);
    end;
  end;

  CSSend('Result', S(Result));
  CSExitMethod(nil, cFn);
end;

function InstallWebHubFileType: Boolean;
const cFn = 'InstallWebHubFileType';
var
  Ini: TIniFile;
  IniFilespec: string;
  FileType33: string;
begin
  CSEnterMethod(nil, cFn);
  ini := nil;

  FileType33 := string(GetUTF8Resource('Resource_FT33'));
  IniFilespec := IncludeTrailingPathDelimiter(EditPadPlusDataRoot) +
    'EditPadPro7.ini';
  Result := FileExists(IniFilespec);
  if Result then
  begin
    StringAppendToFile(IniFilespec,
      AnsiString(sLineBreak + FileType33 + sLineBreak));

    try
      ini := TIniFile.Create(IniFilespec);
      ini.WriteString('Lite', 'FileTypes', '36');
    finally
      FreeAndNil(ini);
    end;
  end;

  CSSend('Result', S(Result));
  CSExitMethod(nil, cFn);
end;

function InstallWHBridgeTools: Boolean;
const cFn = 'InstallWHBridgeTools';
var
  IniFilespec: string;
  WHBridgeTools: string;
  iniTrg: TIniFile;
  ACommandLine: string;
  bContinue: Boolean;
  iTool: Integer;
const
  nTools = 3;
begin
  CSEnterMethod(nil, cFn);

  iniTrg := nil;
  WHBridgeTools := string(GetUTF8Resource('Resource_Tools_Ini'));
  IniFilespec := IncludeTrailingPathDelimiter(EditPadPlusDataRoot) +
    'EditPadPro7.ini';

  bContinue := FileExists(IniFilespec);
  if bContinue then
  begin
    try
      iniTrg := TIniFile.Create(IniFilespec);
      iniTrg.WriteString('Pro', 'ToolCount', IntToStr(nTools));
      for iTool := 0 to Pred(nTools) do
      begin
        if bContinue then
        begin
          if iniTrg.SectionExists('Tool' + IntToStr(iTool)) then
          begin
            ACommandLine := Lowercase(iniTrg.ReadString('Tool' + IntToStr(iTool),
              'CommandLine', ''));
            if Pos('whbridge2editpad.exe', ACommandLine) > 0 then
              iniTrg.EraseSection('Tool' + IntToStr(iTool))
            else
              bContinue := False;
          end;
        end;
      end;
    finally
      FreeAndNil(iniTrg);
    end;

    if bContinue then
      StringAppendToFile(IniFilespec,
        AnsiString(sLineBreak + WHBridgeTools + sLineBreak));
  end;
  Result := bContinue;
  CSSend('Result', S(Result));
  CSExitMethod(nil, cFn);
end;

end.
