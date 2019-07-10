select distinct s.naam, s.voorletters, s.plaats
from spelers s
inner join boetes b on b.spelersnr = s.spelersnr and b.bedrag > 50
order by 1, 2, 3
; 
select distinct b.betalingsnr, b.bedrag, round((select b.bedrag / sum(bedrag) * 100 from boetes), 2)
from boetes b
order by 1, 2, 3
; 
select distinct bl.begin_datum, s.naam, s.straat | s.huisnr | s.postcode | s.plaats as adres
from spelers s
inner join bestuursleden bl 
on bl.spelersnr = s.spelersnr and bl.functie = 'Voorzitter'
order by 1, 2, 3
; 
