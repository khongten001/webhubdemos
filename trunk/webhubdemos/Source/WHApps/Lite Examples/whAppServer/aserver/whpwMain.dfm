inherited fmWebHubPowerMainForm: TfmWebHubPowerMainForm
  Left = 255
  Top = 260
  Caption = 'fmWebHubPowerMainForm'
  Menu = MainMenu1
  ExplicitHeight = 240
  PixelsPerInch = 120
  TextHeight = 18
  inherited tpComboBar1: TtpComboBar
    ExplicitWidth = 429
  end
  inherited tpComponentPanel2: TtpComponentPanel
    ExplicitHeight = 170
  end
  inherited StatusBar: TtpStatusBar
    ExplicitTop = 208
    ExplicitWidth = 429
  end
  inherited Restorer: TtpGridRestorer
    Tag = -1
    ZaphodKeyGroupName = 'WebHub'
    Left = 5
    Top = 75
  end
  inherited TrayIcon: TtpTrayIcon
    OnClick = TrayIconClick
    OnMouseDown = TrayIconMouseDown
    Left = 5
  end
  inherited SystemPopUp: TtpSystemPopup
    Left = 67
    object sysmiRefresh: TMenuItem
      Caption = '&Refresh'
      OnClick = sysmiRefreshClick
    end
    object sysmiSuspend: TMenuItem
      Caption = '&Suspend'
      GroupIndex = 1
      OnClick = sysmiSuspendClick
    end
    object sysmiUseWebHub: TMenuItem
      Caption = '&Use WebHub'
      Checked = True
      GroupIndex = 1
      OnClick = sysmiUseWebHubClick
    end
  end
  object ActionListStd: TActionList
    Left = 16
    Top = 120
    object FileExit1: TFileExit
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
    end
    object HelpContents1: THelpContents
      Category = 'Help'
      Caption = '&Contents'
      Enabled = False
      Hint = 'Help Contents'
      ImageIndex = 40
    end
    object actToolbarToolmode: TAction
      Category = 'View'
      Caption = 'Toolbar with Shortcuts'
      OnExecute = actToolbarToolmodeExecute
    end
    object HelpTopicSearch1: THelpTopicSearch
      Category = 'Help'
      Caption = '&Topic Search'
      Enabled = False
      Hint = 'Topic Search'
      ImageIndex = 9
    end
    object actHelpAbout: TAction
      Category = 'Help'
      Caption = 'actHelpAbout'
    end
    object actComponentsListAll: TAction
      Category = 'Components'
      Caption = 'List All Web&Actions'
      OnExecute = actComponentsListAllExecute
    end
    object actToolbarVerbmode: TAction
      Category = 'View'
      Caption = 'Show Component Verb Buttons'
      OnExecute = actToolbarVerbmodeExecute
    end
    object actToolbarNone: TAction
      Category = 'View'
      Caption = 'No Toolbar'
      OnExecute = actToolbarNoneExecute
    end
    object actViewStatusbar: TAction
      Category = 'View'
      Caption = 'Statusbar'
      OnExecute = actViewStatusbarExecute
    end
  end
  object MainMenu1: TMainMenu
    Left = 64
    Top = 120
    object File1: TMenuItem
      Caption = '&File'
      object New2: TMenuItem
        Caption = '&New'
        OnClick = New1Click
      end
      object Open2: TMenuItem
        Caption = '&Open'
        OnClick = Open1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = FileExit1
      end
    end
    object AppID2: TMenuItem
      Caption = 'WebHub&App'
      object Properties6: TMenuItem
        Caption = 'app_Properties'
      end
      object htWebAppRefresh1: TMenuItem
        Caption = 'app_Refresh'
      end
      object htWebAppEditINIFile1: TMenuItem
        Caption = 'app_Edit Config File'
      end
      object htWebAppEditAppSettings1: TMenuItem
        Caption = 'app_Edit AppSettings'
      end
      object htWebAppExportPages1: TMenuItem
        Caption = 'app_Export Pages'
      end
      object htWebAppViewErrors1: TMenuItem
        Caption = 'app_View Errors'
      end
      object htWebAppViewUploadedFiles1: TMenuItem
        Caption = 'app_View Uploaded Files'
      end
      object htWebAppEditMediaServers1: TMenuItem
        Caption = 'app_Edit MediaSources'
      end
      object htWebAppEditFiles1: TMenuItem
        Caption = 'app_Edit Files'
      end
      object htWebAppEditEvents1: TMenuItem
        Caption = 'app_Edit Events'
      end
      object htWebAppEditMacros1: TMenuItem
        Caption = 'app_Edit Macros'
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object miAppUnCoverApp1: TMenuItem
        Caption = 'app_[Un]Cover App'
      end
      object PickAppID2: TMenuItem
        Caption = 'app_Pick AppID'
      end
    end
    object Components2: TMenuItem
      Caption = '&Components'
      object WebInfo2: TMenuItem
        Caption = 'Central&Info'
        object WebInfoProperties1: TMenuItem
          Caption = 'CentralInfo_Properties'
        end
        object WebInfoRefresh1: TMenuItem
          Caption = 'CentralInfo_Refresh'
        end
        object CentralInfoNewAppID1: TMenuItem
          Caption = 'CentralInfo_New AppID'
        end
        object N6: TMenuItem
          Caption = '-'
        end
        object CentralInfoEditCentralConfigFile1: TMenuItem
          Caption = 'CentralInfo_Edit Central Config File'
        end
        object CentralInfoEditNetworkInfoFile1: TMenuItem
          Caption = 'CentralInfo_Edit Network Config File'
        end
        object CentralInfoEditLicenseFile1: TMenuItem
          Caption = 'CentralInfo_Edit License Config File'
        end
        object CentralInfoEditSystemMessagesFile1: TMenuItem
          Caption = 'CentralInfo_Edit System Messages Config File'
        end
        object N5: TMenuItem
          Caption = '-'
        end
        object CentralInfoViewHTTPServers1: TMenuItem
          Caption = 'CentralInfo_View HTTP Servers'
        end
        object CentralInfoViewRunners1: TMenuItem
          Caption = 'CentralInfo_View Runners'
        end
        object CentralInfoViewServerProfiles1: TMenuItem
          Caption = 'CentralInfo_View Server Profiles'
        end
      end
      object WebCommandLine2: TMenuItem
        Caption = 'Connection'
        object miConnectionActive: TMenuItem
          Caption = 'Active'
          OnClick = miConnectionActiveClick
        end
        object WebCommandLineProperties1: TMenuItem
          Caption = 'Connection_Properties'
        end
        object UseWebHubCentral1: TMenuItem
          Caption = 'Use WebHub Central'
          Checked = True
          Default = True
          OnClick = sysmiUseWebHubClick
        end
      end
      object WebCycle2: TMenuItem
        Caption = 'WebC&ycle'
        object Properties1: TMenuItem
          Caption = 'WebCycle_Properties'
          HelpContext = 1
        end
        object EditItems1: TMenuItem
          Caption = 'WebCycle_Edit Items'
        end
        object WebCycleRefresh1: TMenuItem
          Caption = 'WebCycle_Refresh'
          HelpContext = 2
        end
      end
      object WebLogin2: TMenuItem
        Caption = 'Web&Login'
        object Properties2: TMenuItem
          Caption = 'WebLogin_Properties'
          HelpContext = 1
        end
        object EditUserList1: TMenuItem
          Caption = 'WebLogin_Edit User List'
        end
        object Refresh1: TMenuItem
          Caption = 'WebLogin_Refresh'
          HelpContext = 2
        end
      end
      object ListWebActions1: TMenuItem
        Action = actComponentsListAll
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      object ShowTools1: TMenuItem
        Action = actToolbarToolmode
        AutoCheck = True
        Checked = True
        Default = True
        GroupIndex = 1
        RadioItem = True
      end
      object ShowComponentVerbs1: TMenuItem
        Action = actToolbarVerbmode
        AutoCheck = True
        Caption = 'Toolbar with Component Verb Buttons'
        GroupIndex = 1
        RadioItem = True
      end
      object Toolbar1: TMenuItem
        Action = actToolbarNone
        AutoCheck = True
        GroupIndex = 1
        RadioItem = True
      end
      object N4: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object Statusbar1: TMenuItem
        Action = actViewStatusbar
        AutoCheck = True
        Checked = True
        GroupIndex = 2
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Contents1: TMenuItem
        Action = HelpContents1
      end
      object opicSearch1: TMenuItem
        Action = HelpTopicSearch1
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Action = fmAppsetups.actHelpAbout
      end
    end
  end
end
