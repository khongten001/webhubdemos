unit htsvrfrm;

(*
files in this example:

htsv.tlb  .. the type library for the exe.
htsv_tlb.pas .. delphi's ascii rendition of the type library.
htsv_tlb.dcr .. delphi's resource file from the type library.
htsv_imp.pas .. customized import unit redirecting everything to this form.

htSvrFrm.pas/.dfm .. this form to demonstrate how each proc is called.


create a new com server based on this unit by importing it, or by
re-creating it from File | New | ActiveX | Automation Object.

The TwhDCOM component in WebDCom.pas is designed to call servers
conforming to this interface. One Component Instance per server used.
Full source is included so that you can customize for what you need to call.

*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TServerForm = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //
    //these are the methods redirected here from htsv_imp to do the work.
    procedure Reset;
    procedure AddParam(const Value: String);
    procedure Execute;
    function  ResultText: String;
    //
    end;

var
  ServerForm: TServerForm;

implementation

{$R *.DFM}

procedure TServerForm.Reset;
begin
  Memo1.Lines.Clear;
end;

procedure TServerForm.AddParam(const Value: String);
begin
  with Memo1, Lines do begin
    Add(Value);
    SelStart:=pred(length(Text));
    SelLength:=0;
    end;
end;

procedure TServerForm.Execute;
begin
  with Memo1.Lines do
    Text:=lowercase(Text);
end;

function TServerForm.ResultText: String;
begin
  Result:=Memo1.Lines.Text;
end;

//

procedure TServerForm.FormCreate(Sender: TObject);
begin
  //set up the initial screen.
  //the com-client will call reset before running.
  Reset;
  AddParam('Idle.. ');
end;

end.
