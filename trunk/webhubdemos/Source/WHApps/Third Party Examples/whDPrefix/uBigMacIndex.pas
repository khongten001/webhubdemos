unit uBigMacIndex;

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
  i: Integer;
  AdjustedUSD: string;
begin
  CSEnterMethod(nil, cFn);
  if BigMacList = nil then
  begin
    BigMacList := TStringList.Create;
    BigMacList.LoadFromFile('D:\Projects\webhubdemos\Live\Database\' +
      'whDPrefix\BigMacIndex.csv');
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
  (*i := BigMacList.IndexOf(ThisCountryCode);
  CSSend('i', S(i));
  if i = -1 then
  begin
    CSSend('just values', bigMacList.Values['AU']);
    i := BigMacList.IndexOf('US');
    CSSend('i for US', S(i));
  end;
  if i <> -1 then
  begin
    AdjustedUSD := BigMacList.ValueFromIndex[i];
    CSSend('AdjustedUSD', AdjustedUSD);
    Result := StrToFloatDef(Copy(AdjustedUSD, 2, MaxInt), 0); // no $ symbol
  end
  else
    Result := 4.50;*)

  Result := Result * BurgerCount;
  CSExitMethod(nil, cFn);
end;

initialization
finalization
  FreeAndNil(BigMacList);

end.
