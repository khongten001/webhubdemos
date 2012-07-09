object dmCommon: TdmCommon
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 696
  object cn1: TIB_Connection
    CacheStatementHandles = False
    SQLDialect = 3
    DatabaseName = 'dbcoderageschedule'
    Params.Strings = (
      'SQL DIALECT=3')
    Left = 48
    Top = 16
  end
  object tr1: TIB_Transaction
    Isolation = tiConcurrency
    Left = 128
    Top = 16
  end
end
