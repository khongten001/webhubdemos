object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 318
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 25
  object Label1: TLabel
    Left = 56
    Top = 120
    Width = 51
    Height = 25
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 56
    Top = 48
    Width = 137
    Height = 49
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 56
    Top = 160
    Width = 569
    Height = 137
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button2: TButton
    Left = 440
    Top = 48
    Width = 177
    Height = 49
    Caption = 'Exit'
    TabOrder = 2
    OnClick = Button2Click
  end
  object tpAppRole2: TtpAppRole
    CaptionObservationActive = False
    AppID = 'appvers'
    Left = 312
    Top = 88
  end
end
