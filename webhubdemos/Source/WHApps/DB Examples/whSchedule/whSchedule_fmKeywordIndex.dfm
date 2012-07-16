inherited fmRubiconIndex: TfmRubiconIndex
  Left = 157
  Top = 146
  Caption = '&Search'
  ClientHeight = 270
  ClientWidth = 460
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 478
  ExplicitHeight = 315
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 460
    Height = 270
    ExplicitWidth = 460
    ExplicitHeight = 270
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 450
      BorderWidth = 5
      TabOrder = 0
      object tpToolButton1: TtpToolButton
        Left = 6
        Top = 6
        Action = ActionCreateIndex
        MinWidth = 28
      end
    end
    object tpComponentPanel: TtpComponentPanel
      Left = 5
      Top = 45
      Width = 156
      Height = 220
      Caption = 'Invisible Parking'
      TabOrder = 1
    end
    object Panel: TPanel
      Left = 161
      Top = 45
      Width = 294
      Height = 220
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 2
      ExplicitLeft = 105
      ExplicitWidth = 350
    end
  end
  object ActionList1: TActionList
    Left = 29
    Top = 69
    object ActionCreateIndex: TAction
      Caption = 'Create Keyword Index'
      OnExecute = ActionCreateIndexExecute
    end
  end
end
