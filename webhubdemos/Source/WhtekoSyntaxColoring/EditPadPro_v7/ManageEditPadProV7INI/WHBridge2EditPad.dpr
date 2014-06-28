program WHBridge2EditPad;

(*
commandline
 %TEMPFILE% %SELSTART% %SELSTOP% --line=%LINE%
WHBridge2EditPad.exe --verb=FindDeclaration "--exe=%EPPFILE%"
  --file=%FILE% --col=%COL% --pos=%POS%
  --projectfile=%PROJECTFILE% "--linetext=%LINETEXT%"
  "--word=%WORD%"

WHBridge2EditPad.exe --verb=FindDeclaration "--exe=%EPPFILE%" --projectfile=%PROJECTFILE% --pos=%POS% "--linetext=%LINETEXT%" --col=%COL% "--word=%WORD%"

WHBridge2EditPad.exe --verb=PopBookmark "--exe=%EPPFILE%"

*)

uses
  EMemLeaks,
  FMX.Forms, FMX.Dialogs,
  ucCodeSiteInterface,
  uCode,
  WHBridge2EditPad_fmMain in 'WHBridge2EditPad_fmMain.pas' {Form3},
  WHBridge2EditPad_uIni in 'WHBridge2EditPad_uIni.pas',
  WHBridge2EditPad_uRegex in 'WHBridge2EditPad_uRegex.pas',
  WHBridge2EditPad_uBookmark in 'WHBridge2EditPad_uBookmark.pas';

{$R *.res}

var
  ErrorText: string;
  AFilespec, APosition: string;

begin
  Application.Initialize;

  CSSend('verb', ParamString('-verb'));

  if ParamString('-verb') = 'FindDeclaration' then
  begin
    WrapFindInFiles(ErrorText);

    if ErrorText <> '' then
    begin
      CSSendError(ErrorText);
      ShowMessage(ErrorText);
    end;
  end
  else
  if ParamString('-verb') = 'PopBookmark' then
  begin
    if StackPopLocation(AFilespec, APosition) then
      LaunchEPPAgainst(AFilespec, APosition)
    else
    begin
      ErrorText := 'No saved bookmark locations to pop back to.';
      CSSendError(ErrorText);
      ShowMessage(ErrorText);
    end;
  end;
end.
