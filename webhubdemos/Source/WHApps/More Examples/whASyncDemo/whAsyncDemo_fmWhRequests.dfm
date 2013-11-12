inherited fmWhRequests: TfmWhRequests
  Left = 157
  Top = 146
  Caption = '&Requests[2]'
  ClientHeight = 263
  ClientWidth = 490
  ExplicitWidth = 508
  ExplicitHeight = 308
  PixelsPerInch = 120
  TextHeight = 18
  inherited pa: TPanel
    Width = 490
    Height = 263
    ExplicitWidth = 490
    ExplicitHeight = 263
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 480
      BorderWidth = 5
      TabOrder = 0
      object CheckBox1: TCheckBox
        Left = 8
        Top = 12
        Width = 329
        Height = 17
        Caption = 'Show each request in the listbox'
        TabOrder = 0
      end
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 480
      Height = 213
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      object PageControl1: TPageControl
        Left = 0
        Top = 0
        Width = 476
        Height = 209
        ActivePage = TabSheet4
        Align = alClient
        TabOrder = 0
        object TabSheet5: TTabSheet
          Caption = 'Requests'
          object ListBox1: TListBox
            Left = 0
            Top = 0
            Width = 468
            Height = 176
            Align = alClient
            ItemHeight = 18
            TabOrder = 0
            TabWidth = 50
          end
        end
        object TabSheet1: TTabSheet
          Caption = 'TabSheet1'
          object WebHtmlMemo1: TwhguiTekoMemo
            Left = 0
            Top = 0
            Width = 468
            Height = 176
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -18
            Font.Name = 'Lucida Sans Unicode'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
            ConfirmReadOnly = False
            ClearLines = True
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'TabSheet2'
          object WebHtmlMemo2: TwhguiTekoMemo
            Left = 0
            Top = 0
            Width = 468
            Height = 176
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -18
            Font.Name = 'Lucida Sans Unicode'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
            ConfirmReadOnly = False
            ClearLines = True
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'TabSheet3'
          object WebHtmlMemo3: TwhguiTekoMemo
            Left = 0
            Top = 0
            Width = 468
            Height = 176
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -18
            Font.Name = 'Lucida Sans Unicode'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
            ConfirmReadOnly = False
            ClearLines = True
          end
        end
        object TabSheet4: TTabSheet
          Caption = 'TabSheet4'
          object WebHtmlMemo4: TwhguiTekoMemo
            Left = 0
            Top = 0
            Width = 468
            Height = 176
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -18
            Font.Name = 'Lucida Sans Unicode'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
            ConfirmReadOnly = False
            ClearLines = True
          end
        end
      end
    end
  end
end
