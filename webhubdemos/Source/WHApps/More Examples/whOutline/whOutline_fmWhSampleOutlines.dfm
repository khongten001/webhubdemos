inherited fmWhSampleOutlines: TfmWhSampleOutlines
  Left = 157
  Top = 146
  Width = 321
  Height = 245
  Caption = '&Outline'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 313
    Height = 188
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 303
      BorderWidth = 5
      TabOrder = 0
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 303
      Height = 138
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      object PageControl1: TPageControl
        Left = 0
        Top = 0
        Width = 299
        Height = 134
        ActivePage = tsOutline1
        Align = alClient
        TabOrder = 0
        object tsOutline1: TTabSheet
          Caption = 'tsOutline1'
        end
        object tsOutline2: TTabSheet
          Caption = 'tsOutline2'
          ImageIndex = 1
        end
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 188
    Width = 313
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object WebOutline: TwhOutline
    ComponentOptions = [tpUpdateOnLoad]
    Level = 0
    Indent = 3
    Left = 80
    Top = 8
  end
  object WebOutlineMaslow: TwhOutline
    ComponentOptions = [tpUpdateOnLoad]
    Level = 0
    Indent = 3
    Left = 117
    Top = 13
  end
end
