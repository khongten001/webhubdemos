object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'WebHub Syntax Check'
  ClientHeight = 551
  ClientWidth = 953
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Lucida Sans Unicode'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 22
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 225
    Height = 551
    Align = alLeft
    TabOrder = 0
    ExplicitHeight = 831
    object BitBtnCancel: TBitBtn
      Left = 10
      Top = 144
      Width = 201
      Height = 121
      DoubleBuffered = True
      Kind = bkCancel
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = BitBtnCancelClick
    end
    object Button1: TButton
      Left = 9
      Top = 10
      Width = 201
      Height = 127
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Scan'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 225
    Top = 0
    Width = 728
    Height = 551
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 231
    ExplicitWidth = 460
    ExplicitHeight = 831
    object TreeView1: TTreeView
      Left = 1
      Top = 1
      Width = 726
      Height = 549
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Indent = 19
      TabOrder = 0
      ExplicitLeft = 218
      ExplicitTop = 10
      ExplicitWidth = 1061
      ExplicitHeight = 809
    end
  end
end
