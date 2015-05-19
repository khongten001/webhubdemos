unit whOpenID_dmProjMgr;

interface

uses
  SysUtils, Classes,
  whdemo_DMProjMgr, tpProj;

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
  MultiTypeApp, ucLogFil,
  whdemo_ViewSource,
  whOpenID_dmwhAction;

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
  if Continue then
  begin
    DMWHOpenIDviaJanrain.APIKey :=
      Trim(StringLoadFromFile(getHtDemoCodeRoot +
      'More Examples\whOpenID\janrain_api_key.txt'));
  end;
end;

end.
