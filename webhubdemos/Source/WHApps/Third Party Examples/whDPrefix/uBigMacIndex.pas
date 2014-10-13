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


interface

function BigMacPriceForCountry(const ThisCountryCode: string;
  const BurgerCount: Integer = 1): Double;

implementation

uses
  SysUtils, Classes,
  ucString, ucCodeSiteInterface;

var
  BigMacList: TStringList = nil;

function BigMacPriceForCountry(const ThisCountryCode: string;
  const BurgerCount: Integer = 1): Double;
const cFn = 'BigMacPriceForCountry';
var
  AdjustedUSD: string;
begin
  CSEnterMethod(nil, cFn);
  if BigMacList = nil then
  begin
    BigMacList := TStringList.Create;
    BigMacList.LoadFromFile('D:\Projects\webhubdemos\Live\Database\' +
      'whDPrefix\BigMacPrices.tsv');
    BigMacList.Text := StringReplaceAll(BigMacList.Text, #9, '=');
    CSSend('BigMacList', BigMacList.Text);
  end;
  CSSend('ThisCountryCode', ThisCountryCode);
  AdjustedUSD := bigMacList.Values[ThisCountryCode];
  if AdjustedUSD = '' then
    AdjustedUSD := BigMacList.Values['US'];
  if AdjustedUSD = '' then
    AdjustedUSD := '$4.50';
  Result := StrToFloatDef(Copy(AdjustedUSD, 2, MaxInt), 0); // no $ symbol

  Result := Result * BurgerCount;
  CSExitMethod(nil, cFn);
end;

initialization
finalization
  FreeAndNil(BigMacList);

end.
