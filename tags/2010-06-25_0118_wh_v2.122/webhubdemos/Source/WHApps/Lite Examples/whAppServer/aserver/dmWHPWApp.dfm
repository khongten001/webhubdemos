object dmWebHubPowerApp: TdmWebHubPowerApp
  OldCreateOrder = True
  Left = 300
  Top = 421
  Height = 472
  Width = 437
  object CentralInfo: TwhCentralInfo
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    CentralApps = CentralInfo.CentralApps
    Left = 192
    Top = 56
  end
  object tpActionListApp: TtpActionList
    AddConnectorOnly = True
    Left = 80
    Top = 168
    object actWebCommandLineProperties: TAction
      Category = 'hardcoded'
      Caption = 'Properties'
      OnExecute = actWebCommandLinePropertiesExecute
    end
  end
  object app: TwhApplication
    ComponentOptions = [tpUpdateOnLoad, tpQuiet]
    AppID = 'appvers'
    Left = 72
    Top = 56
  end
  object tpActionListCentralInfo: TtpActionList
    AddConnectorOnly = True
    Left = 192
    Top = 168
    object Action1: TAction
      Category = 'hardcoded'
      Caption = 'Properties'
      OnExecute = actWebCommandLinePropertiesExecute
    end
  end
  object tpActionListConnection: TtpActionList
    AddConnectorOnly = True
    Left = 192
    Top = 240
    object Action2: TAction
      Category = 'hardcoded'
      Caption = 'Properties'
      OnExecute = actWebCommandLinePropertiesExecute
    end
  end
end
