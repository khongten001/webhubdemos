unit CharReplace_fmTest;
(*
Copyright (c) 2003 HREF Tools Corp.
Author: Ann Lynnworth

Permission is hereby granted, on 22-Aug-2003, free of charge, to any person
obtaining a copy of this file (the "Software"), to deal in the Software
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

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFormTest = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    EditInputFile: TEdit;
    Label1: TLabel;
    EditFrom: TEdit;
    EditTo: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    EditOutputFile: TEdit;
    Label4: TLabel;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTest: TFormTest;

implementation

uses CharReplace_uProcess, ucLogFil;

{$R *.dfm}

procedure TFormTest.BitBtn1Click(Sender: TObject);
begin
  if ProcessFile(EditInputFile.Text, EditOutputFile.Text, EditFrom.Text[1],
    EditTo.Text[1]) then
    ShowMessage(StringLoadFromFile(EditOutputFile.Text))
  else
    ShowMessage('Input file not found.');
end;

end.
