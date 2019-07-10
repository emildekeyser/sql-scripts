
select t.teamnr, max(w.wedstrijdnr) as laatstewedstrijd
from teams t
left join wedstrijden w using(teamnr)
inner join bestuursleden b on w.spelersnr = b.spelersnr
left join boetes bo on bo.spelersnr = w.spelersnr
where bo.spelersnr is null
group by t.teamnr
;

select s.naam , s.geslacht, 
	case
		when bl.functie is not null then bl.functie 
		else null
	end as functie
from spelers s
left join bestuursleden bl on s.spelersnr = bl.spelersnr and bl.eind_datum is null
where s.naam ilike '%e%e%' 
and s.geslacht = 'M'
order by 1, 3;

select t.teamnr, t.divisie, w.wedstrijdnr, w.spelersnr, 
case when b.spelersnr is not null then 'actief' else '-' end as bestuurslid
from teams t 
left outer join wedstrijden w on t.teamnr = w.teamnr and w.verloren > w.gewonnen
left outer join bestuursleden b on w.spelersnr = b.spelersnr and b.eind_datum is null
order by 2, 3

select s.naam, case
		when avg(b.bedrag) is null then null
		else cast(avg(b.bedrag) as varchar(8))
	end as gemiddeld
from spelers s
left outer join boetes b using(spelersnr)
group by s.spelersnr
order by 1, 2 desc nulls first
;

select k.naam, count(d.reisnr) as aantal_reizen
from klanten k
left join deelnames d using(klantnr)
left join reizen r using(reisnr)
where r.prijs > 2.5
group by k.naam
having count(d.reisnr) > 1
order by 1
;

select r.reisnr, r.vertrekdatum
from reizen r 
left join bezoeken b using(reisnr)
inner join hemelobjecten h on b.objectnaam = h.objectnaam
and (h.objectnaam = 'Maan' or h.objectnaam = 'Mars')
and b.verblijfsduur > 0
group by r.reisnr
having count(b.reisnr) > 0
order by 2 asc
;

select r.reisnr
from reizen r 
left outer join bezoeken b using(reisnr)
group by r.reisnr
having count(distinct b.objectnaam) = 3
	and count(b.volgnr) = 3
order by 1
;

select h.objectnaam as planeet, manen.objectnaam as maan
from hemelobjecten h
left outer join hemelobjecten manen on manen.satellietvan = h.objectnaam
where h.objectnaam <> 'Zon' and h.satellietvan = 'Zon'
order by 1, 2

;


select min(extract(year from age(r.vertrekdatum, k.geboortedatum))) as jongsteleeftijd
from klanten k
left outer join deelnames d using(klantnr)
left outer join reizen r using(reisnr)
;


select *
from hemelobjecten h
left outer join bezoeken b using(objectnaam)
where h.satellietvan <> 'Zon' and b.volgnr is null
;


select h1.objectnaam, h1.diameter, max(b.verblijfsduur) as maximale_verblijf
from hemelobjecten h1
left outer join hemelobjecten h2 on h1.objectnaam = h2.satellietvan
left outer join bezoeken b on h1.objectnaam = b.objectnaam
where b.verblijfsduur is not null
group by h1.objectnaam
having count(distinct h2.objectnaam) < 5
order by 1
;


select k.klantnr, count(distinct r.reisnr) as aantal, max(b.verblijfsduur) as langstebezoek
from klanten k
left outer join deelnames d using(klantnr)
left outer join reizen r using(reisnr)
left outer join bezoeken b using(reisnr)
group by k.klantnr
;

