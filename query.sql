-- SUBQ 1 VERBREDING

-- Geef een lijst van alle hemelobjecten die meer keer bezocht gaan worden dan Jupiter. (onafhankelijk van het aantal deelnames)
-- Sorteer op objectnaam.

select count(*) from bezoeken
where objectnaam = 'Jupiter'
;

select objectnaam from bezoeken
where objectnaam != 'Jupiter'
group by objectnaam
having count(*) > 2
;

select * from bezoeken;


select objectnaam, diameter from bezoeken
left join hemelobjecten using(objectnaam)
where objectnaam != 'Jupiter'
group by objectnaam, diameter
having count(*) > (select count(*) from bezoeken where objectnaam = 'Jupiter')
order by objectnaam
;

-- Geef het hemellichaam dat het laatst bezocht is.
-- Gebruik hiervoor de laatste vertrekdatum van de reis en laatste volgnummer van bezoek. Tip: gebruik hiervoor een rij-subquery.
-- Gebruik geen limit of top.

select reisnr from reizen
where vertrekdatum = (select max(vertrekdatum) from reizen);

select max(volgnr) from bezoeken
where reisnr = 36
;

select objectnaam from bezoeken
where reisnr =
	(select reisnr from reizen
	where vertrekdatum = (select max(vertrekdatum) from reizen))
and volgnr = 
	(select max(volgnr) from bezoeken
	where reisnr = 
		(select reisnr from reizen
		where vertrekdatum = (select max(vertrekdatum) from reizen))
	)
;

-- Geef het reisnr, de prijs en vertrekdatum van de reis met de hoogste
-- gemiddelde verblijfsduur op een hemelobject (=som van de verblijfsduur /
-- aantal bezoeken per reis).

select max(avg) from
(select avg(verblijfsduur) from bezoeken group by reisnr) as a
;

select reisnr from bezoeken
group by reisnr
having avg(verblijfsduur) = 8
;

select reisnr, prijs, vertrekdatum
from reizen
where reisnr = 
	(select reisnr from bezoeken
	group by reisnr
	having avg(verblijfsduur) = 
		(select max(avg) from
		(select avg(verblijfsduur) from bezoeken group by reisnr) as a)
	)
;

-- Geef de planeet (draait dus rond de zon) met de meeste satellieten.
-- Sorteer op objectnaam.

select objectnaam from hemelobjecten where satellietvan = 'Zon'
;

select satellietvan, count(objectnaam) as satelieten from hemelobjecten
where satellietvan in (select objectnaam from hemelobjecten where satellietvan = 'Zon')
group by satellietvan
;

select  max(planeten.satelieten)
from 
	(select satellietvan as planeet, count(objectnaam) as satelieten from hemelobjecten
	where satellietvan in (select objectnaam from hemelobjecten where satellietvan = 'Zon')
	group by satellietvan) as planeten
;


select planeten.planeet as objectnaam
from 
	(select satellietvan as planeet, count(objectnaam) as satelieten from hemelobjecten
	where satellietvan in (select objectnaam from hemelobjecten where satellietvan = 'Zon')
	group by satellietvan) as planeten
where planeten.satelieten =
	(select max(planeten.satelieten)
	from 
		(select satellietvan as planeet, count(objectnaam) as satelieten from hemelobjecten
		where satellietvan in (select objectnaam from hemelobjecten where satellietvan = 'Zon')
		group by satellietvan) as planeten
	)
;

-- Geef het op één na kleinste hemellichaam.  Je kan dit vinden door handig
-- gebruik te maken van expliciete joins en een doorsnedevoorwaarde. Tip:
-- probeer eerst een lijst te krijgen van alle hemelobjecten en het aantal
-- hemellichaam dat kleiner is dan dat hemelobject.

select h1.objectnaam, count(h2.objectnaam) as aantalkleiner
from hemelobjecten h1
left join hemelobjecten h2 on h1.diameter > h2.diameter
group by h1.objectnaam
;

select * from 
	(select h1.objectnaam, count(h2.objectnaam) as aantalkleiner
	from hemelobjecten h1
	left join hemelobjecten h2 on h1.diameter > h2.diameter
	group by h1.objectnaam) as objecten
where aantalkleiner = 
	(select min(aantalkleiner) from
		(select h1.objectnaam, count(h2.objectnaam) as aantalkleiner
		from hemelobjecten h1
		left join hemelobjecten h2 on h1.diameter > h2.diameter
		group by h1.objectnaam 
		having count(h2.objectnaam) != 0) as objecten2
	)
