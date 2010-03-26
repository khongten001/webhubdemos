object DataModuleColorScheme: TDataModuleColorScheme
  OldCreateOrder = False
  Left = 153
  Top = 192
  Height = 150
  Width = 215
  object waColorScheme: TwhWebAction
    OnUpdate = waColorSchemeUpdate
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waColorSchemeExecute
    Left = 48
    Top = 32
  end
end
