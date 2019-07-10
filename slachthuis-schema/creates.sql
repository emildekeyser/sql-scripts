-- -----------------------------------------------------
-- Schema dbR09_g4
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Schema dbR09_g4
-- -----------------------------------------------------
CREATE SCHEMA dbR09_g4 AUTHORIZATION r0599128;
    GRANT ALL ON SCHEMA dbR09_g4 TO r0637235 WITH GRANT OPTION;
    GRANT ALL ON SCHEMA dbR09_g4 TO r0599128 WITH GRANT OPTION;
    GRANT ALL ON SCHEMA dbR09_g4 TO r0722538 WITH GRANT OPTION;
SET SCHEMA 'dbR09_g4';

-- -----------------------------------------------------
-- Table dbR09_g4.Administrator
-- -----------------------------------------------------



CREATE TABLE IF NOT EXISTS dbR09_g4.Administrator (
  idAdministrator INT NOT NULL,
  Login VARCHAR(20) NOT NULL,
  Paswoord VARCHAR(45) NOT NULL,
  Naam VARCHAR(20) NOT NULL,
  PRIMARY KEY (idAdministrator))
;



-- -----------------------------------------------------
-- Table dbR09_g4.Slachthuis
-- -----------------------------------------------------


CREATE TABLE IF NOT EXISTS dbR09_g4.Slachthuis (
  idSlachthuis INT NOT NULL,
  Adres VARCHAR(45) NOT NULL,
  Openingsuren VARCHAR(45) NOT NULL,
  Sluitingsdagen VARCHAR(45) NOT NULL,
  Capaciteit INT NOT NULL,
  Naam VARCHAR(45) NOT NULL,
  PRIMARY KEY (idSlachthuis))
;


-- -----------------------------------------------------
-- Table dbR09_g4.Voertuig
-- -----------------------------------------------------


CREATE TABLE IF NOT EXISTS dbR09_g4.Voertuig (
  Nummerplaat VARCHAR(7) NOT NULL,
  Aankomsttijd TIME NOT NULL,
  Type VARCHAR(45) NOT NULL,
  Merk VARCHAR(45) NOT NULL,
  PRIMARY KEY (Nummerplaat))
  
;


-- -----------------------------------------------------
-- Table dbR09_g4.Reservatie
-- -----------------------------------------------------


