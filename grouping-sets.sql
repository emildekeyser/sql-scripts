SELECT geslacht, plaats, count(*)
FROM spelers
GROUP BY GROUPING SETS ((geslacht, plaats),(geslacht), (plaats), ())
order by 1, 2
; 
