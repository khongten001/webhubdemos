object fmF2HDemo: TfmF2HDemo
  Left = 227
  Top = 165
  Caption = 'F2H Demo'
  ClientHeight = 308
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 120
  TextHeight = 16
  object ButtonEditFiles: TButton
    Left = 20
    Top = 20
    Width = 160
    Height = 30
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Action = app_EditFiles1
    TabOrder = 0
  end
  object ButtonAppRefresh: TButton
    Left = 21
    Top = 62
    Width = 160
    Height = 30
    HelpContext = 2
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Action = app_Refresh1
    TabOrder = 1
  end
  object ButtonShowForm: TButton
    Left = 20
    Top = 102
    Width = 160
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Show Form'
    TabOrder = 2
    OnClick = ButtonShowFormClick
  end
  object ButtonEditConfigFile: TButton
    Left = 20
    Top = 194
    Width = 160
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Action = app_EditConfigFile1
    TabOrder = 3
  end
  object ButtonAppProperties: TButton
    Left = 20
    Top = 148
    Width = 160
    Height = 30
    HelpContext = 1
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Action = app_Properties1
    TabOrder = 4
  end
  object tpActionListApp: TtpActionList
    ComponentConnector = whDataModule.app
    AddConnectorOnly = True
    Left = 240
    Top = 24
    object app_PickAppID1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 0
    end
    object app_EditPages1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 1
    end
    object app_EditMacros1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 2
    end
    object app_EditEvents1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 3
    end
    object app_EditFiles1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 4
    end
    object app_EditDroplets1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 5
    end
    object app_EditMediaSources1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 6
    end
    object app_ViewUploadedFiles1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 7
    end
    object app_ViewErrors1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 8
    end
    object app_ExportPages1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 9
    end
    object app_EditAppSettings1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 10
    end
    object app_EditConfigFile1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 11
    end
    object app_OpenErrorLogFolder1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 12
    end
    object app_UnCoverApp1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 13
    end
    object app_TestComponent1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 14
    end
    object app_Update1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 15
    end
    object app_Refresh1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 16
    end
    object app_Help1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 17
    end
    object app_Properties1: TtpVCLAction
      tpComponent = whDataModule.app
      VerbIndex = 18
    end
  end
end
