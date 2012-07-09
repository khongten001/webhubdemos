//unit uFillClientDataSets_CodeRageSchedule;
unit uFillClientDataSets_CodeRageSchedule;
// project abbreviation: CodeRageSchedule
// generated 09-Jul-2012 00:03
// by Firebird_GenPAS_FillClientDatasets in TPack, maintained by HREF Tools Corp.

{$INCLUDE IB_Directives.inc}

interface 

uses
  DB, DBClient;

procedure FillCDS_for_SCHEDULE(var table : TClientDataset);
procedure FillCDS_for_ABOUT(var table : TClientDataset);
procedure FillCDS_for_XPRODUCT(var table : TClientDataset);

implementation

uses
  SysUtils,
  IB_Components, IB_Access,
  MultiTypeApp, uStructureClientDataSets_CodeRageSchedule,
  uFirebird_Connect_CodeRageSchedule;

procedure FillCDS_for_SCHEDULE(var table : TClientDataset);
var
  q: TIB_Query;
  FlagWasConnected: Boolean;
begin
  q := nil;

  Assert(Assigned(table), 'table nil');
  Assert(Assigned(gCodeRageSchedule_Conn), 'gCodeRageSchedule_Conn');
  try
    q := TIB_Query.Create(nil);
    q.Name := 'qSCHEDULE';
    q.SQL.Text := 'select * from SCHEDULE ' +
    'order by SCHID';
    q.IB_Connection := gCodeRageSchedule_Conn;
    q.IB_Transaction := gCodeRageSchedule_Tr;
    FlagWasConnected := gCodeRageSchedule_Conn.Connected;
    if NOT FlagWasConnected then gCodeRageSchedule_Conn.Connect;
    q.Open;
    q.First;
    while not q.EOF do
    begin
      table.Append;
      table.FieldByName('SCHID').AsInteger := q.FieldByName('SCHID').AsInteger;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHTITLE').AsString := q.FieldByName('SCHTITLE').AsString;
      table.FieldByName('SCHONATPDT').AsDateTime := q.FieldByName('SCHONATPDT').AsDateTime;
      table.FieldByName('SCHMINUTES').AsInteger := q.FieldByName('SCHMINUTES').AsInteger;
      table.FieldByName('SCHPRESENTERFULLNAME').AsString := q.FieldByName('SCHPRESENTERFULLNAME').AsString;
      table.FieldByName('SCHPRESENTERORG').AsString := q.FieldByName('SCHPRESENTERORG').AsString;
      table.FieldByName('SCHLOCATION').AsString := q.FieldByName('SCHLOCATION').AsString;
      table.FieldByName('SCHBLURB').AsString := q.FieldByName('SCHBLURB').AsString;
      table.FieldByName('UPDATECOUNTER').AsInteger := q.FieldByName('UPDATECOUNTER').AsInteger;
      table.FieldByName('UPDATEDONAT').AsDateTime := q.FieldByName('UPDATEDONAT').AsDateTime;
      table.FieldByName('SCHREPEATOF').AsInteger := q.FieldByName('SCHREPEATOF').AsInteger;
      table.FieldByName('SCHTAGC').AsString := q.FieldByName('SCHTAGC').AsString;
      table.FieldByName('SCHTAGD').AsString := q.FieldByName('SCHTAGD').AsString;
      table.FieldByName('SCHTAGPRISM').AsString := q.FieldByName('SCHTAGPRISM').AsString;
      table.Post;
      q.Next;
    end;
    q.Close;
    if NOT FlagWasConnected then gCodeRageSchedule_Conn.Disconnect;
  finally
    FreeAndNil(q);
  end;
end;

procedure FillCDS_for_ABOUT(var table : TClientDataset);
var
  q: TIB_Query;
  FlagWasConnected: Boolean;
begin
  q := nil;

  Assert(Assigned(table), 'table nil');
  Assert(Assigned(gCodeRageSchedule_Conn), 'gCodeRageSchedule_Conn');
  try
    q := TIB_Query.Create(nil);
    q.Name := 'qABOUT';
    q.SQL.Text := 'select * from ABOUT ' +
    'order by ABOUTID';
    q.IB_Connection := gCodeRageSchedule_Conn;
    q.IB_Transaction := gCodeRageSchedule_Tr;
    FlagWasConnected := gCodeRageSchedule_Conn.Connected;
    if NOT FlagWasConnected then gCodeRageSchedule_Conn.Connect;
    q.Open;
    q.First;
    while not q.EOF do
    begin
      table.Append;
      table.FieldByName('ABOUTID').AsInteger := q.FieldByName('ABOUTID').AsInteger;
      table.FieldByName('SCHID').AsInteger := q.FieldByName('SCHID').AsInteger;
      table.FieldByName('PRODUCTID').AsInteger := q.FieldByName('PRODUCTID').AsInteger;
      table.FieldByName('UPDATECOUNTER').AsInteger := q.FieldByName('UPDATECOUNTER').AsInteger;
      table.FieldByName('UPDATEDONAT').AsDateTime := q.FieldByName('UPDATEDONAT').AsDateTime;
      table.Post;
      q.Next;
    end;
    q.Close;
    if NOT FlagWasConnected then gCodeRageSchedule_Conn.Disconnect;
  finally
    FreeAndNil(q);
  end;
end;

procedure FillCDS_for_XPRODUCT(var table : TClientDataset);
var
  q: TIB_Query;
  FlagWasConnected: Boolean;
begin
  q := nil;

  Assert(Assigned(table), 'table nil');
  Assert(Assigned(gCodeRageSchedule_Conn), 'gCodeRageSchedule_Conn');
  try
    q := TIB_Query.Create(nil);
    q.Name := 'qXPRODUCT';
    q.SQL.Text := 'select * from XPRODUCT ' +
    'order by PRODUCTID';
    q.IB_Connection := gCodeRageSchedule_Conn;
    q.IB_Transaction := gCodeRageSchedule_Tr;
    FlagWasConnected := gCodeRageSchedule_Conn.Connected;
    if NOT FlagWasConnected then gCodeRageSchedule_Conn.Connect;
    q.Open;
    q.First;
    while not q.EOF do
    begin
      table.Append;
      table.FieldByName('PRODUCTID').AsInteger := q.FieldByName('PRODUCTID').AsInteger;
      table.FieldByName('PRODUCTABBREV').AsString := q.FieldByName('PRODUCTABBREV').AsString;
      table.FieldByName('PRODUCTNAME').AsString := q.FieldByName('PRODUCTNAME').AsString;
      table.FieldByName('UPDATECOUNTER').AsInteger := q.FieldByName('UPDATECOUNTER').AsInteger;
      table.FieldByName('UPDATEDONAT').AsDateTime := q.FieldByName('UPDATEDONAT').AsDateTime;
      table.Post;
      q.Next;
    end;
    q.Close;
    if NOT FlagWasConnected then gCodeRageSchedule_Conn.Disconnect;
  finally
    FreeAndNil(q);
  end;
end;

end.

