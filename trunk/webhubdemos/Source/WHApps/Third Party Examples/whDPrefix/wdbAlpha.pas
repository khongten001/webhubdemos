unit wdbAlpha; {TWebDBAlphabet, a web action component for use with WebHub}
{The 2003 version of this file is at http://www.href.com/pub/WebAct/db
}

(*
Copyright (c) 1995-2003 HREF Tools Corp. 

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

//usage in macros:
// %=AZ.alphabet=%   get the alphabet property
// %=AZ.execute=%    locate record

// See the "ABC" demo for an example of this web action component in use
// in a web application written in Borland Delphi.

interface

uses
  Windows, SysUtils, Classes, db, dbTables,
  updateOk, ucString,
  webTypes, webLink, wbdeSource;

type
  TWebDBAlphabet = class(TwhWebAction)
  private
    { Private declarations }
    fWebDataSource: TwhbdeSource;   //where the data comes from
    fNumPerRow:integer;
    fAlphabet:string;
    fLinkMacro:string;
  protected
    { Protected declarations }
    procedure   DoExecute; override;
    function    DoUpdate: Boolean; override;
    function    getAlphabet:string;
    procedure   SetNoString(const Value:String);
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
  end;

//procedure Register;

implementation

uses
  whMacroAffixes;

constructor TWebDBAlphabet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fNumPerRow:=26;
  fLinkMacro:='JUMPR';
end;

destructor TWebDBAlphabet.Destroy;
begin
  inherited Destroy;
end;

procedure TWebDBAlphabet.SetNoString(const Value:String);
begin
end;

procedure TWebDBAlphabet.Notification(AComponent: TComponent; Operation: TOperation);
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

procedure TWebDBAlphabet.SetNumPerRow(Value: Integer);
begin
  fNumPerRow := Value;
  if fNumPerRow < 1 then
    fNumPerRow := 1;
  if fNumPerRow > 26 then
    fNumPerRow := 26;
end;

function TWebDBAlphabet.getAlphabet;
var
  a0,a1,a2,a3: String;
  i:integer;
begin
  a0:=DefaultsTo(Command,HtmlParam);
  a1:='| ';
  if not assigned(WebApp) then
  begin
    result:='(no WebApp)';
    exit;
  end;
  a2:=WebApp.PageID;
  if a2='' then a2:='PageID';

  for i:=ord('A') to ord('Z') do
  begin
    if chr(i)=a0 then
      a3:=fLinkMacro   // option for GO or HIDE on current letter
    else
      a3:='JUMP';      // otherwise we better use JUMP... since we're linking to same page!
    a1:=a1+ MacroStart + a3+'|'+a2+','+chr(i)+'|'+chr(i)+ MacroEnd + ' | ';
    if (i<ord('Z')) AND ((i-ord('A')+1) mod fNumPerRow = 0) then
      a1:=a1+'<br />| ';
    end;
  fAlphabet:=a1;
  result:=a1;
end;

procedure TWebDBAlphabet.DoExecute;
var
  S: String;
begin
  inherited DoExecute;
  S := DefaultsTo(Command,HtmlParam);
  if (length(S)<>1) or (not CharInSet(UpChar(S[1]), ['A'..'Z'])) then
    Exit;

  with TTable(WebDataSource.Dataset) do
  begin
    FindNearest([S]);
    WebApp.StringVar[WebDataSource.Name+'.Keys'] := WebDataSource.keys;
  end;
end;

function TWebDBAlphabet.DoUpdate:Boolean;
begin
  cx.MakeIfNil(fWebDataSource,TwhbdeSource);
  Result := inherited DoUpdate
    and (WebDataSource.ComponentUpdated)
    and assigned(WebDataSource.DataSet)
    and (WebDataSource.DataSet is TTable);
end;

//procedure Register;
//begin
//  RegisterComponents('WebActions', [TWebDBAlphabet]);
//end;

end.




