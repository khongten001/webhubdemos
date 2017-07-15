program GoogleAs;

(*
Permission is hereby granted, on 14-Jul-2017, free of charge, to any person
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

Author: Ann Lynnworth at HREF Tools Corp.
*)

uses
  Forms,
  ZM_CodeSiteInterface in 'H:\ZM_CodeSiteInterface.pas',
  ucShellProcessCntrl in 'k:\webhub\tpack\ucShellProcessCntrl.pas',
  uCode in 'k:\webhub\tpack\uCode.pas',
  System.UITypes,
  ceflib in 'Externals\CEF3\src\ceflib.pas',
  cefgui in 'Externals\CEF3\src\cefgui.pas',
  ceferr in 'Externals\CEF3\src\ceferr.pas',
  cefvcl in 'Externals\CEF3\src\cefvcl.pas',
  GoogleAs_uCEF3_Init in 'GoogleAs_uCEF3_Init.pas',
  GoogleAs_uBookmark in 'GoogleAs_uBookmark.pas',
  GoogleAs_fmChromium in 'GoogleAs_fmChromium.pas' {fmChromiumWrapper};

{$R *.res}

var
  Flag: Boolean;

begin
  InitCEF_GoogleAs(Flag);
  ConditionalStartup(Flag);
end.
