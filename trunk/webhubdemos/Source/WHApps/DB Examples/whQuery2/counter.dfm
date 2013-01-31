inherited fmCounterPanel: TfmCounterPanel
  Left = 351
  Top = 151
  Caption = '&Counter'
  ClientHeight = 243
  ClientWidth = 397
  OnDestroy = FormDestroy
  ExplicitWidth = 415
  ExplicitHeight = 288
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 397
    Height = 224
    ExplicitWidth = 303
    ExplicitHeight = 181
    object Panel1: TPanel
      Left = 388
      Top = 45
      Width = 4
      Height = 174
      Cursor = crHSplit
      Align = alRight
      BevelOuter = bvNone
      DragCursor = crHSplit
      TabOrder = 0
      ExplicitLeft = 294
      ExplicitHeight = 131
    end
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 387
      BorderWidth = 5
      TabOrder = 1
      ExplicitWidth = 293
    end
    object Panel2: TPanel
      Left = 5
      Top = 45
      Width = 383
      Height = 174
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 2
      ExplicitWidth = 289
      ExplicitHeight = 131
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 65
        Height = 18
        Caption = 'Counter:'
      end
      object EditCounter: TEdit
        Left = 104
        Top = 21
        Width = 145
        Height = 26
        TabOrder = 0
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 224
    Width = 397
    Height = 19
    Panels = <
      item
        Text = 'whWebAction2: Not Updated'
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimpleText = ''
    PanelStatusIndex = 0
    ExplicitTop = 181
    ExplicitWidth = 303
  end
  object waShowCounter: TwhWebAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waShowCounterExecute
    Left = 144
    Top = 112
  end
end
