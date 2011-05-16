unit CodeRage_dmCommon;

//Project:   Code Rage Schedule
//Revision:  1.0
//Filename:  D:\Projects\WebHubDemos\Source\WHApps\DB Examples\whSchedule\DBDesign\gen_Delphi\1\CodeRage_dmCommon.pas
//Generated: 08-Sep-2009 01:12
//Legal:     Copyright (c) 2009 HREF Tools Corp.. All Rights Reserved Worldwide.

interface

{$I IB_Directives.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables,
  IB_Access,  // part of IBObjects 4.9.9 but not part of v4.8.6
  IB_Components, IBODataset, 
{$IFNDEF IBO_UseUnicode}  IB_StoredProc, {$ENDIF}
  ldiDmUtil;

type
  TdmCommon = class(TDataModule)
    cn1: TIB_Connection;
    tr1: TIB_Transaction;
    sp_g_AboutNo    : TIB_StoredProc;
    sp_g_ScheduleNo : TIB_StoredProc;
    sp_g_XProductNo : TIB_StoredProc;
    quInsertAbout    : TIB_DSQL;
    quInsertSchedule : TIB_DSQL;
    quInsertXProduct : TIB_DSQL;
    procedure SetAllSQLStatements;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetDefaultsFor_About;
    procedure SetDefaultsFor_Schedule;
    procedure SetDefaultsFor_XProduct;
    procedure InsertRecordInto_About;
    procedure InsertRecordInto_Schedule;
    procedure InsertRecordInto_XProduct;
  end;

var
  dmCommon: TdmCommon;
  globCheckLengthBeforeExecSQL: boolean=false;

type

// -----------------------------------------------------------------------------

bufferFor_About_Rec = record
  SetPrimaryKeyOnInsert : boolean;
  AboutID       :integer;
  SchID         :integer;
  ProductID     :integer;
  UpdateCounter :integer;
  UpdatedOnAt   :TDateTime;
end;

// -----------------------------------------------------------------------------

bufferFor_Schedule_Rec = record
  SetPrimaryKeyOnInsert : boolean;
  SchID                :integer;
  SchTitle             :string;
  SchOnAtPDT           :TDateTime;
  SchMinutes           :smallint;
  SchPresenterFullname :string;
  SchPresenterOrg      :string;
  SchLocation          :string;
  SchBlurb             :string;
  UpdateCounter        :smallint;
  UpdatedOnAt          :TDateTime;
end;

// -----------------------------------------------------------------------------

bufferFor_XProduct_Rec = record
  SetPrimaryKeyOnInsert : boolean;
  ProductID     :integer;
  ProductAbbrev :string;
  ProductName   :string;
  UpdateCounter :integer;
  UpdatedOnAt   :TDateTime;
end;

var
  bufferFor_About: bufferFor_About_Rec;
  bufferFor_Schedule: bufferFor_Schedule_Rec;
  bufferFor_XProduct: bufferFor_XProduct_Rec;

implementation

{$R *.DFM}

uses
  ucString, ZaphodsMap;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

procedure TDmCommon.SetAllSQLStatements;
begin
  with quInsertAbout do
  begin
    SQL.Clear;
    SQL.Add(''
      + 'INSERT INTO ABOUT('
      + 'AboutID,SchID,ProductID)'
      + 'VALUES('
      + ':AboutID,:SchID,:ProductID);');
  end;
//
  with quInsertSchedule do
  begin
    SQL.Clear;
    SQL.Add(''
      + 'INSERT INTO SCHEDULE('
      + 'SchID,SchTitle,SchOnAtPDT,SchMinutes,SchPresenterFullname,SchPresenterOrg,SchLocation,'
      + 'SchBlurb)'
      + 'VALUES('
      + ':SchID,:SchTitle,:SchOnAtPDT,:SchMinutes,:SchPresenterFullname,:SchPresenterOrg,:SchLocation,'
      + ':SchBlurb);');
  end;
//
  with quInsertXProduct do
  begin
    SQL.Clear;
    SQL.Add(''
      + 'INSERT INTO XPRODUCT('
      + 'ProductID,ProductAbbrev,ProductName)'
      + 'VALUES('
      + ':ProductID,:ProductAbbrev,:ProductName);');
  end;
//
end;

procedure TdmCommon.DataModuleCreate(Sender: TObject);
var
  ldiDBHost, ldiDBAlias, ldiDBUsername, ldiDBPassword: string;
const
  cZaphodBranch = 'LDI\ScriptGen';
  cKeyName = 'ProjCodeRage';
  
