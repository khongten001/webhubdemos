unit WHBridge2EditPad_uRegex;

interface

type
  TwhsType = (whsUnknown, whsMacro, whsDroplet, whsPage, whsTranslation,
    whsTranslations, whsAppSetting, whsWebAction);

function Word2SearchType(const InWord, InLineText: string): TwhsType;
function Word2SearchPattern(const InWord: string; const InType: TwhsType): string;

procedure WrapFindInFiles(out InfoMsg: string);

function FindInFiles(const ASearchType: TwhsType;
  const ASearchPattern, InFileList: string;
  out FoundInFilespec: string; out StartSel, EndSel: Integer): Boolean;

implementation

uses
  Classes, SysUtils, TypInfo,
  ldi.RegEx.RegularExpressions,
  uCode, ucShell, ucString, ucLogFil, ucCodeSiteInterface,
  WHBridge2EditPad_uIni, WHBridge2EditPad_uBookmark;

var
  FRegEx: TldiRegExMulti;

function Word2SearchType(const InWord, InLineText: string): TwhsType;
const cFn = 'Word2SearchType';
var
  LettersAfter, LettersBefore: String;
  xb, xa: Integer;
begin
  CSEnterMethod(nil, cFn);
  CSSend('InWord', InWord);
  LogToCodeSiteKeepCRLF('InLineText', InLineText);

  xb := Pos(InWord, InLineText);
  CSSend('x', S(xb));
  if xb > 2 then
    LettersBefore := Copy(InLineText, xb-2, 2)
  else
    LettersBefore := '';
  if (LettersBefore = '~~') then
    Result := whsTranslation
  else
  if Copy(InWord, 1, 2) = 'dr' then
    Result := whsDroplet
  else
  if Copy(InWord, 1, 2) = 'mc' then
    Result := whsMacro
  else
  begin
    if (Copy(InWord, 1, 2) = 'wa') then
      Result := whsWebAction
    else
    begin
      xa := xb + Length(InWord);
      //CSSend('x after', S(xa));
      LettersAfter := Lowercase(Copy(InLineText, xa, 25));
      //CSSend('LettersAfter', LettersAfter);
      if (Pos('.execute', LettersAfter) = 1) then
        Result := whsWebAction
      else
      begin
        if xb > 11 then  // AppSetting.
          LettersBefore := Lowercase(Copy(InLineText, xb-11, 11))
        else
          LettersBefore := '';
        CSSend('LettersBefore', LettersBefore);
        if LettersBefore = 'appsetting.' then
          Result := whsAppSetting
        else
          Result := whsPage;  // try pageid
      end;
    end;
  end;
  CSSend('Result', GetEnumName(TypeInfo(TwhsType), Ord(Result)));
  CSExitMethod(nil, cFn);
end;

function Word2SearchPattern(const InWord: string; const InType: TwhsType): string;
const cFn = 'Word2SearchPhrase';
begin
  CSEnterMethod(nil, cFn);
  //CSSend('InWord', InWord);
  CSSend('InType', GetEnumName(TypeInfo(TwhsType), Ord(InType)));

  case InType of
    whsMacro: Result := Format('\n%s=', [InWord]);
    whsDroplet: Result := Format('<whdroplet[^>]*?\sname="%s"', [InWord]);
    whsPage: Result := Format('\sid="%s"', [InWord]);
    whsTranslation: Result := Format('<whtranslation[^>]*?\skey="~%s"', [InWord]);
    whsTranslations: Result := Format('\n~%s=', [InWord]);
    whsWebAction: Result := Format('procedure\s[^.]*\.%sExecute',
      [InWord]);
    whsAppSetting: Result := Format('AppSetting\sname="%s"', [InWord]);
    else
      Result := '';
  end;

  CSSend('Result', Result);
  CSExitMethod(nil, cFn);
end;


function FindInFiles(const ASearchType: TwhsType;
  const ASearchPattern, InFileList: string;
  out FoundInFilespec: string; out StartSel, EndSel: Integer): Boolean;
const cFn = 'FindInFiles';
var
  AFilespec: string;
  FileContent8: UTF8String;
  y: TStringList;
  i: Integer;
  FlagUTF8, FlagUTF16: Boolean;
  APattern8: UTF8String;
  IPattern: Integer;
  PatternStatus: TPatternStatus;
  MatchCollection: TMatchCollection;
  AFileExt: string;
  DoThisFileExt: Boolean;
  CountFilesSearched: Integer;
const
  cWhteko = '.whteko';
  cPas = '.pas';
  cXml = '.xml';
