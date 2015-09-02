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
var
  AFilespec: string;
begin
  inherited;
  Continue := DMWHOpenIDviaJanrain.Init(ErrorText);
  if Continue then
  begin
    AFilespec := getHtDemoCodeRoot +
      'More Examples\whOpenID\janrain_api_key.txt';
    DMWHOpenIDviaJanrain.APIKey :=
      Trim(StringLoadFromFile(AFilespec));
    if DMWHOpenIDviaJanrain.APIKey = '' then
    begin
      ErrorText := 'Unable to load valid JANRAIN API Secret Key from ' + AFilespec;
      Continue := False;
    end;
  end;
end;

end.
