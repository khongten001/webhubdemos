inherited fmMap: TfmMap
  Left = 157
  Top = 146
  Width = 540
  Height = 380
  Caption = '&EZGIS Demo'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 532
    Height = 353
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 522
      Height = 40
      Align = alTop
      BorderWidth = 5
      TabOrder = 0
      LeaveSpace = False
      object btnGISVersion: TtpToolButton
        Left = 0
        Top = 6
        Width = 42
        Height = 28
        Caption = 'Version'
        OnClick = btnGISVersionClick
        LeaveSpace = True
        MinWidth = 28
      end
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 522
      Height = 303
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      object DrawBox1: TEzDrawBox
        Left = 0
        Top = 24
        Width = 425
        Height = 249
        UseThread = False
        Align = alCustom
        Color = clWhite
        TabOrder = 0
        About = 'EzGIS Version 1.96.10 (Mar, 2003)'
        GIS = Gis1
        NoPickFilter = []
        SnapToGuidelinesDist = 1
        ScreenGrid.Step.X = 1
        ScreenGrid.Step.Y = 1
        ShowMapExtents = False
        ShowLayerExtents = False
        GridInfo.Grid.X = 1
        GridInfo.Grid.Y = 1
        GridInfo.GridColor = clMaroon
        GridInfo.DrawAsCross = True
        GridInfo.GridSnap.X = 0.500000000000000000
        GridInfo.GridSnap.Y = 0.500000000000000000
        RubberPen.Color = clRed
        RubberPen.Mode = pmXor
        FlatScrollBar = False
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 518
        Height = 25
        Align = alTop
        TabOrder = 1
        object Label1: TLabel
          Left = 16
          Top = 8
          Width = 32
          Height = 13
          Caption = 'Label1'
        end
      end
    end
  end
  object Gis1: TEzGIS
    Active = False
    LayersSubdir = 'C:\D5\Bin\'
    AutoSetLastView = False
    About = 'EzGIS Version 1.96.10 (Mar, 2003)'
    Left = 14
    Top = 106
  end
end
