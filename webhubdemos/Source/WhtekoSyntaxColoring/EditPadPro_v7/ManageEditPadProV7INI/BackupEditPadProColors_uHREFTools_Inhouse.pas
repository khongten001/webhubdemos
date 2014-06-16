unit BackupEditPadProColors_uHREFTools_Inhouse;

interface

function LoadHREFToolsColors(out ErrorText: string): string;
function PreserveHREFToolsColors(out ErrorText: string): Boolean;

implementation

uses
  Classes, SysUtils, IniFiles,
  ucLogFil,
  SetupEditPadForWebHub_uPaths;

function LoadHREFToolsColors(out ErrorText: string): string;
var
  IniFileSpec: string;
  ini: TIniFile;
  SyntaxColorsSection: string;
  SyntaxColors0, SyntaxColors1, SyntaxColors2: string;
  SyntaxColorsRegex0, SyntaxColorsRegex1, SyntaxColorsRegex2: string;
  y: TStringList;
  Memo1: TStringBuilder;

  function SectionToStr(const InSectionName: string): string;
  begin
    if NOT Assigned(y) then
      y := TStringList.Create;
    ini.ReadSectionValues (InSectionName, y);
    Result := '[' + InSectionName + ']' + sLineBreak + y.Text + sLineBreak;
  end;

begin
  ini := nil;
  y := nil;
  Memo1 := nil;
  Result := '';
  ErrorText := '';
  IniFileSpec := IncludeTrailingPathDelimiter(
      EditPadPlusDataRoot) + 'EditPadPro7.ini';
  if FileExists(IniFileSpec) then
  begin
    try
      ini := TIniFile.Create(IniFileSpec);
      Memo1 := TStringBuilder.Create;

      SyntaxColorsSection := SectionToStr('SyntaxColors');
      Memo1.Append(SyntaxColorsSection);

      SyntaxColors0 := SectionToStr('SyntaxColors0');
      Memo1.Append(SyntaxColors0);

      SyntaxColorsRegex0 := SectionToStr('SyntaxColorsRegex0');
      Memo1.Append(SyntaxColorsRegex0);

      SyntaxColors1 := SectionToStr('SyntaxColors1');
      Memo1.Append(SyntaxColors1);

      SyntaxColorsRegex1 := SectionToStr('SyntaxColorsRegex1');
      Memo1.Append(SyntaxColorsRegex1);

      SyntaxColors2 := SectionToStr('SyntaxColors2');
      Memo1.Append(SyntaxColors2);

      SyntaxColorsRegex2 := SectionToStr('SyntaxColorsRegex2');
      Memo1.Append(SyntaxColorsRegex2);

      Result := Memo1.ToString;
    finally
      FreeAndNil(y);
      FreeAndNil(ini);
      FreeAndNil(memo1);
    end;
  end
  else
    ErrorText := 'File not found: ' + IniFilespec;
end;

function PreserveHREFToolsColors(out ErrorText: string): Boolean;
const
  cSaveAs = 'D:\Projects\webhubdemos\Source\WhtekoSyntaxColoring\' +
    'EditPadPro_v7\EditPad_Colors_Backup.ini';
var
  ColorStr: string;
begin
  ColorStr := LoadHREFToolsColors(ErrorText);
  if (ErrorText = '') then
  begin
    Result := DirectoryExists(ExtractFilePath(cSaveAs));
    if Result then
      StringWriteToFile(cSaveAs, AnsiString(ColorStr))
    else
      ErrorText := 'Directory does not exist: ' + ExtractFilePath(cSaveAs);
  end;
end;

end.
