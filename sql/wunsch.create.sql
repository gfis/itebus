--  Tabelle for itebus - Personen mit Impfterminwuenschen
--  @(#) $Id$
--  2021-03-19, Georg Fischer
--
DROP    TABLE  IF EXISTS wunsch;
CREATE  TABLE            wunsch
    ( anrede    VARCHAR(16)   DEFAULT 'Frau'
    , vorname   VARCHAR(64)
    , name      VARCHAR(64)
    , alt       INT
    , strasse   VARCHAR(64)
    , hausnr    VARCHAR(8)
    , plz       VARCHAR(8)    DEFAULT '79341'
    , ort       VARCHAR(32)   DEFAULT 'Kenzingen'
    , tel       VARCHAR(32)
    , email     VARCHAR(64)
    , vm        VARCHAR(32)   DEFAULT 'EM' -- oder gewuenschte IZs 
    , status    VARCHAR(16)   DEFAULT 'offen'
    , bemerk    VARCHAR(64)
    , PRIMARY KEY(name, vorname, vm)
    );
COMMIT;
