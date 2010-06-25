inherited fmHTFSPanel: TfmHTFSPanel
  Left = 454
  Top = 141
  Width = 480
  Height = 453
  Caption = 'Fish Store Form'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 472
    Height = 390
    object Image1: TImage
      Left = 241
      Top = 47
      Width = 226
      Height = 338
      Align = alClient
    end
    object tpToolBar2: TtpToolBar
      Left = 5
      Top = 5
      Width = 462
      Height = 42
      TabOrder = 0
    end
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 47
      Width = 236
      Height = 338
      TabOrder = 1
      object GroupBox1: TGroupBox
        Left = 1
        Top = 225
        Width = 234
        Height = 56
        Align = alTop
        Caption = 'BMP to JPG conversion'
        TabOrder = 0
      end
      object GroupBox3: TGroupBox
        Left = 1
        Top = 1
        Width = 234
        Height = 56
        Align = alTop
        Caption = 'Shipping Cost Grid'
        TabOrder = 1
      end
      object GroupBox4: TGroupBox
        Left = 1
        Top = 57
        Width = 234
        Height = 56
        Align = alTop
        Caption = 'Grid of Fish (GF)'
        TabOrder = 2
      end
      object GroupBox5: TGroupBox
        Left = 1
        Top = 113
        Width = 234
        Height = 56
        Align = alTop
        Caption = 'Grid of Fish -- Advanced (GFA1)'
        TabOrder = 3
      end
      object GroupBox6: TGroupBox
        Left = 1
        Top = 169
        Width = 234
        Height = 56
        Align = alTop
        Caption = 'Put fish in cart'
        TabOrder = 4
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 390
    Width = 472
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object WebListGrid1: TwhListGrid
    ComponentOptions = [tpUpdateOnGet]
    CaptionDelimiter = '@'
    LinesMode = wlgAsGrid
    Left = 37
    Top = 68
  end
  object gf: TwhbdeGrid
    ComponentOptions = []
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    PageHeight = 3
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    Border = 'cellspacing="0"'
    TR = '<tr>'
    TD = '<td>'
    ShowRecno = False
    Preformat = False
    WebDataSource = WebDataSourceBiolife
    Left = 14
    Top = 118
  end
  object WebDataSourceBiolife: TwhbdeSource
    ComponentOptions = [tpUpdateOnGet]
    GotoMode = wgGotoKey
    KeyFieldNames = 'Species No'
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSourceBiolife
    Left = 49
    Top = 118
  end
  object DataSourceBiolife: TDataSource
    DataSet = TableBiolife
    Left = 84
    Top = 118
  end
  object TableBiolife: TTable
    TableName = 'BIOLIFE.DB'
    TableType = ttParadox
    Left = 119
    Top = 118
  end
  object DataSourceA1: TDataSource
    Left = 92
    Top = 177
  end
  object wdsa1: TwhbdeSource
    ComponentOptions = [tpUpdateOnGet]
    GotoMode = wgGotoKey
    KeyFieldNames = 'Species No'
    MaxOpenDataSets = 1
    OpenDataSets = 0
    OpenDataSetRetain = 600
    SaveTableName = False
    DataSource = DataSourceA1
    Left = 57
    Top = 177
  end
  object gfa1: TwhbdeGrid
    ComponentOptions = [tpUpdateOnGet]
    DataScanOptions = [dsbFirst, dsbPrior, dsbNext, dsbLast]
    ScanMode = dsByKey
    ButtonAutoHide = False
    OverlapScroll = False
    TR = '<tr>'
    TD = '<td>'
    ShowRecno = False
    Preformat = False
    WebDataSource = wdsa1
    Left = 22
    Top = 177
  end
  object waFishPhoto: TwhWebActionEx
    ComponentOptions = [tpUpdateOnGet]
    OnExecute = waFishPhotoExecute
    Left = 88
    Top = 288
  end
  object waGrabFish: TwhWebAction
    ComponentOptions = [tpUpdateOnGet]
    OnExecute = waGrabFishExecute
    Left = 88
    Top = 288
  end
  object TableA1: TtpTable
    TableMode = tmData
    PostBeforeClose = False
    HideLinkingKeys = False
    LeaveOpen = False
    Left = 128
    Top = 177
  end
end
