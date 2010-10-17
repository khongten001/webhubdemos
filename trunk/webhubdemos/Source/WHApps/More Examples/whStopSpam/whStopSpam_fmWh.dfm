inherited fmUnicodePanel: TfmUnicodePanel
  Left = 413
  Top = 180
  Width = 397
  Height = 405
  Caption = '&Unicode'
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 379
    Height = 341
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 369
      Height = 291
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 24
        Width = 38
        Height = 18
        Caption = 'Input'
      end
      object Label2: TLabel
        Left = 8
        Top = 48
        Width = 52
        Height = 18
        Caption = 'Output'
      end
      object Label3: TLabel
        Left = 8
        Top = 74
        Width = 80
        Height = 18
        Caption = 'Mailto Link'
      end
      object BtnObfuscate: TBitBtn
        Left = 80
        Top = 102
        Width = 241
        Height = 25
        Caption = 'Obfuscate'
        TabOrder = 0
        OnClick = BtnObfuscateClick
        Kind = bkYes
      end
      object Edit1: TEdit
        Left = 81
        Top = 16
        Width = 241
        Height = 26
        TabOrder = 1
        OnChange = Edit1Change
      end
      object Edit2: TEdit
        Left = 81
        Top = 42
        Width = 241
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clActiveCaption
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object Edit3: TEdit
        Left = 81
        Top = 69
        Width = 241
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clActiveCaption
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
    end
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 369
      BorderWidth = 5
      TabOrder = 0
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 341
    Width = 379
    Height = 19
    Panels = <
      item
        Text = 'WebActionNoSaveState1: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
end
