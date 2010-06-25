program memosvr;

uses
  Forms,
  fmMemoSv in 'fmMemoSv.pas' {Form1},
  Memo_TLB in 'Memo_TLB.pas',
  TMemoSv in 'TMemoSv.pas' {TMemoServer: CoClass};

{$R *.RES}

{$R *.TLB}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
