object DMDPRWebAct: TDMDPRWebAct
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 236
  Width = 224
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
end
