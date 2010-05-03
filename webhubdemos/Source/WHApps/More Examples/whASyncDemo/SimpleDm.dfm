object dmSimpleAsync: TdmSimpleAsync
  OldCreateOrder = True
  Height = 479
  Width = 742
  object waAsyncSimple1: TwhAsyncAction
    ComponentOptions = [tpUpdateOnLoad, tpStatusPanel]
    OnExecute = waAsyncSimple1Execute
    TicksExpires = 3600000
    AsyncState = asInit
    ThreadOnInit = waAsyncSimple1ThreadOnInit
    ThreadOnExecute = waAsyncSimple1ThreadOnExecute
    ThreadOnDestroy = waAsyncSimple1ThreadOnDestroy
    Left = 108
    Top = 20
  end
end
