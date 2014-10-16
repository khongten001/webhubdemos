object dmwhUIHelpers: TdmwhUIHelpers
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 876
  Width = 662
  object waShowSessionVariables: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waSessionVariablesExecute
    Left = 160
    Top = 40
  end
end
