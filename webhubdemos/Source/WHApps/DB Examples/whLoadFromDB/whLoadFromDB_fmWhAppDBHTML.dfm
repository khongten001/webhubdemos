inherited fmAppDBHTML: TfmAppDBHTML
  Left = 411
  Top = 158
  Caption = '&Database'
  ClientHeight = 551
  ClientWidth = 720
  ExplicitWidth = 738
  ExplicitHeight = 596
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Left = 41
    Width = 679
    Height = 551
    ExplicitLeft = 41
    ExplicitWidth = 679
    ExplicitHeight = 551
    object ToolBar: TtpToolBar
      Left = 5
      Top = 45
      Width = 669
      BorderWidth = 5
      TabOrder = 0
      object BtnLoad: TtpToolButton
        Left = 6
        Top = 6
        Width = 186
        Caption = 'Toggle Open/Close DB'
        OnClick = BtnLoadClick
        MinWidth = 28
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
        Font.Height = -18
        Font.Name = 'Lucida Sans Unicode'
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
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Lucida Sans Unicode'
        Font.Style = []
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
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
        DataSource = DMContent.DataSource1
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh, nbApplyUpdates, nbCancelUpdates]
        Align = alBottom
        TabOrder = 2
      end
    end
    object tpToolBar2: TtpToolBar
      Left = 5
      Top = 5
      Width = 669
      TabOrder = 2
      LeaveSpace = True
      object btnPostOnePage: TButton
        Left = 286
        Top = 7
        Width = 123
        Height = 24
        Caption = 'Save 1 Page'
        Enabled = False
        TabOrder = 0
        OnClick = btnPostOnePageClick
      end
      object EditPageID: TEdit
        Tag = 3
        Left = 128
        Top = 6
        Width = 137
        Height = 26
        Enabled = False
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
