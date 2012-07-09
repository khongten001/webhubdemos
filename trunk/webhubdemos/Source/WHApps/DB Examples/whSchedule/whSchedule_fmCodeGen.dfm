inherited fmCodeGenerator: TfmCodeGenerator
  Left = 157
  Top = 146
  Caption = '&Code-Generator'
  ClientHeight = 406
  ClientWidth = 742
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 760
  ExplicitHeight = 451
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 742
    Height = 406
    Font.Height = -18
    ParentFont = False
    ExplicitWidth = 742
    ExplicitHeight = 406
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 732
      BorderWidth = 5
      TabOrder = 0
      object LabelDBInfo: TLabel
        Left = 295
        Top = 9
        Width = 103
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
      object PageControl1: TPageControl
        Left = 0
        Top = 0
        Width = 572
        Height = 193
        ActivePage = TabSheet3
        Align = alTop
        TabOrder = 0
        object TabSheet1: TTabSheet
          Caption = 'Once'
          object tpToolBar2: TtpToolBar
            Left = 0
            Top = 0
            Width = 564
            TabOrder = 0
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
          object tpToolBar3: TtpToolBar
            Left = 0
            Top = 0
            Width = 564
            TabOrder = 0
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
          object tpToolBar4: TtpToolBar
            Left = 0
            Top = 0
            Width = 564
            TabOrder = 0
            object tpToolButton15: TtpToolButton
              Left = 6
              Top = 1
              Width = 112
              Action = ActionExport
              LeaveSpace = True
              MinWidth = 28
            end
            object tpToolButton16: TtpToolButton
              Left = 124
              Top = 1
              Width = 132
              Action = ActionImport
              LeaveSpace = True
              MinWidth = 28
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = 'By Pattern'
          ImageIndex = 3
          object tpToolBar1: TtpToolBar
            Left = 0
            Top = 0
            Width = 564
            TabOrder = 0
            object cbCodeGenPattern: TComboBox
              Left = 8
              Top = 3
              Width = 259
              Height = 30
              TabOrder = 0
              Text = 'Macros for Field Labels'
              Items.Strings = (
                'Macros for Field Labels'
                'Field List for IBObjects Import')
            end
            object Button1: TButton
              Left = 288
              Top = 8
              Width = 105
              Height = 25
              Action = ActionCodeGenForPattern
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
    object ActionCodeGenForPattern: TAction
      Caption = 'Generate'
      OnExecute = ActionCodeGenForPatternExecute
    end
  end
end
