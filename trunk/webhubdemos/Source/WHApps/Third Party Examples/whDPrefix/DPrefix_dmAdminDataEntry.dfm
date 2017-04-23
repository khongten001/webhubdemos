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
    end
    object Act1stLetter: TAction
      Caption = 'Set 1st Letter'
    end
    object ActUpcaseStatus: TAction
      Caption = 'Upcase Status'
    end
    object ActDeleteStatusD: TAction
      Caption = 'Delete where Status is D'
    end
    object ActCreateIndices: TAction
      Caption = 'Create Indices'
    end
    object ActCountPending: TAction
      Caption = 'Count Pending'
    end
    object ActCheckURLs: TAction
      Caption = 'Check URLs'
    end
    object ActAssignPasswords: TAction
      Caption = 'Assign Passwords'
    end
    object ActExportToCSV: TAction
      Caption = 'ActExportToCSV'
    end
    object ActionPurpose: TAction
      Caption = 'Purpose'
    end
    object ActLowercaseEMail: TAction
      Caption = 'Lowercase EMail'
    end
    object ActNoAmpersand: TAction
      Caption = 'No Ampersand'
    end
  end
  object DataSource1: TDataSource
    Left = 166
    Top = 78
  end
  object ManPref: TwhdbScan
    ComponentOptions = []
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 10
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    Left = 22
    Top = 68
  end
end
