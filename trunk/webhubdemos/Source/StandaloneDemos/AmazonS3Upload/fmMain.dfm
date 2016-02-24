object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Delphi TAmazonStorageService'
  ClientHeight = 480
  ClientWidth = 602
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 297
    Width = 602
    Height = 183
    Align = alClient
    TabOrder = 0
    object Button1: TButton
      Left = 465
      Top = 5
      Width = 110
      Height = 84
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Upload to S3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 1
      Width = 216
      Height = 181
      Align = alLeft
      Caption = 'Source folder'
      Padding.Left = 10
      TabOrder = 1
      object DriveComboBox1: TDriveComboBox
        Left = 12
        Top = 21
        Width = 202
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alTop
        DirList = DirectoryListBox1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object DirectoryListBox1: TDirectoryListBox
        Left = 12
        Top = 46
        Width = 202
        Height = 133
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alClient
        DirLabel = Label1
        FileList = FileListBox1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemHeight = 19
        ParentFont = False
        TabOrder = 1
      end
    end
    object GroupBox3: TGroupBox
      Left = 217
      Top = 1
      Width = 243
      Height = 181
      Align = alLeft
      Caption = 'File to upload'
      Padding.Left = 3
      TabOrder = 2
      object Label1: TLabel
        Left = 5
        Top = 21
        Width = 236
        Height = 19
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alTop
        Caption = 'D:\'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 18
      end
      object FileListBox1: TFileListBox
        Left = 5
        Top = 40
        Width = 236
        Height = 139
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemHeight = 19
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 602
    Height = 297
    Align = alTop
    TabOrder = 1
    object LabeledEditBucket: TLabeledEdit
      Left = 32
      Top = 26
      Width = 238
      Height = 27
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      EditLabel.Width = 162
      EditLabel.Height = 19
      EditLabel.Margins.Left = 2
      EditLabel.Margins.Top = 2
      EditLabel.Margins.Right = 2
      EditLabel.Margins.Bottom = 2
      EditLabel.Caption = 'Bucket (try one in US East)'
      TabOrder = 0
      Text = 'screenshots.href.com'
    end
    object LabeledEditAccessKey: TLabeledEdit
      Left = 32
      Top = 86
      Width = 238
      Height = 27
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      EditLabel.Width = 111
      EditLabel.Height = 19
      EditLabel.Margins.Left = 2
      EditLabel.Margins.Top = 2
      EditLabel.Margins.Right = 2
      EditLabel.Margins.Bottom = 2
      EditLabel.Caption = 'Bucket Access Key'
      TabOrder = 1
    end
    object LabeledEditSecret: TLabeledEdit
      Left = 32
      Top = 141
      Width = 462
      Height = 27
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      EditLabel.Width = 99
      EditLabel.Height = 19
      EditLabel.Margins.Left = 2
      EditLabel.Margins.Top = 2
      EditLabel.Margins.Right = 2
      EditLabel.Margins.Bottom = 2
      EditLabel.Caption = 'Secret Password'
      TabOrder = 2
    end
    object LabeledEditTargetPath: TLabeledEdit
      Left = 32
      Top = 193
      Width = 462
      Height = 27
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      EditLabel.Width = 345
      EditLabel.Height = 19
      EditLabel.Margins.Left = 2
      EditLabel.Margins.Top = 2
      EditLabel.Margins.Right = 2
      EditLabel.Margins.Bottom = 2
      EditLabel.Caption = 'Upload Target Path ( blank or end with / example data/ )'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object EditCustomHeader: TLabeledEdit
      Left = 32
      Top = 252
      Width = 462
      Height = 27
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      EditLabel.Width = 276
      EditLabel.Height = 19
      EditLabel.Margins.Left = 2
      EditLabel.Margins.Top = 2
      EditLabel.Margins.Right = 2
      EditLabel.Margins.Bottom = 2
      EditLabel.Caption = 'Custom Header e.g. Content-Type=text/html'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object GroupBox1: TGroupBox
      Left = 296
      Top = 8
      Width = 281
      Height = 105
      Caption = 'Messages (when uploading)'
      TabOrder = 5
      object Memo1: TMemo
        Left = 2
        Top = 21
        Width = 277
        Height = 82
        Align = alClient
        Lines.Strings = (
          'Memo1')
        TabOrder = 0
      end
    end
  end
  object AmazonConnectionInfo1: TAmazonConnectionInfo
    TableEndpoint = 'sdb.amazonaws.com'
    QueueEndpoint = 'queue.amazonaws.com'
    StorageEndpoint = 's3.amazonaws.com'
    Left = 520
    Top = 192
  end
end
