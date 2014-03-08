program Test_Indy_Smtp;

(*
Copyright (c) 2013-2014 HREF Tools Corp.

Permission is hereby granted, on 29-Dec-2013, free of charge, to any person
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

{$I hrefdefines.inc}

uses
  ucCodeSiteInterface,
  Vcl.Forms,
  {$IFDEF Delphi19UP}
  Vcl.Themes,
  Vcl.Styles,
  {$ENDIF}
  fmIndyEMailSSL in 'fmIndyEMailSSL.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  {$IFDEF Delphi19UP}
  TStyleManager.TrySetStyle('Ruby Graphite');
  {$ENDIF}
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