;

-- SUBQ 2 VERBREDING

-- Geef de diameter van het grootste hemellichaam dat bezocht is op de vroegste
-- reis waar klantnr 126 niet op meegegaan is.

select reisnr from reizen
where vertrekdatum =
	(select min(vertrekdatum)
	from reizen
	where reisnr in 
		(select reisnr from deelnames where klantnr != 126)
	)
;

select diameter as grootste
from hemelobjecten
where diameter = 
	(select max(diameter)
	from hemelobjecten
	where objectnaam in 
			(select objectnaam from bezoeken
			where reisnr =
				(select reisnr from reizen
				where vertrekdatum =
				(select min(vertrekdatum)
					from reizen
					where reisnr in 
					(select reisnr from deelnames where klantnr != 126)
				))
		)
	)
;

-- Geef de deelnemers waarbij hun aantal reizen die ze ondernemen groter is dan
-- alle hemelobjecten (die niet beginnen met de letter 'M') hun aantal keren
-- dat ze bezocht zijn. Of anders geformuleerd: Geef de deelnemers met meer
-- deelnames dan het grootste aantal bezoeken aan een hemelobject dat niet met
-- de letter 'M' begint (:deze deelnemer meer deelnames heeft dan de "grootste"
-- .. = deze deelnemer heeft meer deelnames dan "alle" ..) Sorteer op
-- klantnr.


select klantnr, vnaam, naam, count(*) as aantaldeelnames
from klanten
left join deelnames using(klantnr)
group by klantnr
having count(*) > all 
	(select count(*) from bezoeken
	where objectnaam not similar to 'M%'
	group by objectnaam)
order by klantnr
;

select count(*) from bezoeken
where objectnaam not similar to 'M%'
group by objectnaam
;

-- Geef alle niet-bezochte hemelobjecten, buiten het grootste hemellichaam.
-- Sorteer op diameter en objectnaam.

select objectnaam, afstand, diameter from hemelobjecten
where objectnaam not in
	(select objectnaam from bezoeken)
and diameter !=
	(select max(diameter) from hemelobjecten)
order by diameter, objectnaam
;

-- Maak een lijst van klanten die meer dan 2 keer een reis gemaakt hebben waarbij
-- er geen bezoek was aan Jupiter.

select k.klantnr, naam || ' ' || vnaam as klantnaam, count(*) as aantalreizen
from klanten k
left join deelnames d on(k.klantnr = d.klantnr and d.reisnr not in
	(select reisnr from bezoeken where objectnaam = 'Jupiter')
)
group by k.klantnr
having count(*) > 2
;

-- Geef de klantnr voor de klant met het meeste bezoeken aan de maan. Geef ook
-- het aantal bezoeken.  Gebruik geen limit of top.

select d.klantnr, count(*)
from deelnames d
left join bezoeken b on(d.reisnr = b.reisnr and b.objectnaam = 'Maan')
group by d.klantnr
having count(*) = 
	(select max(count) from 
		(select d.klantnr, count(*)
		from deelnames d
		left join bezoeken b on(d.reisnr = b.reisnr and b.objectnaam = 'Maan')
		group by d.klantnr) as m
	)
;

-- OPTIM

-- Je kan per speler berekenen hoeveel boetes die speler heeft gehad en wat het
-- totaalbedrag per speler is. Pas nu deze querie aan zodat per verschillend
-- aantal boetes wordt getoond hoe vaak dit aantal boetes voorkwam. Sorteer van
-- voor naar achter.  Probeer gelijk of beter te doen dan "Sort
-- (cost=46.39..46.89 rows=200 width=8)".

select count(bedrag)
from boetes
group by spelersnr
;

explain select c as a, count(c)
from 
	(select count(bedrag) as c
	from boetes
	group by spelersnr) as cc
group by c
order by 1
;

-- Geef van alle spelers het verschil tussen het jaar van toetreding en het
-- geboortejaar, maar geef alleen die spelers waarvan dat verschil groter is
-- dan 20. Sorteer van voor naar achter.  Probeer zo goed of beter te doen dan
-- "Sort (cost=17.20..17.37 rows=67 width=90)"

explain select spelersnr, naam, voorletters, jaartoe - extract(year from geb_datum) as toetredingsleeftijd
from spelers
where jaartoe - extract(year from geb_datum) > 20
order by 1
;

