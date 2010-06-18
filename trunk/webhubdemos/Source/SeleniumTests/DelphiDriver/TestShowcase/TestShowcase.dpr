program TestShowcase;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  uDefaultSelenium in '..\uDefaultSelenium.pas',
  uISelenium in '..\uISelenium.pas',
  uICommandProcessor in '..\uICommandProcessor.pas',
  uHttpCommandProcessor in '..\uHttpCommandProcessor.pas',
  uDefaultRemoteCommand in '..\uDefaultRemoteCommand.pas',
  uIRemoteCommand in '..\uIRemoteCommand.pas',
  uCommon in '..\uCommon.pas',
  uSeleniumShared in '..\uSeleniumShared.pas',
  uSeleniumIgnoreChanging in '..\uSeleniumIgnoreChanging.pas',
  uPerformanceTest in 'uPerformanceTest.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
