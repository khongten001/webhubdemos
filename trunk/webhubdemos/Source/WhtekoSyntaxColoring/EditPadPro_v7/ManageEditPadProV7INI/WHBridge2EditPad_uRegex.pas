unit WHBridge2EditPad_uRegex;

interface

type
  TwhsType = (whsUnknown, whsMacro, whsDroplet, whsPage, whsTranslation,
    whsTranslations, whsWebAction);

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
  WHBridge2EditPad_uIni;

var
  FRegEx: TldiRegExMulti;

function Word2SearchType(const InWord, InLineText: string): TwhsType;
const cFn = 'Word2SearchType';
var
  LettersAfter, LettersBefore: String;
  x: Integer;
begin
  //CSEnterMethod(nil, cFn);
  //CSSend('InWord', InWord);
  //LogToCodeSiteKeepCRLF('InLineText', InLineText);

  x := Pos(InWord, InLineText);
  //CSSend('x', S(x));
  if x > 2 then
    LettersBefore := Copy(InLineText, x-2, 2)
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
    x := x + Length(InWord);
    //CSSend('x after', S(x));
    LettersAfter := Lowercase(Copy(InLineText, x, 25));
    //CSSend('LettersAfter', LettersAfter);
    if (Copy(InWord, 1, 2) = 'wa') or (Pos('.execute', LettersAfter) = 1) then
      Result := whsWebAction  // not yet going to Delphi code
    else // try pageid
      Result := whsPage;
  end;
  //CSSend('Result', GetEnumName(TypeInfo(TwhsType), Ord(Result)));
  //CSExitMethod(nil, cFn);
end;

function Word2SearchPattern(const InWord: string; const InType: TwhsType): string;
const cFn = 'Word2SearchPhrase';
begin
  //CSEnterMethod(nil, cFn);
  //CSSend('InWord', InWord);
  //CSSend('InType', GetEnumName(TypeInfo(TwhsType), Ord(InType)));

  case InType of
    whsMacro: Result := Format('\n%s=', [InWord]);
    whsDroplet: Result := Format('<whdroplet[^>]*?\sname="%s"', [InWord]);
    whsPage: Result := Format('\sid="%s"', [InWord]);
    whsTranslation: Result := Format('<whtranslation[^>]*?\skey="~%s"', [InWord]);
    whsTranslations: Result := Format('\n~%s=', [InWord]);
    whsWebAction: Result := Format('procedure\s[^.]*\.%sExecute',
      [InWord]);
    else
      Result := '';
  end;

  //CSSend('Result', Result);
  //CSExitMethod(nil, cFn);
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
const
  cWhteko = '.whteko';
  cPas = '.pas';
begin
  CSEnterMethod(nil, cFn);
  //CSSend('ASearchPattern', ASearchPattern);
  Result := False;
  y := nil;
  FoundInFilespec := '';
  StartSel := -1;
  EndSel := -1;
  APattern8 := UTF8String(ASearchPattern);

  try
    y := TStringList.Create;
    y.Text := InFileList;

    if NOT Assigned(FRegEx) then
      FRegEx := TldiRegExMulti.Create(nil);
    MatchCollection := TMatchCollection.Create;

    FRegEx.AddPattern8(APattern8, IPattern, PatternStatus,
      [poIgnoreCase] {i.e. NOT poDotMatchesAll});
    if NOT PatternStatus.PatternOK then begin Exit; end;

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
        else DoThisFileExt := False;
      end;

      if DoThisFileExt then
      begin
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
    FRegEx.ClearPatterns;
  finally
    FreeAndNil(MatchCollection);
    FreeAndNil(y);
  end;
  CSExitMethod(nil, cFn);
end;

procedure WrapFindInFiles(out InfoMsg: string);
const cFn = 'WrapFindInFiles';
var
  ExeFile: string;
  ErrorText: string;
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
        Launch(ExtractFileName(ExeFile),
          MatchFilespec + ' /s' + IntToStr(StartSel) + '-' + IntToStr(EndSel),
          ExtractFilepath(ExeFile), True, 0,
          ErrorText);
        if ErrorText <> '' then
        begin
          CSSend('ErrorText', ErrorText);
          InfoMsg := ErrorText;
        end;
      end;
    end;
  end;

  CSExitMethod(nil, cFn);
end;

initialization
  FRegEx := nil;
finalization
  FreeAndNil(FRegEx);

end.
