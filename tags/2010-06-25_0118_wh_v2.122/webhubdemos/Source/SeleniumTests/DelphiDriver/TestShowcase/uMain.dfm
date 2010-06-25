object Form1: TForm1
  Left = 193
  Top = 108
  Width = 713
  Height = 458
  Caption = 'selenium --- showcase'
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
    Top = 137
    Width = 705
    Height = 294
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 705
    Height = 137
    Align = alTop
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 312
      Top = 8
      Width = 185
      Height = 121
      Caption = 'Performance Test'
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 34
        Height = 13
        Caption = 'Thread'
      end
      object Label2: TLabel
        Left = 16
        Top = 48
        Width = 28
        Height = 13
        Caption = 'Times'
      end
      object btnPerformanceTestStart: TButton
        Left = 16
        Top = 80
        Width = 75
        Height = 25
        Caption = 'Start'
        Enabled = False
        TabOrder = 0
        OnClick = btnPerformanceTestStartClick
      end
      object editThread: TEdit
        Left = 64
        Top = 24
        Width = 49
        Height = 21
        TabOrder = 1
        Text = '2'
      end
      object editTimes: TEdit
        Left = 64
        Top = 48
        Width = 49
        Height = 21
        TabOrder = 2
        Text = '10'
      end
      object btnPerformanceTestStop: TButton
        Left = 96
        Top = 80
        Width = 75
        Height = 25
        Caption = 'Stop'
        Enabled = False
        TabOrder = 3
        OnClick = btnPerformanceTestStopClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 504
      Top = 8
      Width = 193
      Height = 121
      Caption = 'Test'
      TabOrder = 1
      object btnTest: TButton
        Left = 8
        Top = 24
        Width = 95
        Height = 25
        Caption = 'test showcase'
        TabOrder = 0
        OnClick = btnTestClick
      end
      object Button1: TButton
        Left = 8
        Top = 56
        Width = 95
        Height = 25
        Caption = 'test google'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 8
        Top = 88
        Width = 163
        Height = 25
        Caption = 'test captureNetworkStream'
        TabOrder = 2
        OnClick = Button2Click
      end
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 8
      Width = 97
      Height = 121
      Caption = 'Showcase'
      TabOrder = 2
      object btnTestA: TButton
        Left = 16
        Top = 24
        Width = 75
        Height = 25
        Caption = 'test a'
        TabOrder = 0
        OnClick = btnTestAClick
      end
      object btnTestB: TButton
        Left = 16
        Top = 56
        Width = 75
        Height = 25
        Caption = 'test b'
        TabOrder = 1
        OnClick = btnTestAClick
      end
      object btnStop: TButton
        Left = 14
        Top = 88
        Width = 75
        Height = 25
        Caption = 'stop'
        TabOrder = 2
        OnClick = btnStopClick
      end
    end
    object GroupBox4: TGroupBox
      Left = 112
      Top = 8
      Width = 193
      Height = 121
      Caption = 'my-next-home'
      TabOrder = 3
      object btn_andere: TButton
        Left = 16
        Top = 24
        Width = 75
        Height = 25
        Caption = 'andere'
        TabOrder = 0
        OnClick = btn_andereClick
      end
      object btn_expose: TButton
        Left = 16
        Top = 56
        Width = 75
        Height = 25
        Caption = 'expose'
        TabOrder = 1
        OnClick = btn_exposeClick
      end
      object btn_inserieren: TButton
        Left = 14
        Top = 88
        Width = 75
        Height = 25
        Caption = 'inserieren'
        TabOrder = 2
        OnClick = btn_inserierenClick
      end
      object btn_nodouble: TButton
        Left = 104
        Top = 24
        Width = 75
        Height = 25
        Caption = 'nodouble'
        TabOrder = 3
        OnClick = btn_nodoubleClick
      end
      object btn_partner: TButton
        Left = 104
        Top = 56
        Width = 75
        Height = 25
        Caption = 'partner'
        TabOrder = 4
        OnClick = btn_partnerClick
      end
      object btn_suchen: TButton
        Left = 102
        Top = 88
        Width = 75
        Height = 25
        Caption = 'suchen'
        TabOrder = 5
        OnClick = btn_suchenClick
      end
    end
  end
end
