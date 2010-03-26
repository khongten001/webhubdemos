object dmStreams: TdmStreams
  OldCreateOrder = True
  Left = 225
  Top = 115
  Height = 150
  Width = 215
  object waDocStreams: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    OnExecute = waDocStreamsExecute
    Left = 35
    Top = 53
  end
end
