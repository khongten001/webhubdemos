inherited fmUnicodePanel: TfmUnicodePanel
  Left = 413
  Top = 180
  Width = 397
  Height = 405
  Caption = '&Unicode'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 389
    Height = 348
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 379
      Height = 298
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 24
        Width = 24
        Height = 13
        Caption = 'Input'
      end
      object Label2: TLabel
        Left = 8
        Top = 48
        Width = 32
        Height = 13
        Caption = 'Output'
      end
      object Label3: TLabel
        Left = 8
        Top = 74
        Width = 51
        Height = 13
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
        Height = 21
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
      Width = 379
      Height = 40
      BorderWidth = 5
      TabOrder = 0
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 348
    Width = 389
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
  object WebActionNoSaveState1: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = WebActionNoSaveState1Execute
    Left = 253
    Top = 205
  end
end
