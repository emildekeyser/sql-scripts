CREATE TABLE bestuursleden (
    spelersnr integer NOT NULL,
    begin_datum date NOT NULL,
    eind_datum date,
    functie character(20),
    CONSTRAINT bestuursleden_begin_datum_check CHECK ((begin_datum >= '1990-01-01')),
    CONSTRAINT bestuursleden_check CHECK ((begin_datum < eind_datum)),
PRIMARY KEY (spelersnr, begin_datum),
FOREIGN KEY (spelersnr) REFERENCES spelers(spelersnr)
);
CREATE TABLE boetes (
    betalingsnr integer NOT NULL,
    spelersnr integer NOT NULL,
    datum date NOT NULL,
    bedrag numeric(7,2) NOT NULL,
    CONSTRAINT boetes_bedrag_check CHECK ((bedrag > (0))),
    CONSTRAINT boetes_datum_check CHECK ((datum >= '1969-12-31')),
PRIMARY KEY (betalingsnr),
FOREIGN KEY (spelersnr) REFERENCES spelers(spelersnr)
);
CREATE TABLE spelers (
    spelersnr integer NOT NULL,
    naam character(15) NOT NULL,
    voorletters character(3) NOT NULL,
    geb_datum date,
    geslacht character(1) NOT NULL,
    jaartoe smallint NOT NULL,
    straat character varying(30) NOT NULL,
    huisnr character(4),
    postcode character(6),
    plaats character varying(30) NOT NULL,
    telefoon character(13),
    bondsnr character(4),
    CONSTRAINT spelers_jaartoe_check CHECK ((jaartoe > 1969)),
PRIMARY KEY (spelersnr)
);
CREATE TABLE teams (
    teamnr integer NOT NULL,
    spelersnr integer NOT NULL,
    divisie character(6) NOT NULL,
PRIMARY KEY (teamnr),
FOREIGN KEY (spelersnr) REFERENCES spelers(spelersnr)
);
CREATE TABLE wedstrijden (
    wedstrijdnr integer NOT NULL,
    teamnr integer NOT NULL,
    spelersnr integer NOT NULL,
    gewonnen smallint NOT NULL,
    verloren smallint NOT NULL,
    CONSTRAINT wedstrijden_gewonnen_check CHECK (((gewonnen >= 0) AND (gewonnen <= 3))),
    CONSTRAINT wedstrijden_verloren_check CHECK (((verloren >= 0) AND (verloren <= 3))),
PRIMARY KEY (wedstrijdnr),
FOREIGN KEY (teamnr) REFERENCES teams(teamnr)
);
