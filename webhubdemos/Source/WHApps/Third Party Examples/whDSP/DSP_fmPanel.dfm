inherited fmPanel: TfmPanel
  Left = 263
  Top = 191
  Width = 321
  Height = 245
  Caption = '&Panel'
  Position = poDefault
  PixelsPerInch = 96
  TextHeight = 13
  inherited pa: TPanel
    Width = 313
    Height = 201
    object PageControl1: TPageControl
      Left = 5
      Top = 5
      Width = 303
      Height = 191
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        object Panel: TPanel
          Left = 0
          Top = 40
          Width = 295
          Height = 123
          Align = alClient
          BevelOuter = bvNone
          BorderStyle = bsSingle
          TabOrder = 0
        end
        object ToolBar: TtpToolBar
          Left = 0
          Top = 0
          Width = 295
          TabOrder = 1
        end
      end
    end
  end
end
