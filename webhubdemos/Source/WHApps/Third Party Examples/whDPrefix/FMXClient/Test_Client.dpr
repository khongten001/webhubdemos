program Test_Client;

uses
  System.StartUpCopy,
  FMX.Forms,
  Test_Client_fmMain in 'Test_Client_fmMain.pas' {Form1},
  DPrefix_Client_uInitialize in 'DPrefix_Client_uInitialize.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
