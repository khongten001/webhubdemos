unit whDropdown_dmProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TDMForWHDropdown = class(TDMForWHDemo)
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
  DMForWHDropdown: TDMForWHDropdown;

implementation

{$R *.dfm}

uses
  MultiTypeApp, webApp, htDropDM;

procedure TDMForWHDropdown.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TDMDrop, DMDrop);
end;

procedure TDMForWHDropdown.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  pWebApp.OnNewSession := DMDrop.htWebAppNewSession;
end;

end.
