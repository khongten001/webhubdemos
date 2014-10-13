object DMWHNexus: TDMWHNexus
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 375
  Width = 603
  object waAdminDelete: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waAdminDeleteExecute
    Left = 183
    Top = 118
  end
  object waModify: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waModifyExecute
    Left = 288
    Top = 168
  end
end
