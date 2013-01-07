unit wnxdbAlpha; {TWebnxdbAlphabet, a web action component for use with WebHub}

{ The 2003 BDE version of this file is at http://www.href.com/pub/WebAct/db }

(*
Copyright (c) 1995-2012 HREF Tools Corp.

Permission is hereby granted, on 27-Feb-2003, free of charge, to any person 
obtaining a copy of this software (the "Software"), to deal in the Software 
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

//usage in whteko:
// AZ.alphabet   get the alphabet property
// AZ.execute    locate record

interface

uses
  Windows, SysUtils, Classes,
  updateOk, ucString,
  webTypes, webLink, wbdeSource;

type
  TWebnxdbAlphabet = class(TwhWebAction)
  private
    { Private declarations }
    fWebDataSource: TwhbdeSource;   //where the data comes from
    fNumPerRow:integer;
    fAlphabet:string;
    fLinkMacro:string;
    fSeparator: string;
  protected
    { Protected declarations }
    procedure   DoExecute; override;
    function    DoUpdate: boolean; override;
    function    getAlphabet:string;
    procedure   SetNoString(const Value: string);
    procedure   SetNumPerRow(Value:Integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    { Published declarations }
    property NumPerRow: integer read fNumPerRow write setNumPerRow;
    property WebDataSource: TwhbdeSource read fWebDataSource write fWebDataSource;
    property Alphabet: String read getAlphabet write SetNoString stored False;
    property LinkMacro: String read fLinkMacro write fLinkMacro;
    property Separator: string read FSeparator write FSeparator;
  end;

implementation

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  nxdb, // TnxTable
  ucCodeSiteInterface,
  whMacroAffixes;

constructor TWebnxdbAlphabet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fNumPerRow := 26;
  fLinkMacro := 'JUMPR';
  fSeparator := #$2758;  // light vertical bar
end;

destructor TWebnxdbAlphabet.Destroy;
begin
  inherited Destroy;
end;

procedure TWebnxdbAlphabet.SetNoString(const Value: string);
begin
end;

procedure TWebnxdbAlphabet.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (csUpdating in ComponentState) then
    exit;
  if Operation = opRemove then
    cx.NilIfSet(fWebDataSource,AComponent)
  else
    if (aComponent is TwhbdeSource) then
    begin
      if NOT Assigned(fWebDataSource) then
        TComponent(fWebDataSource) := aComponent;
    end;
end;

procedure TWebnxdbAlphabet.SetNumPerRow(Value: Integer);
begin
  fNumPerRow := Value;
  if fNumPerRow < 1 then
    fNumPerRow := 1;
  if fNumPerRow > 26 then
    fNumPerRow := 26;
end;

function TWebnxdbAlphabet.getAlphabet;
const cFn = 'getAlphabet';
var
  a0,a1,a2,a3: String;
  i:integer;
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  a0:=DefaultsTo(Command,HtmlParam);
  a1:=fSeparator + ' ';
  Assert(assigned(WebApp), '(no WebApp)');

  a2 := WebApp.PageID;
  if a2='' then a2:='PageID';

  for i:=ord('a') to ord('z') do  // lowercase for URLs
  begin
    if chr(i)=a0 then
      a3:=fLinkMacro   // option for GO or HIDE on current letter
    else
      a3:='JUMP';      // otherwise we better use JUMP... linking to same page!
    a1:=a1+ MacroStart + a3+'|'+a2+','+chr(i)+ '|itemprop="url"|' +chr(i)+
      MacroEnd + ' ' + fSeparator + ' ';
    if (i<ord('z')) AND ((i-ord('a')+1) mod fNumPerRow = 0) then
      a1:=a1+'<br />' + fSeparator + ' ';
    end;
  fAlphabet:=a1;
  result:=a1;
  CSSend('fAlphabet', fAlphabet);
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TWebnxdbAlphabet.DoExecute;
var
  S: String;
  svName: string;
begin
  inherited DoExecute;
  S := Uppercase(DefaultsTo(Command,HtmlParam));
  if (length(S)=1) and CharInSet(S[1], ['0'..'9','A'..'Z']) then
  begin
    with TnxTable(WebDataSource.Dataset) do
    begin
      FindNearest([S]);
      svName := WebDataSource.Name+'.Keys';
      WebApp.StringVar[svName] := WebDataSource.keys;
    end;
  end;
end;

function TWebnxdbAlphabet.DoUpdate: boolean;
begin
  cx.MakeIfNil(fWebDataSource,TwhbdeSource);
  Result := inherited DoUpdate
    and (WebDataSource.ComponentUpdated)
    and assigned(WebDataSource.DataSet)
    and (WebDataSource.DataSet is TnxTable);
end;

end.




