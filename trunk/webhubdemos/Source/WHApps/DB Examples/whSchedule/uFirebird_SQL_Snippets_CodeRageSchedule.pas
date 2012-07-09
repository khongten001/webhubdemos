//unit uFirebird_SQL_Snippets_CodeRageSchedule;
unit uFirebird_SQL_Snippets_CodeRageSchedule;
// project abbreviation: CodeRageSchedule
// generated 09-Jul-2012 00:03
// by Firebird_GenPAS_SQL_Snippets in TPack, maintained by HREF Tools Corp.

interface 

function Firebird_SQL_Insert_for_SCHEDULE: string;
function Firebird_SQL_Insert_for_ABOUT: string;
function Firebird_SQL_Insert_for_XPRODUCT: string;

function Firebird_SQL_Insert_Defaults_for_SCHEDULE: string;
function Firebird_SQL_Insert_Defaults_for_ABOUT: string;
function Firebird_SQL_Insert_Defaults_for_XPRODUCT: string;

function Firebird_SQL_Select1_from_SCHEDULE: string;
function Firebird_SQL_Select1_from_ABOUT: string;
function Firebird_SQL_Select1_from_XPRODUCT: string;

function Firebird_SQL_Update_for_SCHEDULE(const MatchUpdateCounter
  : Boolean): string;
function Firebird_SQL_Update_for_ABOUT(const MatchUpdateCounter
  : Boolean): string;
function Firebird_SQL_Update_for_XPRODUCT(const MatchUpdateCounter
  : Boolean): string;

implementation

function Firebird_SQL_Insert_for_SCHEDULE: string;
begin
  Result := 'insert into SCHEDULE ' + sLineBreak +
            '( ' + sLineBreak + 
  'SCHID' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
  ', SCHTITLE' +
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
  ')' + sLineBreak + sLineBreak + 
  'VALUES( ' + sLineBreak +
  ':SCHID' + sLineBreak + // 0
  ', :SCHTITLE' + sLineBreak + // 1
  ', :SCHTITLE' + sLineBreak + // 2
  ', :SCHTITLE' + sLineBreak + // 3
  ', :SCHTITLE' + sLineBreak + // 4
  ', :SCHTITLE' + sLineBreak + // 5
  ', :SCHTITLE' + sLineBreak + // 6
  ', :SCHTITLE' + sLineBreak + // 7
  ', :SCHTITLE' + sLineBreak + // 8
  ', :SCHTITLE' + sLineBreak + // 9
  ', :SCHTITLE' + sLineBreak + // 10
  ', :SCHTITLE' + sLineBreak + // 11
  ', :SCHTITLE' + sLineBreak + // 12
  ', :SCHTITLE' + sLineBreak + // 13
  ', :SCHTITLE' + sLineBreak + // 14
  ', :SCHTITLE' + sLineBreak + // 15
  ', :SCHTITLE' + sLineBreak + // 16
  ', :SCHTITLE' + sLineBreak + // 17
  ', :SCHTITLE' + sLineBreak + // 18
  ', :SCHTITLE' + sLineBreak + // 19
  ', :SCHTITLE' + sLineBreak + // 20
  ', :SCHTITLE' + sLineBreak + // 21
  ', :SCHTITLE' + sLineBreak + // 22
  ', :SCHTITLE' + sLineBreak + // 23
  ', :SCHTITLE' + sLineBreak + // 24
  ', :SCHTITLE' + sLineBreak + // 25
  ', :SCHTITLE' + sLineBreak + // 26
  ', :SCHTITLE' + sLineBreak + // 27
  ', :SCHTITLE' + sLineBreak + // 28
  ', :SCHTITLE' + sLineBreak + // 29
  ', :SCHTITLE' + sLineBreak + // 30
  ', :SCHTITLE' + sLineBreak + // 31
  ', :SCHTITLE' + sLineBreak + // 32
  ', :SCHTITLE' + sLineBreak + // 33
  ', :SCHTITLE' + sLineBreak + // 34
  ', :SCHTITLE' + sLineBreak + // 35
  ', :SCHTITLE' + sLineBreak + // 36
  ', :SCHTITLE' + sLineBreak + // 37
  ', :SCHTITLE' + sLineBreak + // 38
  ', :SCHTITLE' + sLineBreak + // 39
  ', :SCHTITLE' + sLineBreak + // 40
  ', :SCHTITLE' + sLineBreak + // 41
  ', :SCHTITLE' + sLineBreak + // 42
  ', :SCHTITLE' + sLineBreak + // 43
  ', :SCHTITLE' + sLineBreak + // 44
  ', :SCHTITLE' + sLineBreak + // 45
  ', :SCHTITLE' + sLineBreak + // 46
  ', :SCHTITLE' + sLineBreak + // 47
  ', :SCHTITLE' + sLineBreak + // 48
  ', :SCHTITLE' + sLineBreak + // 49
  ', :SCHTITLE' + sLineBreak + // 50
  ', :SCHTITLE' + sLineBreak + // 51
  ', :SCHTITLE' + sLineBreak + // 52
  ', :SCHONATPDT' + sLineBreak + // 53
  ', :SCHMINUTES' + sLineBreak + // 54
  ', :SCHPRESENTERFULLNAME' + sLineBreak + // 55
  ', :SCHPRESENTERORG' + sLineBreak + // 56
  ', :SCHLOCATION' + sLineBreak + // 57
  ', :SCHBLURB' + sLineBreak + // 58
  ', :SCHREPEATOF' + sLineBreak + // 61
  ', :SCHTAGC' + sLineBreak + // 62
  ', :SCHTAGD' + sLineBreak + // 63
  ', :SCHTAGPRISM' + sLineBreak + // 64
  ') returning SCHID';
end;

