object DataModuleHTQ4: TDataModuleHTQ4
  OldCreateOrder = True
  Left = 380
  Top = 120
  Height = 283
  Width = 492
  object grid1: TwhbdeGrid
    ComponentOptions = [tpUpdateOnLoad]
    DirectCallOk = True
    WebDataSource = WebDataSource1
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 3
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    TR = '<tr>'
    TD = '<td>'
    Preformat = False
    OnHotField = grid1HotField
    Left = 128
    Top = 52
  end
  object WebDataSource1: TwhbdeSource
    ComponentOptions = [tpUpdateOnGet, tpStatusPanel]
    OpenDataSets = 0
    OpenDataSetRetain = 600
    MaxOpenDataSets = 20
    BendPointers = True
    GotoMode = wgGotoKey
    SaveTableName = False
    DataSource = DataSource1
    KeyFieldNames = 'EmpNo'
    Left = 128
    Top = 100
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 128
    Top = 148
  end
  object Query1: TQuery
    BeforeOpen = Query1BeforeOpen
    Left = 128
    Top = 196
  end
  object WebDataForm1: TwhbdeForm
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet, tpStatusPanel]
    Border = 'cellspacing="0"'
    WrapMemo = False
    SkipBlank = False
    WebDataSource = WebDataSourceEmp
    Left = 320
    Top = 20
  end
  object WebDataSourceEmp: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet, tpStatusPanel]
    OpenDataSets = 0
    OpenDataSetRetain = 600
    MaxOpenDataSets = 1
    GotoMode = wgGotoKey
    SaveTableName = False
    DataSource = DataSourceEmp
    Left = 320
    Top = 64
  end
  object DataSourceEmp: TDataSource
    DataSet = TableEmp
    Left = 320
    Top = 108
  end
  object TableEmp: TTable
    TableName = 'EMPLOYEE.DB'
    TableType = ttParadox
    Left = 320
    Top = 152
  end
  object WebAction1: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = WebAction1Execute
    DirectCallOk = True
    Left = 24
    Top = 104
  end
end
