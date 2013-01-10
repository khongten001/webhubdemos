unit whOpenID_dmProjMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TDMProjForWHOpenID = class(TDMForWHDemo)
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: string; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject; var ErrorText: string;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMProjForWHOpenID: TDMProjForWHOpenID;

implementation

{$R *.dfm}

uses
  MultiTypeApp, whOpenID_dmwhAction;

procedure TDMProjForWHOpenID.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Application.CreateForm(TDMWHOpenIDviaJanRain, DMWHOpenIDviaJanRain);
end;

procedure TDMProjForWHOpenID.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Continue := DMWHOpenIDviaJanrain.Init(ErrorText);
end;

end.
