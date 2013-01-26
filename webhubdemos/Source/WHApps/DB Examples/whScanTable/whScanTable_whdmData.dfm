object DMData: TDMData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 347
  Width = 376
  object wdsDBX: TwhdbxSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource1
    Left = 38
    Top = 110
  end
  object sdsScanDemo: TSimpleDataSet
    Aggregates = <>
    Connection.ConnectionName = 'FBConnection'
    Connection.DriverName = 'Firebird'
    Connection.LoginPrompt = False
    Connection.Params.Strings = (
      'DriverName=Firebird'
      'Database=database.gdb'
      'RoleName=RoleName'
      'User_Name=sysdba'
      'Password=masterkey'
      'ServerCharSet='
      'SQLDialect=3'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'BlobSize=-1'
      'CommitRetain=False'
      'WaitOnLocks=True'
      'IsolationLevel=ReadCommitted'
      'Trim Char=False')
    DataSet.CommandText = 'GRAPHICS'
    DataSet.CommandType = ctTable
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    ReadOnly = True
    Left = 262
    Top = 54
  end
  object DataSource1: TDataSource
    DataSet = sdsScanDemo
    Left = 168
    Top = 48
  end
  object BrowseScan: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = True
    WebDataSource = wdsDBX
    OnRowStart = BrowseScanRowStart
    OnInit = BrowseScanInit
    OnFinish = BrowseScanFinish
    Left = 36
    Top = 24
  end
end
