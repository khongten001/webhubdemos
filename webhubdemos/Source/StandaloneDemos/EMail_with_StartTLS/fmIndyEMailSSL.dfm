object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Test Secure EMail with Indy'
  ClientHeight = 654
  ClientWidth = 1164
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 28
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1164
    Height = 654
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Memo1: TMemo
      Left = 16
      Top = 335
      Width = 513
      Height = 142
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      Lines.Strings = (
        'Test  message'
        'line 2'
        'and line 3.'
        'Bye.')
      ParentFont = False
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 16
      Top = 591
      Width = 1113
      Height = 49
      Caption = 'Test Secure EMail'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      Kind = bkYes
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = BitBtn2Click
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 483
      Width = 241
      Height = 42
      Caption = 'Include Attachment'
      TabOrder = 2
    end
    object RadioGroup1: TRadioGroup
      Left = 576
      Top = 244
      Width = 249
      Height = 282
      Caption = 'Errors'
      ItemIndex = 0
      Items.Strings = (
        'no intentional errors'
        'bad smtp server'
        'bad username'
        'bad password'
        'bad sender'
        'bad recipient'
        'missing file attachment')
      TabOrder = 3
    end
    object GroupBox1: TGroupBox
      Left = 576
      Top = 0
      Width = 553
      Height = 249
      Caption = 'SMTP Login'
      TabOrder = 4
      object editSMTP: TLabeledEdit
        Left = 16
        Top = 56
        Width = 513
        Height = 36
        EditLabel.Width = 110
        EditLabel.Height = 28
        EditLabel.Caption = 'SMTP Server'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = 'email-smtp.us-east-1.amazonaws.com'
      end
      object EditUser: TLabeledEdit
        Left = 16
        Top = 128
        Width = 513
        Height = 36
        EditLabel.Width = 87
        EditLabel.Height = 28
        EditLabel.Caption = 'Username'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object editPass: TLabeledEdit
        Left = 16
        Top = 202
        Width = 513
        Height = 36
        EditLabel.Width = 82
        EditLabel.Height = 28
        EditLabel.Caption = 'Password'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
    end
    object editFilespec: TLabeledEdit
      Left = 16
      Top = 549
      Width = 513
      Height = 36
      EditLabel.Width = 176
      EditLabel.Height = 28
      EditLabel.Caption = 'Attachment Filespec'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object rbAttachmentTechnique: TRadioGroup
      Left = 831
      Top = 255
      Width = 298
      Height = 271
      Caption = 'Attachment'
      ItemIndex = 0
      Items.Strings = (
        '01 simplest PDF attachment'
        '02 explicit content type'
        '03 ContentTransfer 8BIT'
        '04 TIdMessageBuilderPlain')
      TabOrder = 6
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 0
      Width = 553
      Height = 329
      Caption = 'EMail Envelope'
      TabOrder = 7
      object edSubject: TLabeledEdit
        Left = 16
        Top = 277
        Width = 513
        Height = 36
        EditLabel.Width = 65
        EditLabel.Height = 28
        EditLabel.Caption = 'Subject'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = 'testing aws email'
      end
      object edFrom: TLabeledEdit
        Left = 16
        Top = 56
        Width = 513
        Height = 36
        EditLabel.Width = 46
        EditLabel.Height = 28
        EditLabel.Caption = 'From'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = 'info@href.com'
      end
      object EdCC: TLabeledEdit
        Left = 16
        Top = 202
        Width = 513
        Height = 36
        EditLabel.Width = 24
        EditLabel.Height = 28
        EditLabel.Caption = 'CC'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object edTo: TLabeledEdit
        Left = 16
        Top = 128
        Width = 513
        Height = 36
        EditLabel.Width = 22
        EditLabel.Height = 28
        EditLabel.Caption = 'To'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = 'webmaster@href.com'
      end
    end
    object cbUTF8: TCheckBox
      Left = 288
      Top = 483
      Width = 241
      Height = 42
      Caption = 'Add UTF8 Content'
      TabOrder = 8
    end
  end
end
