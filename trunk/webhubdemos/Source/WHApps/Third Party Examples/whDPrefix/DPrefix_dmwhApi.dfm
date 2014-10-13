object DMWHAPI: TDMWHAPI
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object waJsonApiRequest: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waJsonApiRequestExecute
    Left = 88
    Top = 56
  end
end
