SELECT row_number() over () as volgnr, geslacht, plaats, count(*)
FROM spelers
GROUP BY CUBE (geslacht, plaats)
order by geslacht, plaats
;
