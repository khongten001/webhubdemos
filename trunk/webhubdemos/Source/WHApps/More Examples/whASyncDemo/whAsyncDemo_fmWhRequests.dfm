inherited fmWhRequests: TfmWhRequests
  Left = 157
  Top = 146
  Width = 508
  Height = 308
  Caption = '&Requests[2]'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 500
    Height = 264
    object ToolBar: TtpToolBar
      Left = 5
      Top = 5
      Width = 490
      BorderWidth = 5
      TabOrder = 0
      object CheckBox1: TCheckBox
        Left = 8
        Top = 12
        Width = 185
        Height = 17
        Caption = 'Show each request in the listbox'
        TabOrder = 0
      end
    end
    object Panel: TPanel
      Left = 5
      Top = 45
      Width = 490
      Height = 214
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      object PageControl1: TPageControl
        Left = 0
        Top = 0
        Width = 486
        Height = 210
        ActivePage = TabSheet5
        Align = alClient
        TabOrder = 0
        object TabSheet5: TTabSheet
          Caption = 'Requests'
          object ListBox1: TListBox
            Left = 0
            Top = 0
            Width = 478
            Height = 182
            Align = alClient
            ItemHeight = 13
            TabOrder = 0
            TabWidth = 50
          end
        end
        object TabSheet1: TTabSheet
          Caption = 'TabSheet1'
          object WebHtmlMemo1: TwhguiTekoMemo
            Left = 0
            Top = 0
            Width = 478
            Height = 182
            Align = alClient
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
            Width = 478
            Height = 182
            Align = alClient
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
            Width = 478
            Height = 182
            Align = alClient
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
            Width = 478
            Height = 182
            Align = alClient
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
  object wa: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waExecute
    DirectCallOk = True
    Left = 152
    Top = 150
  end
end
