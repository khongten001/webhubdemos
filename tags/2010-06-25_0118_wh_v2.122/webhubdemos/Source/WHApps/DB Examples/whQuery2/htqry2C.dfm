inherited fmHTQ2Panel: TfmHTQ2Panel
  Left = 812
  Top = 299
  Width = 517
  Height = 298
  Caption = 'HTQ2 Database'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 509
    Height = 235
    object DBGrid1: TDBGrid
      Left = 5
      Top = 45
      Width = 499
      Height = 120
      Align = alTop
      Enabled = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
    object Toolbar: TtpToolBar
      Left = 5
      Top = 5
      Width = 499
      TabOrder = 1
      object tpToolButton1: TtpToolButton
        Left = 1
        Top = 1
        Width = 124
        Caption = 'Show Table (using ADO)'
        OnClick = tpToolButton1Click
        MinWidth = 28
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 235
    Width = 509
    Height = 19
    Panels = <
      item
        Text = 'whdbxSource2: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object wdsFull: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    OpenDataSetVisual = False
    SaveTableName = False
    DataSource = DataSourceForFullTable
    Left = 128
    Top = 180
  end
  object DataSourceForFullTable: TDataSource
    DataSet = TableComplete
    Left = 165
    Top = 180
  end
  object TableComplete: TTable
    DatabaseName = 'WebHubDemoData'
    Left = 200
    Top = 180
  end
  object WebDataSource1: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 3
    OpenDataSets = 0
    OpenDataSetRetain = 600
    OpenDataSetVisual = False
    SaveTableName = False
    DataSource = DataSource1
    Left = 149
    Top = 140
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 181
    Top = 141
  end
  object Query1: TQuery
    BeforeOpen = Query1BeforeOpen
    DatabaseName = 'WebHubDemoData'
    Left = 216
    Top = 141
  end
  object grid: TwhbdeGrid
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    AfterExecute = gridAfterExecute
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 2
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    Border = 'cellspacing="0"'
    TR = '<tr>'
    TD = '<td>'
    Preformat = False
    OnHotField = gridHotField
    WebDataSource = WebDataSource1
    Left = 117
    Top = 140
  end
  object WebDataScan1: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = WebDataScan1RowStart
    OnInit = WebDataScan1Init
    OnFinish = WebDataScan1Finish
    OnEmptyDataSet = WebDataScan1EmptyDataSet
    WebDataSource = whdbxSource2
    Left = 304
    Top = 184
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery1
    Left = 381
    Top = 181
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Data Source=WebHu' +
      'bDemoHTQ2;Initial Catalog=D:\PROJECTS\WEBHUBDEMOS\LIVE\DATABASE' +
      '\WHQUERY2'
    OnFilterRecord = Query2FilterRecord
    Parameters = <>
    Left = 416
    Top = 184
  end
  object whdbxSource2: TwhdbxSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource2
    Left = 344
    Top = 184
  end
end
