unit WHBridge2EditPad_uExpressionReplacement;

interface

uses
  Classes, FMX.Controls;

type
  TValidControlArray = Array of TStyledControl; // TCustomEdit;

function FindImportantInputText: Boolean;

function CalculateFullExpression(const LabelCommandText: string;
  AnyE: TValidControlArray): string;

function ReplaceFileContentsNow(const LabelCommandText: string;
  AnyE: TValidControlArray): Boolean;

var
  ActiveFilespec: string = '';
  ActiveWebHubCommandWord: string = '';
  ActiveWebHubExtract: string = '';
  InputStartPos, InputStopPos: Integer;
  OutputStartPos, OutputStopPos: Integer;


implementation

uses
  SysUtils, FMX.Memo, FMX.Edit,
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
      //LogToCodeSiteKeepCRLF('Content8', string(content8));

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



function CalculateFullExpression(const LabelCommandText: string;
  AnyE: TValidControlArray): string;
var
  TentativeResult: string;
  ThisEditText: string;
  i, n: Integer;
begin
  TentativeResult := MacroStart + LabelCommandText + '|';
  n := High(AnyE);
  for i := Low(AnyE) to n do
  begin
    if Assigned(AnyE[i]) then
    begin
      CSSend(AnyE[i].Name + ': ClassName', AnyE[i].ClassName);
      if AnyE[i] is TMemo then
        ThisEditText := TMemo(AnyE[i]).Lines.Text
      else
        ThisEditText := TCustomEdit(AnyE[i]).Text;
      TentativeResult := TentativeResult + '__' + ThisEditText;
    end;
  end;
  TentativeResult := TentativeResult + MacroEnd;
  Result := TentativeResult;
end;

function ReplaceFileContentsNow(const LabelCommandText: string;
  AnyE: TValidControlArray): Boolean;
var
  ReplacementInfo8: UTF8String;
  Content8: UTF8String;
  Before8, After8: UTF8String;
begin
  if FileExists(ActiveFilespec) then
  begin
    Content8 := UTF8String(StringLoadFromFile(ActiveFilespec));
    Before8 := UTF8Copy(Content8, 1, Pred(InputStartPos));
    CSSend('Before8', string(Before8));
    After8 := UTF8Copy(Content8, Succ(InputStopPos), MaxInt);
    CSSend('After8', string(After8));
    ReplacementInfo8 := UTF8String(CalculateFullExpression(LabelCommandtext,
      AnyE));
    ReplacementInfo8 := Before8 + ReplacementInfo8 + After8;
    UTF8StringWriteToFile(ActiveFilespec, ReplacementInfo8);
    Result := True;
  end
  else
    Result := False;
end;

initialization
  ActiveFilespec := ParamString('-file');
  ActiveWebHubCommandWord := Lowercase(ParamString('-word'));

end.
