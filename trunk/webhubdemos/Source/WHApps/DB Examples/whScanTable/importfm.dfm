inherited FormImport: TFormImport
  Left = 471
  Top = 110
  Width = 450
  Height = 356
  Caption = '&Import Data'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 442
    Height = 299
    object tpComponentPanel2: TtpComponentPanel
      Left = 5
      Top = 5
      Width = 100
      Height = 289
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 105
      Top = 5
      Width = 332
      Height = 289
      Align = alClient
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 56
        Width = 320
        Height = 13
        Caption = 
          'This panel is provided to demonstrate how you can scan directori' +
          'es.'
      end
      object Toolbar: TtpToolBar
        Left = 1
        Top = 1
        Width = 330
        TabOrder = 0
        object tpToolButton1: TtpToolButton
          Left = 1
          Top = 1
          Width = 124
          Caption = 'Load Files into Database'
          OnClick = tpToolButton1Click
          MinWidth = 28
        end
      end
      object EditDirectory: TEdit
        Left = 8
        Top = 80
        Width = 297
        Height = 21
        Hint = 'Directory to Scan for Files'
        TabOrder = 1
      end
      object EditURL: TEdit
        Left = 8
        Top = 112
        Width = 297
        Height = 21
        Hint = 'Equivalent URL to enter into database for these files.'
        TabOrder = 2
      end
    end
  end
  object tpStatusBar1: TtpStatusBar
    Left = 0
    Top = 299
    Width = 442
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
