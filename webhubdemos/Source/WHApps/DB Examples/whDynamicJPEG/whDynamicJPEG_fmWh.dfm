inherited fmWhAnimals: TfmWhAnimals
  Left = 391
  Top = 235
  Caption = '&Panel'
  ClientHeight = 346
  ClientWidth = 1052
  ExplicitWidth = 1070
  ExplicitHeight = 391
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 1052
    Height = 327
    ExplicitWidth = 548
    ExplicitHeight = 287
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 1042
      BorderWidth = 5
      TabOrder = 0
      ExplicitWidth = 538
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 1042
      Height = 277
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      ExplicitWidth = 538
      ExplicitHeight = 237
      object Splitter1: TSplitter
        Left = 352
        Top = 0
        Width = 9
        Height = 273
        ExplicitHeight = 240
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 352
        Height = 273
        Align = alLeft
        DataSource = DMBIOLIFE.DataSourceBiolife
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Lucida Sans Unicode'
        TitleFont.Style = []
      end
      object DBImage: TDBImage
        Left = 361
        Top = 0
        Width = 677
        Height = 273
        Align = alClient
        DataField = 'Graphic'
        DataSource = DMBIOLIFE.DataSourceBiolife
        TabOrder = 1
        ExplicitLeft = 592
        ExplicitWidth = 446
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 327
    Width = 1052
    Height = 19
    Panels = <
      item
        Text = 'WebActionNoSaveState1: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
    ExplicitTop = 287
    ExplicitWidth = 548
  end
  object Table1: TTable
    IndexName = 'NAME'
    TableName = 'animals.dbf'
    Left = 100
    Top = 204
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
  object waJPEG: TwhWebActionEx
    OnUpdate = waJPEGUpdate
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waJPEGExecute
    DirectCallOk = True
    Left = 164
    Top = 84
  end
end
