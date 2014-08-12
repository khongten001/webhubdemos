unit ShutdownApps_fmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, tpShareB;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    tpSharedLongint1: TSharedInt;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  tpSharedLongint1.GlobalInteger := 57;
end;

(* on create
  object tpSharedLongint1: TtpSharedInt32
    GlobalName = 'AppShutdown'
    GlobalValue = 0
    IgnoreOwnChanges = True
    Left = 96
    Top = 88
  end
*)

end.
