program WHBridge2EditPad;

(*
commandline
 %TEMPFILE% %SELSTART% %SELSTOP% --line=%LINE%
WHBridge2EditPad.exe --verb=FindDeclaration "--exe=%EPPFILE%"
  --file=%FILE% --col=%COL% --pos=%POS%
  --projectfile=%PROJECTFILE% "--linetext=%LINETEXT%"
  "--word=%WORD%"

WHBridge2EditPad.exe --verb=FindDeclaration "--exe=%EPPFILE%" --projectfile=%PROJECTFILE% --pos=%POS% "--linetext=%LINETEXT%" --col=%COL% "--word=%WORD%"
*)

uses
  FMX.Forms,
  ucCodeSiteInterface,
  uCode,
  WHBridge2EditPad_fmMain in 'WHBridge2EditPad_fmMain.pas' {Form3},
  WHBridge2EditPad_uIni in 'WHBridge2EditPad_uIni.pas',
  WHBridge2EditPad_uRegex in 'WHBridge2EditPad_uRegex.pas';

{$R *.res}

var
  ErrorText: string;

begin
  Application.Initialize;

  CSSend('verb', ParamString('-verb'));

  if ParamString('-verb') = 'FindDeclaration' then
  begin
    WrapFindInFiles(ErrorText);

    if ErrorText <> '' then
    begin
      CSSendNote('"' + ErrorText + '"');
      Application.CreateForm(TForm3, Form3);
      Application.Run;
    end;
  end;

end.
