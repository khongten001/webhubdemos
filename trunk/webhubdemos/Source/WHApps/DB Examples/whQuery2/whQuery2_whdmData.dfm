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
  object wdsFull: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    OpenDataSetVisual = False
    SaveTableName = False
    DataSource = DataSourceFull
    Left = 120
    Top = 220
  end
  object DataSourceFull: TDataSource
    DataSet = ADOQueryFull
    Left = 213
    Top = 228
  end
  object WebDataScanAll: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = wdsFull
    OnRowStart = WebDataScanAllRowStart
    OnInit = WebDataScanAllInit
    OnFinish = WebDataScanAllFinish
    OnEmptyDataSet = WebDataScanAllEmptyDataSet
    Left = 40
    Top = 224
  end
  object Query1: TADOQuery
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Extended Properti' +
      'es="DBQ=D:\Projects\webhubdemos\Live\Database\whQuery2\employee.' +
      'mdb;DefaultDir=D:\Projects\webhubdemos\Live\Database\whQuery2;Dr' +
      'iver={Driver do Microsoft Access (*.mdb)};DriverId=25;FIL=MS Acc' +
      'ess;FILEDSN=D:\Projects\webhubdemos\Source\WHApps\DB Examples\wh' +
      'Query2\employeeADO.dsn;MaxBufferSize=2048;MaxScanRows=8;PageTime' +
      'out=5;SafeTransactions=0;Threads=3;UID=admin;UserCommitSync=Yes;' +
      '";Initial Catalog=D:\Projects\webhubdemos\Live\Database\whQuery2' +
      '\employee'
    BeforeOpen = Query1BeforeOpen
    Parameters = <>
    Left = 304
    Top = 40
  end
  object ADOQueryFull: TADOQuery
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Extended Properti' +
      'es="DBQ=D:\Projects\webhubdemos\Live\Database\whQuery2\employee.' +
      'mdb;DefaultDir=D:\Projects\webhubdemos\Live\Database\whQuery2;Dr' +
      'iver={Driver do Microsoft Access (*.mdb)};DriverId=25;FIL=MS Acc' +
      'ess;FILEDSN=D:\Projects\webhubdemos\Source\WHApps\DB Examples\wh' +
      'Query2\employeeADO.dsn;MaxBufferSize=2048;MaxScanRows=8;PageTime' +
      'out=5;SafeTransactions=0;Threads=3;UID=admin;UserCommitSync=Yes;' +
      '";Initial Catalog=D:\Projects\webhubdemos\Live\Database\whQuery2' +
      '\employee'
    BeforeOpen = Query1BeforeOpen
    Parameters = <>
    Left = 320
    Top = 224
  end
end
