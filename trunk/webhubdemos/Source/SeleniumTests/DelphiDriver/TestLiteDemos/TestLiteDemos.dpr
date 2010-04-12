program TestLiteDemos;

uses
  Forms,
  TestLiteDemos_fmMain in 'TestLiteDemos_fmMain.pas' {Form1},
  uDefaultRemoteCommand in '..\uDefaultRemoteCommand.pas',
  uDefaultSelenium in '..\uDefaultSelenium.pas',
  uHttpCommandProcessor in '..\uHttpCommandProcessor.pas',
  uICommandProcessor in '..\uICommandProcessor.pas',
  uIRemoteCommand in '..\uIRemoteCommand.pas',
  uISelenium in '..\uISelenium.pas',
  uSeleniumException in '..\uSeleniumException.pas',
  uCommon in '..\uCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
