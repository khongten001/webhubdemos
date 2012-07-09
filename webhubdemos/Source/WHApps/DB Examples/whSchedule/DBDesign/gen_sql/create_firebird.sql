/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases v4.2.0                     */
/* Target DBMS:           Firebird 2                                      */
/* Project file:          CodeRageSchedule.dez                            */
/* Project name:                                                          */
/* Author:                                                                */
/* Script type:           Database creation script                        */
/* Created on:            2012-07-09 02:05                                */
/* ---------------------------------------------------------------------- */


/* ---------------------------------------------------------------------- */
/* Sequences                                                              */
/* ---------------------------------------------------------------------- */

CREATE GENERATOR GENXPRODUCTNO;
SET GENERATOR GENXPRODUCTNO TO 0;

CREATE GENERATOR GENSCHEDULENO;
SET GENERATOR GENSCHEDULENO TO 0;

CREATE GENERATOR GENABOUTNO;
SET GENERATOR GENABOUTNO TO 0;

/* ---------------------------------------------------------------------- */
/* Tables                                                                 */
/* ---------------------------------------------------------------------- */

/* ---------------------------------------------------------------------- */
/* Add table "SCHEDULE"                                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE SCHEDULE (
    SCHNO INTEGER NOT NULL,
    SCHTITLE VARCHAR(65) CHARACTER SET UTF8,
    SCHONATPDT TIMESTAMP,
    SCHMINUTES SMALLINT,
    SCHPRESENTERFULLNAME VARCHAR(45) CHARACTER SET UTF8,
    SCHPRESENTERORG VARCHAR(45) CHARACTER SET UTF8,
    SCHLOCATION VARCHAR(10) CHARACTER SET UTF8,
    SCHBLURB VARCHAR(512) CHARACTER SET UTF8,
    SCHREPEATOF INTEGER,
    SCHTAGC VARCHAR(40),
    SCHTAGD VARCHAR(40),
    SCHTAGPRISM CHAR(1),
    UPDATEDBY CHAR(1),
    UPDATECOUNTER CHAR(1) DEFAULT '0',
    UPDATEDONAT TIMESTAMP,
    CONSTRAINT PK_SCHEDULE PRIMARY KEY (SCHNO)
);

UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION = 'autoincrement' WHERE (RDB$RELATION_NAME = 'SCHEDULE') AND (RDB$FIELD_NAME = 'SCHNO');

UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION = 'label="Presentation Title"' WHERE (RDB$RELATION_NAME = 'SCHEDULE') AND (RDB$FIELD_NAME = 'SCHTITLE');

UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION = 'label="Live presentation time (PDT)"' WHERE (RDB$RELATION_NAME = 'SCHEDULE') AND (RDB$FIELD_NAME = 'SCHONATPDT');

UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION = 'label="Duration"' WHERE (RDB$RELATION_NAME = 'SCHEDULE') AND (RDB$FIELD_NAME = 'SCHMINUTES');

UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION = 'label="Presenter"' WHERE (RDB$RELATION_NAME = 'SCHEDULE') AND (RDB$FIELD_NAME = 'SCHPRESENTERFULLNAME');

UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION = 'label="Organization"' WHERE (RDB$RELATION_NAME = 'SCHEDULE') AND (RDB$FIELD_NAME = 'SCHPRESENTERORG');

UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION = 'label="Location"' WHERE (RDB$RELATION_NAME = 'SCHEDULE') AND (RDB$FIELD_NAME = 'SCHLOCATION');

UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION = 'label="Presentation Description"' WHERE (RDB$RELATION_NAME = 'SCHEDULE') AND (RDB$FIELD_NAME = 'SCHBLURB');

/* ---------------------------------------------------------------------- */
/* Add table "XPRODUCT"                                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE XPRODUCT (
    PRODUCTNO INTEGER NOT NULL,
    PRODUCTABBREV VARCHAR(8),
    PRODUCTNAME VARCHAR(15),
    UPDATEDBY VARCHAR(3),
    UPDATECOUNTER INTEGER,
    UPDATEDONAT TIMESTAMP,
    CONSTRAINT PK_XPRODUCT PRIMARY KEY (PRODUCTNO)
);

UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION = 'autoincrement' WHERE (RDB$RELATION_NAME = 'XPRODUCT') AND (RDB$FIELD_NAME = 'PRODUCTNO');

UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION = 'label="Abbreviation"' WHERE (RDB$RELATION_NAME = 'XPRODUCT') AND (RDB$FIELD_NAME = 'PRODUCTABBREV');

UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION = 'label="Full Product Name"' WHERE (RDB$RELATION_NAME = 'XPRODUCT') AND (RDB$FIELD_NAME = 'PRODUCTNAME');

/* ---------------------------------------------------------------------- */
/* Add table "ABOUT"                                                      */
/* ---------------------------------------------------------------------- */

CREATE TABLE ABOUT (
    ABOUTNO INTEGER NOT NULL,
    SCHNO INTEGER NOT NULL,
    PRODUCTNO INTEGER NOT NULL,
    UPDATEDBY VARCHAR(3),
    UPDATECOUNTER INTEGER,
    UPDATEDONAT TIMESTAMP,
    CONSTRAINT PK_ABOUT PRIMARY KEY (ABOUTNO)
);

UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION = 'autoincrement' WHERE (RDB$RELATION_NAME = 'ABOUT') AND (RDB$FIELD_NAME = 'ABOUTNO');

/* ---------------------------------------------------------------------- */
/* Foreign key constraints                                                */
/* ---------------------------------------------------------------------- */

ALTER TABLE ABOUT ADD CONSTRAINT SCHEDULE_ABOUT 
    FOREIGN KEY (SCHNO) REFERENCES SCHEDULE (SCHNO);

ALTER TABLE ABOUT ADD CONSTRAINT XPRODUCT_ABOUT 
    FOREIGN KEY (PRODUCTNO) REFERENCES XPRODUCT (PRODUCTNO);
