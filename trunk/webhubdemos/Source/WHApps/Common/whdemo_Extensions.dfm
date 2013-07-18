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
  object waDelaySec: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waDelaySecExecute
    Left = 208
    Top = 304
  end
  object waDemoCaptcha: TwhCaptcha
    ComponentOptions = [tpUpdateOnLoad]
    Left = 280
    Top = 200
  end
  object waImgSrc: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waImgSrcExecute
    Left = 392
    Top = 272
  end
  object FEATURE: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = FEATUREExecute
    Left = 512
    Top = 144
  end
  object waCheckSubnet: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waCheckSubnetExecute
    Left = 520
    Top = 264
  end
  object waFromList: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waFromListExecute
    Left = 376
    Top = 72
  end
  object waCauseAV: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waCauseAVExecute
    Left = 504
    Top = 376
  end
  object waWaitSeconds: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waWaitSecondsExecute
    Left = 640
    Top = 352
  end
end
