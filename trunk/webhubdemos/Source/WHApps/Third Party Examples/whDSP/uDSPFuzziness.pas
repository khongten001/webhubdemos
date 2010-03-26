unit uDSPFuzziness;

interface

uses
  Classes,
  rbRank, rbSearch;

type
   TFuzzyness = (fuzAuto,fuzNone,fuzSome,fuzFuzzy,fuzFuzzier);

function Fuzzy(const Value: string; Fuzzyness: TFuzzyness): string;
function PerformSearch(InRbSearch: TrbSearch; const aFind,aExclude,aOr,
  aAnd: string; FuzzLevel: TFuzzyness; var aSearched: string;
  FinalMatchedList: TStrings): Integer;
function DoPerformSearch(InRbSearch: TrbSearch; aFind, aExclude, aOr,
  aAnd: string; aSearchLogic: TSearchLogic; FinalMatchedList: TStrings)
  : Boolean;

implementation

uses
  SysUtils,
  ucLogFil, ucString;
  
function OneWord(const value: string): Boolean;
begin
   Result:=(Length(Value)>1)     //more than a single character
         and (pos(' ',value)=0)    //and no spaces
         and (pos('*',value)=0)    //and no full wildcard
         and (pos('?',value)=0);   //and no char wildcard
end;

function Fuzzy(const Value: string; Fuzzyness: TFuzzyness): string;
var
  i: integer;

   function CharSubst: string;
   begin
      Result:=copy(Value,1,pred(i))+'?'+copy(Value,succ(i),maxlongint);
      Result:=Result+' '+Result+'? '+Result+'??';
   end;
   function CharInsert: string;
   begin
      Result:=copy(Value,1,pred(i))+'?'+copy(Value,i,maxlongint);
      Result:=Result+' '+Result+'? '+Result+'??';
   end;

begin
   Result:=Value;                              // abc
   if not OneWord(Value)
     or (Fuzzyness in [fuzNone,fuzAuto]) then
     Exit;
   Result:=Result+' '+Value+'?';               // abc?
   Result:=Result+' '+Value+'??';              // abc??
   if Fuzzyness=fuzSome then
     Exit;
   for i:=2 to length(Value) do
     Result:=Result+' '+CharSubst;               // abc a?c ab?
   if Fuzzyness=fuzFuzzy then
     Exit;
   //fuzFuzzier:
   for i:=2 to length(Value) do
     Result:=Result+' '+CharInsert;               // abc a?bc ab?c
end;


function PerformSearch(InRbSearch: TrbSearch; const aFind, aExclude, aOr,
  aAnd: string; FuzzLevel: TFuzzyness; var aSearched: string;
  FinalMatchedList: TStrings): integer;
var
   bFuzzy:Boolean;
   FuzzNow:TFuzzyness;
begin
  //copy to loop var
  if FuzzLevel=fuzAuto then
    //if auto, start at lowest level (which is one higher than fuzNone)
    FuzzNow:=fuzSome
  else
    FuzzNow:=FuzzLevel;

  //see if fuzzy search even applies
  if (FuzzNow = fuzNone) then
  begin
    aSearched := aFind;
    DoPerformSearch(InRbSearch, aSearched, aExclude, aOr, aAnd,
      slOr, // Do not use slPhrase nor slSmart here.
      FinalMatchedList);
  end
  else
  begin
    bFuzzy:= OneWord(aFind) and (FuzzNow<>fuzNone);
    if not bFuzzy then
      begin
         aSearched:=aFind;
         DoPerformSearch(InRbSearch, aSearched, aExclude, aOr, aAnd, slSmart,
           FinalMatchedList);
      end
   else
      repeat
         //or else go and try the fuzzy search
         aSearched:=Fuzzy(aFind,FuzzNow);
// *****
aSearched := aFind;  // IS THIS IMPORTANT ?
// *****
         if DoPerformSearch(InRbSearch, aSearched, aExclude, aOr, aAnd, slOr,
           FinalMatchedList) or (FuzzNow=fuzFuzzier) or (FuzzLevel<>fuzAuto)
         then
           break;
         Inc(FuzzNow);
      until FuzzNow > fuzFuzzier;
  end;

   //how many answers?
   if not assigned(InRbSearch.MatchBits) then
   begin
      aSearched:='';
      Result:=0;
   end
   else
     Result:= InRbSearch.MatchBits.Count;
end;


function DoPerformSearch(InRbSearch: TrbSearch; aFind, aExclude, aOr,
  aAnd: string; aSearchLogic: TSearchLogic; FinalMatchedList: TStrings)
  : Boolean;
const
  cFn = 'DoPerformSearch';
var
  sl: TSearchLogic;
begin
   Result:=false;
   with InRbSearch do
      begin
      
         if aFind='' then
         begin
           //no phrase entered, but selected some categories.
           ExchangeStrings(aFind,aOr);
           SearchLogic := slOr;
         end
         else
           //let rubicon figure out what the user meant
           SearchLogic:=aSearchLogic; //slSmart;

         if aFind='' then
            begin
               //no categories and no phrase, must be all selected types
               SearchLogic:=slAnd;
               ExchangeStrings(aFind,aAnd);
            end;

         if aFind='' then
         begin
           if assigned(MatchBits) then
              MatchBits.Clear;
           Exit;
         end;

         if aExclude<>'' then
            begin
               SearchMode:=smSearch;
               sl:=SearchLogic;
               SearchLogic:=slNot;
               SearchFor:=aExclude;
               Execute;
               SearchMode:=smNarrow;
               SearchLogic:=sl;
            end
         else
           SearchMode:=smSearch;

         SearchFor := aFind;
         try
            Execute;
         except
            On e: Exception do
               begin
                  Result := False;
                  HREFTestLog('ERROR', cFn, aFind + #9 + e.Message);
                  Exit;
               end;
         end;

         try
            if aOr<>'' then
               begin
                  SearchMode:=smNarrow;
                  SearchLogic:=slOr;
                  SearchFor:=aOr;
                  Execute;
               end;

            if aAnd<>'' then
               begin
                  SearchMode:=smNarrow;
                  SearchLogic:=slAnd;
                  SearchFor:=aAnd;
                  Execute;
               end;
         Except
            On e: Exception do
               begin
                  Result := False;
                  HREFTestLog('ERROR', cFn, aAnd + #9 + aOr + #9 + e.Message);
                  Exit;
               end;
         End;

         MatchingWords(FinalMatchedList);
         Result := MatchBits.Count > 0;
      end;
end;

end.
