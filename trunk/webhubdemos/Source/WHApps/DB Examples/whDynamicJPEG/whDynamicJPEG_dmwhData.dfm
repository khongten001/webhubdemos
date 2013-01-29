object DMBIOLIFE: TDMBIOLIFE
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 262
  Width = 538
  object ClientDataSet1: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    ProviderName = 'XMLTransformProvider1'
    ReadOnly = True
    Left = 112
    Top = 104
  end
  object XMLTransformProvider1: TXMLTransformProvider
    TransformRead.TransformationFile = 
      'D:\Projects\webhubdemos\Live\Database\radstudio10\BiolifeToDp.xt' +
      'r'
    XMLDataFile = 'D:\Projects\webhubdemos\Live\Database\radstudio10\biolife.xml'
    Left = 112
    Top = 176
  end
  object DataSourceBiolife: TDataSource
    DataSet = ClientDataSet1
    Left = 112
    Top = 32
  end
  object waAnimalNav: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waAnimalNavExecute
    Left = 237
    Top = 117
  end
end
