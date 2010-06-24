program WHIgnoreChanging;
(*
Copyright (c) 2010 HREF Tools Corp.

Permission is hereby granted, on 14-Jun-2010, free of charge, to any person
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

Author of original version of this file: Ann Lynnworth

Requires: Delphi 2010+
*)

{$APPTYPE CONSOLE}

uses
  MultiTypeApp,
  ConApp,
  IOUtils,
  Classes,
  SysUtils,
  ucPos in 'k:\webhub\tpack\ucPos.pas',
  ucVers,
  uCode,
  ucString in 'k:\webhub\tpack\ucString.pas',
  ucLogFil in 'k:\webhub\tpack\ucLogFil.pas',
  uSeleniumIgnoreChanging in '..\uSeleniumIgnoreChanging.pas';

{$R *.res}

var
  Filespec : string;
  BaseFolder: string;
  A: AnsiString;
  S8Before, S8After: UTF8String;
  FilterSpec: string;
  AdminSessionID: string;
  LSearchOption: TSearchOption;

begin

  Writeln('WHIgnoreChanging v' + GetVersionDigits(False));
  Writeln('Open Source; Creative Commons License');
  Writeln('Copyright (c) 2010 HREF Tools Corp.');
  Writeln('');

  AdminSessionID := '12345';

  {References:
   http://docwiki.embarcadero.com/CodeSamples/en/DirectoriesAndFilesEnumeraion_(Delphi)
   http://www.malcolmgroves.com/blog/?p=447
  }

  LSearchOption := TSearchOption.soTopDirectoryOnly;
  if (ParamCount >= 1) then
  begin
    BaseFolder := ParamStr(1);
    if ParamCount >= 2 then
    begin
      FilterSpec := ParamStr(2);
      if ParamCount >= 3 then
      begin
        AdminSessionID := ParamStr(3);
        if HaveParam('/s') then
          LSearchOption := TSearchOption.soAllDirectories;
      end;
    end
    else
      FilterSpec := 'test*.txt';

    if TDirectory.Exists(BaseFolder) then
    begin
      RegExInit(AdminSessionID);
      for Filespec in TDirectory.GetFiles(BaseFolder, FilterSpec, LSearchOption) do
      begin
        Writeln(Filespec);
        S8Before := UTF8StringLoadFromFile(Filespec);
        S8After := StripChanging(S8Before);
        if (S8Before <> S8After) then
          UTF8StringWriteToFile(Filespec, S8After);
        //if Counter > 5 then break;
      end;
    end
    else
      writeln(Format('Directory [%s] does not exist.', [BaseFolder]));
  end
  else
  begin
    Writeln('usage: pass in the name of the folder containing files to clean ' +
     'plus optionally the filespec plus optionally the separator plus ' +
     'AdminSessionID; finally optionally /s for recurse subdirs.');
    Writeln('Example: WHIgnoreChanging.exe .\test1\ test*.txt :12345 /s');
    Writeln('Example: WHIgnoreChanging.exe .\test2\ a*.txt /1204 /s');
  end;
end.
