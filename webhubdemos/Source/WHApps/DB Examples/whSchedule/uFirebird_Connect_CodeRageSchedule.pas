//unit uFirebird_Connect_CodeRageSchedule;
unit uFirebird_Connect_CodeRageSchedule;
// database engine: Firebird
// project abbreviation: CodeRageSchedule
// generated 01-Dec-2012 02:06
// by IbAndFb_GenPAS_Connect

interface 

{$INCLUDE IB_Directives.inc}

uses
  IB_Components,
  Classes, SysUtils;

procedure CreateIfNil(const FullDatabaseName: string;
  const InUsername: string = 'SYSDBA'; const InPassword: string = 'masterkey');

var
  gCodeRageSchedule_Conn: TIB_Connection = nil;
  gCodeRageSchedule_Tr: TIB_Transaction = nil;
  gCodeRageSchedule_Sess: TIB_Session = nil;

const
  gUpdatedOnAtFieldname = 'UpdatedOnAt';
  gUpdateCounterFieldname = 'UpdateCounter';

implementation

procedure CreateIfNil(const FullDatabaseName: string;
  const InUsername: string = 'SYSDBA'; const InPassword: string = 'masterkey');
begin
  if gCodeRageSchedule_Conn = nil then
  begin
    gCodeRageSchedule_Sess := TIB_Session.Create(nil);
    gCodeRageSchedule_Sess.Name := 'gCodeRageSchedule_Sess';
    gCodeRageSchedule_Conn := TIB_Connection.Create(nil);
    gCodeRageSchedule_Conn.Name := 'gCodeRageSchedule_Conn';
    gCodeRageSchedule_Tr := TIB_Transaction.Create(nil);
    gCodeRageSchedule_Tr.Name := 'gCodeRageSchedule_Tr';
    with gCodeRageSchedule_Conn do
    begin
      IB_Session := gCodeRageSchedule_Sess;
      Database := FullDatabaseName;
      Username := InUsername;
      Password := InPassword;
      CharSet := 'UTF8';
    end;
    with gCodeRageSchedule_Tr do
    begin
      IB_Connection := gCodeRageSchedule_Conn;
      IB_Session := gCodeRageSchedule_Sess;
      Isolation := tiCommitted; // note the default is tiConcurrency
    end;
  end;
end;

initialization
finalization
  if Assigned(gCodeRageSchedule_Conn) then
  begin
    gCodeRageSchedule_Conn.Disconnect;
    FreeAndNil(gCodeRageSchedule_Tr);
    FreeAndNil(gCodeRageSchedule_Conn);
    FreeAndNil(gCodeRageSchedule_Sess);
  end;

end.

