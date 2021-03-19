--  Tabelle for itebus - Impfzentren
--  @(#) $Id$
--  2021-03-19, Georg Fischer
--
DROP    TABLE  IF EXISTS izent;
CREATE  TABLE            izent
    ( iplz      VARCHAR(10)   -- Postleitzahl des Impfzentrums
    , server    VARCHAR(8)    -- meistens 005
    , ort       VARCHAR(64)   -- Standort des Impfzentrums
    , PRIMARY KEY(iplz)
    );
COMMIT;
