object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'WebHub Syntax Check'
  ClientHeight = 382
  ClientWidth = 685
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Lucida Sans Unicode'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 22
  object Button1: TButton
    Left = 10
    Top = 10
    Width = 201
    Height = 127
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Scan'
    TabOrder = 0
    OnClick = Button1Click
  end
  object TreeView1: TTreeView
    Left = 218
    Top = 10
    Width = 1061
    Height = 809
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Indent = 19
    TabOrder = 1
  end
  object BitBtnCancel: TBitBtn
    Left = 10
    Top = 144
    Width = 201
    Height = 121
    DoubleBuffered = True
    Kind = bkCancel
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = BitBtnCancelClick
  end
end
