object PMforF2H: TPMforF2H
  OldCreateOrder = False
  Left = 259
  Top = 142
  Height = 150
  Width = 215
  object ProjMgr: TtpProject
    InstanceMonitoringMode = simmLimitOneInstance
    OnDataModulesCreate1 = ProjMgrDataModulesCreate1
    OnDataModulesCreate2 = ProjMgrDataModulesCreate2
    OnDataModulesCreate3 = ProjMgrDataModulesCreate3
    OnDataModulesInit = ProjMgrDataModulesInit
    OnGUICreate = ProjMgrGUICreate
    OnGUIInit = ProjMgrGUIInit
    Left = 72
    Top = 32
  end
end
