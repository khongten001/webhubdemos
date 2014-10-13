unit uBigMacIndex;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2014 HREF Tools Corp.  All Rights Reserved Worldwide.      * }
{ *                                                                          * }
{ * This source code file is part of the Delphi Prefix Registry.             * }
{ *                                                                          * }
{ * This file is licensed under a Creative Commons Attribution 2.5 License.  * }
{ * http://creativecommons.org/licenses/by/2.5/                              * }
{ * If you use this file, please keep this notice intact.                    * }
{ *                                                                          * }
{ * Author: Ann Lynnworth                                                    * }
{ *                                                                          * }
{ * Refer friends and colleagues to www.href.com/whvcl. Thanks!              * }
{ ---------------------------------------------------------------------------- }

(* iso codes from https://www.iso.org/obp/ui/#search *)

{$DEFINE LogBMIdx}

interface

function BigMacPriceForCountry(const ThisCountryCode: string;
  const BurgerCount: Integer = 1): Double;
function IsCountrySupported(const ThisCountryCode: string): Boolean;
function HtmlSelectCountry(
  const InHtmlFieldname, InHtmlFieldID, InHtmlClass: string): string;

implementation

uses
  SysUtils, Classes,
  ucString, ucCodeSiteInterface, whdemo_ViewSource;

var
  BigMacList: TStringList = nil;
  BigMacCountries: TStringList = nil;

procedure LoadBigMacList;
var
  DemoRootPath: string;
  Filespec: string;
begin
  if BigMacList = nil then
  begin
    BigMacList := TStringList.Create;
    DemoRootPath := getWebHubDemoInstallRoot;
    CSSend('DemoRootPath', DemoRootPath);
    Filespec := DemoRootPath + 'Live' + PathDelim + 'Database' + PathDelim +
      'whDPrefix' + PathDelim + 'BigMacPrices.tsv';
    if NOT FileExists(Filespec) then
      CSSendError('File not found: ' + Filespec)
    else
      BigMacList.LoadFromFile(Filespec);
    BigMacList.Text := StringReplaceAll(BigMacList.Text, #9, '=');
    {$IFDEF LogBMIdx}CSSend('BigMacList', BigMacList.Text);{$ENDIF}
  end;
  if BigMacCountries = nil then
  begin
    BigMacCountries := TStringList.Create;
    DemoRootPath := getWebHubDemoInstallRoot;
    Filespec := DemoRootPath + 'Live' + PathDelim + 'Database' + PathDelim +
      'whDPrefix' + PathDelim + 'BigMacCountries.tsv';
    if NOT FileExists(Filespec) then
      CSSendError('File not found: ' + Filespec)
    else
      BigMacCountries.LoadFromFile(Filespec);
    BigMacCountries.Text := StringReplaceAll(BigMacCountries.Text, #9, '=');
    {$IFDEF LogBMIdx}CSSend('BigMacCountries', BigMacCountries.Text);{$ENDIF}
  end;
end;


function BigMacPriceForCountry(const ThisCountryCode: string;
  const BurgerCount: Integer = 1): Double;
const cFn = 'BigMacPriceForCountry';
var
  AdjustedUSD: string;
  FlagCountrySupported: Boolean;
begin
  {$IFDEF LogBMIdx}CSEnterMethod(nil, cFn);{$ENDIF}

   LoadBigMacList;

  {$IFDEF LogBMIdx}CSSend('ThisCountryCode', ThisCountryCode);{$ENDIF}
  AdjustedUSD := bigMacList.Values[ThisCountryCode];

  FlagCountrySupported := AdjustedUSD <> '';
  if NOT FlagCountrySupported then
    AdjustedUSD := BigMacList.Values['US'];

  Result := StrToFloatDef(Copy(AdjustedUSD, 2, MaxInt), 0); // no $ symbol

  Result := Result * BurgerCount;

  if NOT FlagCountrySupported then
    Result := Result * 2;  // high price for unsupported country

  {$IFDEF LogBMIdx}CSSend('Result', Format('%m', [Result]));{$ENDIF}

  {$IFDEF LogBMIdx}CSExitMethod(nil, cFn);{$ENDIF}
end;

function IsCountrySupported(const ThisCountryCode: string): Boolean;
const cFn = 'IsCountrySupported';
begin
  {$IFDEF LogBMIdx}CSEnterMethod(nil, cFn);{$ENDIF}

  LoadBigMacList;

  Result := (bigMacList.Values[ThisCountryCode] <> '');
  {$IFDEF LogBMIdx}
  CSSend(ThisCountryCode, S(Result));
  CSExitMethod(nil, cFn);{$ENDIF}
end;

function HtmlSelectCountry(
  const InHtmlFieldname, InHtmlFieldID, InHtmlClass: string): string;
var
  sb: TStringBuilder;
  i: Integer;
  ACode, AName: string;
begin
  sb := nil;
  Result := '';
  LoadBigMacList;
  try
    sb := TStringBuilder.Create;
    sb.AppendFormat('<select id="%s" name="%s" classname="%s">',
      [InHtmlFieldID, InHtmlFieldname, InHtmlClass]);
    for i := 0 to Pred(BigMacCountries.Count) do
    begin
      SplitString(BigMacCountries[i], '=', ACode, AName);
      sb.AppendFormat('<option value="%s">%s</option>', [ACode, AName]);
    end;
    sb.AppendLine('</select>');

    Result := sb.ToString;
  finally
    FreeAndNil(sb);
  end;
end;

initialization
finalization
  FreeAndNil(BigMacList);
  FreeAndNil(BigMacCountries);

end.
