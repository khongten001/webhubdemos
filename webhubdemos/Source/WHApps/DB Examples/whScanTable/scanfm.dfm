inherited fmDBPanel: TfmDBPanel
  Left = 316
  Top = 151
  Caption = '&Database'
  ClientHeight = 402
  ClientWidth = 547
  ExplicitWidth = 565
  ExplicitHeight = 447
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 547
    Height = 383
    ExplicitWidth = 547
    ExplicitHeight = 383
    object Panel1: TPanel
      Left = 177
      Top = 5
      Width = 365
      Height = 373
      Align = alClient
      TabOrder = 0
      object DBGrid2: TDBGrid
        Left = 1
        Top = 66
        Width = 363
        Height = 306
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Lucida Sans Unicode'
        TitleFont.Style = []
      end
      object DBNavigator2: TDBNavigator
        Left = 1
        Top = 41
        Width = 363
        Height = 25
        Align = alTop
        TabOrder = 1
      end
      object tpToolBar: TtpToolBar
        Left = 1
        Top = 1
        Width = 363
        TabOrder = 2
        object tpToolButton1: TtpToolButton
          Left = 1
          Top = 1
          Width = 125
          Caption = 'Show Database'
          OnClick = tpToolButton1Click
          MinWidth = 28
        end
      end
    end
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 5
      Width = 172
      Height = 373
      TabOrder = 1
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 383
    Width = 547
    Height = 19
    Panels = <
      item
        Text = 'whbdeSource2: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
  end
end
