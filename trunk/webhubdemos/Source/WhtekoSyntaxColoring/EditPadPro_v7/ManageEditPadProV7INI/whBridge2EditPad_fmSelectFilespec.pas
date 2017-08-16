unit whBridge2EditPad_fmSelectFilespec;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2014-2017 HREF Tools Corp.                                 * }
{ *                                                                          * }
{ * This source code file is part of the WebHub plug-in for EditPad Pro.     * }
{ *                                                                          * }
{ * This file is licensed under a Creative Commons Attribution 2.5 License.  * }
{ * http://creativecommons.org/licenses/by/2.5/                              * }
{ * If you use this file, please keep this notice intact.                    * }
{ *                                                                          * }
{ * Author: Ann Lynnworth                                                    * }
{ *                                                                          * }
{ * Refer friends and colleagues to www.href.com/whvcl. Thanks!              * }
{ ---------------------------------------------------------------------------- }

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TForm4 = class(TForm)
    Panel1: TPanel;
    ButtonCancel: TButton;
    ButtonOk: TButton;
    Panel2: TPanel;
    ListBox1: TListBox;
    Label1: TLabel;
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
  ucString, uCode, ZM_CodeSiteInterface,
  WHBridge2EditPad_uSearchDir;

var
  FlagInitDone: Boolean = False;
  FlagJustClose: Boolean = False;

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
  if (NOT FlagJustClose) and Assigned(Listbox1) then
  begin
    AFilespec := Listbox1.ItemByIndex(ListBox1.ItemIndex).Text;
    CSSend('Selected', AFilespec);
    Push2Stack_and_OpenFile(ParamString('-exe'), AFilespec);
  end;
  Self.Close;
  CSExitMethod(Self, cFn);
end;

procedure TForm4.FormActivate(Sender: TObject);
var
  ErrorText: string;
begin
  if NOT FlagInitDone then
  begin
    WrapOpenJSorCSSorOtherFile(ListBox1, ErrorText);
    if ErrorText <> '' then
    begin
      FreeAndNil(ListBox1);
      Label1.Visible := True;
      Label1.Text := ErrorText;
      CSSendError(ErrorText);
      //ShowMessage(ErrorText);
      FreeAndNil(ButtonCancel);
      ButtonOk.Text := 'Ok';
      FlagJustClose := True;
    end
    else
    begin
      if ListBox1.Items.Count = 0 then
        Self.Close
      else
      begin
        // calling function takes over... GUI is involved.
      end;
    end;
  end;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  ListBox1.Clear;
  Label1.Visible := False;
  Self.Caption := ExtractFilename(ParamStr(0)) + ': Select File to Open';
end;

end.
