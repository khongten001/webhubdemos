unit dmwhAnsiUmlauts;

interface

uses
  SysUtils, Classes, updateOK, tpAction, webTypes, webLink;

type
  TDataModule1 = class(TDataModule)
    waUUmlauts: TwhWebAction;
    procedure waUUmlautsExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init;
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

uses
  ucAnsiUtil,
  webApp;

procedure TDataModule1.Init;
begin
  RefreshWebActions(Self);
end;

procedure TDataModule1.waUUmlautsExecute(Sender: TObject);
begin
  pwebapp.SendString('üüü');
end;

end.
