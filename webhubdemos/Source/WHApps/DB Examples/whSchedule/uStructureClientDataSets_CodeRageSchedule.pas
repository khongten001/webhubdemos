//unit uStructureClientDataSets_CodeRageSchedule;
unit uStructureClientDataSets_CodeRageSchedule;
// project abbreviation: CodeRageSchedule
// generated 10-Jul-2012 02:08
// by Firebird_GenPAS_StructureClientDatasets in TPack, maintained by HREF Tools Corp.

interface 

uses
  DB, DBClient;

procedure PrepareCDS_for_SCHEDULE(var table : TClientDataset;
  const CreateNow: Boolean = True);
procedure PrepareCDS_for_XPRODUCT(var table : TClientDataset;
  const CreateNow: Boolean = True);
procedure PrepareCDS_for_ABOUT(var table : TClientDataset;
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

  table.FieldDefs.Add('SCHNO',  ftInteger, 0, False);(* autoincrement *)
  table.FieldDefs.Add('SCHTITLE',  ftString, 260 div 4, False);(* label="Presentation Title" *)
  table.FieldDefs.Add('SCHONATPDT',  ftDateTime, 0, False);(* label="Live presentation time (PDT)" *)
  table.FieldDefs.Add('SCHMINUTES',  ftSmallInt, 0, False);(* label="Duration" *)
  table.FieldDefs.Add('SCHPRESENTERFULLNAME',  ftString, 180 div 4, False);(* label="Presenter" *)
  table.FieldDefs.Add('SCHPRESENTERORG',  ftString, 180 div 4, False);(* label="Organization" *)
  table.FieldDefs.Add('SCHLOCATION',  ftString, 40 div 4, False);(* label="Location" *)
  table.FieldDefs.Add('SCHBLURB',  ftMemo, 0, False);(* label="Presentation Description" *)
  table.FieldDefs.Add('SCHREPEATOF',  ftInteger, 0, False);
  table.FieldDefs.Add('SCHTAGC',  ftString, 160 div 4, False);
  table.FieldDefs.Add('SCHTAGD',  ftString, 160 div 4, False);
  table.FieldDefs.Add('SCHTAGPRISM',  ftFixedChar, 4 div 4, False);
  table.FieldDefs.Add('SCHREPLAYDOWNLOADURL',  ftString, 320 div 4, False);
  table.FieldDefs.Add('SCHREPLAYWATCHNOWURL',  ftMemo, 0, False);
  table.FieldDefs.Add('SCHCODERAGECONFNO',  ftSmallInt, 0, False);(* Code Rage #4 was in 2009 *)
  table.FieldDefs.Add('UPDATEDBY',  ftString, 12 div 4, False);
  table.FieldDefs.Add('UPDATEDONAT',  ftDateTime, 0, False);
  table.FieldDefs.Add('UPDATECOUNTER',  ftSmallInt, 0, False);

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

  table.FieldDefs.Add('PRODUCTNO',  ftInteger, 0, False);(* autoincrement *)
  table.FieldDefs.Add('PRODUCTABBREV',  ftString, 32 div 4, False);(* label="Abbreviation" *)
  table.FieldDefs.Add('PRODUCTNAME',  ftString, 60 div 4, False);(* label="Full Product Name" *)
  table.FieldDefs.Add('UPDATEDBY',  ftString, 12 div 4, False);
  table.FieldDefs.Add('UPDATEDONAT',  ftDateTime, 0, False);
  table.FieldDefs.Add('UPDATECOUNTER',  ftSmallInt, 0, False);

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

  table.FieldDefs.Add('ABOUTNO',  ftInteger, 0, False);(* autoincrement *)
  table.FieldDefs.Add('SCHNO',  ftInteger, 0, False);
  table.FieldDefs.Add('PRODUCTNO',  ftInteger, 0, False);
  table.FieldDefs.Add('UPDATEDBY',  ftString, 12 div 4, False);
  table.FieldDefs.Add('UPDATEDONAT',  ftDateTime, 0, False);
  table.FieldDefs.Add('UPDATECOUNTER',  ftSmallInt, 0, False);

  if CreateNow then
    table.CreateDataSet;
end;

end.

