object DMQuery2: TDMQuery2
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 395
  Width = 574
  object grid: TwhbdeGrid
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    AfterExecute = gridAfterExecute
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 2
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = WebDataSource1
    Border = 'cellspacing="0"'
    TR = '<tr>'
    TD = '<td>'
    Caption = ''
    Preformat = False
    OnHotField = gridHotField
    Left = 53
    Top = 36
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
    Left = 125
    Top = 36
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 221
    Top = 37
  end
  object Query1: TQuery
    BeforeOpen = Query1BeforeOpen
    DatabaseName = 'WebHubDemoData'
    Left = 296
    Top = 45
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
    Left = 120
    Top = 124
  end
  object DataSourceForFullTable: TDataSource
    DataSet = TableComplete
    Left = 221
    Top = 124
  end
  object TableComplete: TTable
    DatabaseName = 'WebHubDemoData'
    Left = 432
    Top = 324
  end
  object WebDataScan1: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = whdbxSource2
    OnRowStart = WebDataScan1RowStart
    OnInit = WebDataScan1Init
    OnFinish = WebDataScan1Finish
    OnEmptyDataSet = WebDataScan1EmptyDataSet
    Left = 40
    Top = 224
  end
  object whdbxSource2: TwhdbxSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSet = ADOQuery1
    DataSource = DataSource2
    Left = 136
    Top = 224
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery1
    Left = 229
    Top = 229
  end
  object ADOQuery1: TADOQuery
    OnFilterRecord = ADOQuery1FilterRecord
    Parameters = <>
    Left = 312
    Top = 224
  end
end