-- Geef alle spelers die alfabetisch (dus naam en voorletters, in deze
-- volgorde) voor speler 8 staan. Sorteer van voor naar achter.
-- Probeer zo goed of beter te doen dan
-- "Sort (cost=24.31..24.47 rows=67 width=88)"

select spelersnr, naam, voorletters, geb_datum,
	row_number() over(order by naam, voorletters)
from spelers
;

select row_number
from 
	(select spelersnr, naam, voorletters, geb_datum,
		row_number() over(order by naam, voorletters)
	from spelers) as numbered
where spelersnr = 8;


select spelersnr, naam, voorletters, geb_datum from
	(select spelersnr, naam, voorletters, geb_datum,
		row_number() over(order by naam, voorletters)
	from spelers) as numbered
where row_number between 1 and
	(select row_number
	from 
		(select spelersnr, naam, voorletters, geb_datum,
			row_number() over(order by naam, voorletters)
		from spelers) as numbered
	where spelersnr = 8) - 1
order by 1
;

-- JOINS EXTRA

-- Hoeveel kilometers heeft iedereen in totaal gevlogen tot nu toe en hoeveel
-- hebben ze hier in totaal voor betaald. Vermits we de posities van de
-- planeten niet kennen, mag je de afstanden van de hemelobjecten direct
-- gebruiken. Geef het totaal gespendeerde bedrag, de afgelegde kilometers, de
-- prijs per kilometer en datum van hun laatste vlucht van al hun persoonlijke
-- reizen. In het geval dat iemand niet op reis is geweest of geen kilometers
-- gedaan heeft, toon je de boodschap 'veel geld voor niks of niet op reis
-- geweest’ in de kolom prijs_per_kilometer.  Sorteer van voor naar achter.

select reisnr, sum(afstand)
from bezoeken
left join hemelobjecten using(objectnaam)
group by reisnr;

select klanten.klantnr, klanten.naam || ' ' || klanten.vnaam as naam,
	sum(reizen.prijs) as tot_bedrag,
	sum(reisafstand) as tot_afstand,
	sum(reizen.prijs) / sum(reisafstand) as prijs_per_kilometer,
	max(reizen.vertrekdatum) as laatste_reis_datum
from klanten
left join deelnames using(klantnr)
left join reizen using(reisnr)
left join 
	(select reisnr, sum(afstand) as reisafstand
	from bezoeken
	left join hemelobjecten using(objectnaam)
	group by reisnr) as reisafstanden
	using(reisnr)
group by klanten.klantnr, klanten.naam
order by klantnr
;

-- Geef de volledige frequentietabel voor de diameters van de hemelobjecten
-- (frequentie: hoeveel ojecten zijn er met de gegeven diameter, cumulatieve
-- Frequentie, relatieve frequentie, Relatieve cumulatieve frequentie).
-- Let op de datatypes en de precisie, gebruik CAST, rond niet af. Sorteer op
-- diameter.

select df1.diameter, df1.f, sum(df2.f) as cf,
cast(cast(df1.f as numeric) / cast((select count(*) from hemelobjecten) as numeric) * 100.00 as dec(4,2)) as rf,
cast(cast(sum(df2.f) as numeric) / cast((select count(*) from hemelobjecten) as numeric) * 100.00 as numeric(5, 2)) as crf
from 
	(select diameter, count(diameter) as f
	from hemelobjecten
	group by diameter) as df1
left join
	(select diameter, count(diameter) as f
	from hemelobjecten
	group by diameter) as df2
on(df1.diameter >= df2.diameter)
group by df1.diameter, df1.f
order by 1
;

-- Geef voor elke reis het aantal klanten waarvan de naam niet met een 'G'
-- begint en waarvan de periode van de geboortedatum van de klant tot de
-- vertrekdatum van de reis overlapt met de huidige datum en 50 jaar verder
-- (gebruik hiervoor de gepaste operator: OVERLAPS).  Indien er op de reis
-- hemelobjecten worden bezocht waarvan de tweede letter van het hemelobject
-- voorkomt in de naam van het hemelobject waarvan dit bezocht hemelobject een
-- satelliet is, dan wordt deze reis genegeerd.  Sorteer op reisnr.

select r.reisnr, count(k.naam)
from reizen r
natural left join deelnames d
left join klanten k on(k.klantnr = d.klantnr and k.naam not like 'G%')
where (k.geboortedatum, r.vertrekdatum) overlaps (current_date, interval '50 years')
and r.reisnr not in 
	(select reisnr
	from bezoeken
	natural left join hemelobjecten
	where satellietvan like '%' || substr(objectnaam, 2, 1) || '%')
