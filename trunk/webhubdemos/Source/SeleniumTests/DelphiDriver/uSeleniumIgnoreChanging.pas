unit uSeleniumIgnoreChanging;

interface

function StripChanging(const InValue: UTF8String): UTF8String;

implementation

uses
  SysUtils,
  ldiRegEx,   // search path use H:\ or K:\WebHub\regex
  ucPos, ucString;

var
  InitOnce: Boolean = False;
  Reg : TldiRegExMulti = nil;
  PatternIDSpanChanging: Integer;
  PatternIDSpanComment: Integer;
  PatternIDSpanJSComment: Integer;


function RegReplace(const src: string; const APatternID: Integer;
  const replaceWith: string): TldiString;
var
  PatternStatus: TPatternStatus;

    procedure NewRegexPattern(const PatString: String;
      out NewPatternID: Integer);
    begin
      if not Reg.AddPattern(PatString,
        [{coIgnoreCase, }coUnGreedy],
        NewPatternID,
        PatternStatus) then
      begin
        FreeAndNil(Reg);
        raise Exception.Create('AddPattern error! ' + PatternStatus.ErrorMessage);
      end;
    end;
begin

  if NOT InitOnce then
  begin
    Reg := TldiRegExMulti.Create(nil);
    NewRegexPattern('<span class="changing">.*</span>',
      PatternIDSpanChanging );
    NewRegexPattern('<!-- changing:start-->.*<!-- changing:stop-->',
      PatternIDSpanComment );
    NewRegexPattern('/\* changing:start \*/.*/\* changing:stop \*/',
      PatternIDSpanJSComment );

    InitOnce := True;
  end;
  Result := TldiString(Reg.Replace(APatternID, src, replaceWith));
end;

function StripChanging(const InValue: UTF8String): UTF8String;
var
  x, y, z: Integer;
begin
  Result := InValue;
  //Result := RegReplace(Result, ':[0-9]+(?=[^0-9])', ':1234');
  //Result := RegReplace(Result, ':[0-9]+\.[0-9]+:', ':1234.5678:');
  //Result := RegReplace(Result, ':[0-9]+"', ':1204"');
  //Result := RegReplace(Result, ':[0-9]+:', ':1204:');
  //Result := RegReplace(Result, ':1204\..*"', ':1204"');
  Result := RegReplace(string(Result), PatternIDSpanChanging, '');

  // fails in D14
  // Result := RegReplace(string(Result), PatternIDSpanComment, '');

  z := Length('<!-- changing:stop-->');
  while true do
  begin
    x := UTF8PosCI('<!-- changing:start-->', Result);
    if x = 0 then break;
    y := UTF8PosCI('<!-- changing:stop-->', Result);
    if y = 0 then break;
    Result := UTF8Copy(Result, 1, x - 1) +
      UTF8Copy(Result, y + z, MaxInt);
  end;

  // not sure yet whether this works
  Result := RegReplace(string(Result), PatternIDSpanJSComment, '');
end;

initialization
finalization
  FreeAndNil(Reg);

end.
