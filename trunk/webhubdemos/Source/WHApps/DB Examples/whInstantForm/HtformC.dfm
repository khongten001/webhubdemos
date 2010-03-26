inherited fmHTFMPanel: TfmHTFMPanel
  Left = 537
  Top = 118
  Width = 433
  Height = 375
  Caption = 'HTFM Table'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 425
    Height = 318
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 5
      Width = 100
      Height = 308
      Align = alLeft
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 105
      Top = 5
      Width = 315
      Height = 308
      Align = alClient
      TabOrder = 1
      object DBGrid2: TDBGrid
        Left = 1
        Top = 26
        Width = 313
        Height = 281
        Align = alClient
        DataSource = DataSource1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object DBNavigator2: TDBNavigator
        Left = 1
        Top = 1
        Width = 313
        Height = 25
        DataSource = DataSource1
        Align = alTop
        TabOrder = 1
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 318
    Width = 425
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
  end
  object grid: TwhbdeGrid
    ComponentOptions = [tpStatusPanel]
    OnExecute = gridExecute
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 4
    ScanMode = dsByKey
    ControlsWhere = dsbNone
    ButtonsWhere = dsbNone
    ButtonAutoHide = False
    OverlapScroll = False
    TR = '<tr>'
    TD = '<td>'
    Preformat = False
    OnHotField = gridHotField
    WebDataSource = WebDataSource1
    Left = 21
    Top = 87
  end
  object WebDataSource1: TwhbdeSource
    ComponentOptions = [tpStatusPanel]
    GotoMode = wgGotoKey
    KeyFieldNames = 'PartNo'
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource1
    Left = 21
    Top = 151
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 21
    Top = 183
  end
  object Table1: TtpTable
    TableName = 'PARTS'
    TableType = ttParadox
    TableMode = tmData
    PostBeforeClose = False
    HideLinkingKeys = False
    LeaveOpen = True
    Left = 21
    Top = 215
  end
  object waPost: TwhWebActionEx
    ComponentOptions = [tpUpdateOnGet, tpStatusPanel]
    OnExecute = waPostExecute
    Left = 56
    Top = 12
  end
  object WebDataForm1: TwhbdeForm
    ComponentOptions = [tpStatusPanel]
    Border = 'cellspacing="0"'
    WrapMemo = False
    SkipBlank = False
    WebDataSource = WebDataSource1
    Left = 21
    Top = 116
  end
end
