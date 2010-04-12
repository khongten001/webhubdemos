object Form1: TForm1
  Left = 191
  Top = 122
  Caption = 'adv test case'
  ClientHeight = 413
  ClientWidth = 800
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
    Width = 800
    Height = 363
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 50
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 217
      Top = 20
      Width = 47
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Start On'
    end
    object Label2: TLabel
      Left = 374
      Top = 20
      Width = 51
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Threads'
    end
    object Label3: TLabel
      Left = 502
      Top = 20
      Width = 50
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Duration'
    end
    object Button1: TButton
      Left = 20
      Top = 10
      Width = 92
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Start1'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 118
      Top = 10
      Width = 90
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Start2'
      TabOrder = 1
      OnClick = Button2Click
    end
    object editStartOn: TEdit
      Left = 276
      Top = 15
      Width = 80
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 2
      Text = '04:00:00'
    end
    object editThreads: TEdit
      Left = 433
      Top = 15
      Width = 51
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 3
      Text = '4'
    end
    object editDuration: TEdit
      Left = 561
      Top = 15
      Width = 61
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 4
      Text = '60'
    end
    object Button3: TButton
      Left = 660
      Top = 11
      Width = 92
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Button3'
      TabOrder = 5
      OnClick = Button3Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 120
    Top = 40
  end
end
