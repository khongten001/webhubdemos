inherited fmBendFields: TfmBendFields
  Left = 207
  Top = 175
  Caption = '&Database'
  ClientHeight = 297
  ClientWidth = 551
  ExplicitWidth = 569
  ExplicitHeight = 342
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 551
    Height = 278
    ExplicitWidth = 551
    ExplicitHeight = 278
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 541
      BorderWidth = 5
      TabOrder = 0
    end
    object DBGrid: TDBGrid
      Left = 5
      Top = 45
      Width = 541
      Height = 228
      Align = alClient
      DataSource = DMData2Clone.DataSource1
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -15
      TitleFont.Name = 'Lucida Sans Unicode'
      TitleFont.Style = []
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 278
    Width = 551
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
  end
end