CREATE TABLE IF NOT EXISTS dbR09_g4.Reservatie (
  idReservatie INT NOT NULL,
  Datum DATE NOT NULL,
  Uur TIME NOT NULL,
  Administrator_idAdministrator INT NOT NULL,
  Voertuig_idVoertuig INT NOT NULL,
  Slachthuis_idSlachthuis INT NOT NULL,
  Voertuig_Nummerplaat VARCHAR(7) NOT NULL,
  
  PRIMARY KEY (idReservatie),
  
  
  
  CONSTRAINT fk_Reservatie_Administrator1
    FOREIGN KEY (Administrator_idAdministrator)
    REFERENCES dbR09_g4.Administrator (idAdministrator)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Reservatie_Slachthuis1
    FOREIGN KEY (Slachthuis_idSlachthuis)
    REFERENCES dbR09_g4.Slachthuis (idSlachthuis)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Reservatie_Voertuig1
    FOREIGN KEY (Voertuig_Nummerplaat)
    REFERENCES dbR09_g4.Voertuig (Nummerplaat)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table dbR09_g4.Slot
-- -----------------------------------------------------


CREATE TABLE IF NOT EXISTS dbR09_g4.Slot (
  Slot_nr INT NOT NULL,
  Grootte INT NOT NULL,
  Reservatie_idReservatie INT NOT NULL,
  Slachthuis_idSlachthuis INT NOT NULL,
  PRIMARY KEY (Slot_nr),
  
  
  CONSTRAINT fk_Slot_Reservatie
    FOREIGN KEY (Reservatie_idReservatie)
    REFERENCES dbR09_g4.Reservatie (idReservatie)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Slot_Slachthuis1
    FOREIGN KEY (Slachthuis_idSlachthuis)
    REFERENCES dbR09_g4.Slachthuis (idSlachthuis)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table dbR09_g4.Hulpdesk
-- -----------------------------------------------------


CREATE TABLE IF NOT EXISTS dbR09_g4.Hulpdesk (
  IdHulpdesk INT NOT NULL,
  Naam VARCHAR(20) NOT NULL,
  Login VARCHAR(20) NOT NULL,
  Paswoord VARCHAR(45) NOT NULL,
  Slachthuis_FK INT NOT NULL,
  PRIMARY KEY (IdHulpdesk),
  
  
  CONSTRAINT fk_Hulpdesk_Slachthuis1
    FOREIGN KEY (Slachthuis_FK)
    REFERENCES dbR09_g4.Slachthuis (idSlachthuis)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table dbR09_g4.Leverancier
-- -----------------------------------------------------


CREATE TABLE IF NOT EXISTS dbR09_g4.Leverancier (
  idLeverancier INT NOT NULL,
  Naam VARCHAR(20) NOT NULL,
  Login VARCHAR(20) NOT NULL,
  Paswoord VARCHAR(45) NOT NULL,
  PRIMARY KEY (idLeverancier))
;


-- -----------------------------------------------------
-- Table dbR09_g4.Hulpdesk_Past_Reservatie_Aan
-- -----------------------------------------------------


CREATE TABLE IF NOT EXISTS dbR09_g4.Hulpdesk_Past_Reservatie_Aan (
  Hulpdesk_IdHulpdesk INT NOT NULL,
  Reservatie_idReservatie INT NOT NULL,
  Datum DATE NOT NULL,
  Reden_van_aanpassing VARCHAR(100) NOT NULL,
  Uur TIME NOT NULL,
  PRIMARY KEY (Hulpdesk_IdHulpdesk, Reservatie_idReservatie, Uur),
  
  
  CONSTRAINT fk_Hulpdesk_has_Reservatie_Hulpdesk1
    FOREIGN KEY (Hulpdesk_IdHulpdesk)
    REFERENCES dbR09_g4.Hulpdesk (IdHulpdesk)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Hulpdesk_has_Reservatie_Reservatie1
    FOREIGN KEY (Reservatie_idReservatie)
    REFERENCES dbR09_g4.Reservatie (idReservatie)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table dbR09_g4.Leverancier_Maakt_Reservatie
-- -----------------------------------------------------


CREATE TABLE IF NOT EXISTS dbR09_g4.Leverancier_Maakt_Reservatie (
  Leverancier_idLeverancier INT NOT NULL,
  Reservatie_idReservatie INT NOT NULL,
  Datum DATE NOT NULL,
  Opmerkingen VARCHAR(100) NULL,
  PRIMARY KEY (Leverancier_idLeverancier, Reservatie_idReservatie),
  
  
  CONSTRAINT fk_Leverancier_has_Reservatie_Leverancier1
    FOREIGN KEY (Leverancier_idLeverancier)
    REFERENCES dbR09_g4.Leverancier (idLeverancier)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Leverancier_has_Reservatie_Reservatie1
    FOREIGN KEY (Reservatie_idReservatie)
    REFERENCES dbR09_g4.Reservatie (idReservatie)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table dbR09_g4.Loskade
-- -----------------------------------------------------


CREATE TABLE IF NOT EXISTS dbR09_g4.Loskade (
  Loskade_nr INT NOT NULL,
  Grootte INT NOT NULL,
  Aantal INT NOT NULL,
  Slachthuis_idSlachthuis INT NOT NULL,
  PRIMARY KEY (Loskade_nr),
  
  CONSTRAINT fk_Loskade_Slachthuis1
    FOREIGN KEY (Slachthuis_idSlachthuis)
    REFERENCES dbR09_g4.Slachthuis (idSlachthuis)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table dbR09_g4.Loskade_Bij_Voertuig
-- -----------------------------------------------------


CREATE TABLE IF NOT EXISTS dbR09_g4.Loskade_Bij_Voertuig (
  Loskade_Nummer INT NOT NULL,
  Datum DATE NOT NULL,
  Voertuig_Nummerplaat VARCHAR(7) NOT NULL,
  PRIMARY KEY (Loskade_Nummer, Datum, Voertuig_Nummerplaat),
  
  
  CONSTRAINT fk_Loskade_has_Voertuig_Loskade1
    FOREIGN KEY (Loskade_Nummer)
    REFERENCES dbR09_g4.Loskade (Loskade_nr)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Loskade_Bij_Voertuig_Voertuig1
    FOREIGN KEY (Voertuig_Nummerplaat)
    REFERENCES dbR09_g4.Voertuig (Nummerplaat)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

GRANT ALL ON ALL TABLES IN SCHEMA dbr09_g4 TO r0637235;
GRANT ALL ON ALL TABLES IN SCHEMA dbr09_g4 TO r0599128;
GRANT ALL ON ALL TABLES IN SCHEMA dbr09_g4 TO r0722538;