object whDataModule: TwhDataModule
  OldCreateOrder = True
  Left = 187
  Top = 176
  Height = 179
  Width = 581
  object CentralInfo: TwhCentralInfo
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    CentralApps = CentralInfo.CentralApps
    Left = 158
    Top = 22
  end
  object waF2H: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    OnExecute = waF2HExecute
    WebApp = app
    Left = 400
    Top = 20
  end
  object waRESETNOW: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    OnExecute = waRESETNOWExecute
    WebApp = app
    Left = 473
    Top = 20
  end
  object app: TwhApplication
    OnUpdate = appUpdate
    ComponentOptions = []
    AppID = 'dfm2html'
    OnNewSession = appNewSession
    Left = 80
    Top = 24
  end
end
