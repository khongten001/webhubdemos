object dmStreams: TdmStreams
  OldCreateOrder = True
  Height = 150
  Width = 215
  object waDocStreams: TwhWebActionEx
    ComponentOptions = [tpUpdateOnLoad, tpUpdateOnGet]
    OnExecute = waDocStreamsExecute
    Left = 35
    Top = 53
  end
end
