unit whCom_dmProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TPMforWHCom = class(TDMForWHDemo)
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PMforWHCom: TPMforWHCom;

implementation

{$R *.dfm}

uses
  MultiTypeApp, whsample_COM;
  
procedure TPMforWHCom.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TdmCOMIdler, dmCOMIdler);
end;

procedure TPMforWHCom.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  dmCOMIdler.Init;
end;

end.
