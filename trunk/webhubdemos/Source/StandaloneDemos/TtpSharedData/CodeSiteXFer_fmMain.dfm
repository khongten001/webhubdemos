object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Transmit from TtpSharedBuf to CodeSite Logger'
  ClientHeight = 310
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 20
  object Label1: TLabel
    Left = 80
    Top = 32
    Width = 44
    Height = 20
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 80
    Top = 58
    Width = 44
    Height = 20
    Caption = 'Label1'
  end
  object Label3: TLabel
    Left = 80
    Top = 88
    Width = 44
    Height = 20
    Caption = 'Label1'
  end
  object LabelOnAt: TLabel
    Left = 80
    Top = 120
    Width = 44
    Height = 20
    Caption = 'Label1'
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 8
    Width = 297
    Height = 17
    Caption = 'Echo last message to GUI here'
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 160
    Width = 408
    Height = 150
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
end
