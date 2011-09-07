unit HTMLText;

interface

uses
   Messages, SysUtils, Classes, Graphics, Controls, StdCtrls;

type
   TToken = (etEnd, etSymbol, etLineEnd, etHTMLTag);

   TSimpleHTMLParser = class
   private
      FSourcePtr: PChar;
      FTitle: string;
      FTokenPtr: PChar;
      FTokenString: string;
      FToken: TToken;
      procedure NextToken;
      //procedure NextSymbol;
      function GetCleanToken : string;
      //function TokenSymbolIs(const S: string): Boolean;
      function TokenHTMLTagIs(const S: string): Boolean;
   public
      constructor Create(Text: PChar);
      procedure Filter(List : TStrings ; Clean : Boolean);
      property Title: string read FTitle;
   end;

function TextFromHTML(const Value:String):String;
function TextFromHTMLpChar(Buffer:PChar):String;
function TextFromHTMLFile(const Filename:string):String;
function TextFromHTMLStream(Stream:TStream):String;

implementation

function TextFromHTML(const Value:String):String;
begin
   Result:=TextFromHTMLpChar(pChar(Value));
end;

function TextFromHTMLpChar(Buffer:PChar):String;
var List: TStrings;
begin
   Result:= '';
   With TSimpleHTMLParser.Create(Buffer) do
      Try
         List:= TStringList.Create;
         Try
            Filter(List,True);
            Result:=List.Text;
         Finally
            List.Free
         End;
      Finally
         Free
      End;
end;

function TextFromHTMLFile(const Filename:string):String;
var Stream : TStream;
begin
   Stream := TFileStream.Create(Filename,fmOpenRead);
   Try
      Result:=TextFromHTMLStream(Stream);
   Finally
      Stream.Free;
   End;
end;

function TextFromHTMLStream(Stream:TStream):String;
var
   Buffer : PChar;
   Size   : LongInt;
begin
   Result:='';
   Size := Stream.Size;
   GetMem(Buffer,Size + 1);
   Try
      Stream.ReadBuffer(Buffer^,Size);
      Buffer[Size] := #0;
      Result:= TextFromHTMLpChar(Buffer);
   Finally
      FreeMem(Buffer,Size + 1)
   End;
end;

procedure ReplaceStr(Remove, Replace : string; var Source : string);
var i : Integer;
begin
   i := Pos(Remove,Source);
   While i > 0 do
      begin
         Delete(Source, i, Length(Remove));
         Insert(Replace, Source, i);
         i := Pos(Remove,Source)
      end
end;

{ TSimpleHTMLParser }

constructor TSimpleHTMLParser.Create(Text: PChar);
begin
   FSourcePtr := Text;
   NextToken;
end;

procedure TSimpleHTMLParser.NextToken;
var P, TokenStart: PChar;
begin
   FTokenString := '';
   P := FSourcePtr;
   While (P^<>#0) and (P^<=' ') do Inc(P);
   FTokenPtr := P;
   Case P^ of
      '<':
         begin
            Inc(P);
            TokenStart := P;
            While (P^<>'>') and (P^<>#0) do Inc(P);
            SetString(FTokenString, TokenStart, P - TokenStart);
            FToken := etHTMLTag;
            Inc(P);
         end;
      #13:
         FToken := etLineEnd;
      #0:
         FToken := etEnd;
   Else
      begin
         TokenStart := P;
         Inc(P);
         while not CharInSet(P^, ['<', #0, #13,#10]) do
           Inc(P);
         SetString(FTokenString, TokenStart, P-TokenStart);
         FToken := etSymbol;
      end;
   End;
   FSourcePtr := P;
end;

//procedure TSimpleHTMLParser.NextSymbol;
//begin
//  while (FToken <> etEnd) do begin
//    NextToken;
//    if FToken = etSymbol then
//      break;
//    end;
//end;

function TSimpleHTMLParser.GetCleanToken : string;
begin
   Result:= FTokenString;
   ReplaceStr('  ',' ',Result);
   ReplaceStr('&amp;','&',Result);
   ReplaceStr('&#160;','',Result);
   ReplaceStr('&nbsp;','',Result);
end;

//function TSimpleHTMLParser.TokenSymbolIs(const S: string): Boolean;
//begin
//  Result := (FToken = etSymbol) and (CompareText(FTokenString, S) = 0);
//end;

function TSimpleHTMLParser.TokenHTMLTagIs(const S: string): Boolean;
begin
   Result:= (FToken = etHTMLTag) and ((CompareText(FTokenString, S) = 0) or (Pos(S, FTokenString) = 1));
end;

procedure TSimpleHTMLParser.Filter(List : TStrings ; Clean : Boolean);
var ALine: String;
   procedure AddLine;
   begin
      List.Add(ALine);
      ALine := '';
   end;
begin
   List.Clear;
   ALine := '';
   While FToken <> etEnd do
      begin
         Case FToken of
            etHTMLTag:
               begin
                  If TokenHTMLTagIs('BR') then AddLine
                  Else
                     If TokenHTMLTagIs('P') then AddLine
                     Else
                        If TokenHTMLTagIs('TITLE') then
                           begin
                              NextToken;
                              FTitle := FTokenString
                           end
               end;
            etSymbol:
               If Clean then ALine := TrimRight(ALine) + ' ' + GetCleanToken
               Else ALine := ALine + ' ' + FTokenString;
            etLineEnd: AddLine;
         End;
         NextToken;
      end;
   AddLine;
end;

end.

