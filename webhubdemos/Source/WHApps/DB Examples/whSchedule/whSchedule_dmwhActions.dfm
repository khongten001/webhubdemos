object DMCodeRageActions: TDMCodeRageActions
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 277
  Width = 656
  object ScanSchedule: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = ScanScheduleExecute
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ControlsWhere = dsNone
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = ScanScheduleRowStart
    OnInit = ScanScheduleInit
    OnFinish = ScanScheduleFinish
    Left = 64
    Top = 40
  end
  object waOnAt: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waOnAtExecute
    Left = 176
    Top = 72
  end
  object waRepeatOf: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waRepeatOfExecute
    Left = 224
    Top = 152
  end
  object ScanAbout: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = ScanScheduleExecute
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = ScanAboutRowStart
    OnInit = ScanScheduleInit
    OnFinish = ScanScheduleFinish
    Left = 64
    Top = 128
  end
  object waFindSchedule: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waFindScheduleExecute
    Left = 560
    Top = 112
  end
  object waDownload: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waDownloadExecute
    Left = 592
    Top = 24
  end
  object waPKtoStringVars: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waPKtoStringVarsExecute
    Left = 560
    Top = 160
  end
  object waUpdateFromStringVars: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waUpdateFromStringVarsExecute
    Left = 560
    Top = 208
  end
end
