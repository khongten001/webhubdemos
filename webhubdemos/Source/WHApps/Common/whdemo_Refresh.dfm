object dmWhRefresh: TdmWhRefresh
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 251
  Top = 103
  Height = 480
  Width = 696
  object tpSharedLongint: TtpSharedInt32
    GlobalName = 'WebHubDemo'
    GlobalValue = 0
    IgnoreOwnChanges = True
    OnChange = tpSharedLongintChange
    Left = 56
    Top = 32
  end
  object waDemoRefresh: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    OnExecute = waDemoRefreshExecute
    Left = 56
    Top = 96
  end
end
