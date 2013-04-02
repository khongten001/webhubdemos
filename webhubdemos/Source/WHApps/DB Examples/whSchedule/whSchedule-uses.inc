
{$IFDEF INHOUSE}
  ucCalifTime in 'O:\WebApplication\project-hrefrack-d\trunk\meta\Source\SharedAll\ucCalifTime.pas',
(* keyword index requires Rubicon *)
  whSchedule_dmKeywordSearch in 'whSchedule_dmKeywordSearch.pas' {DMRubiconSearch: TDataModule},
  whSchedule_fmKeywordIndex in 'whSchedule_fmKeywordIndex.pas' {fmRubiconIndex},
(* when compiling with source use these *)
  IB_Import in 'K:\Vendors\CPS\IBObjects\v5.x\source\tools\IB_Import.pas',
  IB_Export in 'K:\Vendors\CPS\IBObjects\v5.x\source\tools\IB_Export.pas',
  rbMake in 'K:\Rubicon\source\rbMake.pas',
  rbAccept in 'K:\Rubicon\source\rbAccept.pas',
  rbPrgDlg in 'K:\Rubicon\source\rbPrgDlg.pas' {rbProgressDlg},
  rbCache in 'K:\Rubicon\source\rbCache.pas',
  rbSearch in 'K:\Rubicon\source\rbSearch.pas',
  webRubi in 'K:\WebHub\lib\whplus\rubi\webRubi.pas',
  whCodeGenIBObj in 'K:\WebHub\lib\whplus\whCodeGenIBObj.pas',
  whutil_RegExParsing in 'K:\WebHub\lib\whplus\whutil_RegExParsing.pas',
//  ucIBObjPrepare in 'K:\WebHub\tpack\ucIBObjPrepare.pas',

{$ENDIF}

