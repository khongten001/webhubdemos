object Form1: TForm1
  Left = 189
  Top = 104
  Caption = 'selenium --- showcase'
  ClientHeight = 431
  ClientWidth = 705
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object memoLog: TMemo
    Left = 0
    Top = 41
    Width = 705
    Height = 390
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 705
    Height = 41
    Align = alTop
    TabOrder = 1
    object btnStart: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = btnStartClick
    end
    object btnTest: TButton
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Caption = 'test'
      TabOrder = 1
      OnClick = btnTestClick
    end
  end
end
