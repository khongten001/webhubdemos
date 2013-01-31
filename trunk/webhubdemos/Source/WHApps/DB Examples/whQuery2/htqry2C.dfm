inherited fmHTQ2Panel: TfmHTQ2Panel
  Left = 812
  Top = 299
  Caption = 'HTQ2 Database'
  ClientHeight = 253
  ClientWidth = 499
  OnDestroy = FormDestroy
  ExplicitWidth = 517
  ExplicitHeight = 298
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 499
    Height = 234
    ExplicitWidth = 499
    ExplicitHeight = 234
    object DBGrid1: TDBGrid
      Left = 5
      Top = 45
      Width = 489
      Height = 120
      Align = alTop
      Enabled = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -15
      TitleFont.Name = 'Lucida Sans Unicode'
      TitleFont.Style = []
    end
    object Toolbar: TtpToolBar
      Left = 5
      Top = 5
      Width = 489
      TabOrder = 1
      object tpToolButton1: TtpToolButton
        Left = 1
        Top = 1
        Width = 191
        Caption = 'Show Table (using ADO)'
        OnClick = tpToolButton1Click
        MinWidth = 28
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 234
    Width = 499
    Height = 19
    Panels = <
      item
        Text = 'whdbxSource2: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
  end
end
