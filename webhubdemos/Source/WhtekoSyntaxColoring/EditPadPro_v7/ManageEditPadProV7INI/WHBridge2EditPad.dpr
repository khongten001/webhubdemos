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

WHBridge2EditPad.exe --verb=ExprHelp "--word=%WORD%"

*)

{$R *.dres}   // some resources are available only at HREF Tools. IFDEF INHOUSE.

uses
  FMX.Forms,
  FMX.Dialogs,
  ZM_CodeSiteInterface,
  uCode,
  ucVers,
  SysUtils,
  WHBridge2EditPad_fmMain in 'WHBridge2EditPad_fmMain.pas' {Form3},
  WHBridge2EditPad_uIni in 'WHBridge2EditPad_uIni.pas',
  WHBridge2EditPad_uRegex in 'WHBridge2EditPad_uRegex.pas',
  {$IFDEF INHOUSE}
  WHBridge2EditPad_fmWHExprHelp in 'WHBridge2EditPad_fmWHExprHelp.pas' {fmWebHubExpressionHelp},
  WHBridge2EditPad_uLoadWHCommands in 'WHBridge2EditPad_uLoadWHCommands.pas',
  {$ENDIF }
  WHBridge2EditPad_uBookmark in 'WHBridge2EditPad_uBookmark.pas',
  WebHubDWSourceUtil_uGlobal in 'P:\KompProd\Pak\WebHubP\WHDocs\WHCommandDocs\Source\WebHubDWSourceUtil_uGlobal.pas',
  WebHubDWSourceUtil_uSyntaxRegex in 'P:\KompProd\Pak\WebHubP\WHDocs\WHCommandDocs\Source\WebHubDWSourceUtil_uSyntaxRegex.pas',
  WHBridge2EditPad_uExpressionReplacement in 'WHBridge2EditPad_uExpressionReplacement.pas',
  whBridge2EditPad_fmSelectFilespec in 'whBridge2EditPad_fmSelectFilespec.pas' {Form4},
  WHBridge2EditPad_uSearchDir in 'WHBridge2EditPad_uSearchDir.pas';

{$R *.res}

var
  ErrorText: string;
  AFilespec, APosition: string;

procedure ShowError;
begin
  ShowMessage('WHBridge2EditPad v' + GetVersionDigits(False) +
    sLineBreak + sLineBreak +
    ErrorText);
end;

begin
  Application.Initialize;

  CSSend('version', ucVers.GetVersionDigits(False));
  CSSend('verb', ParamString('-verb'));

  if ParamString('-verb') = 'FindDeclaration' then
  begin
    WrapFindInFiles(ErrorText);

    if ErrorText <> '' then
    begin
      CSSendParams;
      CSSendError(ErrorText);
      ShowError;
    end;
  end
  else
  if ParamString('-verb') = 'PopBookmark' then
  begin
    if StackPopLocation(AFilespec, APosition) then
      LaunchEPPAgainst(AFilespec, APosition)
    else
    begin
      CSSendParams;
      ErrorText := 'No saved bookmark locations to pop back to.';
      CSSendError(ErrorText);
      ShowError;
    end;
  end
  else
  if ParamString('-verb') = 'FileOpen' then
  begin
    Application.CreateForm(TForm4, Form4);  // FMX different from Vcl !
    Application.Run;
  end
  else
  if ParamString('-verb') = 'FindJSFunction' then
  begin
    WrapFindJavascriptFunctionInFiles(ErrorText);
    if ErrorText <> '' then
    begin
      CSSendParams;
      CSSendError(ErrorText);
      ShowError;
    end;
  end
  {$IFDEF INHOUSE}
  else
  if ParamString('-verb') = 'ExprHelp' then
  begin
    Application.CreateForm(TfmWebHubExpressionHelp, fmWebHubExpressionHelp);
  Application.Run;
  end
  {$ENDIF}
  else
  if ParamString('-verb') = 'ClearBookmarks' then
  begin
    if FileExists(WHBridgeDataFilespec) then
      DeleteFile(WHBridgeDataFilespec);
  end;
  ;

end.
