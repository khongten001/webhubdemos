SET TERM ^;

CREATE TRIGGER About_UC
FOR About
ACTIVE
BEFORE UPDATE
AS
BEGIN
   new.UpdatedOnAt = CURRENT_TIMESTAMP;
   new.UpdateCounter = (old.UpdateCounter + 1);
END^

CREATE TRIGGER Schedule_UC
FOR Schedule
ACTIVE
BEFORE UPDATE
AS
BEGIN
   new.UpdatedOnAt = CURRENT_TIMESTAMP;
   new.UpdateCounter = (old.UpdateCounter + 1);
END^

CREATE TRIGGER XProduct_UC
FOR XProduct
ACTIVE
BEFORE UPDATE
AS
BEGIN
   new.UpdatedOnAt = CURRENT_TIMESTAMP;
   new.UpdateCounter = (old.UpdateCounter + 1);
END^


COMMIT^

SET TERM ;^
