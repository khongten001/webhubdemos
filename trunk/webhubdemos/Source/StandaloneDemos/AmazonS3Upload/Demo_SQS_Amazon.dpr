program Demo_SQS_Amazon;

uses
  Vcl.Forms,
  fmSQSread in 'fmSQSread.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
