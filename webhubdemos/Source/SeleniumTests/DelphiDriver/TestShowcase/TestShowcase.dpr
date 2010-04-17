program TestShowcase;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  uDefaultSelenium in '..\uDefaultSelenium.pas',
  uISelenium in '..\uISelenium.pas',
  uCommon in '..\uCommon.pas',
  uICommandProcessor in '..\uICommandProcessor.pas',
  uHttpCommandProcessor in '..\uHttpCommandProcessor.pas',
  uDefaultRemoteCommand in '..\uDefaultRemoteCommand.pas',
  uIRemoteCommand in '..\uIRemoteCommand.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
