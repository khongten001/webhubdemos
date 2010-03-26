unit dserver_whdmGeneral;

interface

uses
  SysUtils, Classes;

type
  TdmwhGeneral = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init;
    procedure LoadProjectSyntax(Sender: TObject);
    procedure LoadProjectLingvo(Sender: TObject);
  end;

var
  dmwhGeneral: TdmwhGeneral;

implementation

{$R *.dfm}

uses
  webApp, webCall, htmConst, htWebApp,
  ucString, ucPos;

procedure TdmwhGeneral.Init;
begin
  if assigned(pWebApp) then
  begin
    pWebApp.OnLoadProjectSyntax := dmwhGeneral.LoadProjectSyntax;
    pWebApp.OnLoadProjectLingvo := dmwhGeneral.LoadProjectLingvo;
  end;
end;

procedure TdmwhGeneral.LoadProjectSyntax(Sender: TObject);
begin
  with TwhAppBase(Sender) do
    ProjectSyntax := cSyntaxStage;  {19-May-2004}
end;

procedure TdmwhGeneral.LoadProjectLingvo(Sender: TObject);
begin
  with TwhAppBase(Sender) do
    ProjectLingvo := 'eng';     {08-May-2004}
end;


end.
