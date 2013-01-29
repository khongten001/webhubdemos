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
    ExplicitWidth = 1052
    ExplicitHeight = 327
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 1042
      BorderWidth = 5
      TabOrder = 0
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
        Text = 'waJPEG: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
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
