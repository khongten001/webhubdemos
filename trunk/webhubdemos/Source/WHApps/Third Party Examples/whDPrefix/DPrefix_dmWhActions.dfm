object DMDPRWebAct: TDMDPRWebAct
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 306
  Width = 448
  object waAdd: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waAddExecute
    Left = 72
    Top = 32
  end
  object waCountPending: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waCountPendingExecute
    Left = 72
    Top = 104
  end
  object waCleanup2013Login: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waCleanup2013LoginExecute
    Left = 72
    Top = 168
  end
  object waDelete: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waDeleteExecute
    OnSetCommand = waDeleteSetCommand
    Left = 208
    Top = 136
  end
end
