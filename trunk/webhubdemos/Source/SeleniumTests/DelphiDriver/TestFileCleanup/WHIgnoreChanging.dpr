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
  AdminSessionID: string;

begin
  AdminSessionID := '12345';
  if (ParamCount >= 1) then
  begin
    BaseFolder := ParamStr(1);
    if ParamCount >= 2 then
    begin
      FilterSpec := ParamStr(2);
      if ParamCount = 3 then
        AdminSessionID := ParamStr(3);
    end
    else
      FilterSpec := 'test*.txt';

    if TDirectory.Exists(BaseFolder) then
    begin
      RegExInit(AdminSessionID);
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
     'plus optionally the filespec plus optionally the separator plus ' +
     'AdminSessionID.');
    Writeln('Example: WHIgnoreChanging.exe .\test1\ test*.txt :12345');
    Writeln('Example: WHIgnoreChanging.exe .\test2\ a*.txt /1204');
  end;
end.
