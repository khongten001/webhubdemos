object Admindm1: TAdmindm1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 192
  Top = 114
  Height = 480
  Width = 696
  object iboqABOUT: TIBOQuery
    Params = <>
    DatabaseName = 'dbcoderageschedule'
    RecordCountAccurate = True
    AfterOpen = iboqABOUTAfterOpen   
    BeforePost = iboqABOUTBeforePost
    SQL.Strings = (
      'select * from About')
    FieldOptions = []
    Left = 48
    Top = 68
  end
  object dsABOUT: TDataSource
    DataSet = iboqABOUT
    Left = 180
    Top = 68
  end
  object iboqSCHEDULE: TIBOQuery
    Params = <>
    DatabaseName = 'dbcoderageschedule'
    RecordCountAccurate = True
    AfterOpen = iboqSCHEDULEAfterOpen   
    BeforePost = iboqSCHEDULEBeforePost
    SQL.Strings = (
      'select * from Schedule')
    FieldOptions = []
    Left = 312
    Top = 68
  end
  object dsSCHEDULE: TDataSource
    DataSet = iboqSCHEDULE
    Left = 444
    Top = 68
  end
  object iboqXPRODUCT: TIBOQuery
    Params = <>
    DatabaseName = 'dbcoderageschedule'
    RecordCountAccurate = True
    AfterOpen = iboqXPRODUCTAfterOpen   
    BeforePost = iboqXPRODUCTBeforePost
    SQL.Strings = (
      'select * from XProduct')
    FieldOptions = []
    Left = 576
    Top = 68
  end
  object dsXPRODUCT: TDataSource
    DataSet = iboqXPRODUCT
    Left = 708
    Top = 68
  end
end

