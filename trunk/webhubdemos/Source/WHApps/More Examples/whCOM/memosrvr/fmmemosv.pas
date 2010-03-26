unit fmmemosv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  comobj,     // ClassIDToProgID defined here
  Memo_TLB;   // Class_TMemoServer defined here

procedure TForm1.FormActivate(Sender: TObject);
begin
  // Identify the server by displaying the ProgID.
  // The ClassIDToProgID function displays the ProgID, which is the server
  // name which must be passed into the COM macro to connect with the server.
  form1.caption:=ExtractFilename(paramstr(0))+': '+ClassIDToProgID(Class_TMemoServer);
end;

end.
