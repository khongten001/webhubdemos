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
    Memo1: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
var
  S1: string;
begin
  S1 :=
    Format('"%s" is #%d of %d',
    [tpAppRole2.AppID, tpAppRole2.InstanceSequence, tpAppRole2.InstanceCount]);
  Memo1.Lines.Add(S1);
  Label1.Caption := S1;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  Form3.Close;
end;

procedure TForm3.FormActivate(Sender: TObject);
begin
  Button1Click(Sender);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Button1Click(Sender);
end;

end.
