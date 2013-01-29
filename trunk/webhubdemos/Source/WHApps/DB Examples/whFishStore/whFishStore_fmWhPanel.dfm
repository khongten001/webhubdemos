inherited fmHTFSPanel: TfmHTFSPanel
  Left = 454
  Top = 141
  Caption = 'Fish Store Form'
  ClientHeight = 408
  ClientWidth = 462
  ExplicitWidth = 480
  ExplicitHeight = 453
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 462
    Height = 389
    ExplicitWidth = 462
    ExplicitHeight = 389
    object Image1: TImage
      Left = 241
      Top = 47
      Width = 216
      Height = 337
      Align = alClient
      ExplicitWidth = 226
      ExplicitHeight = 338
    end
    object tpToolBar2: TtpToolBar
      Left = 5
      Top = 5
      Width = 452
      Height = 42
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 12
        Width = 208
        Height = 18
        Caption = 'Fish images will display here'
      end
    end
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 47
      Width = 236
      Height = 337
      TabOrder = 1
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 389
    Width = 462
    Height = 19
    Panels = <
      item
        Text = 'waFishPhoto: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
  end
  object waFishPhoto: TwhWebActionEx
    ComponentOptions = []
    OnExecute = waFishPhotoExecute
    Left = 80
    Top = 72
  end
end
