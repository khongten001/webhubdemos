object DMShop1: TDMShop1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 335
  Width = 654
  object WebDataSource1: TwhbdeSource
    ComponentOptions = [tpStatusPanel]
    GotoMode = wgGotoKey
    KeyFieldNames = 'PartNo'
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource1
    Left = 136
    Top = 68
  end
  object WebDataGrid1: TwhbdeGrid
    ComponentOptions = [tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    Border = 'BORDER'
    TR = '<TR>'
    TD = '<TD>'
    ShowRecno = False
    Preformat = False
    Left = 32
    Top = 68
  end
  object DataSource1: TDataSource
    Left = 32
    Top = 124
  end
  object WebActionOrderList: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = WebActionOrderListExecute
    Left = 112
    Top = 140
  end
  object WebActionPostLit: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = WebActionPostLitExecute
    Left = 56
    Top = 188
  end
  object waScrollGrid: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waScrollGridExecute
    Left = 134
    Top = 198
  end
  object ADOConnectionShop1: TADOConnection
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 312
    Top = 152
  end
end
