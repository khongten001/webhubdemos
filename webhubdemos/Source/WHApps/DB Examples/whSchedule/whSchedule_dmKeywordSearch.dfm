object DMRubiconSearch: TDMRubiconSearch
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 145
  Width = 401
  object waSelectSearchLogic: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waSelectSearchLogicExecute
    Left = 88
    Top = 56
  end
  object waShowIndex: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waShowIndexExecute
    Left = 248
    Top = 56
  end
end
