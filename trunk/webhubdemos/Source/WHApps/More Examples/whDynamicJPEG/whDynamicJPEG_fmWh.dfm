inherited fmWhAnimals: TfmWhAnimals
  Left = 391
  Top = 235
  Width = 566
  Height = 351
  Caption = '&Panel'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 558
    Height = 294
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 548
      BorderWidth = 5
      TabOrder = 0
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 548
      Height = 244
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      object Splitter1: TSplitter
        Left = 352
        Top = 0
        Width = 9
        Height = 240
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 352
        Height = 240
        Align = alLeft
        DataSource = DataSource1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object DBImage: TDBImage
        Left = 361
        Top = 0
        Width = 183
        Height = 240
        Align = alClient
        DataField = 'BMP'
        DataSource = DataSource1
        TabOrder = 1
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 294
    Width = 558
    Height = 19
    Panels = <
      item
        Text = 'WebActionNoSaveState1: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object Table1: TTable
    IndexName = 'NAME'
    TableName = 'animals.dbf'
    Left = 12
    Top = 164
    object Table1NAME: TStringField
      FieldName = 'NAME'
      Size = 10
    end
    object Table1SIZE: TSmallintField
      FieldName = 'SIZE'
    end
    object Table1WEIGHT: TSmallintField
      FieldName = 'WEIGHT'
    end
    object Table1AREA: TStringField
      FieldName = 'AREA'
    end
    object Table1BMP: TBlobField
      FieldName = 'BMP'
      Visible = False
      BlobType = ftTypedBinary
      Size = 1
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 12
    Top = 136
  end
  object waJPEG: TwhWebActionEx
    OnUpdate = waJPEGUpdate
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waJPEGExecute
    DirectCallOk = True
    Left = 12
    Top = 108
  end
  object waAnimalNav: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waAnimalNavExecute
    Left = 77
    Top = 149
  end
end
