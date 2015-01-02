unit WHBridge2EditPad_uSearchDir;

interface

{$I hrefdefines.inc}

uses
  SysUtils, FMX.Forms, FMX.ListBox;

function OpenJSorCSSorOtherFile(const InFindThisFilename, EPPFilespec
  : string; out FoundInFilespecs: TStringBuilder): Boolean;

procedure Push2Stack_and_OpenFile(const EditpadExeFilespec, AFilespecToOpen
  : string);

procedure WrapOpenJSorCSSorOtherFile(LB: TListBox; out InfoMsg: string);


implementation

uses
  Classes, System.IOUtils, //FMX.Forms,
  uCode, ucShell, ucString, ucCodeSiteInterface, WHBridge2EditPad_uBookmark;


function OpenJSorCSSorOtherFile(const InFindThisFilename, EPPFilespec
  : string; out FoundInFilespecs: TStringBuilder): Boolean;
const cFn = 'OpenJSorCSSorOtherFile';
var
  AFilename: string;
  AMask: string;
  EPPRootFolder: string;
  AFileExt: string;
  SearchOption: TSearchOption;
  FlagAny: Boolean;
begin
  CSEnterMethod(nil, cFn);
  FoundInFilespecs := TStringBuilder.Create;
  Result := False;
  FlagAny := False;

  AFileExt := ExtractFileExt(InFindThisFilename);
  AMask := '*' + AFileExt;
  //CSSend('AMask', AMask);
  SearchOption := TSearchOption.soAllDirectories;
  EPPRootFolder := ExtractFilePath(EPPFilespec);
  //CSSend('EPPRootFolder', EPPRootFolder);

  for AFilename in TDirectory.GetFiles(EPPRootFolder, AMask, SearchOption, nil)
  do
  begin
    //CSSend('Considering', AFilename);
    if SameText(ExtractFilename(AFilename), ExtractFilename(InFindThisFilename))
    then
    begin
      if FlagAny then
        FoundInFilespecs.Append(sLineBreak);
      FoundInFilespecs.Append(AFilename);
      FlagAny := True;
      //CSSend('FoundInFilespecs', FoundInFilespecs.ToString);
      Result := True;
    end;
  end;
  CSExitMethod(nil, cFn);
end;


function Word2FilenameAtCursor(const InWord, InTextLineNoQuotes: string;
  out ErrorText: string): string;
const cFn = 'Word2FilenameAtCursor';
var
  x: Integer;
  Left, Right: string;
  FileExt: string;
  FlagSlash: Boolean;
begin
  CSEnterMethod(nil, cFn);
  Result := '';
  ErrorText := '';

  CSSend('InWord', InWord);
  CSSend('InTextLineNoQuotes', InTextLineNoQuotes);

  SplitRight(InTextLineNoQuotes, InWord, Left, Right);
  CSSend('Left', Left);
  CSSend('Right', Right);

  // look for end of filename noting that quotes are lost en-route
  x := Pos('"', Right);
  if x = 0 then
    x := Pos('''', Right);
  if x = 0 then
    x := Pos('>', Right);
  if x > 0 then
  begin
    Right := Copy(Right, 1, Pred(x));
    CSSend('Right', Right);
    FlagSlash := False;
    while true do
    begin
      x := Pos('/', Right);
      if x = 0 then break
      else
      begin
        FlagSlash := True;
        Right := Copy(Right, Succ(x), MaxInt);
      end;
    end;

    x := Pos('.', Right);
    if x > 0 then
    begin
      FileExt := Copy(Right, x, MaxInt);  // e.g. '.js' or '.css'
      CSSend('FileExt', FileExt);
      CSSend('FlagSlash', S(FlagSlash));
      if FlagSlash then
        Result := Right
      else
        Result := InWord + FileExt;
    end
    else
      ErrorText := Format('No . found after "%s" within "%s"',
      [InWord, InTextLineNoQuotes]);
  end
  else
    ErrorText := Format(
      'No closing quote mark nor > symbol found after "%s" and within "%s"',
      [InWord, InTextLineNoQuotes]);

  CSSend('Result', Result);
  CSExitMethod(nil, cFn);
end;

procedure SetFilespecList(ListBox1: TListBox; AList: TStringBuilder;
  const ADelim: string);
const cFn = 'SetFilespecList';
var
  a1, a2: string;
begin
  CSEnterMethod(nil, cFn);
  ListBox1.Clear;

  a2 := AList.ToString;
  while true do
  begin
    SplitString(a2, ADelim, a1, a2);
    if a1 <> '' then
      ListBox1.Items.Add(a1)
    else
      break;
  end;

  CSExitMethod(nil, cFn);
end;

procedure Push2Stack_and_OpenFile(const EditpadExeFilespec, AFilespecToOpen
  : string);
const cFn = 'Push2Stack_and_OpenFile';
var
  AFile: string;
  APos: string;
  InfoMsg: string;
begin
  AFile := ParamString('-file');
  if AFile = '' then
  begin
    CSSendWarning(cFn + ': Missing required -file parameter');
  end
  else
  begin
    APos := ParamString('-pos');
    if APos = '' then
      CSSendWarning(cFn + ': Missing required -pos parameter')
    else
      StackPushLocation(AFile, APos);
  end;

  Launch(ExtractFileName(EditpadExeFilespec),
    AFilespecToOpen,
    ExtractFilepath(EditpadExeFilespec), True, 0,
    InfoMsg);
  if InfoMsg <> '' then
    CSSend(cFn, InfoMsg);
end;

procedure WrapOpenJSorCSSorOtherFile(LB: TListBox; out InfoMsg: string);
const cFn = 'WrapOpenJSorCSSorOtherFile';
var
  EPPFilespec: string;
  ExeFile: string;
  GoodSearchPhrase: string;
  MatchFilespecList: TStringBuilder;
  Flag: Boolean;
begin
  CSEnterMethod(nil, cFn);
  InfoMsg := '';
  MatchFilespecList := nil;

  CSSend('word', ParamString('-word'));
  CSSend('linetext with double-quotes stripped!', ParamString('-linetext'));

  EPPFilespec := ParamString('-projectfile');
  CSSend('EPPFilespec', EPPFilespec);

  ExeFile := ParamString('-exe');
  CSSend('ExeFile', ExeFile);

  if FileExists(ExeFile) then
  begin
    GoodSearchPhrase := Word2FilenameAtCursor(
      ParamString('-word'),
      ParamString('-linetext'), InfoMsg);
    CSSend('GoodSearchPhrase', GoodSearchPhrase);
    if InfoMsg = '' then
    begin
      Flag := OpenJSorCSSorOtherFile(GoodSearchPhrase, EPPFilespec,
        MatchFilespecList);

      CSSend('Flag', S(Flag));
      if Flag then
      begin
        CSSend('MatchFilespecList.Length', S(MatchFilespecList.Length));
        if Pos(sLineBreak, MatchFilespecList.ToString) = 0 then
        begin
          // easy - only one match
          Push2Stack_and_OpenFile(ExeFile, MatchFilespecList.ToString);
        end
        else
        begin
          CSSendWarning('Multiple matches');
          if Assigned(LB) then
          begin
            SetFilespecList(LB, MatchFilespecList, sLineBreak);
          end
          else
            CSSendError('Form4 nil');
        end;
      end
      else
        InfoMsg := 'File not found for ' + GoodSearchPhrase;
    end;
  end;

  if InfoMsg <> '' then
  begin
    CSSend('InfoMsg', InfoMsg);
  end;

  FreeAndNil(MatchFilespecList);

  CSExitMethod(nil, cFn);
end;


end.
