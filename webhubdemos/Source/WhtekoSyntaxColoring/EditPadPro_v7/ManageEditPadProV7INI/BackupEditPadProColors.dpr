program BackupEditPadProColors;

// compiler defines: -DPREVENTSVCMGR;FMACTIVE

uses
  EMemLeaks,
  FMX.Forms,
  BackupEditPadProColors_fmMain in 'BackupEditPadProColors_fmMain.pas' {Form1},
  BackupEditPadProColors_uHREFTools_Inhouse in 'BackupEditPadProColors_uHREFTools_Inhouse.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
