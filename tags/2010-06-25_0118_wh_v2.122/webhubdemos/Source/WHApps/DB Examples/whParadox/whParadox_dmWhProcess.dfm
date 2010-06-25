object dmwhProcess: TdmwhProcess
  OldCreateOrder = False
  Left = 685
  Top = 138
  Height = 150
  Width = 339
  object scanTable: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = whdbxSource2
    Left = 24
    Top = 32
  end
  object whdbxSource2: TwhdbxSource
    ComponentOptions = [tpUpdateOnLoad]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource1
    Left = 88
    Top = 32
  end
  object DataSource1: TDataSource
    DataSet = SimpleDataSet1
    Left = 152
    Top = 32
  end
  object SimpleDataSet1: TSimpleDataSet
    Aggregates = <>
    DataSet.CommandText = 'select * from tocoutln'
    DataSet.CommandType = ctTable
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 232
    Top = 32
  end
end
