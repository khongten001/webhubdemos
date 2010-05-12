object Form1: TForm1
  Left = 189
  Top = 104
  Caption = 'selenium --- showcase'
  ClientHeight = 530
  ClientWidth = 868
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object memoLog: TMemo
    Left = 0
    Top = 50
    Width = 868
    Height = 480
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 868
    Height = 50
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    TabOrder = 1
    object btnTestA: TButton
      Left = 20
      Top = 12
      Width = 92
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'test a'
      TabOrder = 0
      OnClick = btnTestAClick
    end
    object btnTest: TButton
      Left = 384
      Top = 12
      Width = 117
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'test showcase'
      TabOrder = 1
      OnClick = btnTestClick
    end
    object btnTestB: TButton
      Left = 119
      Top = 10
      Width = 93
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'test b'
      TabOrder = 2
      OnClick = btnTestAClick
    end
    object btnStop: TButton
      Left = 219
      Top = 12
      Width = 92
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'stop'
      TabOrder = 3
      OnClick = btnStopClick
    end
    object Button1: TButton
      Left = 513
      Top = 12
      Width = 117
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'test google'
      TabOrder = 4
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 638
      Top = 12
      Width = 200
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'test captureNetworkStream'
      TabOrder = 5
      OnClick = Button2Click
    end
  end
end
