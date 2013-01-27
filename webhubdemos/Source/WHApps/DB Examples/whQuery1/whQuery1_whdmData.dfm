object DMHTQ1: TDMHTQ1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 367
  Width = 459
  object Query1: TQuery
    AfterOpen = Query1AfterOpen
    Left = 325
    Top = 172
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 245
    Top = 172
  end
  object WebDataSource1: TwhbdeSource
    ComponentOptions = [tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource1
    Left = 149
    Top = 172
  end
  object answergrid: TwhbdeGrid
    ComponentOptions = [tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = WebDataSource1
    Border = 'cellspacing="0"'
    TR = '<tr>'
    TD = '<td>'
    Caption = ''
    ShowRecno = False
    ShowRecJump = False
    Preformat = False
    Left = 61
    Top = 172
  end
end
