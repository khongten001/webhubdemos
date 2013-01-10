object DMWHOpenIDviaJanrain: TDMWHOpenIDviaJanrain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object waJanrain: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waJanrainExecute
    Left = 88
    Top = 56
  end
end
