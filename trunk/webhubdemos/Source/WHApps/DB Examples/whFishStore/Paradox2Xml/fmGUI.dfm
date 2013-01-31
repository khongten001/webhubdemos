object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Convert Paradox to XML'
  ClientHeight = 338
  ClientWidth = 918
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 25
  object tpComponentPanel1: TtpComponentPanel
    Left = 0
    Top = 0
    Width = 145
    Height = 338
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 145
    Top = 0
    Width = 773
    Height = 338
    Align = alClient
    TabOrder = 1
    object LabeledEditParadox: TLabeledEdit
      Left = 16
      Top = 32
      Width = 689
      Height = 33
      EditLabel.Width = 159
      EditLabel.Height = 25
      EditLabel.Caption = 'Paradox DB Filespec'
      TabOrder = 0
    end
    object Button1: TButton
      Left = 16
      Top = 144
      Width = 689
      Height = 49
      Action = ActionConvert
      TabOrder = 1
    end
    object LabeledEditXML: TLabeledEdit
      Left = 16
      Top = 96
      Width = 689
      Height = 33
      EditLabel.Width = 102
      EditLabel.Height = 25
      EditLabel.Caption = 'XML Filespec'
      TabOrder = 2
    end
    object Button2: TButton
      Left = 711
      Top = 36
      Width = 35
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = Button2Click
    end
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 56
    Top = 224
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = Table1
    Left = 56
    Top = 184
  end
  object Table1: TTable
    DatabaseName = 'D:\Projects\webhubdemos\Live\Database\whFishStore'
    TableName = 'fishcost.DB'
    Left = 56
    Top = 128
  end
  object FileOpenDialog1: TFileOpenDialog
    DefaultExtension = '*.db'
    DefaultFolder = 'd:\Projects\WebHubDemos\Live\Database'
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 56
    Top = 272
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Action = FileExit1
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Action = ActionAbout
      end
    end
  end
  object ActionList1: TActionList
    Left = 88
    Top = 8
    object FileExit1: TFileExit
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
    end
    object ActionConvert: TAction
      Category = 'File'
      Caption = 'Convert Paradox to XML'
      OnExecute = ActionConvertExecute
    end
    object ActionAbout: TAction
      Category = 'File'
      Caption = 'About'
      OnExecute = ActionAboutExecute
    end
  end
end
