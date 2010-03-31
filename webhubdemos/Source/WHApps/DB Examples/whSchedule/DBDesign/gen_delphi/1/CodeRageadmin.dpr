program coderageAdmin;

//Project:   Code Rage Schedule
//Revision:  1.0
//Filename:  D:\Projects\WebHubDemos\Source\WHApps\DB Examples\whSchedule\DBDesign\gen_Delphi\1\CodeRageadmin.dpr
//Generated: 08-Sep-2009 01:12
//Legal:     Copyright (c) 2009 HREF Tools Corp.. All Rights Reserved Worldwide.

uses
  Forms,
  coderageAdmin_fmMenu in 'coderageAdmin_fmMenu.pas' {fmMenu},
  all_fmTableMaint in 'd:\vcl\ldi\tblmaint\all_fmTableMaint.pas' {fmTableMaint},
  coderageAdmin_fmMaint_About in 'coderageAdmin_fmMaint_About.pas' {fmMaintAbout},
  coderageAdmin_fmMaint_Schedule in 'coderageAdmin_fmMaint_Schedule.pas' {fmMaintSchedule},
  coderageAdmin_fmMaint_XProduct in 'coderageAdmin_fmMaint_XProduct.pas' {fmMaintXProduct},
  coderageAdmin_dm1 in 'coderageAdmin_dm1.pas' {admindm1: TDataModule},
  coderage_dmCommon in 'coderage_dmCommon.pas' {dmCommon: TDataModule},
  ZaphodsMap in 'h:\ZaphodsMap.pas';

{$R *.RES}


begin
  Application.Initialize;


  Application.CreateForm(TfmTblMaintMenu, fmTblMaintMenu);
  Application.CreateForm(TdmCommon, dmCommon);
  Application.CreateForm(TAdmindm1, admindm1);
  Application.CreateForm(TfmMaintAbout, fmMaintAbout);
  Application.CreateForm(TfmMaintSchedule, fmMaintSchedule);
  Application.CreateForm(TfmMaintXProduct, fmMaintXProduct);
  Application.Run;
end.

