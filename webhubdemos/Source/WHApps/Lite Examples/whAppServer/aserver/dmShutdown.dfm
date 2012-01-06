object DataModuleShutdown: TDataModuleShutdown
  OldCreateOrder = False
  Left = 655
  Top = 127
  Height = 150
  Width = 215
  object tpSharedLongint1: TtpSharedInt32
    GlobalName = 'AppShutdown'
    GlobalValue = 0
    IgnoreOwnChanges = True
    OnChange = tpSharedLongint1Change
    Left = 56
    Top = 32
  end
end
