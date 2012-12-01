//unit uFirebird_Connect_Employee;
unit uFirebird_Connect_Employee;
// database engine: Firebird
// project abbreviation: Employee
// generated 01-Dec-2012 01:47
// by IbAndFb_GenPAS_Connect

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
  gUpdatedOnAtFieldname = '';
  gUpdateCounterFieldname = '';

implementation

procedure CreateIfNil(const FullDatabaseName: string;
  const InUsername: string = 'SYSDBA'; const InPassword: string = 'masterkey');
begin
  if gEmployee_Conn = nil then
  begin
    gEmployee_Sess := TIB_Session.Create(nil);
    gEmployee_Sess.Name := 'gEmployee_Sess';

    gEmployee_Conn := TIB_Connection.Create(nil);
    gEmployee_Conn.Name := 'gEmployee_Conn';

    gEmployee_Tr := TIB_Transaction.Create(nil);
    gEmployee_Tr.Name := 'gEmployee_Tr';

    with gEmployee_Conn do
    begin
      Database := FullDatabaseName;
      Username := InUsername;
      Password := InPassword;
      IB_Session := gEmployee_Sess;
      CharSet := 'UTF8';
    end;
    with gEmployee_Tr do
    begin
      IB_Connection := gEmployee_Conn;
      IB_Session := gEmployee_Sess;
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

