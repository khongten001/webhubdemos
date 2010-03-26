program cntr;

uses
  Forms,
  CntrF in 'CntrF.pas' {ServerForm},
  Cntr_TLB in 'Cntr_TLB.pas',
  CntrI in 'CntrI.pas' {htComServer: CoClass};

{$R *.TLB}

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
