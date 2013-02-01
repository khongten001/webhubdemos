object DataModuleGrid2: TDataModuleGrid2
  OldCreateOrder = True
  Height = 254
  Width = 323
  object WebDataSource2: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource2
    Left = 104
    Top = 72
  end
  object grid2: TwhbdeGrid
    ComponentOptions = [tpUpdateOnLoad]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 3
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = WebDataSource2
    TR = '<tr>'
    TD = '<td>'
    Caption = ''
    Preformat = False
    OnHotField = grid2HotField
    Left = 104
    Top = 24
  end
  object DataSource2: TDataSource
    DataSet = Query2
    Left = 104
    Top = 112
  end
  object Query2: TQuery
    BeforeOpen = Query2BeforeOpen
    DatabaseName = 'c:\ht\htdemos\demodata'
    Left = 104
    Top = 160
  end
end
