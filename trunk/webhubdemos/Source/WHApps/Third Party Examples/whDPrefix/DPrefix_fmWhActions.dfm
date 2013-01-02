inherited fmWhActions: TfmWhActions
  Left = 298
  Top = 150
  Caption = '&ManPref Database'
  ClientHeight = 438
  ClientWidth = 525
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 543
  ExplicitHeight = 483
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 525
    Height = 419
    ExplicitWidth = 525
    ExplicitHeight = 419
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 515
      BorderWidth = 5
      TabOrder = 0
      object tpToolButton1: TtpToolButton
        Left = 11
        Top = 6
        Width = 160
        Caption = 'Toggle Grid Display'
        OnClick = tpToolButton1Click
        LeaveSpace = True
        MinWidth = 28
      end
      object tpToolButton2: TtpToolButton
        Left = 172
        Top = 6
        Width = 90
        Caption = 'Create IDs'
        OnClick = tpToolButton2Click
        MinWidth = 28
      end
    end
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 45
      Width = 212
      Height = 369
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
      Width = 303
      Height = 369
      Align = alClient
      TabOrder = 2
      object DBGrid1: TDBGrid
        Left = 1
        Top = 1
        Width = 301
        Height = 342
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Lucida Sans Unicode'
        TitleFont.Style = []
      end
      object DBNavigator1: TDBNavigator
        Left = 1
        Top = 343
        Width = 301
        Height = 25
        Align = alBottom
        TabOrder = 1
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 419
    Width = 525
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
  end
  object wdsManPref: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
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
    FilterOptions = [foCaseInsensitive]
    OnFilterRecord = Table1FilterRecord
    TableName = 'MANPREF.DB'
    Left = 126
    Top = 134
  end
  object ManPref: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 10
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = ManPrefRowStart
    OnInit = ManPrefInit
    OnFinish = ManPrefFinish
    WebDataSource = wdsManPref
    Left = 14
    Top = 132
  end
  object WebLogin: TwhLogin
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    UserIndex = -1
    Left = 22
    Top = 198
  end
  object waPrefixLink: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waPrefixLinkExecute
    Left = 118
    Top = 254
  end
  object WebDataForm: TwhbdeForm
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnSetCommand = WebDataFormSetCommand
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
    Left = 62
    Top = 326
  end
  object wdsAdmin: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
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
    Left = 102
    Top = 326
  end
  object waAdminDownload: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waAdminDownloadExecute
    Left = 22
    Top = 382
  end
  object waAdminDelete: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waAdminDeleteExecute
    Left = 142
    Top = 326
  end
end
