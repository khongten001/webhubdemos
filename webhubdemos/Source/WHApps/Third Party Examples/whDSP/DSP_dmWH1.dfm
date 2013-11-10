object dmDSPWebSearch: TdmDSPWebSearch
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 152
  Width = 263
  object waSearch: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waSearchExecute
    DirectCallOk = True
    Left = 64
    Top = 8
  end
end
