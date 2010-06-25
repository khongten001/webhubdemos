unit htdropdm;
(*
Copyright (c) 1999 HREF Tools Corp.

Permission is hereby granted, on 04-Jun-2004, free of charge, to any person
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UpdateOk, tpAction, WebTypes,   WebLink, WebDrop;

type
  TDMDrop = class(TDataModule)
    DropDown1: TwhDropDown;
    DropDown2: TwhDropDown;
    DropDown3: TwhDropDown;
    DropDown4: TwhDropDown;
    DropDown5: TwhDropDown;
    DropDown6: TwhDropDown;
    DropDown7: TwhDropDown;
    DropDown8: TwhDropDown;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure htWebAppNewSession(Sender: TObject; InSessionNumber: Cardinal;
      const Command: String);
  end;

var
  DMDrop: TDMDrop;

implementation

{$R *.DFM}

uses
  webapp;  // unit containing the global pWebApp pointer.

procedure TDMDrop.htWebAppNewSession(Sender: TObject;
  InSessionNumber: Cardinal; const Command: String);
begin
  inherited;
  // Program the OnNewSession event to set a default value for the TwhDropDown component.
  // By using this event you can set a different default for each surfer (based on
  // some rules in your system - not shown here.)
  if InSessionNumber <> 0 then
  begin
    // Drop Down #8 defaults to 'c'
    pWebApp.StringVar['DropDown8.Value'] := 'c';

//    DropDown8.value:='c';  //Could be a formula that pulls the default from a database or other calculation
      // where the end result varies based on some information known about the surfer.
      // hypothetically speaking...
    end;
end;

end.
