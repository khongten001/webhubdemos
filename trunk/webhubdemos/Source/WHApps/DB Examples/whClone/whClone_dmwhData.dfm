object DMData2Clone: TDMData2Clone
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 511
  Width = 653
  object Table2: TTable
    TableName = 'BIOLIFE.DB'
    Left = 296
    Top = 128
    object Table2SpeciesNo: TFloatField
      FieldName = 'Species No'
    end
    object Table2Category: TStringField
      FieldName = 'Category'
      Size = 15
    end
    object Table2Common_Name: TStringField
      FieldName = 'Common_Name'
      Size = 30
    end
    object Table2SpeciesName: TStringField
      FieldName = 'Species Name'
      Size = 40
    end
    object Table2Lengthcm: TFloatField
      FieldName = 'Length (cm)'
    end
    object Table2Length_In: TFloatField
      FieldName = 'Length_In'
    end
    object Table2Notes: TMemoField
      FieldName = 'Notes'
      BlobType = ftMemo
      Size = 50
    end
    object Table2Graphic: TGraphicField
      FieldName = 'Graphic'
      BlobType = ftGraphic
    end
  end
  object DataSource2: TDataSource
    DataSet = Table2
    Left = 200
    Top = 128
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
    Left = 96
    Top = 128
  end
  object Table1: TTable
    IndexName = 'ACCT_NBR'
    TableName = 'HOLDINGS.DBF'
    Left = 296
    Top = 32
    object Table1ACCT_NBR: TFloatField
      FieldName = 'ACCT_NBR'
    end
    object Table1SYMBOL: TStringField
      FieldName = 'SYMBOL'
      Size = 7
    end
    object Table1SHARES: TFloatField
      FieldName = 'SHARES'
    end
    object Table1PUR_PRICE: TFloatField
      FieldName = 'PUR_PRICE'
    end
    object Table1PUR_DATE: TDateField
      FieldName = 'PUR_DATE'
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 208
    Top = 40
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
    DataSet = SimpleDataSetXML
    DataSource = DataSourceXML
    Left = 96
    Top = 232
  end
  object SimpleDataSetXML: TSimpleDataSet
    Aggregates = <>
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    FileName = 'D:\Projects\webhubdemos\Live\Database\iso639\xml\countrycode.xml'
    Params = <>
    Left = 312
    Top = 240
  end
  object DataSourceXML: TDataSource
    DataSet = SimpleDataSetXML
    Left = 200
    Top = 240
  end
  object whdbxSourceXMLCloned: TwhdbxSource
    ComponentOptions = [tpUpdateOnLoad]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 3
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSet = SimpleDataSetXML
    DataSource = DataSourceXML
    Left = 96
    Top = 304
  end
end
