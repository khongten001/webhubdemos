//Project:   Code Rage Schedule
//Revision:  1.0
//Filename:  D:\Projects\WebHub Demos\Source\WHApps\DB Examples\whSchedule\DBDesign\gen_sql\CodeRage-1.0.sql
//Generated: 08-Sep-2009 01:12
//Legal:     Copyright (c) 2009 HREF Tools Corp.. All Rights Reserved Worldwide.

//CONNECT "D:\Projects\WebHub Demos\Live\Database\whSchedule\coderageschedule.fdb" USER "SYSDBA" PASSWORD "masterkey";

// -------------------------------------------------------------------------------------------------
// About Table
// -------------------------------------------------------------------------------------------------

CREATE TABLE About
(
    AboutID       integer not null,
    SchID         integer not null,
    ProductID     integer not null,
    UpdateCounter integer,
    UpdatedOnAt   timestamp,

    CONSTRAINT PK_About PRIMARY KEY (AboutID)
);
COMMIT;


// Generators
SET TERM ^ ;

CREATE GENERATOR gen_AboutNo^
SET GENERATOR gen_AboutNo TO 0^

CREATE PROCEDURE sp_g_AboutNo
  RETURNS (next_AboutNo INTEGER)
  AS
  BEGIN
    next_AboutNo = GEN_ID (gen_AboutNo,1);
  END^

CREATE TRIGGER tr_i_AboutNo FOR About
  BEFORE INSERT
  POSITION 0
  AS
  BEGIN
    IF (NEW.AboutID is null) then
      BEGIN
      NEW.AboutID = GEN_ID (gen_AboutNo,1);
    END
  END^

COMMIT ^
SET TERM ;^


COMMIT;

// -------------------------------------------------------------------------------------------------
// Schedule Table
// -------------------------------------------------------------------------------------------------

CREATE TABLE Schedule
(
    SchID                integer not null,
    SchTitle             varchar(65),
    SchOnAtPDT           timestamp,
    SchMinutes           smallint,
    SchPresenterFullname varchar(45),
    SchPresenterOrg      varchar(45),
    SchLocation          varchar(10),
    SchBlurb             varchar(512),
    UpdateCounter        smallint,
    UpdatedOnAt          timestamp,

    CONSTRAINT PK_Schedule PRIMARY KEY (SchID)
);
COMMIT;


// Generators
SET TERM ^ ;

CREATE GENERATOR gen_ScheduleNo^
SET GENERATOR gen_ScheduleNo TO 0^

CREATE PROCEDURE sp_g_ScheduleNo
  RETURNS (next_ScheduleNo INTEGER)
  AS
  BEGIN
    next_ScheduleNo = GEN_ID (gen_ScheduleNo,1);
  END^

CREATE TRIGGER tr_i_ScheduleNo FOR Schedule
  BEFORE INSERT
  POSITION 0
  AS
  BEGIN
    IF (NEW.SchID is null) then
      BEGIN
      NEW.SchID = GEN_ID (gen_ScheduleNo,1);
    END
  END^

COMMIT ^
SET TERM ;^


COMMIT;

// -------------------------------------------------------------------------------------------------
// XProduct Table
// -------------------------------------------------------------------------------------------------

CREATE TABLE XProduct
(
    ProductID     integer not null,
    ProductAbbrev varchar(8),
    ProductName   varchar(15),
    UpdateCounter integer,
    UpdatedOnAt   timestamp,

    CONSTRAINT PK_XProduct PRIMARY KEY (ProductID)
);
COMMIT;


// Generators
SET TERM ^ ;

CREATE GENERATOR gen_XProductNo^
SET GENERATOR gen_XProductNo TO 0^

CREATE PROCEDURE sp_g_XProductNo
  RETURNS (next_XProductNo INTEGER)
  AS
  BEGIN
    next_XProductNo = GEN_ID (gen_XProductNo,1);
  END^

CREATE TRIGGER tr_i_XProductNo FOR XProduct
  BEFORE INSERT
  POSITION 0
  AS
  BEGIN
    IF (NEW.ProductID is null) then
      BEGIN
      NEW.ProductID = GEN_ID (gen_XProductNo,1);
    END
  END^

COMMIT ^
SET TERM ;^


COMMIT;


//EXIT;
