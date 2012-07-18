object DMRubiconSearch: TDMRubiconSearch
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object waSelectSearchLogic: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waSelectSearchLogicExecute
    Left = 88
    Top = 56
  end
end
