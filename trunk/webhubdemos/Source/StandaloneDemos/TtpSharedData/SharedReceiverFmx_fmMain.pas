unit SharedReceiverFmx_fmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  tpShareB;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    shared: TtpSharedBuf;
    procedure SharedHasChanged(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
{$I shared_buffer.inc}
begin
  shared := TtpSharedBuf.CreateNamed(nil, cName, cSize);
  shared.Name := 'shared';
  shared.OnChange := SharedHasChanged;
  shared.IgnoreOwnChanges := True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(shared);
end;

procedure TForm1.SharedHasChanged(Sender: TObject);
var
  S8: UTF8String;
begin
  S8 := shared.GlobalUTF8String;
  Label1.Text := string(S8);
end;

end.
