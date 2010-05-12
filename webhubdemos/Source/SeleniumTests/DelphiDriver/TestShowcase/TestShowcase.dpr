program TestShowcase;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  uDefaultSelenium_1_0_3 in '..\uDefaultSelenium_1_0_3.pas',
  uISelenium_1_0_3 in '..\uISelenium_1_0_3.pas',
  uICommandProcessor_1_0_3 in '..\uICommandProcessor_1_0_3.pas',
  uHttpCommandProcessor_1_0_3 in '..\uHttpCommandProcessor_1_0_3.pas',
  uDefaultRemoteCommand_1_0_3 in '..\uDefaultRemoteCommand_1_0_3.pas',
  uIRemoteCommand_1_0_3 in '..\uIRemoteCommand_1_0_3.pas',
  uCommon in '..\uCommon.pas',
  uSeleniumShared in '..\uSeleniumShared.pas',
  uSeleniumIgnoreChanging in '..\uSeleniumIgnoreChanging.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
