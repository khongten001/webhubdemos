object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Shared Sender'
  ClientHeight = 195
  ClientWidth = 455
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 28
  object Button1: TButton
    Left = 32
    Top = 82
    Width = 329
    Height = 47
    Caption = 'Send data to global buffer'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 32
    Top = 24
    Width = 217
    Height = 36
    TabOrder = 1
    Text = 'Edit1'
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 176
    Width = 455
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
  end
end
