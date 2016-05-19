program DemoCleanupFilesAmazonS3;

uses
  Vcl.Forms,
  fmS3FileCleanup in 'fmS3FileCleanup.pas' {Form3},
  ucString in 'k:\webhub\tpack\ucString.pas',
  uAWS_S3 in 'uAWS_S3.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
