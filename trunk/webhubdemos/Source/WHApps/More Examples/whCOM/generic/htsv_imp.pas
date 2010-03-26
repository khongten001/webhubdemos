unit htsv_imp;

interface

uses
  ComObj, ActiveX, htSv_TLB;

type
  ThtSvr = class(TAutoObject, IhtSv)
  protected
    procedure AddParam(Value: OleVariant); safecall;
    procedure Reset; safecall;
    function Get_ResultText: OleVariant; safecall;
    procedure Execute; safecall;
  end;

implementation

uses ComServ, htSvrFrm;

procedure ThtSvr.AddParam(Value: OleVariant);
begin
  ServerForm.AddParam(Value);
end;

procedure ThtSvr.Reset;
begin
  ServerForm.Reset;
end;

function ThtSvr.Get_ResultText: OleVariant;
begin
  Result:=ServerForm.ResultText;
end;

procedure ThtSvr.Execute;
begin
  ServerForm.Execute;
end;

initialization
  TAutoObjectFactory.Create(ComServer, ThtSvr, Class_htSvr, ciMultiInstance);
end.

