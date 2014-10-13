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
  object waConfirmOpenID: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waConfirmOpenIDExecute
    Left = 248
    Top = 216
  end
  object waURL: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waURLExecute
    OnSetCommand = waURLSetCommand
    Left = 328
    Top = 48
  end
  object waPrice: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waPriceExecute
    Left = 376
    Top = 136
  end
  object waSaveAndroidCountryCode: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waSaveAndroidCountryCodeExecute
    Left = 376
    Top = 200
  end
end
