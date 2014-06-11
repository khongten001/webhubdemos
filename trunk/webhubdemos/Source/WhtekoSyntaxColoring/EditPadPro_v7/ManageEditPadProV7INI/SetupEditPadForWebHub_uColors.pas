unit SetupEditPadForWebHub_uColors;

interface

function WriteHREFToolsColorsToEditPadINI: Boolean;

implementation

uses
  Classes, SysUtils, IniFiles,
  ucLogFil, ucCodeSiteInterface,
  SetupEditPadForWebHub_uDownload, SetupEditPadForWebHub_uPaths;

function WriteHREFToolsColorsToEditPadINI: Boolean;
const cFn = 'WriteHREFToolsColorsToEditPadINI';
const
  nColors = 3;
var
  iColor: Integer;
  iniSrc, iniTrg: TIniFile;
  IniData: string;
  IniSourceFilespec: string;
  IniTargetFilespec: string;
  y: TStringList;
  Memo1: TStringBuilder;

  function SectionToStr(const InSectionName: string): string;
  begin
    if NOT Assigned(y) then
      y := TStringList.Create;
    iniSrc.ReadSectionValues (InSectionName, y);
    Result := '[' + InSectionName + ']' + sLineBreak + y.Text + sLineBreak;
  end;

begin
  CSEnterMethod(nil, cFn);
  iniSrc := nil;
  iniTrg := nil;
  Memo1 := nil;
  Result := False;
  try
    try
      // source is the custom HREF colors file
      IniSourceFilespec := IncludeTrailingPathDelimiter(
        EditPadPlusDataRoot) + cHREFToolsColorsIniFilespec;
      CSSend('IniSourceFilespec', IniSourceFilespec);
      IniTargetFilespec := IncludeTrailingPathDelimiter(
        EditPadPlusDataRoot) + 'EditPadPro7.ini';
      CSSend('IniTargetFilespec', IniTargetFilespec);
      if FileExists(IniSourceFilespec) and FileExists(IniTargetFilespec) then
      begin
        iniSrc := TIniFile.Create(IniSourceFilespec);
        iniTrg := TIniFile.Create(IniTargetFilespec);
        Memo1 := TStringBuilder.Create;

        IniData := SectionToStr('SyntaxColors');
        Memo1.Append(IniData);
        iniTrg.EraseSection('SyntaxColors');

        for iColor := 0 to Pred(nColors) do
        begin
          IniData := SectionToStr('SyntaxColors' + IntToStr(iColor));
          Memo1.Append(IniData);
          iniTrg.EraseSection('SyntaxColors' + IntToStr(iColor));
          IniData := SectionToStr('SyntaxColorsRegex' + IntToStr(iColor));
          Memo1.Append(IniData);
          iniTrg.EraseSection('SyntaxColorsRegex' + IntToStr(iColor));
        end;
      end
      else
        CSSendError('Files not found');

    finally
      FreeAndNil(y);
      FreeAndNil(iniSrc);
    end;

  finally
    FreeAndNil(iniTrg);
    if Assigned(memo1) then
    begin
      UTF8StringAppendToFile(IniTargetFilespec, UTF8String(memo1.ToString));
      FreeAndNil(memo1);
      Result := True;
    end;
  end;

  CSSend('Result', S(Result));
  CSExitMethod(nil, cFn);
end;

end.
