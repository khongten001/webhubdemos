object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'TPack: generate bootstrap unit for use with IBObjects'
  ClientHeight = 608
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  PixelsPerInch = 120
  TextHeight = 28
  object Label1: TLabel
    Left = 16
    Top = 57
    Width = 857
    Height = 28
    AutoSize = False
    Caption = 'D:\Projects\webhubdemos\Source\WHApps\DB Examples\whFirebird'
  end
  object Button1: TButton
    Left = 16
    Top = 496
    Width = 857
    Height = 97
    Caption = 'Generate bootstrap unit for project abbrev'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 15
    Width = 299
    Height = 36
    Hint = 'Project Abbreviation'
    TabOrder = 1
    Text = 'Employee'
  end
  object FileListBox1: TFileListBox
    Left = 16
    Top = 351
    Width = 857
    Height = 97
    FileEdit = EditFilespec
    ItemHeight = 28
    Mask = 'uFirebird_Connect_*.pas'
    TabOrder = 2
  end
  object EditFilespec: TEdit
    Left = 16
    Top = 454
    Width = 857
    Height = 36
    AutoSize = False
    TabOrder = 3
    Text = 'uFirebird_Connect_*.pas'
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 16
    Top = 91
    Width = 857
    Height = 254
    DirLabel = Label1
    FileList = FileListBox1
    ItemHeight = 28
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    Left = 368
    Top = 15
    Width = 249
    Height = 36
    Caption = 'UpdatedOnAt fields'
    TabOrder = 5
  end
end
