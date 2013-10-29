object DemoExtensions: TDemoExtensions
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
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
    Left = 77
    Top = 117
  end
  object waGetExename: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waGetExenameExecute
    Left = 77
    Top = 189
  end
  object waLSec: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waLSecExecute
    Left = 32
    Top = 408
  end
  object waDelaySec: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waDelaySecExecute
    Left = 80
    Top = 248
  end
  object waDemoCaptcha: TwhCaptcha
    ComponentOptions = [tpUpdateOnLoad]
    Left = 288
    Top = 88
  end
  object waImgSrc: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waImgSrcExecute
    Left = 288
    Top = 152
  end
  object FEATURE: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = FEATUREExecute
    Left = 672
    Top = 24
  end
  object waCheckSubnet: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waCheckSubnetExecute
    Left = 288
    Top = 216
  end
  object waFromList: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waFromListExecute
    Left = 288
    Top = 32
  end
  object waCauseAV: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waCauseAVExecute
    Left = 248
    Top = 416
  end
  object waWaitSeconds: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waWaitSecondsExecute
    Left = 80
    Top = 312
  end
  object waSimulateBadNews: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waSimulateBadNewsExecute
    Left = 288
    Top = 280
  end
end
