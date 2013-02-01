object DataModuleHTQ4: TDataModuleHTQ4
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 399
  Width = 492
  object grid1: TwhbdeGrid
    ComponentOptions = [tpUpdateOnLoad]
    DirectCallOk = True
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 3
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = WebDataSource1
    TR = '<tr>'
    TD = '<td>'
    Caption = ''
    Preformat = False
    OnHotField = grid1HotField
    Left = 128
    Top = 52
  end
  object WebDataSource1: TwhbdeSource
    ComponentOptions = [tpUpdateOnGet, tpStatusPanel]
    BendPointers = True
    GotoMode = wgGotoKey
    KeyFieldNames = 'EmpNo'
    MaxOpenDataSets = 20
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource1
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
  object WebDataForm1: TwhdbForm
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnSetCommand = WebDataForm1SetCommand
    WrapMemo = False
    SkipBlank = False
    WebDataSource = WebDataSourceEmp
    Left = 64
    Top = 324
  end
  object WebDataSourceEmp: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
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
  object DataSourceDept: TDataSource
    DataSet = QueryDept
    Left = 320
    Top = 236
  end
  object QueryDept: TQuery
    Left = 320
    Top = 292
  end
end
