SET TERM ^;

CREATE TRIGGER About_BI
FOR About
ACTIVE
BEFORE INSERT
AS
BEGIN
   new.UpdatedOnAt = CURRENT_TIMESTAMP;
   new.UpdateCounter = 0;
END^

CREATE TRIGGER Schedule_BI
FOR Schedule
ACTIVE
BEFORE INSERT
AS
BEGIN
   new.UpdatedOnAt = CURRENT_TIMESTAMP;
   new.UpdateCounter = 0;
END^

CREATE TRIGGER XProduct_BI
FOR XProduct
ACTIVE
BEFORE INSERT
AS
BEGIN
   new.UpdatedOnAt = CURRENT_TIMESTAMP;
   new.UpdateCounter = 0;
END^


COMMIT^

SET TERM ;^