begin
  CSEnterMethod(nil, cFn);
  //CSSend('ASearchPattern', ASearchPattern);
  Result := False;
  y := nil;
  FoundInFilespec := '';
  StartSel := -1;
  EndSel := -1;
  CountFilesSearched := 0;
  APattern8 := UTF8String(ASearchPattern);

  try
    y := TStringList.Create;
    y.Text := InFileList;

    if NOT Assigned(FRegEx) then
      FRegEx := TldiRegExMulti.Create(nil);
    MatchCollection := TMatchCollection.Create;

    FRegEx.AddPattern8(APattern8, IPattern, PatternStatus,
      [poIgnoreCase] {i.e. NOT poDotMatchesAll});
    if PatternStatus.PatternOK then
    begin

      for i := 0 to Pred(y.Count) do
      begin
        AFilespec := y[i];
        AFileExt := Lowercase(ExtractFileExt(AFilespec));

        case ASearchType of
          whsMacro,
          whsDroplet,
          whsPage,
          whsTranslation,
          whsTranslations: DoThisFileExt := (AFileExt = cWhteko);
          whsWebAction: DoThisFileExt := (AFileExt = cPas);
          whsAppSetting: DoThisFileExt := (AFileExt = cXml);
          else DoThisFileExt := False;
        end;

        if DoThisFileExt then
        begin
          Inc(CountFilesSearched);
          //CSSend('AFilespec', AFilespec);
          if FileExists(AFilespec) then
          begin
            FileHasBOM(AFilespec, FlagUTF8, FlagUTF16);
            FileContent8 := UTF8StringLoadFromFile(AFilespec);
            if FRegEx.Matches8(IPattern, MatchCollection, FileContent8 ) then
            begin
              Result := True;
              FoundInFilespec := AFilespec;
              CSSend('FoundInFilespec', FoundInFilespec);
              StartSel := MatchCollection.Match[0].GroupStartOffset(0);
              if FlagUTF8 then
                StartSel := StartSel + 3;
              EndSel := StartSel + MatchCollection.Match[0].GroupLength(0);
              //CSSend('StartSel', S(StartSel));
              //CSSend('EndSel', S(EndSel));
            end;
          end
          else
            CSSendWarning('File not found: ' + AFilespec);
        end
        //else
        //  CSSendNote('Skipping: ' + AFilespec)
        ;
      end;
    end;
    FRegEx.ClearPatterns;
  finally
    FreeAndNil(MatchCollection);
    FreeAndNil(y);
  end;
  CSSend('CountFilesSearched', S(CountFilesSearched));
  CSExitMethod(nil, cFn);
end;

procedure WrapFindInFiles(out InfoMsg: string);
const cFn = 'WrapFindInFiles';
var
  ExeFile: string;
  ProjectFileList: string;
  GoodSearchPhrase: string;
  MatchFilespec: string;
  StartSel, EndSel: Integer;
  Flag: Boolean;
  SearchType: TwhsType;
begin
  CSEnterMethod(nil, cFn);
  InfoMsg := '';

  ExeFile := ParamString('-exe');
  if FileExists(ExeFile) then
  begin
    ProjectFileList := EPPExtractFileList(ParamString('-projectfile'));
    SearchType := Word2SearchType(ParamString('-word'),
      ParamString('-linetext'));
    GoodSearchPhrase := Word2SearchPattern(ParamString('-word'), SearchType);

    if GoodSearchPhrase <> '' then
    begin
      CSSend('GoodSearchPhrase', GoodSearchPhrase);

      Flag := FindInFiles(SearchType, GoodSearchPhrase, ProjectFileList,
        MatchFilespec, StartSel, EndSel);

      if (NOT Flag) and (SearchType = whsTranslation) then
      begin
        GoodSearchPhrase := Word2SearchPattern(ParamString('-word'),
          whsTranslations);
        Flag := FindInFiles(whsTranslations, GoodSearchPhrase, ProjectFileList,
          MatchFilespec, StartSel, EndSel);
      end;

      if (NOT Flag) and (SearchType <> whsDroplet) then
      begin
        GoodSearchPhrase := Word2SearchPattern(ParamString('-word'),
          whsDroplet);
        Flag := FindInFiles(whsDroplet, GoodSearchPhrase, ProjectFileList,
          MatchFilespec, StartSel, EndSel);
      end;

      if Flag then
      begin
        StackPushLocation(ParamString('-file'), ParamString('-pos'));
        Launch(ExtractFileName(ExeFile),
          MatchFilespec + ' /s' + IntToStr(StartSel) + '-' + IntToStr(EndSel),
          ExtractFilepath(ExeFile), True, 0,
          InfoMsg);
      end
      else
        InfoMsg := 'Declaration not found for ' + ParamString('-word');
    end
    else
      InfoMsg := 'No good regex pattern for ' + ParamString('-word');
  end;

  if InfoMsg <> '' then
  begin
    CSSend('InfoMsg', InfoMsg);
  end;
  CSExitMethod(nil, cFn);
end;

initialization
  FRegEx := nil;
finalization
  FreeAndNil(FRegEx);

end.
