object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Delphi TAmazonStorageService'
  ClientHeight = 548
  ClientWidth = 768
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 25
  object Label1: TLabel
    Left = 297
    Top = 377
    Width = 168
    Height = 25
    Caption = 'D:\...\Source\WHApp'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 584
    Top = 389
    Width = 137
    Height = 125
    Caption = 'Upload to S3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object LabeledEditBucket: TLabeledEdit
    Left = 40
    Top = 24
    Width = 297
    Height = 33
    EditLabel.Width = 52
    EditLabel.Height = 25
    EditLabel.Caption = 'Bucket'
    TabOrder = 1
    Text = 'screenshots.href.com'
  end
  object LabeledEditAccessKey: TLabeledEdit
    Left = 40
    Top = 96
    Width = 297
    Height = 33
    EditLabel.Width = 86
    EditLabel.Height = 25
    EditLabel.Caption = 'Access Key'
    TabOrder = 2
  end
  object LabeledEditSecret: TLabeledEdit
    Left = 40
    Top = 168
    Width = 577
    Height = 33
    EditLabel.Width = 48
    EditLabel.Height = 25
    EditLabel.Caption = 'Secret'
    TabOrder = 3
  end
  object FileListBox1: TFileListBox
    Left = 297
    Top = 408
    Width = 265
    Height = 106
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    ItemHeight = 25
    ParentFont = False
    TabOrder = 4
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 40
    Top = 417
    Width = 241
    Height = 97
    DirLabel = Label1
    FileList = FileListBox1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    ItemHeight = 25
    ParentFont = False
    TabOrder = 5
  end
  object DriveComboBox1: TDriveComboBox
    Left = 40
    Top = 380
    Width = 145
    Height = 31
    DirList = DirectoryListBox1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object LabeledEditTargetPath: TLabeledEdit
    Left = 40
    Top = 233
    Width = 577
    Height = 33
    EditLabel.Width = 446
    EditLabel.Height = 25
    EditLabel.Caption = 'Upload Target Path ( blank or end with / example data/ )'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
  end
  object EditCustomHeader: TLabeledEdit
    Left = 40
    Top = 306
    Width = 577
    Height = 33
    EditLabel.Width = 354
    EditLabel.Height = 25
    EditLabel.Caption = 'Custom Header e.g. Content-Type=text/html'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    Text = ''
  end
  object AmazonConnectionInfo1: TAmazonConnectionInfo
    Protocol = 'https'
    TableEndpoint = 'sdb.amazonaws.com'
    QueueEndpoint = 'queue.amazonaws.com'
    StorageEndpoint = 's3.amazonaws.com'
    Left = 568
    Top = 64
  end
end
