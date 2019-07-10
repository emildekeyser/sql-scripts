--db1

select s.spelersnr, count(b.betalingsnr) as aantalboetes
from spelers s left join boetes b using(spelersnr)
where s.spelersnr in (select spelersnr from wedstrijden)
group by s.spelersnr
order by 2, 1;
select s.spelersnr, w.wedstrijdnr
from spelers s
inner join wedstrijden w
	on w.spelersnr = s.spelersnr 
	and w.gewonnen > w.verloren
where s.spelersnr not in 
	(select spelersnr from bestuursleden where functie = 'Penningmeester')
order by 2
;
select s.spelersnr, s.naam, s.voorletters,
	cast(
		s.jaartoe
		-
		-- (select cast(avg(ss.jaartoe) as numeric(5, 3)) from spelers ss where ss.plaats = s.plaats)
		(select avg(ss.jaartoe) from spelers ss where ss.plaats = s.plaats)
	as numeric(5, 3))
from spelers s
order by 1
;
select 	sq.a, count(sq.a)
from 	(select b.spelersnr, count(b.betalingsnr) as a, sum(b.bedrag)
	from boetes b 
	group by b.spelersnr) as sq
group by a
order by 1
;
select s.spelersnr, s.naam, s.voorletters, s.jaartoe - extract(year from s.geb_datum) as toetredingsleeftijd
from spelers s
where s.jaartoe - extract(year from s.geb_datum) > 20
order by 1,2,3,4
;
select 	s.spelersnr, s.naam, s.voorletters, count(b.betalingsnr) as aantalboetes, 
	(select count(*) from teams tt where tt.spelersnr = s.spelersnr) as aantalteams
from 	spelers_l s 
	inner join teams t using(spelersnr)
	inner join boetes b using(spelersnr)
group by s.spelersnr
order by 1,2,3,4
;
select 	s.spelersnr, s.plaats
from 	spelers s 
where s.plaats in (select ss.plaats from spelers ss group by ss.plaats having count(ss.plaats) >= 2)
order by 2 desc, 1
;
select 	s.spelersnr, s.voorletters, s.naam
from 	spelers s inner join boetes b using(spelersnr)
where b.bedrag = (select max(bb.bedrag) from boetes bb)
order by 3, 2
;
select
(select count(*) from boetes)::integer as aantal_boetes,
(select sum(b.bedrag) from boetes b)::integer as totaal_bedrag,
(select min(b1.bedrag) from boetes b1)::integer as minimum,
(select max(b2.bedrag) from boetes b2)::integer as maximum
order by 1, 2, 3, 4
;
select 	s.spelersnr, s.naam, s.voorletters, 
	(select count(*) from boetes bb where bb.spelersnr = s.spelersnr) as aantalboetes,
	(select count(*) from teams tt where tt.spelersnr = s.spelersnr) as aantalteams
from 	spelers s 
where s.spelersnr = any(select t.spelersnr from teams t)
order by 1,2,3,4
;
select 	s.spelersnr, s.naam
from 	spelers s 
where s.plaats = 'Rijswijk'
and s.spelersnr in (select b.spelersnr from boetes b where b.bedrag = 25 and extract(year from b.datum) = 1980)
order by 1,2
;
