object dmWhRefresh: TdmWhRefresh
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 251
  Top = 103
  Height = 480
  Width = 696
  object waDemoRefresh: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    OnExecute = waDemoRefreshExecute
    Left = 56
    Top = 96
  end
end
