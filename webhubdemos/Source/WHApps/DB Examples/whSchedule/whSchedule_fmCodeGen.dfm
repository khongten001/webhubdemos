inherited fmCodeGenerator: TfmCodeGenerator
  Left = 157
  Top = 146
  Caption = '&Code-Generator'
  ClientHeight = 406
  ClientWidth = 742
  ExplicitWidth = 760
  ExplicitHeight = 451
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 742
    Height = 406
    Font.Height = -18
    ParentFont = False
    ExplicitWidth = 460
    ExplicitHeight = 270
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 732
      BorderWidth = 5
      TabOrder = 0
      ExplicitTop = 1
      object LabelDBInfo: TLabel
        Left = 295
        Top = 9
        Width = 410
        Height = 22
        Caption = 'LabelDBInfo'
      end
      object LabeledEditProjectAbbrev: TLabeledEdit
        Left = 129
        Top = 6
        Width = 160
        Height = 30
        EditLabel.Width = 119
        EditLabel.Height = 22
        EditLabel.Caption = 'ProjectAbbrev'
        LabelPosition = lpLeft
        TabOrder = 0
        Text = 'CodeRageSchedule'
      end
    end
    object tpComponentPanel: TtpComponentPanel
      Left = 5
      Top = 45
      Width = 156
      Height = 356
      Caption = 'Invisible Parking'
      TabOrder = 1
      ExplicitHeight = 220
    end
    object Panel: TPanel
      Left = 161
      Top = 45
      Width = 576
      Height = 356
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 2
      ExplicitWidth = 294
      ExplicitHeight = 220
      object PageControl1: TPageControl
        Left = 0
        Top = 0
        Width = 572
        Height = 193
        ActivePage = TabSheet2
        Align = alTop
        TabOrder = 0
        object TabSheet1: TTabSheet
          Caption = 'Once'
          ExplicitTop = 29
          ExplicitHeight = 188
          object tpToolBar2: TtpToolBar
            Left = 0
            Top = 0
            Width = 564
            TabOrder = 0
            ExplicitWidth = 438
            object tpToolButton5: TtpToolButton
              Left = 1
              Top = 1
              Width = 79
              Action = ActionBootstrap
              MinWidth = 28
            end
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'Basics'
          ImageIndex = 1
          ExplicitTop = 31
          object tpToolBar3: TtpToolBar
            Left = 0
            Top = 0
            Width = 564
            TabOrder = 0
            ExplicitWidth = 438
            object tpToolButton10: TtpToolButton
              Left = 6
              Top = 1
              Width = 99
              Action = ActionGenPASandSQL
              LeaveSpace = True
              MinWidth = 28
            end
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'CSV I/O'
          ImageIndex = 2
          ExplicitTop = 29
          ExplicitHeight = 279
          object tpToolBar4: TtpToolBar
            Left = 0
            Top = 0
            Width = 564
            TabOrder = 0
            ExplicitWidth = 438
            object tpToolButton15: TtpToolButton
              Left = 6
              Top = 1
              Width = 112
              Action = ActionExport
              LeaveSpace = True
              MinWidth = 28
            end
            object tpToolButton16: TtpToolButton
              Left = 119
              Top = 1
              Width = 132
              Action = ActionImport
              MinWidth = 28
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = 'By Pattern'
          ImageIndex = 3
          ExplicitTop = 31
          object tpToolBar1: TtpToolBar
            Left = 0
            Top = 0
            Width = 564
            TabOrder = 0
            ExplicitTop = 35
            object ComboBox1: TComboBox
              Left = 8
              Top = 3
              Width = 145
              Height = 30
              TabOrder = 0
              Text = 'ComboBox1'
              Items.Strings = (
                'Macros for Field Labels')
            end
            object Button1: TButton
              Left = 192
              Top = 8
              Width = 75
              Height = 25
              Caption = 'Button1'
              TabOrder = 1
            end
          end
        end
      end
      object Memo1: TMemo
        Left = 0
        Top = 193
        Width = 572
        Height = 159
        Align = alClient
        Lines.Strings = (
          'Memo1')
        TabOrder = 1
        ExplicitLeft = 144
        ExplicitTop = 216
        ExplicitWidth = 185
        ExplicitHeight = 89
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
      Caption = 'Export to CSV'
      OnExecute = ActionExportExecute
    end
    object ActionImport: TAction
      Caption = 'Import from CSV'
      OnExecute = ActionImportExecute
    end
  end
end
