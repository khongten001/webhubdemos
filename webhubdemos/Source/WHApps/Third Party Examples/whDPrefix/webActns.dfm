inherited fmAppDataScan: TfmAppDataScan
  Left = 298
  Top = 150
  Width = 543
  Height = 483
  Caption = '&ManPref Database'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 535
    Height = 437
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 525
      Height = 40
      Align = alTop
      BorderWidth = 5
      TabOrder = 0
      LeaveSpace = False
      object tpToolButton1: TtpToolButton
        Left = 5
        Top = 6
        Width = 99
        Height = 28
        Caption = 'Toggle Grid Display'
        OnClick = tpToolButton1Click
        LeaveSpace = True
        MinWidth = 28
      end
      object tpToolButton2: TtpToolButton
        Left = 105
        Top = 6
        Width = 57
        Height = 28
        Caption = 'Create IDs'
        OnClick = tpToolButton2Click
        LeaveSpace = False
        MinWidth = 28
      end
    end
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 45
      Width = 212
      Height = 387
      Align = alLeft
      TabOrder = 1
      object GroupBox1: TGroupBox
        Left = 1
        Top = 321
        Width = 210
        Height = 64
        Align = alTop
        Caption = 'Download ZIP'
        TabOrder = 0
      end
      object GroupBox2: TGroupBox
        Left = 1
        Top = 1
        Width = 210
        Height = 64
        Align = alTop
        Caption = 'Required WebHub Components'
        TabOrder = 1
      end
      object GroupBox3: TGroupBox
        Left = 1
        Top = 65
        Width = 210
        Height = 64
        Align = alTop
        Caption = 'View-only DB Display'
        TabOrder = 2
      end
      object GroupBox4: TGroupBox
        Left = 1
        Top = 193
        Width = 210
        Height = 64
        Align = alTop
        Caption = 'Admin Browse'
        TabOrder = 3
      end
      object GroupBox5: TGroupBox
        Left = 1
        Top = 129
        Width = 210
        Height = 64
        Align = alTop
        Caption = 'Secure Login '
        TabOrder = 4
      end
      object GroupBox6: TGroupBox
        Left = 1
        Top = 257
        Width = 210
        Height = 64
        Align = alTop
        Caption = 'Editing + Posting + Deleting'
        TabOrder = 5
      end
    end
    object Panel1: TPanel
      Left = 217
      Top = 45
      Width = 313
      Height = 387
      Align = alClient
      TabOrder = 2
      object DBGrid1: TDBGrid
        Left = 1
        Top = 1
        Width = 311
        Height = 360
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object DBNavigator1: TDBNavigator
        Left = 1
        Top = 361
        Width = 311
        Height = 25
        Align = alBottom
        TabOrder = 1
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 437
    Width = 535
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
  end
  object wdsManPref: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    WebIni = DesignTimeINI
    OpenDataSets = 0
    OpenDataSetRetain = 600
    MaxOpenDataSets = 1
    GotoMode = wgGotoKey
    SaveTableName = False
    DataSource = DataSource1
    Left = 54
    Top = 134
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 94
    Top = 134
  end
  object Table1: TTable
    Filtered = True
    OnFilterRecord = Table1FilterRecord
    TableName = 'MANPREF.DB'
    Left = 126
    Top = 134
  end
  object ManPref: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    WebIni = DesignTimeINI
    WebDataSource = wdsManPref
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 10
    ScanMode = dsByKey
    ControlsWhere = dsbAbove
    ButtonsWhere = dsbAbove
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = ManPrefRowStart
    OnInit = ManPrefInit
    OnFinish = ManPrefFinish
    Left = 14
    Top = 132
  end
  object WebLogin: TwhLogin
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    WebIni = DesignTimeINI
    UserIndex = -1
    Left = 22
    Top = 198
  end
  object waPrefixLink: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waPrefixLinkExecute
    WebIni = DesignTimeINI
    Left = 118
    Top = 254
  end
  object WebDataForm: TwhbdeForm
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnSetCommand = WebDataFormSetCommand
    WebIni = DesignTimeINI
    Border = 'BORDER'
    WrapMemo = False
    SkipBlank = False
    WebDataSource = wdsAdmin
    OnField = WebDataFormField
    Left = 22
    Top = 326
  end
  object waModify: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waModifyExecute
    WebIni = DesignTimeINI
    Left = 62
    Top = 326
  end
  object wdsAdmin: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    WebIni = DesignTimeINI
    OpenDataSets = 0
    OpenDataSetRetain = 600
    MaxOpenDataSets = 1
    GotoMode = wgGotoKey
    SaveTableName = False
    DataSource = dsAdmin
    Left = 22
    Top = 254
  end
  object dsAdmin: TDataSource
    DataSet = TableAdmin
    Left = 54
    Top = 254
  end
  object TableAdmin: TTable
    TableName = 'MANPREF.DB'
    Left = 86
    Top = 254
  end
  object waAdd: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waAddExecute
    WebIni = DesignTimeINI
    Left = 102
    Top = 326
  end
  object waAdminDownload: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waAdminDownloadExecute
    WebIni = DesignTimeINI
    Left = 22
    Top = 382
  end
  object WindowsShell1: TWindowsShell
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet, tpStatusPanel]
    Flags = [shlWaitTillIdle]
    WindowStyle = wsNormal
    Left = 53
    Top = 382
  end
  object waAdminDelete: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waAdminDeleteExecute
    WebIni = DesignTimeINI
    Left = 142
    Top = 326
  end
  object dm: TtpDataModule
    CloneMe = False
    Left = 15
    Top = 63
  end
end
