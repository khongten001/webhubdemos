inherited fmHTRUPanel: TfmHTRUPanel
  Left = 195
  Top = 158
  Width = 718
  Height = 482
  Caption = 'WebHub-Search'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 710
    Height = 419
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 5
      Width = 153
      Height = 409
      TabOrder = 0
      object GroupBox1: TGroupBox
        Left = 1
        Top = 281
        Width = 151
        Height = 104
        Align = alTop
        Caption = 'Messages Grid'
        TabOrder = 0
      end
      object GroupBox2: TGroupBox
        Left = 1
        Top = 1
        Width = 151
        Height = 168
        Align = alTop
        Caption = 'Rubicon Connection'
        TabOrder = 1
      end
      object GroupBox4: TGroupBox
        Left = 1
        Top = 169
        Width = 151
        Height = 56
        Align = alTop
        Caption = 'Instant Form'
        TabOrder = 2
      end
      object GroupBox5: TGroupBox
        Left = 1
        Top = 225
        Width = 151
        Height = 56
        Align = alTop
        Caption = 'Words Grid'
        TabOrder = 3
      end
    end
    object Panel1: TPanel
      Left = 158
      Top = 5
      Width = 547
      Height = 409
      Align = alClient
      TabOrder = 1
      object DBGrid: TDBGrid
        Left = 1
        Top = 1
        Width = 545
        Height = 382
        Align = alClient
        DataSource = dsWords
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object DBNavigator: TDBNavigator
        Left = 1
        Top = 383
        Width = 545
        Height = 25
        Align = alBottom
        TabOrder = 1
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 419
    Width = 710
    Height = 19
    Panels = <
      item
        Text = 'dgMsgs: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object Msg: TwhdbForm
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = MsgExecute
    DirectCallOk = True
    Border = 'border width="100%"'
    WrapMemo = False
    SkipBlank = False
    WebDataSource = wdsMessage
    Left = 96
    Top = 188
  end
  object wdsMessage: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 0
    SaveTableName = False
    DataSource = dsMessage
    Left = 67
    Top = 188
  end
  object dsMessage: TDataSource
    DataSet = qMessage
    Left = 20
    Top = 340
  end
  object qMessage: TQuery
    SQL.Strings = (
      'SELECT * FROM "help.db" m WHERE ( m."HelpNo" = :wwwKey: )')
    Left = 73
    Top = 340
    ParamData = <
      item
        DataType = ftInteger
        Name = 'wwwKey:'
        ParamType = ptUnknown
        Value = 2
      end>
  end
  object tbWords: TtpTable
    IndexName = 'rbLike'
    TableName = 'words'
    TableType = ttParadox
    TableMode = tmData
    PostBeforeClose = False
    HideLinkingKeys = False
    LeaveOpen = True
    Left = 16
    Top = 242
  end
  object dsWords: TDataSource
    DataSet = tbWords
    Left = 44
    Top = 242
  end
  object wdsWords: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    GotoMode = wgGotoKey
    KeyFieldNames = 'rbWord'
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = dsWords
    Left = 77
    Top = 242
  end
  object dgWords: TwhbdeGrid
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    AfterExecute = dgWordsAfterExecute
    DirectCallOk = True
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnBeginTable = dgWordsBeginTable
    Border = 'BORDER'
    TR = '<tr>'
    TD = '<td>'
    Caption = 'test grid'
    Preformat = False
    WebDataSource = wdsWords
    Left = 105
    Top = 242
  end
  object wdsContents: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    GotoMode = wgGotoKey
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    OnAdjDisplaySet = wdsContentsAdjDisplaySet
    DataSource = dsContents
    Left = 77
    Top = 297
  end
  object dgMsgs: TwhbdeGrid
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = dgMsgsExecute
    DirectCallOk = True
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast, dsbPost, dsbInputFields]
    PageHeight = 4
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = True
    Border = 'cellspacing="0"'
    TR = '<tr>'
    TD = '<td>'
    Preformat = False
    WebDataSource = wdsContents
    Left = 105
    Top = 297
  end
  object dsContents: TDataSource
    DataSet = tbMessages
    Left = 44
    Top = 297
  end
  object tbMessages: TtpTable
    DatabaseName = 'Rubicon2'
    TableName = 'help'
    TableType = ttParadox
    TableMode = tmData
    PostBeforeClose = False
    HideLinkingKeys = False
    LeaveOpen = True
    Left = 16
    Top = 297
  end
  object SearchDictionary: TrbSearch
    International = False
    SearchFor = 'WORK'
    SearchLogic = slSmart
    SearchOptions = []
    TextLink = rbTextBDELink1
    TimeLimit = 0
    Tokens.Strings = (
      'and'
      'or'
      'not'
      'like'
      'near')
    Version = 2.210000000000000000
    WordsLink = rbWordsBDELink1
    Left = 14
    Top = 22
  end
  object rbWordsBDELink1: TrbWordsBDELink
    dbiRead = False
    dbiWrite = False
    Table = tbWords
    Transactions = 0
    Version = 2.210000000000000000
    Left = 46
    Top = 22
  end
  object rbTextBDELink1: TrbTextBDELink
    dbiRead = False
    SubFieldNames.Strings = (
      'Message')
    Table = tbMessages
    Version = 2.210000000000000000
    Left = 86
    Top = 22
  end
end
