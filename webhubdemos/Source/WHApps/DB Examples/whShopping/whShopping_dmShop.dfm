object DMShop1: TDMShop1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 335
  Width = 654
  object WebDataGrid1: TwhdbGrid
    ComponentOptions = [tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    WebDataSource = WebDataSource1
    OnEmptyDataSet = WebDataGrid1EmptyDataSet
    TR = '<TR>'
    TD = '<TD>'
    Caption = ''
    ShowRecno = False
    Preformat = False
    Left = 32
    Top = 20
  end
  object DataSource1: TDataSource
    DataSet = ADOTable1
    Left = 256
    Top = 28
  end
  object WebActionOrderList: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = WebActionOrderListExecute
    Left = 200
    Top = 180
  end
  object WebActionPostLit: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = WebActionPostLitExecute
    Left = 56
    Top = 172
  end
  object waScrollGrid: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waScrollGridExecute
    Left = 374
    Top = 182
  end
  object ADOConnectionShop1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\Projects\WebHubD' +
      'emos\Live\Database\whShopping\dbdemos.mdb;Persist Security Info=' +
      'False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 368
    Top = 32
  end
  object ADOTable1: TADOTable
    Connection = ADOConnectionShop1
    CursorType = ctStatic
    TableName = 'parts'
    Left = 488
    Top = 32
    object ADOTable1PartNo: TFloatField
      FieldName = 'PartNo'
    end
    object ADOTable1VendorNo: TFloatField
      FieldName = 'VendorNo'
    end
    object ADOTable1Description: TWideStringField
      FieldName = 'Description'
      Size = 30
    end
    object ADOTable1OnHand: TFloatField
      FieldName = 'OnHand'
    end
    object ADOTable1OnOrder: TFloatField
      FieldName = 'OnOrder'
    end
    object ADOTable1Cost: TFloatField
      FieldName = 'Cost'
      currency = True
    end
    object ADOTable1ListPrice: TFloatField
      FieldName = 'ListPrice'
      currency = True
    end
    object ADOTable1QTY: TSmallintField
      FieldKind = fkCalculated
      FieldName = 'QTY'
      OnGetText = Table1QtyGetText
      Calculated = True
    end
  end
  object WebDataSource1: TwhdbSource
    ComponentOptions = [tpUpdateOnLoad]
    GotoMode = wgGotoKey
    KeyFieldNames = 'PartNo'
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource1
    Left = 136
    Top = 24
  end
end
