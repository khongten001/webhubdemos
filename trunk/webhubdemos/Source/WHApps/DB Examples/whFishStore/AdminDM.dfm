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
    Border = 'cellspacing="0"'
    TR = '<tr>'
    TD = '<td>'
    ShowRecno = False
    Preformat = False
    OnHotField = gfAdminHotField
    WebDataSource = wdsAdmin
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
    DataSet = TableFishCost
    Left = 241
    Top = 112
  end
  object TableFishCost: TtpTable
    BeforePost = TableFishCostBeforePost
    TableName = 'FISHCOST.DB'
    TableMode = tmData
    PostBeforeClose = False
    HideLinkingKeys = False
    LeaveOpen = False
    Left = 240
    Top = 160
    object TableFishCostSpeciesNo: TFloatField
      FieldName = 'Species No'
    end
    object TableFishCostPrice: TFloatField
      FieldName = 'Price'
    end
    object TableFishCostUpdatedOn: TDateTimeField
      FieldName = 'UpdatedOn'
    end
    object TableFishCostUpdatedBy: TStringField
      FieldName = 'UpdatedBy'
      Size = 8
    end
    object TableFishCostPassword: TStringField
      FieldName = 'Password'
      Size = 2
    end
    object TableFishCostShippingNotes: TMemoField
      FieldName = 'ShippingNotes'
      BlobType = ftMemo
      Size = 1
    end
  end
  object waSaveCurrentFish: TwhWebActionEx
    ComponentOptions = [tpUpdateOnGet]
    OnExecute = waSaveCurrentFishExecute
    Left = 40
    Top = 144
  end
end
