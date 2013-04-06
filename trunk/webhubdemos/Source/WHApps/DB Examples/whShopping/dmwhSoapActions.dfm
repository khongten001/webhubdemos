object DMSOAPClient: TDMSOAPClient
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object waIp2Country: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waIp2CountryExecute
    Left = 88
    Top = 56
  end
end
