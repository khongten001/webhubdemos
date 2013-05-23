unit AppRoleTester_fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, updateOK, tpApplic;

type
  TForm3 = class(TForm)
    tpAppRole2: TtpAppRole;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  Label1.Caption :=
    Format('"%s" is #%d of %d',
    [tpAppRole2.AppID, tpAppRole2.InstanceSequence, tpAppRole2.InstanceCount]);
end;

end.
