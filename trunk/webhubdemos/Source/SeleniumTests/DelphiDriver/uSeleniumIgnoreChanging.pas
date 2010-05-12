unit uSeleniumIgnoreChanging;

interface

function StripChanging(const InValue: UTF8String): UTF8String;

implementation

uses
  SysUtils,
  ldiRegEx;

var
  InitOnce: Boolean = False;
  Reg : TldiRegExMulti = nil;
  PatternIDSpanChanging: Integer;
  PatternIDSpanComment: Integer;
  PatternIDSpanJSComment: Integer;


function RegReplace(const src: UTF8String; const PatternID: Integer;
  const replaceWith: UTF8String): UTF8String;
var
  PatternStatus: TPatternStatus;

    procedure NewRegexPattern(const PatString: UTF8String;
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
  Result := Reg.Replace(PatternID, src, replaceWith);
end;

function StripChanging(const InValue: UTF8String): UTF8String;
var
  S: UTF8String;
begin
  S := InValue;
  //s := RegReplace(s, ':[0-9]+(?=[^0-9])', ':1234');
  //s := RegReplace(s, ':[0-9]+\.[0-9]+:', ':1234.5678:');
  //s := RegReplace(s, ':[0-9]+"', ':1204"');
  //s := RegReplace(s, ':[0-9]+:', ':1204:');
  //s := RegReplace(s, ':1204\..*"', ':1204"');
  s := RegReplace(s, PatternIDSpanChanging, '');
  s := RegReplace(s, PatternIDSpanComment, '');
  s := RegReplace(s, PatternIDSpanJSComment, '');
end;

initialization
finalization
  FreeAndNil(Reg);

end.
