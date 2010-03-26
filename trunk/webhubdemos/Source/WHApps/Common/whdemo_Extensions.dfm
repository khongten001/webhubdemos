object DemoExtensions: TDemoExtensions
  OldCreateOrder = True
  OnDestroy = DataModuleDestroy
  Left = 285
  Top = 161
  Height = 479
  Width = 741
  object WebLogin: TwhLogin
    ComponentOptions = [tpUpdateOnLoad]
    UserIndex = -1
    Left = 112
    Top = 24
  end
  object WebCycle: TwhCycle
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    Left = 184
    Top = 24
  end
  object waVersionInfo: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waVersionInfoExecute
    Left = 93
    Top = 181
  end
  object waGetExename: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waGetExenameExecute
    Left = 93
    Top = 237
  end
  object waLSec: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waLSecExecute
    Left = 96
    Top = 312
  end
end
