object dmwhUIHelpers: TdmwhUIHelpers
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object waCodeSite: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waCodeSiteExecute
    Left = 88
    Top = 56
  end
end
