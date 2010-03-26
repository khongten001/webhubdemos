object DMForWHDemo: TDMForWHDemo
  OldCreateOrder = False
  Height = 150
  Width = 215
  object ProjMgr: TtpProject
    InstanceMonitoringMode = simmIgnoreInstanceNum
    OnDataModulesCreate1 = ProjMgrDataModulesCreate1
    OnDataModulesCreate2 = ProjMgrDataModulesCreate2
    OnDataModulesCreate3 = ProjMgrDataModulesCreate3
    OnDataModulesInit = ProjMgrDataModulesInit
    OnGUICreate = ProjMgrGUICreate
    OnGUIInit = ProjMgrGUIInit
    OnStartupComplete = ProjMgrStartupComplete
    OnStartupError = ProjMgrStartupError
    OnStop = ProjMgrStop
    Left = 40
    Top = 32
  end
end
