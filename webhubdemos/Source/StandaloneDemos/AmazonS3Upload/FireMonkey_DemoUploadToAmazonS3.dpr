program FireMonkey_DemoUploadToAmazonS3;

uses
  System.StartUpCopy,
  FMX.Forms,
  firemonkeyMain in 'firemonkeyMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
