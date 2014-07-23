unit WHBridge2EditPad_uExpressionReplacement;

interface

function FindImportantInputText: Boolean;

var
  ActiveFilespec: string = '';
  ActiveWebHubCommandWord: string = '';
  ActiveWebHubExtract: string = '';
  InputStartPos, InputStopPos: Integer;
  OutputStartPos, OutputStopPos: Integer;


implementation

uses
  SysUtils,
  whMacroAffixes,
  ucString, uCode, ucLogFil, ucCodeSiteInterface;

function FindImportantInputText: Boolean;
const cFn = 'FindImportantInputText';
var
  Content8: UTF8String;
  EditPadPosition: Integer;
  i: Integer;
  CountParentilPairs: Integer;

  function FirstStartParentil: Integer;
  const cFn = 'FirstStartParentil';
  var
    J: Integer;
    c1, c2: Char;
  begin
    CSEnterMethod(nil, cFn);
    Result := -1;
    for J := EditPadPosition downto 2 do
    begin
      c2 := Char(Content8[J]);
      if c2 = MacroStart[2] then
      begin
        c1 := Char(Content8[Pred(J)]);
        //CSSend(c1 + c2);
        if c1 = MacroStart[1] then
        begin
          Result := Pred(J);
          break;
        end;
      end;
    end;
    CSSend('Result', S(Result));
    CSExitMethod(nil, cFn);
  end;

  function IsMacroEnd(const i: Integer): Boolean;
  var
    c1, c2: Char;
  begin
    Result := False;
    c1 := Char(Content8[i]);
    if c1 = MacroEnd[1] then
    begin
      c2 := Char(Content8[Succ(i)]);
      if c2 = MacroEnd[2] then
        Result := True;
    end;
    //CSSend('IsMacroEnd Result for ' + Copy(string(Content8), i, 2),
    //  S(Result));
  end;

  function IsMacroStart(const i: Integer): Boolean;
  var
    c1, c2: Char;
  begin
    Result := False;
    c1 := Char(Content8[i]);
    if c1 = MacroStart[1] then
    begin
      c2 := Char(Content8[Succ(i)]);
      if c2 = MacroStart[2] then
        Result := True;
    end;
    //CSSend('IsMacroStart Result for ' + Copy(string(Content8), i, 2),
    //  S(Result));
  end;

begin
  CSEnterMethod(nil, cFn);
  Result := False;
  InputStartPos := -1;
  InputStopPos := -1;
  ActiveWebHubExtract := '';
  CSSend('ActiveWebHubCommandWord', ActiveWebHubCommandWord);

  if FileExists(ActiveFilespec) then
  begin
    EditPadPosition := StrToIntDef(ParamString('-pos'), -1);
    //CSSend('EditPadPosition', S(EditPadPosition));
    if EditPadPosition <> -1 then
    begin
      Content8 := UTF8String(StringLoadFromFile(ActiveFilespec));
      LogToCodeSiteKeepCRLF('Content8', string(content8));

      InputStartPos := FirstStartParentil;
      //CSSend('InputStartPos', S(InputStartPos));

      if InputStartPos <> -1 then
      begin
        CountParentilPairs := 1;
        i := (InputStartPos + 2 + Length(ActiveWebHubCommandWord) - 1);
        while i <= Pred(Length(Content8)) do
        begin
          if IsMacroEnd(i) then
          begin
            Dec(CountParentilPairs);
            if CountParentilPairs = 0 then
            begin
              InputStopPos := Succ(i);
              Result := True;
              break;
            end
            else
              Inc(i); // move ahead 1 extra
          end
          else
          if IsMacroStart(i) then
          begin
            Inc(CountParentilPairs);
            Inc(i); // move ahead 1 extra
          end;
          Inc(i); // usual increment for the while/for loop
          //CSSend('CountParentilPairs', S(CountParentilPairs));
        end;
      end;
    end;
  end;
  if Result then
  begin
    ActiveWebHubExtract := string(UTF8Copy(Content8, InputStartPos,
      InputStopPos - InputStartPos + 1));
  end;
  CSSend('ActiveWebHubExtract', ActiveWebHubExtract);
  CSExitMethod(nil, cFn);
end;

initialization
  ActiveFilespec := uCode.ParamString('-file');
  ActiveWebHubCommandWord := Lowercase(ParamString('-word'));

end.
