object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Test Secure EMail with Indy'
  ClientHeight = 523
  ClientWidth = 931
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 21
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 931
    Height = 523
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
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 13
      Top = 233
      Width = 110
      Height = 19
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Plain text content:'
    end
    object Label2: TLabel
      Left = 13
      Top = 361
      Width = 289
      Height = 19
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'HTML content (erase this for attachment tests):'
    end
    object Memo1: TMemo
      Left = 13
      Top = 256
      Width = 429
      Height = 97
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      Lines.Strings = (
        'Test message'
        'line 2'
        'and line 3.'
        'Bye.')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
    object BitBtn2: TBitBtn
      Left = 13
      Top = 472
      Width = 890
      Height = 39
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Test Secure EMail'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      Kind = bkYes
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = ClickTestSecureEMail
    end
    object CheckBox1: TCheckBox
      Left = 665
      Top = 194
      Width = 193
      Height = 34
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Include Attachment'
      TabOrder = 2
    end
    object RadioGroup1: TRadioGroup
      Left = 461
      Top = 247
      Width = 199
      Height = 226
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
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
      Left = 461
      Top = 0
      Width = 442
      Height = 199
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'SMTP Login'
      TabOrder = 4
      object editSMTP: TLabeledEdit
        Left = 13
        Top = 45
        Width = 410
        Height = 27
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        EditLabel.Width = 77
        EditLabel.Height = 19
        EditLabel.Margins.Left = 2
        EditLabel.Margins.Top = 2
        EditLabel.Margins.Right = 2
        EditLabel.Margins.Bottom = 2
        EditLabel.Caption = 'SMTP Server'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = 'email-smtp.us-east-1.amazonaws.com'
      end
      object EditUser: TLabeledEdit
        Left = 13
        Top = 102
        Width = 410
        Height = 27
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        EditLabel.Width = 62
        EditLabel.Height = 19
        EditLabel.Margins.Left = 2
        EditLabel.Margins.Top = 2
        EditLabel.Margins.Right = 2
        EditLabel.Margins.Bottom = 2
        EditLabel.Caption = 'Username'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object editPass: TLabeledEdit
        Left = 13
        Top = 162
        Width = 410
        Height = 27
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        EditLabel.Width = 58
        EditLabel.Height = 19
        EditLabel.Margins.Left = 2
        EditLabel.Margins.Top = 2
        EditLabel.Margins.Right = 2
        EditLabel.Margins.Bottom = 2
        EditLabel.Caption = 'Password'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
    end
    object editFilespec: TLabeledEdit
      Left = 474
      Top = 222
      Width = 410
      Height = 27
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      EditLabel.Width = 123
      EditLabel.Height = 19
      EditLabel.Margins.Left = 2
      EditLabel.Margins.Top = 2
      EditLabel.Margins.Right = 2
      EditLabel.Margins.Bottom = 2
      EditLabel.Caption = 'Attachment Filespec'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object rbAttachmentTechnique: TRadioGroup
      Left = 665
      Top = 247
      Width = 238
      Height = 135
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
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
      Width = 442
      Height = 231
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'EMail Envelope'
      TabOrder = 7
      object edSubject: TLabeledEdit
        Left = 13
        Top = 187
        Width = 410
        Height = 27
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        EditLabel.Width = 44
        EditLabel.Height = 19
        EditLabel.Margins.Left = 2
        EditLabel.Margins.Top = 2
        EditLabel.Margins.Right = 2
        EditLabel.Margins.Bottom = 2
        EditLabel.Caption = 'Subject'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = 'testing aws email'
      end
      object edFrom: TLabeledEdit
        Left = 13
        Top = 45
        Width = 410
        Height = 27
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        EditLabel.Width = 32
        EditLabel.Height = 19
        EditLabel.Margins.Left = 2
        EditLabel.Margins.Top = 2
        EditLabel.Margins.Right = 2
        EditLabel.Margins.Bottom = 2
        EditLabel.Caption = 'From'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = 'info@href.com'
      end
      object EdCC: TLabeledEdit
        Left = 13
        Top = 136
        Width = 193
        Height = 27
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        EditLabel.Width = 18
        EditLabel.Height = 19
        EditLabel.Margins.Left = 2
        EditLabel.Margins.Top = 2
        EditLabel.Margins.Right = 2
        EditLabel.Margins.Bottom = 2
        EditLabel.Caption = 'CC'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object edTo: TLabeledEdit
        Left = 13
        Top = 90
        Width = 410
        Height = 27
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        EditLabel.Width = 14
        EditLabel.Height = 19
        EditLabel.Margins.Left = 2
        EditLabel.Margins.Top = 2
        EditLabel.Margins.Right = 2
        EditLabel.Margins.Bottom = 2
        EditLabel.Caption = 'To'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = 'webmaster@href.com'
      end
      object EdReplyTo: TLabeledEdit
        Left = 230
        Top = 136
        Width = 193
        Height = 27
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        EditLabel.Width = 51
        EditLabel.Height = 19
        EditLabel.Margins.Left = 2
        EditLabel.Margins.Top = 2
        EditLabel.Margins.Right = 2
        EditLabel.Margins.Bottom = 2
        EditLabel.Caption = 'Reply To'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
    end
    object cbUTF8: TCheckBox
      Left = 665
      Top = 434
      Width = 193
      Height = 34
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Add UTF8 Content'
      TabOrder = 8
    end
    object Memo2: TMemo
      Left = 13
      Top = 384
      Width = 429
      Height = 84
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      Lines.Strings = (
        '<!DOCTYPE html>'
        
          '<html><head><title>hello</title></head><body><h2>Hello World</h2' +
          '>This is a <b>bold message</b> sent using Delphi and Indy.'
        '</body></html>')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 9
      WordWrap = False
    end
  end
end
