unit coderageAdmin_fmMenu;

//Project:   Code Rage Schedule
//Revision:  1.0
//Filename:  D:\Projects\WebHubDemos\Source\WHApps\DB Examples\whSchedule\DBDesign\gen_Delphi\1\CodeRageAdmin_fmMenu.pas
//Generated: 08-Sep-2009 01:12
//Legal:     Copyright (c) 2009 HREF Tools Corp.. All Rights Reserved Worldwide.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, all_TableMaint_u01, Buttons, ExtCtrls;

type
  TfmTblMaintMenu = class(TForm)
    BitBtnCloseForm: TBitBtn;
    laDatabaseName: TLabel;
    LabelAbout: TLabel;
    BtnViewAbout: TBitBtn;
    BtnMaintainAbout: TBitBtn;
    LabelSchedule: TLabel;
    BtnViewSchedule: TBitBtn;
    BtnMaintainSchedule: TBitBtn;
    LabelXProduct: TLabel;
    BtnViewXProduct: TBitBtn;
    BtnMaintainXProduct: TBitBtn;
    procedure BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public     
    { Public declarations }
  end;

var
  fmTblMaintMenu: TfmTblMaintMenu;

implementation

uses
  ucString, ZaphodsMap, CodeRage_dmCommon,CodeRageAdmin_dm1, 
  coderageAdmin_fmMaint_About, 
  coderageAdmin_fmMaint_Schedule, 
  coderageAdmin_fmMaint_XProduct;

{$R *.DFM}

procedure TfmTblMaintMenu.FormCreate(Sender: TObject);
var
  aProjectCode: string;
  S: string;
  ZMWarning: string;
begin
  Self.Position := poScreenCenter;
  aProjectCode := 'CodeRage';

  with TForm(Sender) do
  begin
    Caption := aProjectCode + ' - Admin';
    s := paramstr(1);
    if s = '' then
    begin
    //  Caption := Caption + ' - SPECIFIC DATABASE';
    end
    else
    begin
      Caption := Caption + ' - ' + s;
    end;
  end;
  laDatabaseName.Caption := ZaphodKeyedFileZNodeAttr('LDI\ScriptGen',
    'ScriptGen', 'CodeRage', 'DBAdminConfig', ['DatabaseAccess', 'ldiDBAlias'],
    cxOptional, usrNone, 'value', '', ZMWarning);


end;

procedure TfmTblMaintMenu.BtnClick(Sender: TObject);
var
  aBtnName: string;
  msMode: TMaintSecurity;
  mMode: TMaintMode;
  aTablename:string;
begin
  aBtnName := TBitBtn(Sender).Name;
  if pos('BtnView',aBtnName)=1 then
  begin
    msMode := msBrowseOnly;
    mMode := mmView;
    aTablename:=copy(aBtnName,Length('BtnView')+1,maxlongint);
  end
  else
  begin
    msMode := msFullMaintenance;
    mMode := mmEditGrid;
    aTablename:=copy(aBtnName,Length('BtnMaintain')+1,maxlongint);
  end;

  if false then
  begin
  end
  else
  if ansiSameText(aTablename,'About') then
  begin
    with fmMaintAbout do
    begin
      DBNavigator.DataSource := admindm1.dsAbout;
      laTableTitleTop.Caption := 'About';
      laTableTitleForm.Caption := 'About';
      CurrentMaintSecurity := msMode;
      CurrentMaintMode := mMode;
      tmTableName := 'About';
    //fmMaintAbout.ShowAs(201);
      Show;
    end;
  end
  else
  if ansiSameText(aTablename,'Schedule') then
  begin
    with fmMaintSchedule do
    begin
      DBNavigator.DataSource := admindm1.dsSchedule;
      laTableTitleTop.Caption := 'Schedule';
      laTableTitleForm.Caption := 'Schedule';
      CurrentMaintSecurity := msMode;
      CurrentMaintMode := mMode;
      tmTableName := 'Schedule';
    //fmMaintSchedule.ShowAs(201);
      Show;
    end;
  end
  else
  if ansiSameText(aTablename,'XProduct') then
  begin
    with fmMaintXProduct do
    begin
      DBNavigator.DataSource := admindm1.dsXProduct;
      laTableTitleTop.Caption := 'XProduct';
      laTableTitleForm.Caption := 'XProduct';
      CurrentMaintSecurity := msMode;
      CurrentMaintMode := mMode;
      tmTableName := 'XProduct';
    //fmMaintXProduct.ShowAs(201);
      Show;
    end;
  end;
end;

end.