function Firebird_SQL_Insert_for_ABOUT: string;
begin
  Result := 'insert into ABOUT ' + sLineBreak +
            '( ' + sLineBreak + 
  'ABOUTID' +
  ', SCHID' +
  ', PRODUCTID' +
  ')' + sLineBreak + sLineBreak + 
  'VALUES( ' + sLineBreak +
  ':ABOUTID' + sLineBreak + // 0
  ', :SCHID' + sLineBreak + // 1
  ', :PRODUCTID' + sLineBreak + // 2
  ') returning ABOUTID';
end;

function Firebird_SQL_Insert_for_XPRODUCT: string;
begin
  Result := 'insert into XPRODUCT ' + sLineBreak +
            '( ' + sLineBreak + 
  'PRODUCTID' +
  ', PRODUCTABBREV' +
  ', PRODUCTNAME' +
  ')' + sLineBreak + sLineBreak + 
  'VALUES( ' + sLineBreak +
  ':PRODUCTID' + sLineBreak + // 0
  ', :PRODUCTABBREV' + sLineBreak + // 1
  ', :PRODUCTNAME' + sLineBreak + // 2
  ') returning PRODUCTID';
end;

function Firebird_SQL_Insert_Defaults_for_SCHEDULE: string;
begin
  Result := 'insert into SCHEDULE ' + sLineBreak +
            ' default values ' + sLineBreak + 
            ' returning SCHID';
end;

function Firebird_SQL_Insert_Defaults_for_ABOUT: string;
begin
  Result := 'insert into ABOUT ' + sLineBreak +
            ' default values ' + sLineBreak + 
            ' returning ABOUTID';
end;

function Firebird_SQL_Insert_Defaults_for_XPRODUCT: string;
begin
  Result := 'insert into XPRODUCT ' + sLineBreak +
            ' default values ' + sLineBreak + 
            ' returning PRODUCTID';
end;

function Firebird_SQL_Select1_from_SCHEDULE: string;
begin
  Result := 'select * from SCHEDULE ' + sLineBreak +
    'where ' + sLineBreak +
    '(SCHID=:SCHID)';
end;

function Firebird_SQL_Select1_from_ABOUT: string;
begin
  Result := 'select * from ABOUT ' + sLineBreak +
    'where ' + sLineBreak +
    '(ABOUTID=:ABOUTID)';
end;

function Firebird_SQL_Select1_from_XPRODUCT: string;
begin
  Result := 'select * from XPRODUCT ' + sLineBreak +
    'where ' + sLineBreak +
    '(PRODUCTID=:PRODUCTID)';
end;

function Firebird_SQL_Update_for_SCHEDULE(const MatchUpdateCounter
  : Boolean): string;
begin
  Result := 'update SCHEDULE ' + sLineBreak +
            'set ' + sLineBreak + 
  'SCHTITLE=:SCHTITLE ' + sLineBreak + // 0
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 1
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 2
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 3
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 4
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 5
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 6
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 7
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 8
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 9
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 10
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 11
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 12
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 13
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 14
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 15
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 16
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 17
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 18
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 19
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 20
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 21
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 22
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 23
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 24
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 25
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 26
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 27
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 28
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 29
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 30
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 31
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 32
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 33
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 34
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 35
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 36
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 37
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 38
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 39
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 40
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 41
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 42
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 43
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 44
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 45
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 46
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 47
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 48
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 49
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 50
  ', SCHTITLE=:SCHTITLE ' + sLineBreak + // 51
  ', SCHONATPDT=:SCHONATPDT ' + sLineBreak + // 52
  ', SCHMINUTES=:SCHMINUTES ' + sLineBreak + // 53
  ', SCHPRESENTERFULLNAME=:SCHPRESENTERFULLNAME ' + sLineBreak + // 54
  ', SCHPRESENTERORG=:SCHPRESENTERORG ' + sLineBreak + // 55
  ', SCHLOCATION=:SCHLOCATION ' + sLineBreak + // 56
  ', SCHBLURB=:SCHBLURB ' + sLineBreak + // 57
  ', SCHREPEATOF=:SCHREPEATOF ' + sLineBreak + // 58
  ', SCHTAGC=:SCHTAGC ' + sLineBreak + // 59
  ', SCHTAGD=:SCHTAGD ' + sLineBreak + // 60
  ', SCHTAGPRISM=:SCHTAGPRISM ' + sLineBreak + // 61
  'WHERE (SCHID = :SCHID) '; // 62
  if MatchUpdateCounter then
    Result := Result +
    ' and (UpdateCounter=:UpdateCounter)'; // 63
end;

function Firebird_SQL_Update_for_ABOUT(const MatchUpdateCounter
  : Boolean): string;
begin
  Result := 'update ABOUT ' + sLineBreak +
            'set ' + sLineBreak + 
  'SCHID=:SCHID ' + sLineBreak + // 0
  ', PRODUCTID=:PRODUCTID ' + sLineBreak + // 1
  'WHERE (ABOUTID = :ABOUTID) '; // 2
  if MatchUpdateCounter then
    Result := Result +
    ' and (UpdateCounter=:UpdateCounter)'; // 3
end;

function Firebird_SQL_Update_for_XPRODUCT(const MatchUpdateCounter
  : Boolean): string;
begin
  Result := 'update XPRODUCT ' + sLineBreak +
            'set ' + sLineBreak + 
  'PRODUCTABBREV=:PRODUCTABBREV ' + sLineBreak + // 0
  ', PRODUCTNAME=:PRODUCTNAME ' + sLineBreak + // 1
  'WHERE (PRODUCTID = :PRODUCTID) '; // 2
  if MatchUpdateCounter then
    Result := Result +
    ' and (UpdateCounter=:UpdateCounter)'; // 3
end;

end.

