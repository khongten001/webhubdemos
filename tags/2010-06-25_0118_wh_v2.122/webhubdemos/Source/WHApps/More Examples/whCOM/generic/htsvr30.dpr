program htsvr30;

uses
  Forms,
  htSvrFrm in 'htSvrFrm.pas' {ServerForm},
  htSv_TLB in 'htSv_TLB.pas',
  htSv_imp in 'htSv_imp.pas' {htSvr: CoClass},
  htsvr30_TLB in 'htsvr30_TLB.pas';

{$R *.TLB}

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
