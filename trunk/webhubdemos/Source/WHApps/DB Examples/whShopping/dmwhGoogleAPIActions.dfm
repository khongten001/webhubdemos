object DMGAPI: TDMGAPI
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 576
  Width = 215
  object waTestGeoLocation: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waTestGeoLocationExecute
    Left = 88
    Top = 56
  end
  object waTestFreebase: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waTestFreebaseExecute
    Left = 88
    Top = 128
  end
  object waOAuth2StepToken: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waOAuth2StepTokenExecute
    Left = 88
    Top = 272
  end
end
