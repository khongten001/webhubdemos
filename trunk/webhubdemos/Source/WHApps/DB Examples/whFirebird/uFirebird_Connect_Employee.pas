unit uFirebird_Connect_Employee;
// project abbreviation: Employee
// see Firebird_GenPAS_Connect

interface 

{$INCLUDE IB_Directives.inc}

uses
  IB_Components,
  Classes, SysUtils;

procedure CreateIfNil(const FullDatabaseName: string;
  const InUsername: string = 'SYSDBA'; const InPassword: string = 'masterkey');

var
  gEmployee_Conn: TIB_Connection = nil;
  gEmployee_Tr: TIB_Transaction = nil;
  gEmployee_Sess: TIB_Session = nil;

const
  gUpdatedOnAtFieldname = 'UpdatedOnAt';
  gUpdateCounterFieldname = 'UpdateCounter';

implementation

procedure CreateIfNil(const FullDatabaseName: string;
  const InUsername: string = 'SYSDBA'; const InPassword: string = 'masterkey');
begin
  if gEmployee_Conn = nil then
  begin
    gEmployee_Conn := TIB_Connection.Create(nil);
    gEmployee_Conn.Name := 'gEmployee_Conn';
    gEmployee_Conn.CharSet := 'UTF8';
    gEmployee_Tr := TIB_Transaction.Create(nil);
    gEmployee_Tr.Name := 'gEmployee_Tr';
    gEmployee_Sess := TIB_Session.Create(nil);
    gEmployee_Sess.Name := 'gEmployee_Sess';
    with gEmployee_Conn do
    begin
      Database := FullDatabaseName;
      Username := InUsername;
      Password := InPassword;
    end;
    with gEmployee_Tr do
    begin
      IB_Connection := gEmployee_Conn;
      Isolation := tiCommitted; // note the default is tiConcurrency
    end;
  end;
end;

initialization
finalization
  if Assigned(gEmployee_Conn) then
  begin
    gEmployee_Conn.Disconnect;
    FreeAndNil(gEmployee_Tr);
    FreeAndNil(gEmployee_Conn);
    FreeAndNil(gEmployee_Sess);
  end;

end.