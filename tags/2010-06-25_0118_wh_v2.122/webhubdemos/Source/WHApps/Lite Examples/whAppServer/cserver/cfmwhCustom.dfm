inherited fmAppCustomPanel: TfmAppCustomPanel
  Left = 157
  Top = 146
  Width = 321
  Height = 245
  Caption = '&Custom'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 313
    Height = 199
    object Splitter1: TSplitter
      Left = 117
      Top = 45
      Width = 6
      Height = 149
      Align = alRight
    end
    object Memo: TtpMemo
      Left = 123
      Top = 45
      Width = 185
      Height = 149
      Align = alRight
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
      ConfirmReadOnly = False
      ClearLines = True
    end
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 303
      BorderWidth = 5
      TabOrder = 1
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 112
      Height = 149
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 2
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 199
    Width = 313
    Height = 19
    Panels = <
      item
        Text = 'WebAction1: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object waTest: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waTestExecute
    WebApp = dmWebHubApp.htWebApp
    Left = 144
    Top = 112
  end
end
