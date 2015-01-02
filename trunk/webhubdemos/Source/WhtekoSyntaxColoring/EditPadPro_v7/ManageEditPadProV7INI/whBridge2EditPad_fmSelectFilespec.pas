unit whBridge2EditPad_fmSelectFilespec;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.StdCtrls;

type
  TForm4 = class(TForm)
    Panel1: TPanel;
    ButtonCancel: TButton;
    ButtonOk: TButton;
    Panel2: TPanel;
    ListBox1: TListBox;
    procedure ButtonOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}

uses
  ucString, uCode, ucCodeSiteInterface,
  WHBridge2EditPad_uSearchDir;

procedure TForm4.ButtonCancelClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TForm4.ButtonOkClick(Sender: TObject);
const cFn = 'ButtonOkClick';
var
  AFilespec: string;
begin
  CSEnterMethod(Self, cFn);
  AFilespec := Listbox1.ItemByIndex(ListBox1.ItemIndex).Text;
  CSSend('Selected', AFilespec);
  Push2Stack_and_OpenFile(ParamString('-exe'), AFilespec);
  Self.Close;
  CSExitMethod(Self, cFn);
end;

var
  FlagInitDone: Boolean = False;

procedure TForm4.FormActivate(Sender: TObject);
var
  ErrorText: string;
begin
  if NOT FlagInitDone then
  begin
    WrapOpenJSorCSSorOtherFile(ListBox1, ErrorText);
    if ErrorText <> '' then
    begin
      CSSendError(ErrorText);
      ShowMessage(ErrorText);
      Self.Close;
    end
    else
    begin
      if ListBox1.Items.Count > 0 then
      begin
        // calling function takes over...
      end;
    end;
  end;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  ListBox1.Clear;
end;

end.
