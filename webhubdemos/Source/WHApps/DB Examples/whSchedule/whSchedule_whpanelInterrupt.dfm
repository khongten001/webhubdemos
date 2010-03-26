inherited fmAppDBInterrupt: TfmAppDBInterrupt
  Left = 157
  Top = 146
  Width = 478
  Height = 315
  Caption = '&Schedule'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 470
    Height = 271
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 460
      BorderWidth = 5
      TabOrder = 0
      object tpToolButton1: TtpToolButton
        Left = 11
        Top = 6
        Width = 45
        Action = ActionDBOFF
        LeaveSpace = True
        MinWidth = 28
      end
      object tpToolButton2: TtpToolButton
        Left = 62
        Top = 6
        Width = 96
        Action = ActionDBOn
        LeaveSpace = True
        MinWidth = 28
      end
      object tpToolButton3: TtpToolButton
        Left = 164
        Top = 6
        Width = 44
        Caption = 'Refresh App'
        OnClick = tpToolButton3Click
        LeaveSpace = True
        MinWidth = 28
      end
      object tpToolButton4: TtpToolButton
        Left = 214
        Top = 6
        Width = 44
        Action = ActionBackup
        LeaveSpace = True
        MinWidth = 28
      end
      object tpToolButton5: TtpToolButton
        Left = 264
        Top = 6
        Width = 44
        Action = ActionRestore
        LeaveSpace = True
        MinWidth = 28
      end
      object tpToolButton6: TtpToolButton
        Left = 309
        Top = 6
        Action = ActionImport
        MinWidth = 28
      end
    end
    object tpComponentPanel: TtpComponentPanel
      Left = 5
      Top = 45
      Width = 100
      Height = 221
      Caption = 'Invisible Parking'
      TabOrder = 1
    end
    object Panel: TPanel
      Left = 105
      Top = 45
      Width = 360
      Height = 221
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 2
    end
  end
  object ActionList1: TActionList
    Left = 29
    Top = 69
    object ActionDBOFF: TAction
      Caption = 'DB OFF'
      OnExecute = ActionDBOFFExecute
    end
    object ActionDBOn: TAction
      Caption = 'DB On (reconnect)'
      OnExecute = ActionDBOnExecute
    end
    object ActionBackup: TAction
      Caption = 'Backup'
      OnExecute = ActionBackupExecute
    end
    object ActionRestore: TAction
      Caption = 'Restore'
      OnExecute = ActionRestoreExecute
    end
    object ActionImport: TAction
      Caption = 'Import'
      Enabled = False
      OnExecute = ActionImportExecute
    end
  end
end
