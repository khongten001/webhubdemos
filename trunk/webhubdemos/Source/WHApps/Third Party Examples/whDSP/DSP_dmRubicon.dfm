object DSPdm: TDSPdm
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DSPdmDestroy
  Height = 479
  Width = 741
  object tblAuthors: TTable
    AfterOpen = tblAuthorsAfterOpen
    TableName = 'AUTHORS'
    TableType = ttParadox
    Left = 130
    Top = 104
  end
  object tblFiles: TTable
    AfterOpen = tblFilesAfterOpen
    IndexFieldNames = 'FileID'
    TableName = 'FILES'
    TableType = ttParadox
    Left = 130
    Top = 8
  end
  object dbDSP: TDatabase
    AliasName = '_DSP'
    DatabaseName = 'DSP'
    SessionName = 'Default'
    Left = 66
    Top = 8
  end
  object tblFilesAuth: TTable
    AfterOpen = tblFilesAuthAfterOpen
    TableName = 'FILESAUT'
    TableType = ttParadox
    Left = 130
    Top = 56
  end
  object tblFilesPlt: TTable
    AfterOpen = tblFilesPltAfterOpen
    TableName = 'FILESPLT'
    TableType = ttParadox
    Left = 202
    Top = 8
  end
  object tblFilesGroup: TTable
    AfterOpen = tblFilesGroupAfterOpen
    TableName = 'FILESGRP'
    TableType = ttParadox
    Left = 202
    Top = 56
  end
  object tblFilesCat: TTable
    AfterOpen = tblFilesCatAfterOpen
    TableName = 'FILESCAT'
    TableType = ttParadox
    Left = 202
    Top = 104
  end
  object tblWords: TTable
    AfterOpen = tblWordsAfterOpen
    TableName = 'words'
    TableType = ttParadox
    Left = 282
    Top = 104
  end
  object rbMake: TrbMake
    Cache = rbCache
    CounterLimit = 0
    FirstSegment = 0
    International = False
    SegmentSize = 2147483647
    TextLink = rbMakeTextBDELink
    Version = 4.038000000000000000
    WordsLink = rbMakeWordsBDELink
    WordDelims = ' ,.;:?![]{}()<>/+-*=\|_&#%$@^^~`"'#39'^M^J^I'
    Left = 48
    Top = 192
  end
  object rbCache: TrbCache
    MemoryLimit = 1000
    Version = 4.038000000000000000
    Left = 136
    Top = 192
  end
  object rbProgressDialog: TrbProgressDialog
    Expanded = False
    Engine = rbMake
    Version = 4.038000000000000000
    Left = 208
    Top = 192
  end
  object rbSearch: TrbSearch
    Cache = rbCache
    OnSearch = rbSearchSearch
    SearchOptions = []
    TextLink = rbMakeTextBDELink
    TimeLimit = 0
    Tokens.Strings = (
      'and'
      'or'
      'not'
      'like'
      'near')
    Version = 4.038000000000000000
    WordsLink = rbMakeWordsBDELink
    Left = 312
    Top = 192
  end
  object rbMakeTextBDELink: TrbMakeTextBDELink
    dbiRead = False
    FieldNames.Strings = (
      'FileName')
    IndexFieldName = 'FileID'
    OnProcessField = rbMakeTextBDELinkProcessField
    Table = tblFiles
    Version = 4.038000000000000000
    Left = 48
    Top = 248
  end
  object rbMakeWordsBDELink: TrbMakeWordsBDELink
    BlobFieldSize = 0
    BytesFieldSize = 0
    CharFieldSize = 0
    dbiRead = False
    dbiWrite = False
    ReverseField = False
    Table = tblWords
    Transactions = 0
    Version = 4.038000000000000000
    Left = 48
    Top = 296
  end
  object dsFiles: TDataSource
    DataSet = tblFiles
    Left = 352
    Top = 8
  end
  object dsWords: TDataSource
    DataSet = tblWords
    Left = 352
    Top = 56
  end
end
