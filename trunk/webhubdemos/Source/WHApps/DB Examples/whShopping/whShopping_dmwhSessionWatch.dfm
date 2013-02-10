object DMSessWatch: TDMSessWatch
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object waCountActiveSessions: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad]
    OnExecute = waCountActiveSessionsExecute
    Left = 88
    Top = 56
  end
end
