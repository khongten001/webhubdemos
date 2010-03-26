inherited fmWhProcess: TfmWhProcess
  Left = 406
  Top = 158
  Width = 484
  Height = 270
  Caption = '&Paradox'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 476
    Height = 207
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 466
      BorderWidth = 5
      TabOrder = 0
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 466
      Height = 157
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 207
    Width = 476
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
end
