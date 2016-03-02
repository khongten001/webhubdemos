object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Delphi TAmazonStorageService'
  ClientHeight = 677
  ClientWidth = 753
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 25
  object Panel1: TPanel
    Left = 0
    Top = 401
    Width = 753
    Height = 276
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 0
    ExplicitTop = 371
    ExplicitHeight = 282
    object Button1: TButton
      Left = 581
      Top = 6
      Width = 138
      Height = 105
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
    object GroupBox2: TGroupBox
      Left = 1
      Top = 1
      Width = 270
      Height = 274
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      Caption = 'Source folder'
      Padding.Left = 10
      TabOrder = 1
      ExplicitHeight = 227
      object DriveComboBox1: TDriveComboBox
        Left = 12
        Top = 27
        Width = 256
        Height = 31
        Align = alTop
        DirList = DirectoryListBox1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitLeft = 15
        ExplicitWidth = 253
      end
      object DirectoryListBox1: TDirectoryListBox
        Left = 12
        Top = 58
        Width = 256
        Height = 214
        Align = alClient
        DirLabel = Label1
        FileList = FileListBox1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemHeight = 25
        ParentFont = False
        TabOrder = 1
        ExplicitLeft = 14
        ExplicitTop = 90
        ExplicitWidth = 253
        ExplicitHeight = 175
      end
    end
    object GroupBox3: TGroupBox
      Left = 271
      Top = 1
      Width = 304
      Height = 274
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      Caption = 'File to upload'
      Padding.Left = 10
      TabOrder = 2
      ExplicitHeight = 227
      object Label1: TLabel
        Left = 12
        Top = 27
        Width = 290
        Height = 25
        Align = alTop
        Caption = 'C:\WINDOWS\system32'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 6
        ExplicitWidth = 194
      end
      object FileListBox1: TFileListBox
        Left = 12
        Top = 52
        Width = 290
        Height = 220
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemHeight = 25
        ParentFont = False
        TabOrder = 0
        ExplicitLeft = 6
        ExplicitWidth = 296
        ExplicitHeight = 173
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 753
    Height = 401
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    TabOrder = 1
    object LabeledEditBucket: TLabeledEdit
      Left = 40
      Top = 33
      Width = 298
      Height = 33
      EditLabel.Width = 206
      EditLabel.Height = 25
      EditLabel.Caption = 'Bucket (try one in US East)'
      TabOrder = 0
      Text = 'screenshots.href.com'
    end
    object LabeledEditAccessKey: TLabeledEdit
      Left = 40
      Top = 108
      Width = 298
      Height = 33
      EditLabel.Width = 143
      EditLabel.Height = 25
      EditLabel.Caption = 'Bucket Access Key'
      TabOrder = 1
    end
    object LabeledEditSecret: TLabeledEdit
      Left = 40
      Top = 176
      Width = 578
      Height = 33
      EditLabel.Width = 128
      EditLabel.Height = 25
      EditLabel.Caption = 'Secret Password'
      TabOrder = 2
    end
    object LabeledEditTargetPath: TLabeledEdit
      Left = 40
      Top = 241
      Width = 578
      Height = 33
      EditLabel.Width = 443
      EditLabel.Height = 25
      EditLabel.Caption = 'Upload Target Path ( blank or end with / example data/ )'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object GroupBox1: TGroupBox
      Left = 370
      Top = 10
      Width = 351
      Height = 131
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Messages (when uploading)'
      TabOrder = 4
      object Memo1: TMemo
        Left = 2
        Top = 27
        Width = 347
        Height = 102
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Lines.Strings = (
          'Memo1')
        TabOrder = 0
      end
    end
  end
  object GroupBox4: TGroupBox
    Left = 40
    Top = 280
    Width = 679
    Height = 105
    Caption = 'Custom Header(s)'
    TabOrder = 2
    object MemoCustomHeaders: TMemo
      Left = 2
      Top = 27
      Width = 675
      Height = 76
      Align = alClient
      Lines.Strings = (
        'Content-Type=text/html'
        'Cache-Control=max-age=31557600'
        '')
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = 26
      ExplicitHeight = 55
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
