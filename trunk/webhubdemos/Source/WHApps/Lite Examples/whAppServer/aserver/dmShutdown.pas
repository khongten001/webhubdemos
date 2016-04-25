unit dmShutdown;

interface

uses
  SysUtils, Classes, tpShareB;

type
  TDataModuleShutdown = class(TDataModule)
    procedure tpSharedLongint1Change(Sender: TObject;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    tpSharedLongint1: TSharedInt;
    { Public declarations }
  end;

var
  DataModuleShutdown: TDataModuleShutdown;

implementation

{$R *.dfm}

uses
  Forms;

procedure TDataModuleShutdown.tpSharedLongint1Change(Sender: TObject);
begin
  with TSharedInt(Sender) do
  begin
    if GlobalInteger = 57 then
    begin
      Application.MainForm.Close;
    end;
  end;
end;

end.
