--  Tabelle for itebus - Extrakte aus den KV-Emails
--  @(#) $Id$
--  2021-03-19, Georg Fischer
--
DROP    TABLE  IF EXISTS kvmail;
CREATE  TABLE            kvmail
    ( typ       VARCHAR(8)   -- tb, vm, ab
    , millisec  VARCHAR(64)  -- Unix-Zeitstempel
    , timestamp VARCHAR(32)  -- 2021-03-04 20:21:03
    , vm        VARCHAR(32)
    , termin    VARCHAR(64)  -- Termin oder "----"
    , impfstoff VARCHAR(64)  -- Impfstoff oder Server
    , link      VARCHAR(128) -- mit Server nach https://
    , PRIMARY KEY(typ, vm)
    );
COMMIT;
