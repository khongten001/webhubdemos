/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases v4.2.0                     */
/* Target DBMS:           Firebird 2                                      */
/* Project file:          CodeRageSchedule.dez                            */
/* Project name:                                                          */
/* Author:                                                                */
/* Script type:           Database drop script                            */
/* Created on:            2012-07-09 02:21                                */
/* ---------------------------------------------------------------------- */


/* ---------------------------------------------------------------------- */
/* Drop foreign key constraints                                           */
/* ---------------------------------------------------------------------- */

ALTER TABLE ABOUT DROP CONSTRAINT SCHEDULE_ABOUT;

ALTER TABLE ABOUT DROP CONSTRAINT XPRODUCT_ABOUT;

/* ---------------------------------------------------------------------- */
/* Drop table "SCHEDULE"                                                  */
/* ---------------------------------------------------------------------- */

/* Drop constraints */

ALTER TABLE SCHEDULE DROP CONSTRAINT PK_SCHEDULE;

/* Drop table */

DROP TABLE SCHEDULE;

/* ---------------------------------------------------------------------- */
/* Drop table "XPRODUCT"                                                  */
/* ---------------------------------------------------------------------- */

/* Drop constraints */

ALTER TABLE XPRODUCT DROP CONSTRAINT PK_XPRODUCT;

/* Drop table */

DROP TABLE XPRODUCT;

/* ---------------------------------------------------------------------- */
/* Drop table "ABOUT"                                                     */
/* ---------------------------------------------------------------------- */

/* Drop constraints */

ALTER TABLE ABOUT DROP CONSTRAINT PK_ABOUT;

/* Drop table */

DROP TABLE ABOUT;

/* ---------------------------------------------------------------------- */
/* Drop sequences                                                         */
/* ---------------------------------------------------------------------- */

DELETE FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME = 'GENXPRODUCTNO';

DELETE FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME = 'GENSCHEDULENO';

DELETE FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME = 'GENABOUTNO';
