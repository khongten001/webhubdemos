//unit uStructureClientDataSets_CodeRageSchedule;
unit uStructureClientDataSets_CodeRageSchedule;
// project abbreviation: CodeRageSchedule
// generated 09-Jul-2012 00:03
// by Firebird_GenPAS_StructureClientDatasets in TPack, maintained by HREF Tools Corp.

interface 

uses
  DB, DBClient;

procedure PrepareCDS_for_SCHEDULE(var table : TClientDataset;
  const CreateNow: Boolean = True);
procedure PrepareCDS_for_ABOUT(var table : TClientDataset;
  const CreateNow: Boolean = True);
procedure PrepareCDS_for_XPRODUCT(var table : TClientDataset;
  const CreateNow: Boolean = True);

implementation

uses
  MultiTypeApp;

procedure PrepareCDS_for_SCHEDULE(var table : TClientDataset;
  const CreateNow: Boolean = True);
begin
  if NOT Assigned(table) then
  begin
    table := TClientDataset.Create(nil);
    table.Name := 'cdsSCHEDULE';
  end;

  table.FieldDefs.Clear;

  table.FieldDefs.Add('SCHID',  ftInteger, 0, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHTITLE',  ftString, 95 div 4, False);
  table.FieldDefs.Add('SCHONATPDT',  ftDateTime, 0, False);
  table.FieldDefs.Add('SCHMINUTES',  ftSmallInt, 0, False);
  table.FieldDefs.Add('SCHPRESENTERFULLNAME',  ftString, 45 div 4, False);
  table.FieldDefs.Add('SCHPRESENTERORG',  ftString, 45 div 4, False);
  table.FieldDefs.Add('SCHLOCATION',  ftString, 10 div 4, False);
  table.FieldDefs.Add('SCHBLURB',  ftString, 512 div 4, False);
  table.FieldDefs.Add('UPDATECOUNTER',  ftSmallInt, 0, False);
  table.FieldDefs.Add('UPDATEDONAT',  ftDateTime, 0, False);
  table.FieldDefs.Add('SCHREPEATOF',  ftInteger, 0, False);
  table.FieldDefs.Add('SCHTAGC',  ftFixedChar, 4 div 4, False);
  table.FieldDefs.Add('SCHTAGD',  ftFixedChar, 4 div 4, False);
  table.FieldDefs.Add('SCHTAGPRISM',  ftFixedChar, 4 div 4, False);

  if CreateNow then
    table.CreateDataSet;
end;

procedure PrepareCDS_for_ABOUT(var table : TClientDataset;
  const CreateNow: Boolean = True);
begin
  if NOT Assigned(table) then
  begin
    table := TClientDataset.Create(nil);
    table.Name := 'cdsABOUT';
  end;

  table.FieldDefs.Clear;

  table.FieldDefs.Add('ABOUTID',  ftInteger, 0, False);
  table.FieldDefs.Add('SCHID',  ftInteger, 0, False);
  table.FieldDefs.Add('PRODUCTID',  ftInteger, 0, False);
  table.FieldDefs.Add('UPDATECOUNTER',  ftInteger, 0, False);
  table.FieldDefs.Add('UPDATEDONAT',  ftDateTime, 0, False);

  if CreateNow then
    table.CreateDataSet;
end;

procedure PrepareCDS_for_XPRODUCT(var table : TClientDataset;
  const CreateNow: Boolean = True);
begin
  if NOT Assigned(table) then
  begin
    table := TClientDataset.Create(nil);
    table.Name := 'cdsXPRODUCT';
  end;

  table.FieldDefs.Clear;

  table.FieldDefs.Add('PRODUCTID',  ftInteger, 0, False);
  table.FieldDefs.Add('PRODUCTABBREV',  ftString, 8 div 4, False);
  table.FieldDefs.Add('PRODUCTNAME',  ftString, 15 div 4, False);
  table.FieldDefs.Add('UPDATECOUNTER',  ftInteger, 0, False);
  table.FieldDefs.Add('UPDATEDONAT',  ftDateTime, 0, False);

  if CreateNow then
    table.CreateDataSet;
end;

end.

