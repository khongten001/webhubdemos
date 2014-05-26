program ConsoleSender;

{$I hrefdefines.inc}

uses
  CodeSiteLogging in 'D:\Projects\webhubdemos\Source\StandaloneDemos\TtpSharedData\alternate\CodeSiteLogging.pas',
  SysUtils,
  NativeXml in 'k:\webhub\ZaphodsMap\NativeXml.pas',
  ucCodeSiteInterface in 'k:\webhub\tpack\ucCodeSiteInterface.pas',
  ucString in 'k:\webhub\tpack\ucString.pas',
  ucLogFil in 'k:\webhub\tpack\ucLogFil.pas',
  ucAnsiUtil in 'k:\webhub\tpack\ucAnsiUtil.pas',
  ucConvertStrings in 'k:\webhub\tpack\ucConvertStrings.pas',
  {$IFDEF FPC}LazUTF8,{$ENDIF}
  MultiTypeApp in 'k:\webhub\tpack\MultiTypeApp.pas',
  tpShareB in 'k:\webhub\tpack\tpShareB.pas'
  ;

{$I fpcFormat.inc}

const
  ws2: str_ing = #$03A8' '#$03A9;  // phi omega
  //ws3: string = #$03A8' '#$03A9;  // phi omega
var
  AFilespec: str_ing;
  Value: str_ing;
  S8: UTF8String;

begin
  AFilespec := GetTestLogFilespec;
  CSSend('AFilespec', AFilespec);
  Value := 'ok' + sLineBreak;
  StringWriteToFile(AFilespec, Value);
  {$IFDEF FPC}
  {$ifdef FPC_HAS_FEATURE_WIDESTRINGS}
  CSSend('FPC_HAS_FEATURE_WIDESTRINGS');
  {$ELSE}
  missing WideString support
  {$ENDIF}
  {$ENDIF}
  HREFTestLog('info', 'a', 'A');  // always UTF16 LOG files
  CSSend('phi omega', ws2);
  Value := ws2 + sLineBreak;
  StringAppendToFile(AFilespec, Value);
  AppendLine(AFilespec, Value);
  S8 := Conv16to8(Format('%s%s', ['thru 8 ', Value]));
  AppendLine(AFilespec, Conv8to16(S8));
  Value := Format('Normal Format %s', [ws2]);
  AppendLine(AFilespec, Value);
  Value := XFormat('XFormat %s', [ws2]);
  AppendLine(AFilespec, Value);
  HREFTestLog('info', 'phi omega', ws2);
  //Value := 'abc';
  //HREFTestLog('info', 'length of abc', IntToStr(Length(Value)));
  //HREFTestLog('info', 'length of ws2', IntToStr(Length(ws2)));
  //HREFTestLog('info', 'length of ws3', IntToStr(Length(ws3)));
  {HREFTestLog('info', 'Addr [1]', IntToHex(NativeUInt(Addr(ws2[1])),8));
  HREFTestLog('info', 'Addr [2]', IntToHex(NativeUInt(Addr(ws2[2])),8));
  HREFTestLog('info', 'Addr [3]', IntToHex(NativeUInt(Addr(ws2[3])),8));
  HREFTestLog('info', 'Addr [1]', IntToHex(NativeUInt(Addr(ws3[1])),8));
  HREFTestLog('info', 'Addr [2]', IntToHex(NativeUInt(Addr(ws3[2])),8));
  HREFTestLog('info', 'Addr [3]', IntToHex(NativeUInt(Addr(ws3[3])),8));
  }
  (*UTF8StringAppendToFile(GetTestLogFilespec,
    {$IFDEF FPC}LazUTF8.UTF16toUTF8(ws2){$ELSE}
    Conv16to8(ws2){$ENDIF});
  UTF8StringAppendToFile(GetTestLogFilespec, Conv16to8(ws2));
  *)
end.



