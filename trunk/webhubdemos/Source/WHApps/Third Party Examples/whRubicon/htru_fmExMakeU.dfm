inherited fmRubiconMakeBDE: TfmRubiconMakeBDE
  Left = 157
  Top = 146
  Width = 646
  Height = 493
  Caption = '&Rubicon-Make-BDE'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 638
    Height = 455
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 628
      BorderWidth = 5
      TabOrder = 0
      object Button1: TButton
        Left = 8
        Top = 5
        Width = 57
        Height = 25
        Caption = 'Make'
        TabOrder = 0
        OnClick = Button1Click
      end
      object CheckBox1: TCheckBox
        Left = 72
        Top = 8
        Width = 81
        Height = 17
        Caption = 'Segmented'
        TabOrder = 1
      end
      object DBNavigator1: TDBNavigator
        Left = 159
        Top = 8
        Width = 144
        Height = 18
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 628
      Height = 405
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      object DBGrid1: TDBGrid
        Left = 100
        Top = 0
        Width = 524
        Height = 383
        Align = alClient
        DataSource = DataSource1
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDblClick = DBGrid1DblClick
      end
      object tpComponentPanel1: TtpComponentPanel
        Left = 0
        Top = 0
        Width = 100
        Height = 383
        TabOrder = 1
      end
      object TabSet1: TTabSet
        Left = 0
        Top = 383
        Width = 624
        Height = 18
        Align = alBottom
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Tabs.Strings = (
          'Text'
          'Words')
        TabIndex = 0
        OnChange = TabSet1Change
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 24
    Top = 72
  end
  object DataSource2: TDataSource
    DataSet = Table2
    Left = 64
    Top = 72
  end
  object Table1: TTable
    IndexFieldNames = 'HelpNo'
    TableName = 'help'
    Left = 24
    Top = 104
  end
  object Table2: TTable
    TableName = 'words'
    TableType = ttParadox
    Left = 64
    Top = 104
  end
  object rbMakeTextBDELink1: TrbMakeTextBDELink
    dbiRead = False
    FieldNames.Strings = (
      'Class'
      'Declaration'
      'Description'
      'Example'
      'Kind'
      'Name'
      'Scope'
      'See_Also'
      'Unit')
    Table = Table1
    Version = 2.210000000000000000
    Left = 24
    Top = 136
  end
  object rbMakeWordsBDELink1: TrbMakeWordsBDELink
    BlobFieldSize = 0
    BytesFieldSize = 0
    CharFieldSize = 0
    dbiRead = False
    dbiWrite = False
    ReverseField = False
    Table = Table2
    Transactions = 0
    Version = 2.210000000000000000
    Left = 64
    Top = 136
  end
  object rbMake1: TrbMake
    Ansi = False
    Cache = rbCache1
    CounterLimit = 0
    FirstSegment = 0
    MinWordLen = 3
    OnAcceptWord = rbMake1AcceptWord
    SegmentSize = 2147483647
    TextLink = rbMakeTextBDELink1
    Version = 2.210000000000000000
    WordsLink = rbMakeWordsBDELink1
    WordDelims = '<<< ,.;:?![]{}()<>/+-*=\|_&#%$@^^~`"'#39
    Left = 24
    Top = 168
  end
  object rbAccept1: TrbAccept
    Accept = True
    Alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    NumericLimit = 1
    Numeric = '0123456789'
    Version = 2.210000000000000000
    Vowel = 'AEIOUY'
    Left = 64
    Top = 168
  end
  object rbCache1: TrbCache
    AltMemMgr = True
    MemoryLimit = 2000
    Version = 2.210000000000000000
    Left = 24
    Top = 200
  end
  object rbProgressDialog1: TrbProgressDialog
    AutoClose = False
    Expanded = True
    Engine = rbMake1
    Version = 2.210000000000000000
    Left = 64
    Top = 200
  end
end
