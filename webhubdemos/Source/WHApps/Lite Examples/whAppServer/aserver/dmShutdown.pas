unit dmShutdown;

interface

uses
  SysUtils, Classes, tpShareI;

type
  TDataModuleShutdown = class(TDataModule)
    tpSharedLongint1: TtpSharedInt32;
    procedure tpSharedLongint1Change(Sender: TObject;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModuleShutdown: TDataModuleShutdown;

implementation

{$R *.dfm}

uses
  Forms;

procedure TDataModuleShutdown.tpSharedLongint1Change(Sender: TObject;
  var Continue: Boolean);
begin
  with TtpSharedInt32(Sender) do
  begin
    if GlobalValue = 57 then
    begin
      Application.MainForm.Close;
    end;
  end;
end;

end.
