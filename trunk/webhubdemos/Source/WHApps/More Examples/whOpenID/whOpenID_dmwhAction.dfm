object DMWHOpenIDviaJanrain: TDMWHOpenIDviaJanrain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 270
  Width = 215
  object waJanrain: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waJanrainExecute
    Left = 88
    Top = 56
  end
  object waOpenIDServer: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waOpenIDServerExecute
    Left = 88
    Top = 136
  end
end
