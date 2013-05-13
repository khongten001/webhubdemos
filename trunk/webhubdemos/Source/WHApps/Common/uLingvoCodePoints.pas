unit uLingvoCodePoints;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2010-2012 HREF Tools Corp.  All Rights Reserved Worldwide. * }
{ *                                                                          * }
{ * This source code file is part of the WebHub Demos.                       * }
{ *                                                                          * }
{ * This file is licensed under a Creative Commons Attribution 2.5 License.  * }
{ * http://creativecommons.org/licenses/by/2.5/                              * }
{ * If you use this file, please keep this notice intact.                    * }
{ *                                                                          * }
{ * Refer friends and colleagues to http://www.href.com -- thanks!           * }
{ *                                                                          * }
{ ---------------------------------------------------------------------------- }

{$I hrefdefines.inc}

interface

function AlphabetCharsInRange(const iLow, iHigh: Integer;
  const title: string = ''; const wrapAt: Integer = 0): string;
function SeparatorCharsInRange(const iLow, iHigh: Integer;
  const title: string = ''; const wrapAt: Integer = 0): string;

function DemoInternationalAlphabet: string;
function DemoInternationalWordDelims: string;

implementation

uses
{$IFDEF UNICODE}
  Character,
{$ENDIF}
  SysUtils;

function AlphabetCharsInRange(const iLow, iHigh: Integer;
  const title: string = '';
  const wrapAt: Integer = 0): string;
var
  c: Char;
  i: Integer;
begin
  {$IFDEF UNICODE}
  if title <> '' then
    Result := title + sLineBreak
  else
    Result := '';
  for i := iLow to iHigh do
  begin
    c := Chr(i);
    {$IFDEF Delphi18UP}
    if c.IsUpper then
    {$ELSE}
    if IsUpper(c) then
    {$ENDIF}
    begin
      Result := Result + c;
      if (wrapAt <> 0) and ((Length(Result) mod wrapAt) = 0) then
        Result := Result + sLineBreak;
    end;
  end;
  {$ELSE}
  Result := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  {$ENDIF}
end;


function SeparatorCharsInRange(const iLow, iHigh: Integer;
  const title: string = '';
  const wrapAt: Integer = 0): string;
var
  c: Char;
  i: Integer;
begin
  {$IFDEF UNICODE}
  if title <> '' then
    Result := title + sLineBreak
  else
    Result := '';
  for i := iLow to iHigh do
  begin
    c := Chr(i);
    {$IFDEF Delphi18UP}
    if c.IsSeparator or c.IsPunctuation or c.IsSymbol or c.IsControl then
    {$ELSE}
    if IsSeparator(c) or IsPunctuation(c) or IsSymbol(c) or IsControl(c) then
    {$ENDIF}
    begin
      Result := Result + c;
      if (wrapAt <> 0) and ((Length(Result) mod wrapAt) = 0) then
        Result := Result + sLineBreak;
    end;
  end;
  {$ELSE}
  Result := ' :;.,' + #9;
  {$ENDIF}
end;


function DemoInternationalAlphabet: string;
begin
  Result :=
      // http://en.wikipedia.org/wiki/Latin_characters_in_Unicode
      // Latin
      AlphabetCharsInRange(0, StrToInt('$007F')) +
      // Latin Extended A
      AlphabetCharsInRange(StrToInt('$0100'), StrToInt('$017F')) +
      // Latin Extended B
      AlphabetCharsInRange(StrToInt('$0180'), StrToInt('$024F')) +
      // Greek
      // http://en.wikipedia.org/wiki/Greek_alphabet#Greek_in_Unicode
      AlphabetCharsInRange(StrToInt('$0370'), StrToInt('$03FF')) +
      // Cyrillic U+0400–U+04FF
      // http://en.wikipedia.org/wiki/Cyrillic_characters_in_Unicode
      // Russian subset
      // U+0410–U+044F, U+0401, U+0451
      AlphabetCharsInRange(StrToInt('$0410'), StrToInt('$044F')) +
      AlphabetCharsInRange(StrToInt('$0401'), StrToInt('$0451')) +
      // Thai
      // http://en.wikipedia.org/wiki/Template:Unicode_chart_Thai
      AlphabetCharsInRange(StrToInt('$0E01'), StrToInt('$0E5B')) +
      // Arabic 0600—06FF
      AlphabetCharsInRange(StrToInt('$0600'), StrToInt('$06FF')) +
      // Japanese Katakana: 30A0 - 30FF
      AlphabetCharsInRange(StrToInt('$30A0'), StrToInt('$30FF'));
end;

function DemoInternationalWordDelims: string;
begin
  Result := SeparatorCharsInRange(0, StrToInt('$007F')) +
      SeparatorCharsInRange(StrToInt('$0100'), StrToInt('$017F')) +
      SeparatorCharsInRange(StrToInt('$0180'), StrToInt('$024F')) +
      SeparatorCharsInRange(StrToInt('$0370'), StrToInt('$03FF')) +
      SeparatorCharsInRange(StrToInt('$0410'), StrToInt('$044F')) +
      SeparatorCharsInRange(StrToInt('$0401'), StrToInt('$0451')) +
      SeparatorCharsInRange(StrToInt('$0E01'), StrToInt('$0E5B')) +
      SeparatorCharsInRange(StrToInt('$0600'), StrToInt('$06FF')) +
      SeparatorCharsInRange(StrToInt('$30A0'), StrToInt('$30FF')) +
      { IB_SQL sometimes puts BOM before UTF8 data in memo fields }
      #65279 +  // U-FEFF zero width non breaking space (BOM)
      { these stylish double-quotes are not otherwise detected as separators }
      #8220  +  // U-201C left  double-comma-quotation-mark
      #8221  +  // U-201D right double-comma-quotation-mark
      #8230     // U-2026 horizontal ellipsis ...
      ;
end;
end.
