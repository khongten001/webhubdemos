// CodeRageSchedule_Triggers.sql
// Generated 09-Jul-2012 02:14
// Pascal source in Firebird_GenSQL_TriggersFor3UpdateFields in TPack, maintained by HREF Tools Corp.


SET TERM ^;

// SCHEDULE
CREATE TRIGGER SCHEDULE_BI
FOR SCHEDULE
ACTIVE
BEFORE INSERT
AS
BEGIN
   new.UpdatedOnAt = CURRENT_TIMESTAMP;
   new.UpdateCounter = 0;
END^

CREATE TRIGGER SCHEDULE_UC
FOR SCHEDULE
ACTIVE
BEFORE UPDATE
AS
BEGIN
   new.UpdatedOnAt = CURRENT_TIMESTAMP;
   if (old.UpdateCounter < 32000)
   then new.UpdateCounter = (old.UpdateCounter + 1);
   else new.UpdateCounter = 1;
END^

CREATE TRIGGER SCHEDULE_PK
FOR SCHEDULE
ACTIVE
BEFORE INSERT
AS
BEGIN
  if (NEW.SCHNO IS NULL)
  then
    NEW.SCHNO = GEN_ID(GenSCHEDULENo, 1);
  if (new.SCHNO = -1)
  then
    NEW.SCHNO = GEN_ID(GenSCHEDULENo, 1);
END^

// XPRODUCT
CREATE TRIGGER XPRODUCT_BI
FOR XPRODUCT
ACTIVE
BEFORE INSERT
AS
BEGIN
   new.UpdatedOnAt = CURRENT_TIMESTAMP;
   new.UpdateCounter = 0;
END^

CREATE TRIGGER XPRODUCT_UC
FOR XPRODUCT
ACTIVE
BEFORE UPDATE
AS
BEGIN
   new.UpdatedOnAt = CURRENT_TIMESTAMP;
   if (old.UpdateCounter < 32000)
   then new.UpdateCounter = (old.UpdateCounter + 1);
   else new.UpdateCounter = 1;
END^

CREATE TRIGGER XPRODUCT_PK
FOR XPRODUCT
ACTIVE
BEFORE INSERT
AS
BEGIN
  if (NEW.PRODUCTNO IS NULL)
  then
    NEW.PRODUCTNO = GEN_ID(GenXPRODUCTNo, 1);
  if (new.PRODUCTNO = -1)
  then
    NEW.PRODUCTNO = GEN_ID(GenXPRODUCTNo, 1);
END^

// ABOUT
CREATE TRIGGER ABOUT_BI
FOR ABOUT
ACTIVE
BEFORE INSERT
AS
BEGIN
   new.UpdatedOnAt = CURRENT_TIMESTAMP;
   new.UpdateCounter = 0;
END^

CREATE TRIGGER ABOUT_UC
FOR ABOUT
ACTIVE
BEFORE UPDATE
AS
BEGIN
   new.UpdatedOnAt = CURRENT_TIMESTAMP;
   if (old.UpdateCounter < 32000)
   then new.UpdateCounter = (old.UpdateCounter + 1);
   else new.UpdateCounter = 1;
END^

CREATE TRIGGER ABOUT_PK
FOR ABOUT
ACTIVE
BEFORE INSERT
AS
BEGIN
  if (NEW.ABOUTNO IS NULL)
  then
    NEW.ABOUTNO = GEN_ID(GenABOUTNo, 1);
  if (new.ABOUTNO = -1)
  then
    NEW.ABOUTNO = GEN_ID(GenABOUTNo, 1);
END^

COMMIT^

SET TERM ;^