object DMWHOpenIDviaJanrain: TDMWHOpenIDviaJanrain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 375
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
  object waSend301: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waSend301Execute
    Left = 80
    Top = 272
  end
end
