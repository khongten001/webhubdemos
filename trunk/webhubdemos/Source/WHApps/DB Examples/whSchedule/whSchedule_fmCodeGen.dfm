inherited fmCodeGenerator: TfmCodeGenerator
  Left = 157
  Top = 146
  Caption = '&Code-Generator'
  ClientHeight = 270
  ClientWidth = 460
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
      object tpToolBar1: TtpToolBar
        Left = 6
        Top = 6
        Width = 438
        TabOrder = 0
        object tpToolButton1: TtpToolButton
          Left = 1
          Top = 1
          Width = 79
          Action = ActionBootstrap
          MinWidth = 28
        end
        object tpToolButton2: TtpToolButton
          Left = 86
          Top = 1
          Width = 99
          Action = ActionGenPASandSQL
          LeaveSpace = True
          MinWidth = 28
        end
        object tpToolButton3: TtpToolButton
          Left = 186
          Top = 1
          Action = ActionExport
          MinWidth = 28
        end
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
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 290
        Height = 216
        Align = alClient
        Lines.Strings = (
          'Memo1')
        TabOrder = 0
      end
    end
  end
  object ActionList1: TActionList
    Left = 29
    Top = 69
    object ActionBootstrap: TAction
      Caption = 'Bootstrap'
      Checked = True
      OnExecute = ActionBootstrapExecute
    end
    object ActionGenPASandSQL: TAction
      Caption = 'PAS and SQL'
      OnExecute = ActionGenPASandSQLExecute
    end
    object ActionExport: TAction
      Caption = 'Export'
      OnExecute = ActionExportExecute
    end
  end
end
