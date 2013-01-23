object DMEmployeeFire: TDMEmployeeFire
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 316
  Width = 629
  object waField: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    Left = 237
    Top = 13
  end
  object waMoney: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waMoneyExecute
    Left = 309
    Top = 13
  end
  object ScanEmployee3: TwhdbScan
    ComponentOptions = [tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnBeginTable = ScanEmployeeBeginTable
    Left = 93
    Top = 133
  end
  object ScanEmployee2: TwhdbScan
    ComponentOptions = [tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnBeginTable = ScanEmployeeBeginTable
    Left = 53
    Top = 69
  end
  object ScanEmployee1: TwhdbScan
    ComponentOptions = []
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = ScanEmployee1RowStart
    OnBeginTable = ScanEmployeeBeginTable
    OnFinish = ScanEmployee1Finish
    Left = 29
    Top = 13
  end
end
