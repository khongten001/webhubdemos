unit uSeleniumIgnoreChanging;
(*
Copyright (c) 2010 HREF Tools Corp.

Permission is hereby granted, on 14-Jun-2010, free of charge, to any person
obtaining a copy of this file (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*)

interface

procedure RegExInit(const AdminSessionID: string);
function StripChanging(const InValue: UTF8String)
  : UTF8String;

implementation

uses
  SysUtils,
  ldiRegEx,   // search path use H:\ or K:\WebHub\regex
  ucPos, ucString;

var
  InitOnce: Boolean = False;
  Reg : TldiRegExMulti = nil;
  PatternIDAdminSessionRandomPortion: Integer;
  PatternIDSpanChanging: Integer;
  PatternIDSpanComment: Integer;
  PatternIDSpanJSComment: Integer;
  PatternIDWebHubVersion: Integer;
  SavAdminSessionID: string;


function RegReplace(const src: string; const APatternID: Integer;
  const replaceWith: string): TldiString;
begin
  Result := TldiString(Reg.Replace(APatternID, src, replaceWith));
end;

procedure RegExInit(const AdminSessionID: string);
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
    SavAdminSessionID := AdminSessionID;
    Reg := TldiRegExMulti.Create(nil);
    NewRegexPattern('<span class="changing">.*</span>',
      PatternIDSpanChanging );
    NewRegexPattern('<!-- changing:start-->.*<!-- changing:stop-->',
      PatternIDSpanComment );
    NewRegexPattern('/\* changing:start \*/.*/\* changing:stop \*/',
      PatternIDSpanJSComment );
    NewRegexPattern(
      Format('%s\.\d\d\d\d', [AdminSessionID]),
      PatternIDAdminSessionRandomPortion);
    NewRegexPattern('WebHub-v2\.\d\d\d', PatternIDWebHubVersion);
    InitOnce := True;
  end;
end;

function StripChanging(const InValue: UTF8String): UTF8String;
var
  x, y, z: Integer;
begin
  Result := InValue;

  // This uses the old version of ldiRegEx from about 2007. We have not
  // yet released an update for Delphi 2010 native strings... (June 2010)
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

  // fails in D14
  //Result := RegReplace(string(Result), PatternIDSpanJSComment, '');

  z := Length('/* changing:stop */');
  while true do
  begin
    x := UTF8PosCI('/* changing:start */', Result);
    if x = 0 then break;
    y := UTF8PosCI('/* changing:stop */', Result);
    if y = 0 then break;
    Result := UTF8Copy(Result, 1, x - 1) +
      UTF8Copy(Result, y + z, MaxInt);
  end;

  Result := RegReplace(string(Result), PatternIDAdminSessionRandomPortion,
    SavAdminSessionID + '\.9999');

  Result := RegReplace(string(Result), PatternIDWebHubVersion,
    'WebHub-v0.000');

end;

initialization
finalization
  FreeAndNil(Reg);

end.
