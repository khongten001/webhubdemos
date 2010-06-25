inherited fmHTQ1Panel: TfmHTQ1Panel
  Left = 235
  Top = 121
  Width = 434
  Height = 219
  Caption = 'HTQ1'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 426
    Height = 162
    object CheckBox1: TCheckBox
      Left = 8
      Top = 46
      Width = 129
      Height = 17
      Caption = 'Show SQL statement'
      TabOrder = 0
    end
    object tpToolBar2: TtpToolBar
      Left = 5
      Top = 5
      Width = 416
      Height = 28
      TabOrder = 1
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 162
    Width = 426
    Height = 19
    Panels = <
      item
        Text = 'WebDataSource1: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object Table1: TTable
    DatabaseName = 'WebHubDemoData'
    TableName = 'CONTRACT.DB'
    Left = 328
    Top = 60
  end
  object DataSource2: TDataSource
    DataSet = Table1
    Left = 296
    Top = 60
  end
  object Query1: TQuery
    AfterOpen = Query1AfterOpen
    Left = 213
    Top = 116
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 181
    Top = 116
  end
  object WebDataSource1: TwhbdeSource
    ComponentOptions = [tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource1
    Left = 149
    Top = 116
  end
  object answergrid: TwhbdeGrid
    ComponentOptions = [tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    Border = 'cellspacing="0"'
    TR = '<tr>'
    TD = '<td>'
    ShowRecJump = False
    Preformat = False
    WebDataSource = WebDataSource1
    Left = 117
    Top = 116
  end
end
