inherited fmWhActions: TfmWhActions
  Left = 298
  Top = 150
  Caption = '&ManPref Database'
  ClientHeight = 481
  ClientWidth = 970
  OnDestroy = FormDestroy
  ExplicitWidth = 988
  ExplicitHeight = 526
  PixelsPerInch = 120
  TextHeight = 18
  object tpToolButton3: TtpToolButton [0]
    Left = 256
    Top = 248
    MinWidth = 28
  end
  inherited pa: TPanel
    Width = 970
    Height = 462
    ExplicitWidth = 970
    ExplicitHeight = 462
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 960
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
      object tpToolButton5: TtpToolButton
        Left = 177
        Top = 6
        Width = 142
        Action = ActAssignPasswords
        LeaveSpace = True
        MinWidth = 28
      end
      object ComboBoxStatus: TComboBox
        Left = 408
        Top = 8
        Width = 145
        Height = 26
        ItemIndex = 0
        TabOrder = 0
        Text = '- All'
        Items.Strings = (
          '- All'
          'P Pending'
          'D Delete'
          'A Approved')
      end
    end
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 45
      Width = 244
      Height = 412
      TabOrder = 1
      object GroupBox3: TGroupBox
        Left = 1
        Top = 1
        Width = 242
        Height = 88
        Align = alTop
        Caption = 'View-only DB Display'
        TabOrder = 0
      end
      object GroupBox6: TGroupBox
        Left = 1
        Top = 89
        Width = 242
        Height = 104
        Align = alTop
        Caption = 'Editing + Posting + Deleting'
        TabOrder = 1
      end
    end
    object Panel1: TPanel
      Left = 249
      Top = 45
      Width = 716
      Height = 412
      Align = alClient
      TabOrder = 2
      object DBGrid1: TDBGrid
        Left = 1
        Top = 1
        Width = 714
        Height = 385
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
        Top = 386
        Width = 714
        Height = 25
        Align = alBottom
        TabOrder = 1
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 462
    Width = 970
    Height = 19
    Panels = <
      item
        Text = 'whbdeGrid2: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
  end
  object wdsManPref: TwhbdeSource
    ComponentOptions = []
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource1
    Left = 86
    Top = 78
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
    WebDataSource = wdsManPref
    Left = 22
    Top = 68
  end
  object waModify: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waModifyExecute
    Left = 38
    Top = 182
  end
  object waAdminDelete: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waAdminDeleteExecute
    Left = 150
    Top = 190
  end
  object ActionList1: TActionList
    Left = 80
    Top = 256
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
  end
end
