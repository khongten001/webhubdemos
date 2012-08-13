object DataModuleQ3: TDataModuleQ3
  OldCreateOrder = True
  OnCreate = DataModuleQ3Create
  Height = 297
  Width = 381
  object WebDataGrid1: TwhbdeGrid
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    Border = 'cellspacing="0"'
    TR = '<tr>'
    TD = '<td>'
    ShowRecno = False
    Preformat = False
    WebDataSource = WebDataSource1
    Left = 109
    Top = 12
  end
  object WebDataSource1: TwhbdeSource
    ComponentOptions = [tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 20
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource1
    Left = 109
    Top = 60
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 109
    Top = 108
  end
  object Query1: TQuery
    AfterOpen = Query1AfterOpen
    DatabaseName = 'WebHubDemoData'
    Left = 109
    Top = 156
  end
end
