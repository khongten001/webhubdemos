unit wnxdbAlpha; { TWebnxdbAlphabet, a WebHub action component }

{ The 2003 BDE version of this component is archived at
  http://www.href.com/pub/WebAct/db }

(*
  Copyright (c) 1995-2017 HREF Tools Corp.

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

// usage in whteko:
// AZ.alphabet   get the alphabet property
// AZ.execute    save selected letter to AZ.ActiveChar; GotoNearest

interface

uses
  SysUtils, Classes,
  updateOk, ucString,
  webTypes, webLink, wdbSSrc, wdbSource;

type
  TWebnxdbAlphabet = class(TwhWebAction)
  private
    { Private declarations }
    fWebDataSource: TwhdbSource; // where the data comes from
    fNumPerRow: integer;
    fAlphabet: string;
    fLinkMacro: string;
    fSeparator: string;
    FActiveChar: char;
  protected
    { Protected declarations }
    procedure DoExecute; override;
    function DoUpdate: boolean; override;
    function getAlphabet: string;
    procedure SetNoString(const Value: string);
    procedure SetNumPerRow(Value: integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    property ActiveChar: char read FActiveChar write FActiveChar;
  published
    { Published declarations }
    property NumPerRow: integer read fNumPerRow write SetNumPerRow;
    property WebDataSource: TwhdbSource read fWebDataSource
      write fWebDataSource;
    property Alphabet: string read getAlphabet write SetNoString stored False;
    property LinkMacro: string read fLinkMacro write fLinkMacro;
    property Separator: string read fSeparator write fSeparator;
  end;

implementation

uses
  nxdb, // TnxTable
  ZM_CodeSiteInterface,
  whMacroAffixes;

constructor TWebnxdbAlphabet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fNumPerRow := 26;
  fLinkMacro := 'JUMPR';
  fSeparator := #$2758; // light vertical bar
  FActiveChar := 'A';
end;

destructor TWebnxdbAlphabet.Destroy;
begin
  inherited Destroy;
end;

procedure TWebnxdbAlphabet.SetNoString(const Value: string);
begin
end;

procedure TWebnxdbAlphabet.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (csUpdating in ComponentState) then
    exit;
  if Operation = opRemove then
    cx.NilIfSet(fWebDataSource, AComponent)
  else if (AComponent is TwhdbSource) then
  begin
    if NOT Assigned(fWebDataSource) then
      TComponent(fWebDataSource) := AComponent;
  end;
end;

procedure TWebnxdbAlphabet.SetNumPerRow(Value: integer);
begin
  fNumPerRow := Value;
  if fNumPerRow < 1 then
    fNumPerRow := 1;
  if fNumPerRow > 26 then
    fNumPerRow := 26;
end;

function TWebnxdbAlphabet.getAlphabet;
const
  cFn = 'getAlphabet';
var
  a0, a1, a2, a3: String;
  i: integer;
begin
CSEnterMethod(Self, cFn);
  a0 := DefaultsTo(Command, HtmlParam);
  a1 := fSeparator + ' ';
  Assert(Assigned(WebApp), '(no WebApp)');

  a2 := WebApp.PageID;
  if a2 = '' then
    a2 := 'PageID';

  for i := ord('a') to ord('z') do // lowercase for URLs
  begin
    if chr(i) = a0 then
      a3 := fLinkMacro // option for GO or HIDE on current letter
    else
      a3 := 'JUMP'; // otherwise we better use JUMP... linking to same page!
    a1 := a1 + MacroStart + a3 + '|' + a2 + ',' + chr(i) + '|itemprop="url"|' +
      chr(i) + MacroEnd + ' ' + fSeparator + ' ';
    if (i < ord('z')) AND ((i - ord('a') + 1) mod fNumPerRow = 0) then
      a1 := a1 + '<br />' + fSeparator + ' ';
  end;
  fAlphabet := a1;
  result := a1;
  CSSend('fAlphabet', fAlphabet);
CSExitMethod(Self, cFn);
end;

procedure TWebnxdbAlphabet.DoExecute;
const
  cFn = 'DoExecute';
var
  S1: String;
  svName: string;
begin
  CSEnterMethod(Self, cFn);
  inherited DoExecute;
  CSSend('Command', Command);
  CSSend('HtmlParam', HtmlParam);
  S1 := Uppercase(DefaultsTo(Command, HtmlParam));
  if (length(S1) = 1) and CharInSet(S1[1], ['0' .. '9', 'A' .. 'Z']) then
  begin
    FActiveChar := S1[1];
    CSSend('FActiveChar', FActiveChar);
    if Assigned(WebDataSource) then
    begin
      with TnxTable(WebDataSource.Dataset) do
      begin
        CSSend('about to call FindNearest');
        FindNearest([S1]);
        svName := WebDataSource.Name + '.Keys';
        WebApp.StringVar[svName] := WebDataSource.keys;
	      CSSend('stringvar ' + svName, WebDataSource.keys);
      end;
    end
    else
    begin
      CSSend('webdatasource nil'); // this is a reasonable situation
    end;
  end;
CSExitMethod(Self, cFn);
end;

function TWebnxdbAlphabet.DoUpdate: boolean;
begin
  result := inherited DoUpdate;
end;

end.
