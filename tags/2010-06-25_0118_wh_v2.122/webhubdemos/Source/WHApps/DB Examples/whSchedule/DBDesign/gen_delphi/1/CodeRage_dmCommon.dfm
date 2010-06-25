object dmCommon: TdmCommon
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 206
  Top = 107
  Height = 480
  Width = 696
  object cn1: TIB_Connection
    SQLDialect = 3
    DatabaseName = 'dbcoderageschedule'
    Left = 48
    Top = 16
  end
  object tr1: TIB_Transaction
    Isolation = tiConcurrency
    Left = 128
    Top = 16
  end
  object sp_g_AboutNo: TIB_StoredProc
    DatabaseName = 'dbcoderageschedule'
    IB_Connection = cn1
    SQL.Strings = (
      'EXECUTE PROCEDURE sp_g_AboutNo')
    StoredProcName = 'sp_g_AboutNo'
    Left = 48
    Top = 68
  end
  object sp_g_ScheduleNo: TIB_StoredProc
    DatabaseName = 'dbcoderageschedule'
    IB_Connection = cn1
    SQL.Strings = (
      'EXECUTE PROCEDURE sp_g_ScheduleNo')
    StoredProcName = 'sp_g_ScheduleNo'
    Left = 180
    Top = 68
  end
  object sp_g_XProductNo: TIB_StoredProc
    DatabaseName = 'dbcoderageschedule'
    IB_Connection = cn1
    SQL.Strings = (
      'EXECUTE PROCEDURE sp_g_XProductNo')
    StoredProcName = 'sp_g_XProductNo'
    Left = 312
    Top = 68
  end
  object quInsertAbout: TIB_DSQL
    DatabaseName = 'dbcoderageschedule'
    Left = 48
    Top = 120
  end
  object quInsertSchedule: TIB_DSQL
    DatabaseName = 'dbcoderageschedule'
    Left = 180
    Top = 120
  end
  object quInsertXProduct: TIB_DSQL
    DatabaseName = 'dbcoderageschedule'
    Left = 312
    Top = 120
  end
end
