inherited fmAppDBHTML: TfmAppDBHTML
  Left = 411
  Top = 158
  Caption = '&Database'
  ClientHeight = 551
  ClientWidth = 563
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 581
  ExplicitHeight = 596
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Left = 41
    Width = 522
    Height = 551
    ExplicitLeft = 41
    ExplicitWidth = 532
    ExplicitHeight = 552
    object ToolBar: TtpToolBar
      Left = 5
      Top = 45
      Width = 522
      BorderWidth = 5
      TabOrder = 0
      object EditPath: TEdit
        Tag = 3
        Left = 16
        Top = 8
        Width = 313
        Height = 21
        Hint = 'Enter the path to your WebHub asset table'
        TabOrder = 0
        Text = 'd:\Projects\WebHubDemos\Live\Database\whLoadFromDB\'
      end
      object BtnLoad: TButton
        Left = 344
        Top = 7
        Width = 139
        Height = 25
        Hint = 'Enter the path and then click this button.'
        Caption = 'load pages from db'
        TabOrder = 1
        OnClick = BtnLoadClick
      end
    end
    object Panel: TPanel
      Left = 5
      Top = 85
      Width = 522
      Height = 462
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      object Splitter1: TSplitter
        Left = 0
        Top = 49
        Width = 518
        Height = 8
        Cursor = crVSplit
        Align = alTop
      end
      object DBMemo1: TDBMemo
        Left = 0
        Top = 0
        Width = 518
        Height = 49
        Align = alTop
        DataField = 'Text'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 57
        Width = 518
        Height = 376
        Align = alClient
        DataSource = DataSource1
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Lucida Sans Unicode'
        TitleFont.Style = []
      end
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = 433
        Width = 518
        Height = 25
        DataSource = DataSource1
        Align = alBottom
        TabOrder = 2
      end
    end
    object tpToolBar2: TtpToolBar
      Left = 5
      Top = 5
      Width = 522
      TabOrder = 2
      LeaveSpace = True
      object btnRefresh: TtpToolButton
        Left = 11
        Top = 1
        Width = 64
        Hint = 'Refresh the entire App'
        Caption = ' Refresh All '
        OnClick = btnRefreshClick
        LeaveSpace = True
        MinWidth = 28
      end
      object EditPageID: TEdit
        Left = 88
        Top = 8
        Width = 137
        Height = 21
        Hint = 'Enter DropletID or PageID, then press button.'
        TabOrder = 0
      end
      object btnPostOnePage: TButton
        Left = 240
        Top = 8
        Width = 161
        Height = 25
        Caption = 'Update this Droplet or Page'
        TabOrder = 1
        OnClick = btnPostOnePageClick
      end
    end
  end
  object tpComponentPanel2: TtpComponentPanel
    Left = 0
    Top = 0
    Width = 41
    Height = 551
    TabOrder = 1
    ExplicitHeight = 552
  end
  object Table1: TTable
    AfterPost = Table1AfterPost
    TableName = 'whassets.db'
    Left = 8
    Top = 160
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 8
    Top = 120
  end
end
