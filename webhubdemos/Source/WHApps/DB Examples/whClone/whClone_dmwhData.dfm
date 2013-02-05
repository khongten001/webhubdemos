object DMData2Clone: TDMData2Clone
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 511
  Width = 759
  object Table2: TTable
    TableName = 'BIOLIFE.DB'
    Left = 384
    Top = 120
  end
  object DataSource2: TDataSource
    DataSet = Table2
    Left = 248
    Top = 120
  end
  object WebDataSource2: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    BendPointers = True
    GotoMode = wgGotoKey
    KeyFieldNames = 'Species No'
    MaxOpenDataSets = 5
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource2
    Left = 104
    Top = 120
  end
  object Table1: TTable
    DatabaseName = 'D:\Projects\webhubdemos\Live\Database\whClone'
    IndexName = 'HOLDINGNO'
    TableName = 'HOLDINGS.DBF'
    Left = 384
    Top = 32
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 248
    Top = 32
  end
  object WebDataSource1: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = WebDataSource1Execute
    BendPointers = True
    GotoMode = wgGotoKey
    KeyFieldNames = 'ACCT_NBR'
    MaxOpenDataSets = 5
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    OnFindKeys = WebDataSource1FindKeys
    DataSource = DataSource1
    Left = 104
    Top = 32
  end
  object whdbxSourceXML: TwhdbxSource
    ComponentOptions = [tpUpdateOnLoad]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSourceXML
    Left = 104
    Top = 208
  end
  object SimpleDataSetXML: TSimpleDataSet
    Aggregates = <>
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    FileName = 'D:\Projects\webhubdemos\Live\Database\iso639\xml\countrycode.xml'
    Params = <>
    Left = 384
    Top = 208
  end
  object DataSourceXML: TDataSource
    DataSet = SimpleDataSetXML
    Left = 248
    Top = 208
  end
  object whdbxSourceXMLCloned: TwhdbxSource
    ComponentOptions = [tpUpdateOnLoad]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 3
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSourceXmlCloned
    Left = 104
    Top = 296
  end
  object whdbxSourceDBF: TwhdbxSource
    ComponentOptions = [tpUpdateOnLoad]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSourceDBF4DBX
    Left = 104
    Top = 384
  end
  object DataSourceDBF4DBX: TDataSource
    DataSet = ClientDataSetDBF
    Left = 248
    Top = 384
  end
  object ClientDataSetDBF: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProviderDBF'
    Left = 384
    Top = 384
  end
  object DataSetProviderDBF: TDataSetProvider
    DataSet = TableDBase
    Options = [poReadOnly, poAutoRefresh, poUseQuoteChar]
    Left = 496
    Top = 384
  end
  object TableDBase: TTable
    IndexName = 'ACCT_NBR'
    TableName = 'HOLDINGS.DBF'
    Left = 600
    Top = 384
    object FloatField1: TFloatField
      FieldName = 'ACCT_NBR'
    end
    object StringField1: TStringField
      FieldName = 'SYMBOL'
      Size = 7
    end
    object FloatField2: TFloatField
      FieldName = 'SHARES'
    end
    object FloatField3: TFloatField
      FieldName = 'PUR_PRICE'
    end
    object DateField1: TDateField
      FieldName = 'PUR_DATE'
    end
  end
  object DataSourceXmlCloned: TDataSource
    DataSet = SimpleDataSetXML
    Left = 248
    Top = 296
  end
end
