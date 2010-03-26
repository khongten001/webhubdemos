unit cntri;

interface

uses
  ComObj, ActiveX, Cntr_TLB;

type
  ThtComServer = class(TAutoObject, IhtComServer)
  protected
    function Get_ResultText: OleVariant; safecall;
    procedure AddParam(Value: OleVariant); safecall;
    procedure Execute; safecall;
    procedure Reset; safecall;
  end;

implementation

uses ComServ, CntrF;

function ThtComServer.Get_ResultText: OleVariant;
begin
  Result:=ServerForm.ResultText;
end;

procedure ThtComServer.AddParam(Value: OleVariant);
begin
  ServerForm.AddParam(Value);
end;

procedure ThtComServer.Execute;
begin
  ServerForm.Execute;
end;

procedure ThtComServer.Reset;
begin
  ServerForm.Reset;
end;

initialization
  TAutoObjectFactory.Create(ComServer, ThtComServer, Class_htComServer, ciMultiInstance);
end.
