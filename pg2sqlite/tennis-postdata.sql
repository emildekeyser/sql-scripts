




ALTER TABLE ONLY tennis.bestuursleden
    ADD CONSTRAINT bestuursleden_pkey PRIMARY KEY (spelersnr, begin_datum);



ALTER TABLE ONLY tennis.boetes
    ADD CONSTRAINT boetes_pkey PRIMARY KEY (betalingsnr);



ALTER TABLE ONLY tennis.spelers
    ADD CONSTRAINT spelers_pkey PRIMARY KEY (spelersnr);



ALTER TABLE ONLY tennis.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (teamnr);



ALTER TABLE ONLY tennis.wedstrijden
    ADD CONSTRAINT wedstrijden_pkey PRIMARY KEY (wedstrijdnr);



ALTER TABLE ONLY tennis.bestuursleden
    ADD CONSTRAINT bestuursleden_spelersnr_fkey FOREIGN KEY (spelersnr) REFERENCES tennis.spelers(spelersnr);



ALTER TABLE ONLY tennis.boetes
    ADD CONSTRAINT boetes_spelersnr_fkey FOREIGN KEY (spelersnr) REFERENCES tennis.spelers(spelersnr);



ALTER TABLE ONLY tennis.teams
    ADD CONSTRAINT teams_spelersnr_fkey FOREIGN KEY (spelersnr) REFERENCES tennis.spelers(spelersnr);



ALTER TABLE ONLY tennis.wedstrijden
    ADD CONSTRAINT wedstrijden_spelersnr_fkey FOREIGN KEY (spelersnr) REFERENCES tennis.spelers(spelersnr);



ALTER TABLE ONLY tennis.wedstrijden
    ADD CONSTRAINT wedstrijden_teamnr_fkey FOREIGN KEY (teamnr) REFERENCES tennis.teams(teamnr);



