inherited FormImport: TFormImport
  Left = 471
  Top = 110
  Width = 450
  Height = 356
  Caption = '&Import Data'
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 432
    Height = 292
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 5
      Width = 100
      Height = 282
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 105
      Top = 5
      Width = 322
      Height = 282
      Align = alClient
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 56
        Width = 507
        Height = 18
        Caption = 
          'This panel is provided to demonstrate how you can scan directori' +
          'es.'
      end
      object Toolbar: TtpToolBar
        Left = 1
        Top = 1
        Width = 320
        TabOrder = 0
        object tpToolButton1: TtpToolButton
          Left = 1
          Top = 1
          Width = 186
          Caption = 'Load Files into Database'
          OnClick = tpToolButton1Click
          MinWidth = 28
        end
      end
      object EditDirectory: TEdit
        Left = 8
        Top = 80
        Width = 297
        Height = 26
        Hint = 'Directory to Scan for Files'
        TabOrder = 1
      end
      object EditURL: TEdit
        Left = 8
        Top = 112
        Width = 297
        Height = 26
        Hint = 'Equivalent URL to enter into database for these files.'
        TabOrder = 2
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 292
    Width = 432
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    PanelStatusIndex = 0
  end
  object Table1: TTable
    TableName = 'graphics.db'
    Left = 25
    Top = 61
  end
end