group by r.reisnr
order by 1
;

select reisnr
from bezoeken
natural left join hemelobjecten
where satellietvan like '%' || substr(objectnaam, 2, 1) || '%'
;

-- EXTRA 4

-- Maak een overzicht waarbij je voor de Maan en voor Mars aangeeft hoeveel
-- ruimtereizen één of meer keer de betreffende bestemming bezocht hebben
-- (d.w.z. erop geland zijn). Sorteer van voor naar achter.

select objectnaam, count(reisnr)
from 
	(select distinct objectnaam, reisnr
	from bezoeken
	where objectnaam in ('Maan', 'Mars')) as m
group by objectnaam
;

-- Maak een lijst van de mensen die Mars wel bezocht hebben maar Io nog niet.
-- Sorteer van voor naar achter.

select klantnr, naam
from klanten
natural left join deelnames
natural left join reizen
natural left join bezoeken
where objectnaam = 'Mars'
and klantnr not in
	(select klantnr 
	from klanten
	natural left join deelnames
	natural left join reizen
	natural left join bezoeken
	where objectnaam = 'Io')
order by 1
; 

-- Maak een overzicht waarbij je voor de Maan en voor Mars aangeeft hoeveel
-- verschillende ruimtereizen er geweest zijn(d.w.z. erop geland zijn is
-- voldoende). En enkel indien er meer dan 1 reis geweest is. Sorteer
-- van voor naar achter

-- Zelfde als hierboven ?

select objectnaam, count(reisnr)
from 
	(select distinct objectnaam, reisnr
	from bezoeken
	where objectnaam in ('Maan', 'Mars')) as m
group by objectnaam
;

-- Geef de klant die het meest op de maan is geweest (+het aantal). Sorteer van
-- voor naar achter.

select k.klantnr, c as count
from
	(select klantnr, count(bezoeken.volgnr) as c
	from deelnames
	natural left join reizen
	natural left join bezoeken
	where objectnaam = 'Maan'
	group by klantnr) as k
where c =
	(select max(c2) from
		(select count(bezoeken.volgnr) as c2
		from deelnames
		natural left join reizen
		natural left join bezoeken
		where objectnaam = 'Maan'
		group by klantnr) k2
	)
;

-- Maak een lijst met die mensen die meer dan 2 maal een reis ondernomen hebben
-- waarin men geen enkele satelliet van Jupiter bezoekt !. Sorteer van voor
-- naar achter.

select reisnr
from bezoeken
natural left join hemelobjecten
where satellietvan != 'Jupiter'
;

select klantnr, naam || vnaam as "volledige naam", count(reisnr) as "aantal ondernomen reizen"
from klanten
natural left join deelnames
where reisnr not in
	(select reisnr
	from bezoeken
	natural left join hemelobjecten
	where satellietvan = 'Jupiter')
group by klantnr
having count(reisnr) > 2
order by 1
;

-- VENSTERS

-- Geef per reis incrementeel de totale verblijfsduur volgens de volgorde
-- waarin de hemelobjecten bezocht worden. Geef ook de totale verblijfsduur van
-- alle reizen om alles in perspectief te zettten.  Sorteer op reisnr, volgnr,
-- objectnaam, verblijfsduur, de volgende kolommen.

select reisnr, volgnr, objectnaam, verblijfsduur,
sum(verblijfsduur) over(partition by reisnr order by volgnr) as inc_duur,
sum(verblijfsduur) over() as tot_duur
from bezoeken
order by reisnr, volgnr, objectnaam, verblijfsduur
;

-- Hoe lang was het geleden dat er nog een reis vertrokken was?  Geef daarnaast
-- de totale reisduur per jaar incrementeel in de tijd (hier genaamd
-- jaar_duur).  Sorteer op reisnr en de andere kolommen.

select reisnr,
lag(reisnr, 1) over() as vorig_reisnr,
vertrekdatum,
vertrekdatum - lag(vertrekdatum, 1) over() as tussen_tijd,
reisduur,
extract(year from vertrekdatum) as jaar,
sum(reisduur) over(partition by extract(year from vertrekdatum) order by reisnr, vertrekdatum) as jaar_duur
-- sum(reisduur) over(partition by extract(year from vertrekdatum), reisnr) as jaar_duur
from reizen
order by 1, 2, 3, 4, 5, 6, 7
;





