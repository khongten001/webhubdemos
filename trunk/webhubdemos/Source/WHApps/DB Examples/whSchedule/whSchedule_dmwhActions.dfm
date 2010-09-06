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
end
