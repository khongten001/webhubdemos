inherited fmHTFMPanel: TfmHTFMPanel
  Left = 537
  Top = 118
  Caption = 'HTFM Table'
  ClientHeight = 330
  ClientWidth = 415
  ExplicitWidth = 433
  ExplicitHeight = 375
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 415
    Height = 311
    ExplicitWidth = 415
    ExplicitHeight = 311
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 5
      Width = 100
      Height = 301
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 105
      Top = 5
      Width = 305
      Height = 301
      Align = alClient
      TabOrder = 1
      object DBGrid2: TDBGrid
        Left = 1
        Top = 26
        Width = 303
        Height = 274
        Align = alClient
        DataSource = DMParts.DataSource1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Lucida Sans Unicode'
        TitleFont.Style = []
      end
      object DBNavigator2: TDBNavigator
        Left = 1
        Top = 1
        Width = 303
        Height = 25
        DataSource = DMParts.DataSource1
        Align = alTop
        TabOrder = 1
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 311
    Width = 415
    Height = 19
    Panels = <
      item
        Text = 'waPost: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
  end
end
