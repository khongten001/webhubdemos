object DataModuleAdmin: TDataModuleAdmin
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 243
  Width = 441
  object gfAdmin: TwhbdeGrid
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
  object wdsAdmin: TwhbdeSource
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
    Left = 241
    Top = 112
  end
  object waSaveCurrentFish: TwhWebActionEx
    ComponentOptions = []
    OnExecute = waSaveCurrentFishExecute
    Left = 72
    Top = 56
  end
  object TableFishCost: TClientDataSet
    Aggregates = <>
    FileName = 'D:\Projects\webhubdemos\Live\Database\whFishStore\fishcost.xml'
    Params = <>
    Left = 240
    Top = 176
  end
end
