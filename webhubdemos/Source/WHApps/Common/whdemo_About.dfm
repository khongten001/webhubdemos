inherited fmAppAboutPanel: TfmAppAboutPanel
  Left = 386
  Top = 197
  Caption = '&About'
  ClientHeight = 272
  ClientWidth = 606
  OnCreate = FormCreate
  ExplicitWidth = 624
  ExplicitHeight = 319
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 606
    Height = 272
    ExplicitWidth = 606
    ExplicitHeight = 272
    object Panel1: TPanel
      Left = 225
      Top = 5
      Width = 4
      Height = 262
      Cursor = crHSplit
      Align = alLeft
      BevelOuter = bvNone
      DragCursor = crHSplit
      TabOrder = 0
      object Splitter1: TSplitter
        Left = 0
        Top = 0
        Width = 20
        Height = 262
      end
    end
    object Panel: TPanel
      Left = 5
      Top = 5
      Width = 220
      Height = 262
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
        ExplicitWidth = 125
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
        ExplicitWidth = 75
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
        ExplicitWidth = 164
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
        ExplicitWidth = 95
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
        ExplicitWidth = 75
      end
      object Panel3: TPanel
        Left = 5
        Top = 212
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
          Caption = 'Copyright (c) 1997-2018'
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
    object GroupBoxWHXP: TGroupBox
      Left = 229
      Top = 5
      Width = 372
      Height = 262
      Align = alClient
      Caption = 'Connection Detail'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object Panel5: TPanel
        Left = 2
        Top = 18
        Width = 10
        Height = 242
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
      end
      object Panel6: TPanel
        Left = 12
        Top = 18
        Width = 358
        Height = 242
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object LabelIdentification: TLabel
          Left = 0
          Top = 0
          Width = 358
          Height = 21
          Align = alTop
          Caption = 'LabelIdentification'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Lucida Sans Unicode'
          Font.Style = []
          ParentFont = False
          WordWrap = True
          ExplicitWidth = 154
        end
        object LabelDllCalls: TLabel
          Left = 0
          Top = 21
          Width = 358
          Height = 21
          Align = alTop
          Caption = 'LabelDllCalls'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Lucida Sans Unicode'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 108
        end
        object LabelAboutCPU: TLabel
          Left = 0
          Top = 63
          Width = 358
          Height = 21
          Align = alTop
          Caption = 'LabelAboutCPU'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Lucida Sans Unicode'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 128
        end
        object LabelAboutHarry: TLabel
          Left = 0
          Top = 42
          Width = 358
          Height = 21
          Align = alTop
          Caption = 'LabelAboutHarry'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Lucida Sans Unicode'
          Font.Style = []
          ParentFont = False
          OnClick = LabelAboutHarryClick
          ExplicitWidth = 141
        end
        object LabelAboutInstance: TLabel
          Left = 0
          Top = 105
          Width = 358
          Height = 21
          Align = alTop
          Caption = 'LabelAboutInstance'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Lucida Sans Unicode'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 163
        end
        object LabelAboutCompiler: TLabel
          Left = 0
          Top = 84
          Width = 358
          Height = 21
          Align = alTop
          Caption = 'LabelAboutCompiler'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Lucida Sans Unicode'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 172
        end
      end
    end
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
  object Timer1: TTimer
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 160
    Top = 128
  end
end
