object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 232
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 352
    Top = 136
    Width = 129
    Height = 33
    Caption = 'Convert'
    TabOrder = 0
    OnClick = Button1Click
  end
  object LabeledEditPdx: TLabeledEdit
    Left = 24
    Top = 40
    Width = 457
    Height = 21
    EditLabel.Width = 133
    EditLabel.Height = 13
    EditLabel.Caption = 'Paradox DB Source Filespec'
    TabOrder = 1
  end
  object LabeledEditNx: TLabeledEdit
    Left = 24
    Top = 93
    Width = 457
    Height = 21
    EditLabel.Width = 103
    EditLabel.Height = 13
    EditLabel.Caption = 'NexusDB Target Path'
    TabOrder = 2
  end
  object nxTable2: TnxTable
    Database = nxDatabase2
    Left = 256
    Top = 144
  end
  object nxDatabase2: TnxDatabase
    Session = nxSession1
    Left = 184
    Top = 144
  end
  object nxServerEngine1: TnxServerEngine
    ServerName = ''
    Options = []
    TableExtension = 'nx1'
    Left = 32
    Top = 144
  end
  object nxSession1: TnxSession
    ServerEngine = nxServerEngine1
    Left = 112
    Top = 144
  end
end
