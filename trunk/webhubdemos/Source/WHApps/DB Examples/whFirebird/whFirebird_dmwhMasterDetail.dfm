object DMMastDet: TDMMastDet
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 281
  Width = 539
  object ScanMasterDept: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpCXSetIfFoundDuringUpdate]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    Left = 64
    Top = 48
  end
  object ScanDetailEmployee: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpCXSetIfFoundDuringUpdate]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    Left = 64
    Top = 120
  end
end
