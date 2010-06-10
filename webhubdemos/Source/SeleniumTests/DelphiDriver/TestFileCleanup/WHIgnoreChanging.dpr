program WHIgnoreChanging;

uses
  Forms,
  IOUtils,
  Classes,
  SysUtils,
  ucPos in 'k:\webhub\tpack\ucPos.pas',
  ucVers,
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

begin
  if (ParamCount >= 1) then
  begin
    BaseFolder := ParamStr(1);
    if ParamCount = 2 then
      FilterSpec := ParamStr(2)
    else
      FilterSpec := 'test*.txt';

    if TDirectory.Exists(BaseFolder) then
    begin
      for Filespec in TDirectory.GetFiles(BaseFolder, FilterSpec) do
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
    Writeln('WHIgnoreChanging v' + GetVersionDigits(False));
    Writeln('Open Source; Creative Commons License');
    Writeln('Copyright (c) 2010 HREF Tools Corp.');
    Writeln('');

    Writeln('usage: pass in the name of the folder containing files to clean ' +
     'plus optionally the filespec');
    Writeln('Example: WHIgnoreChanging.exe .\test1\ test*.txt');
  end;
end.
