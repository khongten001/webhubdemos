inherited fmAppDBHTML: TfmAppDBHTML
  Left = 411
  Top = 158
  Caption = '&Database'
  ClientHeight = 551
  ClientWidth = 720
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 738
  ExplicitHeight = 596
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Left = 41
    Width = 679
    Height = 551
    ExplicitLeft = 41
    ExplicitWidth = 522
    ExplicitHeight = 551
    object ToolBar: TtpToolBar
      Left = 5
      Top = 45
      Width = 669
      BorderWidth = 5
      TabOrder = 0
      ExplicitWidth = 512
      object BtnLoad: TButton
        Left = 11
        Top = 6
        Width = 193
        Height = 25
        Hint = 'Enter the path and then click this button.'
        Caption = 'Toggle Open/Close DB'
        TabOrder = 0
        OnClick = BtnLoadClick
      end
    end
    object Panel: TPanel
      Left = 5
      Top = 85
      Width = 669
      Height = 461
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      ExplicitWidth = 512
      object Splitter1: TSplitter
        Left = 0
        Top = 97
        Width = 665
        Height = 8
        Cursor = crVSplit
        Align = alTop
        ExplicitTop = 49
        ExplicitWidth = 518
      end
      object DBMemo1: TDBMemo
        Left = 0
        Top = 0
        Width = 665
        Height = 97
        Align = alTop
        DataField = 'Text'
        DataSource = DMContent.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 105
        Width = 665
        Height = 327
        Align = alClient
        DataSource = DMContent.DataSource1
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Lucida Sans Unicode'
        TitleFont.Style = []
      end
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = 432
        Width = 665
        Height = 25
        Align = alBottom
        TabOrder = 2
        ExplicitWidth = 508
      end
    end
    object tpToolBar2: TtpToolBar
      Left = 5
      Top = 5
      Width = 669
      TabOrder = 2
      LeaveSpace = True
      ExplicitWidth = 512
      object btnRefresh: TtpToolButton
        Left = 11
        Top = 1
        Width = 102
        Hint = 'Refresh the entire App'
        Caption = ' Refresh All '
        OnClick = btnRefreshClick
        LeaveSpace = True
        MinWidth = 28
      end
      object btnPostOnePage: TButton
        Left = 286
        Top = 7
        Width = 123
        Height = 24
        Caption = 'Save 1 Page'
        TabOrder = 0
        OnClick = btnPostOnePageClick
      end
      object EditPageID: TEdit
        Tag = 3
        Left = 128
        Top = 6
        Width = 137
        Height = 26
        TabOrder = 1
        Text = 'cinnamon'
      end
    end
  end
  object tpComponentPanel2: TtpComponentPanel
    Left = 0
    Top = 0
    Width = 41
    Height = 551
    TabOrder = 1
  end
end
