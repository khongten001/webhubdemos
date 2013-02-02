object DMContent: TDMContent
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 277
  Width = 569
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 120
    Top = 88
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    FileName = 'D:\Projects\webhubdemos\Live\Database\whLoadFromDB\whcontent.xml'
    Params = <>
    Left = 120
    Top = 152
  end
end
