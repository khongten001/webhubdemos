inherited fmCounterPanel: TfmCounterPanel
  Left = 351
  Top = 151
  Width = 321
  Height = 245
  Caption = '&Counter'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 313
    Height = 182
    object Panel1: TPanel
      Left = 304
      Top = 45
      Width = 4
      Height = 132
      Cursor = crHSplit
      Align = alRight
      BevelOuter = bvNone
      DragCursor = crHSplit
      TabOrder = 0
    end
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 303
      BorderWidth = 5
      TabOrder = 1
    end
    object Panel2: TPanel
      Left = 5
      Top = 45
      Width = 299
      Height = 132
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 2
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 40
        Height = 13
        Caption = 'Counter:'
      end
      object EditCounter: TEdit
        Left = 64
        Top = 19
        Width = 73
        Height = 21
        TabOrder = 0
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 182
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
end
