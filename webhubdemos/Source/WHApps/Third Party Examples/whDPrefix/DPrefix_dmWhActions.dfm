object DMDPRWebAct: TDMDPRWebAct
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 355
  Width = 644
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
    Left = 152
    Top = 32
  end
  object waConfirmOpenID: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waConfirmOpenIDExecute
    Left = 64
    Top = 264
  end
  object waURL: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waURLExecute
    OnSetCommand = waURLSetCommand
    Left = 472
    Top = 40
  end
  object waPrice: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waPriceExecute
    Left = 488
    Top = 168
  end
  object waSaveAndroidCountryCode: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waSaveAndroidCountryCodeExecute
    Left = 488
    Top = 224
  end
  object waSelectBigMacCountry: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waSelectBigMacCountryExecute
    Left = 488
    Top = 280
  end
end
