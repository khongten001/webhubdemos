object DataModuleAdmin: TDataModuleAdmin
  OldCreateOrder = True
  Height = 243
  Width = 441
  object gfAdmin: TwhdbGrid
    ComponentOptions = [tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = wdsAdmin
    Border = 'cellspacing="0"'
    TR = '<tr>'
    TD = '<td>'
    Caption = ''
    ShowRecno = False
    Preformat = False
    OnHotField = gfAdminHotField
    Left = 238
    Top = 12
  end
  object wdsAdmin: TwhdbSource
    ComponentOptions = [tpStatusPanel]
    GotoMode = wgGotoNearest
    KeyFieldNames = 'Species No'
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSourceFishCost
    Left = 241
    Top = 60
  end
  object DataSourceFishCost: TDataSource
    DataSet = TableFishCost
    Left = 241
    Top = 112
  end
  object TableFishCost: TClientDataSet
    Aggregates = <>
    FileName = 'D:\Projects\webhubdemos\Live\Database\whFishStore\fishcost.xml'
    Params = <>
    BeforePost = TableFishCostBeforePost
    Left = 240
    Top = 176
  end
  object waPostPrice: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waPostPriceExecute
    Left = 88
    Top = 80
  end
end
