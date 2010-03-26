object fmF2HDemo: TfmF2HDemo
  Left = 227
  Top = 165
  Width = 240
  Height = 231
  Caption = 'F2H Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 16
    Width = 130
    Height = 25
    Action = app_EditFiles1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 17
    Top = 50
    Width = 130
    Height = 25
    HelpContext = 2
    Action = app_Refresh1
    TabOrder = 1
  end
  object Button3: TButton
    Left = 16
    Top = 83
    Width = 130
    Height = 25
    Caption = 'Show Form'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button6: TButton
    Left = 16
    Top = 158
    Width = 130
    Height = 25
    Action = app_EditConfigFile1
    TabOrder = 3
  end
  object Button4: TButton
    Left = 16
    Top = 120
    Width = 130
    Height = 25
    HelpContext = 1
    Action = app_Properties1
    TabOrder = 4
  end
  object tpActionListApp: TtpActionList
    ComponentConnector = whDataModule.app
    AddConnectorOnly = True
    Left = 176
    Top = 24
    object app_Edit01: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 0
    end
    object app_Save01: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 1
    end
    object app_Reload01: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 2
    end
    object app_SelectSession1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 3
    end
    object app_DeleteSessions1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 4
    end
    object app_Separator1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 5
    end
    object app_PickAppID1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 6
    end
    object app_EditPages1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 7
    end
    object app_EditMacros1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 8
    end
    object app_EditEvents1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 9
    end
    object app_EditFiles1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 10
    end
    object app_EditChunks1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 11
    end
    object app_EditMediaSources1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 12
    end
    object app_ViewUploadedFiles1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 13
    end
    object app_ViewErrors1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 14
    end
    object app_ExportPages1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 15
    end
    object app_EditAppSettings1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 16
    end
    object app_EditConfigFile1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 17
    end
    object app_UnCoverApp1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 18
    end
    object app_TestComponent1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 19
    end
    object app_Update1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 20
    end
    object app_Refresh1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 21
    end
    object app_Help1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 22
    end
    object app_Properties1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 23
    end
  end
end
