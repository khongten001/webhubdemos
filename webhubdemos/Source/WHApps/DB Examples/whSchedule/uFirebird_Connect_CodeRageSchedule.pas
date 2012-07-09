//unit uFirebird_Connect_CodeRageSchedule;
unit uFirebird_Connect_CodeRageSchedule;
// project abbreviation: CodeRageSchedule
// generated 08-Jul-2012 23:44
// by Firebird_GenPAS_Connect

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

const
  gUpdatedOnAtFieldname = 'UpdatedOnAt';
  gUpdateCounterFieldname = 'UpdateCounter';

implementation

procedure CreateIfNil(const FullDatabaseName: string;
  const InUsername: string = 'SYSDBA'; const InPassword: string = 'masterkey');
begin
  if gCodeRageSchedule_Conn = nil then
  begin
    gCodeRageSchedule_Conn := TIB_Connection.Create(nil);
    gCodeRageSchedule_Conn.Name := 'gCodeRageSchedule_Conn';
    gCodeRageSchedule_Conn.CharSet := 'UTF8';
    gCodeRageSchedule_Tr := TIB_Transaction.Create(nil);
    gCodeRageSchedule_Tr.Name := 'gCodeRageSchedule_Tr';
    with gCodeRageSchedule_Conn do
    begin
      Database := FullDatabaseName;
      Username := InUsername;
      Password := InPassword;
    end;
    with gCodeRageSchedule_Tr do
    begin
      IB_Connection := gCodeRageSchedule_Conn;
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
  end;

end.

