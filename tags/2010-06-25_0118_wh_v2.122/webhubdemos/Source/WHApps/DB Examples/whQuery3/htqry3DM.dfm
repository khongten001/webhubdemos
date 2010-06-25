object DataModuleQ3: TDataModuleQ3
  OldCreateOrder = True
  OnCreate = DataModuleQ3Create
  Left = 266
  Top = 113
  Height = 297
  Width = 381
  object WebDataGrid1: TwhbdeGrid
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    WebDataSource = WebDataSource1
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    Border = 'cellspacing="0"'
    TR = '<tr>'
    TD = '<td>'
    ShowRecno = False
    Preformat = False
    Left = 109
    Top = 12
  end
  object WebDataSource1: TwhbdeSource
    ComponentOptions = [tpStatusPanel]
    OpenDataSets = 0
    OpenDataSetRetain = 600
    MaxOpenDataSets = 20
    GotoMode = wgGotoKey
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
    DatabaseName = 'WebHubDemoData'
    Left = 109
    Top = 156
  end
end
