object DMForWHDBDemo: TDMForWHDBDemo
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 395
  Top = 138
  Height = 150
  Width = 215
  object ProjMgr: TtpProject
    InstanceMonitoringMode = simmIgnoreInstanceNum
    OnBeforeFirstCreate = ProjMgrBeforeFirstCreate
    OnDataModulesCreate1 = ProjMgrDataModulesCreate1
    OnDataModulesCreate2 = ProjMgrDataModulesCreate2
    OnDataModulesCreate3 = ProjMgrDataModulesCreate3
    OnDataModulesInit = ProjMgrDataModulesInit
    OnGUICreate = ProjMgrGUICreate
    OnGUIInit = ProjMgrGUIInit
    OnStartupError = ProjMgrStartupError
    OnStop = ProjMgrStop
    Left = 40
    Top = 32
  end
end
