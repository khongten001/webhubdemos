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

(* on create
  object tpSharedLongint1: TtpSharedInt32
    GlobalName = 'AppShutdown'
    GlobalValue = 0
    IgnoreOwnChanges = True
    OnChange = tpSharedLongint1Change
    Left = 56
    Top = 32
  end
*)

end.
