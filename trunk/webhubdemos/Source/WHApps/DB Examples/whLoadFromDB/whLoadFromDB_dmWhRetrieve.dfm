object dmWhRetrieve: TdmWhRetrieve
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Height = 346
  Width = 303
  object waSETLOCAL: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    OnExecute = waSETLOCALExecute
    Left = 144
    Top = 80
  end
  object waCLEARLOCAL: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    OnExecute = waCLEARLOCALExecute
    Left = 144
    Top = 136
  end
  object waLOCAL: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    OnExecute = waLOCALExecute
    Left = 144
    Top = 192
  end
end
