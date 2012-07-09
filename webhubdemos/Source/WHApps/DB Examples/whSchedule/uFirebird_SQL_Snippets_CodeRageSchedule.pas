//unit uFirebird_SQL_Snippets_CodeRageSchedule;
unit uFirebird_SQL_Snippets_CodeRageSchedule;
// project abbreviation: CodeRageSchedule
// generated 09-Jul-2012 06:12
// by Firebird_GenPAS_SQL_Snippets in TPack, maintained by HREF Tools Corp.

interface 

function Firebird_SQL_Insert_for_SCHEDULE: string;
function Firebird_SQL_Insert_for_XPRODUCT: string;
function Firebird_SQL_Insert_for_ABOUT: string;

function Firebird_SQL_Insert_Defaults_for_SCHEDULE: string;
function Firebird_SQL_Insert_Defaults_for_XPRODUCT: string;
function Firebird_SQL_Insert_Defaults_for_ABOUT: string;

function Firebird_SQL_Select1_from_SCHEDULE: string;
function Firebird_SQL_Select1_from_XPRODUCT: string;
function Firebird_SQL_Select1_from_ABOUT: string;

function Firebird_SQL_Update_for_SCHEDULE(const MatchUpdateCounter
  : Boolean): string;
function Firebird_SQL_Update_for_XPRODUCT(const MatchUpdateCounter
  : Boolean): string;
function Firebird_SQL_Update_for_ABOUT(const MatchUpdateCounter
  : Boolean): string;

implementation

function Firebird_SQL_Insert_for_SCHEDULE: string;
begin
  Result := 'insert into SCHEDULE ' + sLineBreak +
            '( ' + sLineBreak + 
  'SCHNO' +
  ', SCHTITLE' +
  ', SCHONATPDT' +
  ', SCHMINUTES' +
  ', SCHPRESENTERFULLNAME' +
  ', SCHPRESENTERORG' +
  ', SCHLOCATION' +
  ', SCHBLURB' +
  ', SCHREPEATOF' +
  ', SCHTAGC' +
  ', SCHTAGD' +
  ', SCHTAGPRISM' +
  ', UPDATEDBY' +
  ')' + sLineBreak + sLineBreak + 
  'VALUES( ' + sLineBreak +
  ':SCHNO' + sLineBreak + // 0
  ', :SCHTITLE' + sLineBreak + // 1
  ', :SCHONATPDT' + sLineBreak + // 2
  ', :SCHMINUTES' + sLineBreak + // 3
  ', :SCHPRESENTERFULLNAME' + sLineBreak + // 4
  ', :SCHPRESENTERORG' + sLineBreak + // 5
  ', :SCHLOCATION' + sLineBreak + // 6
  ', :SCHBLURB' + sLineBreak + // 7
  ', :SCHREPEATOF' + sLineBreak + // 8
  ', :SCHTAGC' + sLineBreak + // 9
  ', :SCHTAGD' + sLineBreak + // 10
  ', :SCHTAGPRISM' + sLineBreak + // 11
  ', :UPDATEDBY' + sLineBreak + // 12
  ') returning SCHNO';
end;

function Firebird_SQL_Insert_for_XPRODUCT: string;
begin
  Result := 'insert into XPRODUCT ' + sLineBreak +
            '( ' + sLineBreak + 
  'PRODUCTNO' +
  ', PRODUCTABBREV' +
  ', PRODUCTNAME' +
  ', UPDATEDBY' +
  ')' + sLineBreak + sLineBreak + 
  'VALUES( ' + sLineBreak +
  ':PRODUCTNO' + sLineBreak + // 0
  ', :PRODUCTABBREV' + sLineBreak + // 1
  ', :PRODUCTNAME' + sLineBreak + // 2
  ', :UPDATEDBY' + sLineBreak + // 3
  ') returning PRODUCTNO';
end;

function Firebird_SQL_Insert_for_ABOUT: string;
begin
  Result := 'insert into ABOUT ' + sLineBreak +
            '( ' + sLineBreak + 
  'ABOUTNO' +
  ', SCHNO' +
  ', PRODUCTNO' +
  ', UPDATEDBY' +
  ')' + sLineBreak + sLineBreak + 
  'VALUES( ' + sLineBreak +
  ':ABOUTNO' + sLineBreak + // 0
  ', :SCHNO' + sLineBreak + // 1
  ', :PRODUCTNO' + sLineBreak + // 2
  ', :UPDATEDBY' + sLineBreak + // 3
  ') returning ABOUTNO';