  function ZMAttr( XPath: array of const; ADefault: Variant): string;
  var
    ZMWarning: string;
  begin
    Result := ZaphodKeyedFileZNodeAttr(cZaphodBranch, 'ScriptGen', cKeyName,
      'DBAdminConfig', XPath, cxOptional, usrNone, 'value', ADefault, ZMWarning);
  end;
  
begin
  ldiDBHost     := ZMAttr(['DatabaseAccess', 'ldiDBHost'], 'localhost');
  ldiDBAlias    := ZMAttr(['DatabaseAccess', 'ldiDBAlias'], '');
  ldiDBUsername := ZMAttr(['DatabaseAccess', 'ldiDBUsername'], 'SYSDBA');
  ldiDBPassword := ZMAttr(['DatabaseAccess', 'ldiDBPassword'], 'masterkey');

  with cn1 do
  begin
    Database:=ldiDBHost + ':' + ldiDBAlias;
    Username:=ldiDBUsername;
    Password:=ldiDBPassword;
    Connect;
  end;
  with tr1 do
  begin
    IB_Connection:=cn1;
    Isolation := tiCommitted;  // note the default is tiConcurrency
  end;
  SetAllSQLStatements;
  PrepareAllQueriesAndProcs(Sender as TDataModule, cn1, tr1);
  globCheckLengthBeforeExecSQL:=
    AnsiSameText('Yes',
      ZMAttr(['ErrorReporting', 'CheckLengthBeforeExecSQLYesNo'], 'No'));
end;

procedure TdmCommon.DataModuleDestroy(Sender: TObject);
begin
  UnPrepareAllQueriesAndProcs(Sender as TDataModule);
end;


procedure TdmCommon.SetDefaultsFor_About;
begin
  with BufferFor_About do
  begin
  end;
end;

procedure TdmCommon.SetDefaultsFor_Schedule;
begin
  with BufferFor_Schedule do
  begin
  end;
end;

procedure TdmCommon.SetDefaultsFor_XProduct;
begin
  with BufferFor_XProduct do
  begin
  end;
end;

// -----------------------------------------------------------------------------

procedure TdmCommon.InsertRecordInto_About;
const
  cProcess='InsertRecordInto_About';
begin
  with quInsertAbout do
  begin
    with BufferFor_About do
    begin
      if SetPrimaryKeyOnInsert then
      begin
        with sp_g_AboutNo do
        begin
          ExecProc;
          AboutID := Fields[0].asInteger;
        end;
      end;
      Params[0].asInteger   := AboutID;
      Params[1].asInteger   := SchID;
      Params[2].asInteger   := ProductID;
      with ldiDBError do begin;
        Tablename:='About';
        Process:=cProcess;
      end;
      ExecSQL;
    end;
  end;
end;


// -----------------------------------------------------------------------------

procedure TdmCommon.InsertRecordInto_Schedule;
const
  cProcess='InsertRecordInto_Schedule';
begin
  with quInsertSchedule do
  begin
    with BufferFor_Schedule do
    begin
      if globCheckLengthBeforeExecSQL then
      begin
        ldiCheckFieldLength('SchTitle',SchTitle,65,cProcess);
        ldiCheckFieldLength('SchPresenterFullname',SchPresenterFullname,45,cProcess);
        ldiCheckFieldLength('SchPresenterOrg',SchPresenterOrg,45,cProcess);
        ldiCheckFieldLength('SchLocation',SchLocation,10,cProcess);
        ldiCheckFieldLength('SchBlurb',SchBlurb,512,cProcess);
      end;
      if SetPrimaryKeyOnInsert then
      begin
        with sp_g_ScheduleNo do
        begin
          ExecProc;
          SchID := Fields[0].asInteger;
        end;
      end;
      Params[0].asInteger   := SchID;
      Params[1].asString    := SchTitle;
      Params[2].asDateTime  := SchOnAtPDT;
      Params[3].asInteger   := SchMinutes;
      Params[4].asString    := SchPresenterFullname;
      Params[5].asString    := SchPresenterOrg;
      Params[6].asString    := SchLocation;
      Params[7].asString    := SchBlurb;
      with ldiDBError do begin;
        Tablename:='Schedule';
        Process:=cProcess;
      end;
      ExecSQL;
    end;
  end;
end;


// -----------------------------------------------------------------------------

procedure TdmCommon.InsertRecordInto_XProduct;
const
  cProcess='InsertRecordInto_XProduct';
begin
  with quInsertXProduct do
  begin
    with BufferFor_XProduct do
    begin
      if globCheckLengthBeforeExecSQL then
      begin
        ldiCheckFieldLength('ProductAbbrev',ProductAbbrev,8,cProcess);
        ldiCheckFieldLength('ProductName',ProductName,15,cProcess);
      end;
      if SetPrimaryKeyOnInsert then
      begin
        with sp_g_XProductNo do
        begin
          ExecProc;
          ProductID := Fields[0].asInteger;
        end;
      end;
      Params[0].asInteger   := ProductID;
      Params[1].asString    := ProductAbbrev;
      Params[2].asString    := ProductName;
      with ldiDBError do begin;
        Tablename:='XProduct';
        Process:=cProcess;
      end;
      ExecSQL;
    end;
  end;
end;


end.

