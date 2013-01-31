inherited fmCounterPanel: TfmCounterPanel
  Left = 351
  Top = 151
  Caption = '&Counter'
  ClientHeight = 200
  ClientWidth = 303
  OnDestroy = FormDestroy
  ExplicitWidth = 321
  ExplicitHeight = 245
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 303
    Height = 181
    ExplicitWidth = 313
    ExplicitHeight = 182
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
        Width = 65
        Height = 18
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
    Top = 181
    Width = 303
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
    ExplicitTop = 182
    ExplicitWidth = 313
  end
end