end;

function Firebird_SQL_Insert_Defaults_for_SCHEDULE: string;
begin
  Result := 'insert into SCHEDULE ' + sLineBreak +
            ' default values ' + sLineBreak + 
            ' returning SCHNO';
end;

function Firebird_SQL_Insert_Defaults_for_XPRODUCT: string;
begin
  Result := 'insert into XPRODUCT ' + sLineBreak +
            ' default values ' + sLineBreak + 
            ' returning PRODUCTNO';
end;

function Firebird_SQL_Insert_Defaults_for_ABOUT: string;
begin
  Result := 'insert into ABOUT ' + sLineBreak +
            ' default values ' + sLineBreak + 
            ' returning ABOUTNO';
end;

function Firebird_SQL_Select1_from_SCHEDULE: string;
begin
  Result := 'select * from SCHEDULE ' + sLineBreak +
    'where ' + sLineBreak +
    '(SCHNO=:SCHNO)';
end;

function Firebird_SQL_Select1_from_XPRODUCT: string;
begin
  Result := 'select * from XPRODUCT ' + sLineBreak +
    'where ' + sLineBreak +
    '(PRODUCTNO=:PRODUCTNO)';
end;

function Firebird_SQL_Select1_from_ABOUT: string;
begin
  Result := 'select * from ABOUT ' + sLineBreak +
    'where ' + sLineBreak +
    '(ABOUTNO=:ABOUTNO)';
end;

function Firebird_SQL_Update_for_SCHEDULE(const MatchUpdateCounter
  : Boolean): string;
begin
  Result := 'update SCHEDULE ' + sLineBreak +
            'set ' + sLineBreak + 
  'SCHTITLE=:SCHTITLE ' + sLineBreak + // 0
  ', SCHONATPDT=:SCHONATPDT ' + sLineBreak + // 1
  ', SCHMINUTES=:SCHMINUTES ' + sLineBreak + // 2
  ', SCHPRESENTERFULLNAME=:SCHPRESENTERFULLNAME ' + sLineBreak + // 3
  ', SCHPRESENTERORG=:SCHPRESENTERORG ' + sLineBreak + // 4
  ', SCHLOCATION=:SCHLOCATION ' + sLineBreak + // 5
  ', SCHBLURB=:SCHBLURB ' + sLineBreak + // 6
  ', SCHREPEATOF=:SCHREPEATOF ' + sLineBreak + // 7
  ', SCHTAGC=:SCHTAGC ' + sLineBreak + // 8
  ', SCHTAGD=:SCHTAGD ' + sLineBreak + // 9
  ', SCHTAGPRISM=:SCHTAGPRISM ' + sLineBreak + // 10
  ', UPDATEDBY=:UPDATEDBY ' + sLineBreak + // 11
  'WHERE (SCHNO = :SCHNO) '; // 12
  if MatchUpdateCounter then
    Result := Result +
    ' and (UpdateCounter=:UpdateCounter)'; // 13
end;

function Firebird_SQL_Update_for_XPRODUCT(const MatchUpdateCounter
  : Boolean): string;
begin
  Result := 'update XPRODUCT ' + sLineBreak +
            'set ' + sLineBreak + 
  'PRODUCTABBREV=:PRODUCTABBREV ' + sLineBreak + // 0
  ', PRODUCTNAME=:PRODUCTNAME ' + sLineBreak + // 1
  ', UPDATEDBY=:UPDATEDBY ' + sLineBreak + // 2
  'WHERE (PRODUCTNO = :PRODUCTNO) '; // 3
  if MatchUpdateCounter then
    Result := Result +
    ' and (UpdateCounter=:UpdateCounter)'; // 4
end;

function Firebird_SQL_Update_for_ABOUT(const MatchUpdateCounter
  : Boolean): string;
begin
  Result := 'update ABOUT ' + sLineBreak +
            'set ' + sLineBreak + 
  'SCHNO=:SCHNO ' + sLineBreak + // 0
  ', PRODUCTNO=:PRODUCTNO ' + sLineBreak + // 1
  ', UPDATEDBY=:UPDATEDBY ' + sLineBreak + // 2
  'WHERE (ABOUTNO = :ABOUTNO) '; // 3
  if MatchUpdateCounter then
    Result := Result +
    ' and (UpdateCounter=:UpdateCounter)'; // 4
end;

end.

