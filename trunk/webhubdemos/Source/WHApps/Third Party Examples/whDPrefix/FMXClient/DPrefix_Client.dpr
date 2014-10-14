program DPrefix_Client;

uses
  System.StartUpCopy,
  FMX.Forms,
  DPrefix_Client_uMain in 'DPrefix_Client_uMain.pas' {WebBrowserForm},
  ucHttps in 'K:\WebHub\tpack\ucHttps.pas',
  DPrefix_Client_uInitialize in 'DPrefix_Client_uInitialize.pas';

{$R *.res}

(*
  {$IFNDEF FMACTIVE}
  ucJSONWrapper in 'K:\WebHub\tpack\ucJSONWrapper.pas',
  {$ENDIF}
*)

var
  ErrorText: string = '';

begin
  Application.Initialize;
  if ErrorText = '' then
  begin
    Application.CreateForm(TWebBrowserForm, WebBrowserForm);
    Application.Run;
  end;
end.
