inherited fmAppAboutPanel: TfmAppAboutPanel
  Left = 386
  Top = 197
  Width = 624
  Height = 317
  Caption = '&About'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Left = 100
    Width = 516
    Height = 273
    object Panel1: TPanel
      Left = 225
      Top = 45
      Width = 4
      Height = 223
      Cursor = crHSplit
      Align = alLeft
      BevelOuter = bvNone
      DragCursor = crHSplit
      TabOrder = 0
      object Splitter1: TSplitter
        Left = 0
        Top = 0
        Width = 20
        Height = 223
      end
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 220
      Height = 223
      Align = alLeft
      BevelOuter = bvNone
      BorderWidth = 5
      BorderStyle = bsSingle
      TabOrder = 1
      object LabelShortDesc: TLabel
        Left = 5
        Top = 5
        Width = 206
        Height = 16
        Align = alTop
        Caption = 'Demo Description'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabelQueryString: TLabel
        Left = 5
        Top = 62
        Width = 206
        Height = 13
        Cursor = crDrag
        Align = alTop
        Caption = '?AppID:PageID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        OnClick = LabelURLClick
      end
      object Label3: TLabel
        Left = 5
        Top = 49
        Width = 206
        Height = 13
        Align = alTop
        Caption = 'Click to start demo in web browser:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 5
        Top = 89
        Width = 206
        Height = 13
        Align = alTop
        Caption = 'Click for '#39'about'#39' info:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object LabelAbout: TLabel
        Left = 5
        Top = 102
        Width = 206
        Height = 13
        Cursor = crDrag
        Align = alTop
        Caption = '?AppID:PageID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        OnClick = LabelURLClick
      end
      object Panel3: TPanel
        Left = 5
        Top = 173
        Width = 206
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object LabelCopyright: TLabel
          Left = 0
          Top = 0
          Width = 206
          Height = 41
          Align = alClient
          AutoSize = False
          Caption = 'Copyright (c) 1997-2006'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clTeal
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
      end
      object Panel2: TPanel
        Left = 5
        Top = 21
        Width = 206
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
      end
      object Panel4: TPanel
        Left = 5
        Top = 75
        Width = 206
        Height = 14
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
      end
    end
    object tpToolBar1: TtpToolBar
      Left = 5
      Top = 5
      Width = 506
      TabOrder = 2
      object btnToggleConnection: TtpToolButton
        Left = 6
        Top = 1
        Width = 49
        Action = ActionToggleConnection
        LeaveSpace = True
        MinWidth = 28
      end
      object tpToolButton1: TtpToolButton
        Left = 61
        Top = 1
        Width = 121
        Action = ActionShowConnectionDetail
        LeaveSpace = True
        MinWidth = 28
      end
    end
    object GroupBoxWHXP: TGroupBox
      Left = 229
      Top = 45
      Width = 282
      Height = 223
      Align = alClient
      Caption = 'Connection Detail'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      object Panel5: TPanel
        Left = 2
        Top = 18
        Width = 10
        Height = 203
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
      end
      object Panel6: TPanel
        Left = 12
        Top = 18
        Width = 268
        Height = 203
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object LabelIdentification: TLabel
          Left = 0
          Top = 0
          Width = 268
          Height = 16
          Align = alTop
          Caption = 'LabelIdentification'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object LabelDllCalls: TLabel
          Left = 0
          Top = 16
          Width = 268
          Height = 16
          Align = alTop
          Caption = 'LabelDllCalls'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LabelAboutHarry: TLabel
          Left = 0
          Top = 32
          Width = 268
          Height = 16
          Align = alTop
          Caption = 'LabelAboutHarry'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
      end
    end
  end
  object tpComponentPanel1: TtpComponentPanel
    Left = 0
    Top = 0
    Width = 100
    Height = 273
    TabOrder = 1
  end
  object ActionList1: TActionList
    Left = 24
    Top = 24
    object ActionToggleConnection: TAction
      Caption = 'Suspend'
      OnExecute = ActionToggleConnectionExecute
    end
    object ActionShowConnectionDetail: TAction
      Caption = 'Show Connection Detail'
      OnExecute = ActionShowConnectionDetailExecute
    end
  end
end
