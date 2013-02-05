object DMParts: TDMParts
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 435
  Width = 518
  object waPost: TwhWebActionEx
    ComponentOptions = [tpStatusPanel]
    OnExecute = waPostExecute
    Left = 336
    Top = 100
  end
  object grid: TwhdbGrid
    ComponentOptions = [tpStatusPanel]
    OnExecute = gridExecute
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 4
    ScanMode = dsByKey
    ControlsWhere = dsNone
    ButtonsWhere = dsNone
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = WebDataSource1
    TR = '<tr>'
    TD = '<td>'
    Caption = ''
    Preformat = False
    OnHotField = gridHotField
    Left = 173
    Top = 23
  end
  object WebDataForm1: TwhdbForm
    ComponentOptions = [tpStatusPanel]
    WrapMemo = False
    SkipBlank = False
    WebDataSource = WebDataSource1
    Left = 341
    Top = 28
  end
  object WebDataSource1: TwhdbSource
    ComponentOptions = [tpStatusPanel]
    GotoMode = wgGotoKey
    KeyFieldNames = 'PartNo'
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource1
    Left = 173
    Top = 95
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 181
    Top = 167
  end
  object Table1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 184
    Top = 240
  end
end
