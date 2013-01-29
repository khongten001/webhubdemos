object DMBIOLIFE: TDMBIOLIFE
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 262
  Width = 538
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    FileName = 'D:\Projects\webhubdemos\Live\Database\embSample\biolife.xml'
    Params = <>
    ReadOnly = True
    Left = 112
    Top = 104
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
