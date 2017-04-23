object DMAdminDataEntry: TDMAdminDataEntry
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 482
  Width = 752
  object ActionList1: TActionList
    Left = 80
    Top = 160
    object ActCleanURL: TAction
      Caption = 'Clean URL'
      OnExecute = ActCleanURLExecute
    end
    object Act1stLetter: TAction
      Caption = 'Set 1st Letter'
      OnExecute = Act1stLetterExecute
    end
    object ActUpcaseStatus: TAction
      Caption = 'Upcase Status'
      OnExecute = ActUpcaseStatusExecute
    end
    object ActDeleteStatusD: TAction
      Caption = 'Delete where Status is D'
      OnExecute = ActDeleteStatusDExecute
    end
    object ActCreateIndices: TAction
      Caption = 'Create Indices'
      OnExecute = ActCreateIndicesExecute
    end
    object ActCountPending: TAction
      Caption = 'Count Pending'
      OnExecute = ActCountPendingExecute
    end
    object ActCheckURLs: TAction
      Caption = 'Check URLs'
      OnExecute = ActCheckURLsExecute
    end
    object ActAssignPasswords: TAction
      Caption = 'Assign Passwords'
      OnExecute = ActAssignPasswordsExecute
    end
    object ActExportToCSV: TAction
      Caption = 'ActExportToCSV'
      OnExecute = ActExportToCSVExecute
    end
    object ActionPurpose: TAction
      Caption = 'Purpose'
      OnExecute = ActionPurposeExecute
    end
    object ActLowercaseEMail: TAction
      Caption = 'Lowercase EMail'
      OnExecute = ActLowercaseEMailExecute
    end
    object ActNoAmpersand: TAction
      Caption = 'No Ampersand'
      OnExecute = ActNoAmpersandExecute
    end
  end
  object DataSource1: TDataSource
    Left = 166
    Top = 78
  end
  object ManPref: TwhdbScan
    ComponentOptions = []
    OnExecute = ManPrefExecute
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 10
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = ManPrefRowStart
    OnInit = ManPrefInit
    OnFinish = ManPrefFinish
    Left = 22
    Top = 68
  end
end
