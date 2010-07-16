unit coderageAdmin_dm1;

//Project:   Code Rage Schedule
//Revision:  1.0
//Filename:  D:\Projects\WebHubDemos\Source\WHApps\DB Examples\whSchedule\DBDesign\gen_Delphi\1\CodeRageAdmin_dm1.pas
//Generated: 08-Sep-2009 01:12
//Legal:     Copyright (c) 2009 HREF Tools Corp.. All Rights Reserved Worldwide.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, DB, ldiDmUtil, 
  IB_Access,  // part of IBObjects 4.9.9 but not part of v4.8.6
  IB_Components{, IBODataset};

type
  TAdmindm1 = class(TDataModule)
    iboqABOUT: TIBOQuery;
    dsABOUT: TDataSource;
    iboqSCHEDULE: TIBOQuery;
    dsSCHEDULE: TDataSource;
    iboqXPRODUCT: TIBOQuery;
    dsXPRODUCT: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure iboqABOUTAfterOpen(DataSet: TDataSet);
    procedure iboqABOUTBeforePost(DataSet: TDataSet);
    procedure iboqSCHEDULEAfterOpen(DataSet: TDataSet);
    procedure iboqSCHEDULEBeforePost(DataSet: TDataSet);
    procedure iboqXPRODUCTAfterOpen(DataSet: TDataSet);
    procedure iboqXPRODUCTBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Admindm1: TAdmindm1;

implementation

{$R *.DFM}

uses
  CodeRage_dmCommon;

procedure TAdmindm1.DataModuleCreate(Sender: TObject);
begin
  //PrepareAllQueriesAndProcs(Admindm1,dmCommon.cn1,dmCommon.tr1);
  //taABOUT.Open;
  //taSCHEDULE.Open;
  //taXPRODUCT.Open;
end;

procedure TAdmindm1.DataModuleDestroy(Sender: TObject);
begin
  iboqABOUT.Close;
  iboqSCHEDULE.Close;
  iboqXPRODUCT.Close;
  UnPrepareAllQueriesAndProcs(dmCommon);
end;

// for each table

procedure TAdmindm1.iboqABOUTAfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('AboutID').ReadOnly := True;
  end;
end;

procedure TAdmindm1.iboqSCHEDULEAfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('SchID').ReadOnly := True;
  end;
end;

procedure TAdmindm1.iboqXPRODUCTAfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('ProductID').ReadOnly := True;
  end;
end;


procedure TAdmindm1.iboqABOUTBeforePost(DataSet: TDataSet);
begin
  if iboqABOUT.State = dsInsert then
  begin
    dmCommon.sp_g_AboutNo.ExecProc;
    iboqAbout.Fields[0].asInteger := dmCommon.sp_g_AboutNo.Fields[0].AsInteger;
  end;
end;

procedure TAdmindm1.iboqSCHEDULEBeforePost(DataSet: TDataSet);
begin
  if iboqSCHEDULE.State = dsInsert then
  begin
    dmCommon.sp_g_ScheduleNo.ExecProc;
    iboqSchedule.Fields[0].asInteger := dmCommon.sp_g_ScheduleNo.Fields[0].AsInteger;
  end;
end;

procedure TAdmindm1.iboqXPRODUCTBeforePost(DataSet: TDataSet);
begin
  if iboqXPRODUCT.State = dsInsert then
  begin
    dmCommon.sp_g_XProductNo.ExecProc;
    iboqXProduct.Fields[0].asInteger := dmCommon.sp_g_XProductNo.Fields[0].AsInteger;
  end;
end;

end.

