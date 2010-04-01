unit coderageAdmin_fmMaint_XProduct;

//Project:   Code Rage Schedule
//Revision:  1.0
//Filename:  D:\Projects\WebHubDemos\Source\WHApps\DB Examples\whSchedule\DBDesign\gen_Delphi\1\CodeRageAdmin_fmMaint_XProduct.pas
//Generated: 08-Sep-2009 01:12
//Legal:     Copyright (c) 2009 HREF Tools Corp.. All Rights Reserved Worldwide.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  all_fmTableMaint, StdCtrls, Grids, DBGrids, DBCtrls, Buttons, ExtCtrls,
  ComCtrls, Mask;

type
  TfmMaintXProduct = class(TfmTableMaint)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMaintXProduct: TfmMaintXProduct;

implementation

uses
CodeRageAdmin_dm1;

{$R *.DFM}

procedure TfmMaintXProduct.FormCreate(Sender: TObject);
begin
  inherited;
  //DBNavigator.DataSource := admindm1.dsXProduct;
  //laTableTitleTop.Caption:='XProduct';
  //laTableTitleForm.Caption:='XProduct';
  //dmCommon.tr1.autoCommit := true;
end;

end.
