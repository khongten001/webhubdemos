inherited fmBendFields: TfmBendFields
  Left = 207
  Top = 175
  Width = 569
  Height = 342
  Caption = '&Database'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 561
    Height = 285
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 551
      BorderWidth = 5
      TabOrder = 0
    end
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 45
      Width = 196
      Height = 235
      TabOrder = 1
      object GroupBox2: TGroupBox
        Left = 1
        Top = 1
        Width = 194
        Height = 56
        Align = alTop
        Caption = 'Standard'
        TabOrder = 0
      end
      object GroupBox3: TGroupBox
        Left = 1
        Top = 57
        Width = 194
        Height = 56
        Align = alTop
        Caption = 'Scan #1'
        TabOrder = 1
      end
      object GroupBox4: TGroupBox
        Left = 1
        Top = 169
        Width = 194
        Height = 56
        Align = alTop
        Caption = 'WebDataGrid'
        TabOrder = 2
      end
      object GroupBox1: TGroupBox
        Left = 1
        Top = 113
        Width = 194
        Height = 56
        Align = alTop
        Caption = 'Scan #2'
        TabOrder = 3
      end
    end
    object DBGrid: TDBGrid
      Left = 201
      Top = 45
      Width = 355
      Height = 235
      Align = alClient
      DataSource = DataSource1
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 285
    Width = 561
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object WebDataSource1: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = WebDataSourceExecute
    BendPointers = True
    GotoMode = wgGotoKey
    KeyFieldNames = 'ACCT_NBR'
    MaxOpenDataSets = 5
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    OnFindKeys = WebDataSourceFindKeys
    DataSource = DataSource1
    Left = 48
    Top = 120
  end
  object WebDataSource2: TwhbdeSource
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = WebDataSourceExecute
    BendPointers = True
    GotoMode = wgGotoKey
    KeyFieldNames = 'Species No'
    MaxOpenDataSets = 5
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSource2
    Left = 48
    Top = 176
  end
  object Scan2: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel, tpCXSetIfFoundDuringUpdate]
    OnExecute = Scan2Execute
    AfterExecute = ScanAfterExecute
    DirectCallOk = True
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 3
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnInit = ScanOnInit
    OnFinish = ScanOnFinish
    WebDataSource = WebDataSource2
    Left = 16
    Top = 176
  end
  object WebDataGrid1: TwhbdeGrid
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel, tpCXSetIfFoundExactlyDuringUpdate]
    OnExecute = WebDataGrid1Execute
    AfterExecute = WebDataGrid1AfterExecute
    DirectCallOk = True
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    TR = '<tr>'
    TD = '<td>'
    Preformat = False
    WebDataSource = WebDataSource1
    Left = 16
    Top = 232
  end
  object Scan1: TwhdbScan
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel, tpCXSetIfFoundDuringUpdate]
    OnExecute = ScanOnExecute
    AfterExecute = ScanAfterExecute
    DirectCallOk = True
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 3
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    OnRowStart = Scan1RowStart
    OnInit = ScanOnInit
    OnFinish = ScanOnFinish
    WebDataSource = WebDataSource1
    Left = 16
    Top = 120
  end
  object DataSource2: TDataSource
    DataSet = Table2
    Left = 80
    Top = 176
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 80
    Top = 120
  end
  object Table1: TTable
    IndexName = 'ACCT_NBR'
    TableName = 'HOLDINGS.DBF'
    Left = 112
    Top = 120
    object Table1ACCT_NBR: TFloatField
      FieldName = 'ACCT_NBR'
    end
    object Table1SYMBOL: TStringField
      FieldName = 'SYMBOL'
      Size = 7
    end
    object Table1SHARES: TFloatField
      FieldName = 'SHARES'
    end
    object Table1PUR_PRICE: TFloatField
      FieldName = 'PUR_PRICE'
    end
    object Table1PUR_DATE: TDateField
      FieldName = 'PUR_DATE'
    end
  end
  object Table2: TTable
    TableName = 'BIOLIFE.DB'
    Left = 112
    Top = 176
    object Table2SpeciesNo: TFloatField
      FieldName = 'Species No'
    end
    object Table2Category: TStringField
      FieldName = 'Category'
      Size = 15
    end
    object Table2Common_Name: TStringField
      FieldName = 'Common_Name'
      Size = 30
    end
    object Table2SpeciesName: TStringField
      FieldName = 'Species Name'
      Size = 40
    end
    object Table2Lengthcm: TFloatField
      FieldName = 'Length (cm)'
    end
    object Table2Length_In: TFloatField
      FieldName = 'Length_In'
    end
    object Table2Notes: TMemoField
      FieldName = 'Notes'
      BlobType = ftMemo
      Size = 50
    end
    object Table2Graphic: TGraphicField
      FieldName = 'Graphic'
      BlobType = ftGraphic
    end
  end
end
