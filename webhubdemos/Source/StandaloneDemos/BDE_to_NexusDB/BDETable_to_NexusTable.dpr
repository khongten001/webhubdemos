program BDETable_to_NexusTable;

uses
  Vcl.Forms,
  tpTable in 'k:\webhub\tpack\tpTable.pas',
  BDETable_to_NexusTable_fmMain in 'BDETable_to_NexusTable_fmMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
