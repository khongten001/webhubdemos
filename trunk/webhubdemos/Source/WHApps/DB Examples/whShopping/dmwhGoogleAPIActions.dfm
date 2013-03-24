object DMGAPI: TDMGAPI
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object waTestGeoLocation: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waTestGeoLocationExecute
    Left = 88
    Top = 56
  end
end
