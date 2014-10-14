program DPrefix_Client;

uses
  System.StartUpCopy,
  FMX.Forms,
  DPrefix_Client_uMain in 'DPrefix_Client_uMain.pas' {WebBrowserForm},
  ucHttps in 'K:\WebHub\tpack\ucHttps.pas',
  DPrefix_Client_uInitialize in 'DPrefix_Client_uInitialize.pas',
  ucJSONWrapper in 'K:\WebHub\tpack\ucJSONWrapper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TWebBrowserForm, WebBrowserForm);
  Application.Run;
end.
