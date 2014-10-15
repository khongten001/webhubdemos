program DPrefix_Client;

uses
  System.StartUpCopy,
  System.ByteStrings,
  FMX.Forms,
  DPrefix_Client_uMain in 'DPrefix_Client_uMain.pas' {WebBrowserForm},
  ucHttps in 'K:\WebHub\tpack\ucHttps.pas',
  DPrefix_Client_uInitialize in 'DPrefix_Client_uInitialize.pas';

{$R *.res}

(*
  {$IFNDEF FMACTIVE}
  ucJSONWrapper in 'K:\WebHub\tpack\ucJSONWrapper.pas',
  {$ENDIF}
{$IFDEF FMACTIVE}
  // This patch makes AnsiString etc available for use in FireMonkey apps.
  // http://andy.jgknet.de/blog/2014/09/system-bytestrings-support-for-xe7/
  System.ByteStrings,
{$ENDIF}
*)

var
  ErrorText: string = '';
  s8: UTF8String = '';

begin
  Application.Initialize;
  if ErrorText = '' then
  begin
    Application.CreateForm(TWebBrowserForm, WebBrowserForm);
    Application.Run;
  end;
end.
