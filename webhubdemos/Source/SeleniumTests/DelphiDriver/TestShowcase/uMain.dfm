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
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 705
    Height = 41
    Align = alTop
    TabOrder = 1
    object btnTestA: TButton
      Left = 16
      Top = 10
      Width = 75
      Height = 25
      Caption = 'test a'
      TabOrder = 0
      OnClick = btnTestAClick
    end
    object btnTest: TButton
      Left = 312
      Top = 10
      Width = 75
      Height = 25
      Caption = 'test'
      TabOrder = 1
      OnClick = btnTestClick
    end
    object btnTestB: TButton
      Left = 97
      Top = 8
      Width = 75
      Height = 25
      Caption = 'test b'
      TabOrder = 2
      OnClick = btnTestAClick
    end
    object btnStop: TButton
      Left = 178
      Top = 10
      Width = 75
      Height = 25
      Caption = 'stop'
      TabOrder = 3
      OnClick = btnStopClick
    end
  end
end
