alter database home set search_path to tennis_triggers ;

-- 05_6_Procedures_Functions_Triggers.pdf

CREATE TABLE plaatsen (
    plaatsnaam text
);
select * from plaatsen;

select * from spelers;
INSERT INTO spelers VALUES (500, 'Elfring2', 'K', '1948-09-01', 'M', 1975, 'Kakweg', '43', '3575NH', 'Den Haag', '070-237893', '2443');
INSERT INTO spelers VALUES (500, 'Elfring2', 'K', '1948-09-01', 'M', 1975, 'Kakweg', '43', '3575NH', 'ldfjgldfgjlf', '070-237893', '2443');
delete from spelers where spelersnr = 500;

create or replace function check_plaats_exists()
returns trigger
as $$
begin
    raise notice 'new row: %', NEW;
    if NEW.plaats in (select * from plaatsen) then
        return NEW;
    end if;
    -- raise exception 'will not be added because % is not an existing plaats' , NEW.plaats;
    raise notice 'will not be added because % is not an existing plaats' , NEW.plaats;
    return null;
end;
$$ language plpgsql;

create trigger trigger_plaats_exists
before update or insert
on spelers
for each row execute procedure check_plaats_exists();

--------------------------------------------------------------------------------

-- 2. Zorg ervoor dat er een tabel met een simpele statistiek van een tabel van
-- jouw project, namelijk het aantal inserts dat er reeds is op uitgevoerd.

select * from insert_log;
select * from spelers;
INSERT INTO spelers VALUES (506, 'Elfring4', 'K', '1948-09-01', 'M', 1975, 'Kakweg', '43', '3575NH', 'Den Haag', '070-237893', '2443');
INSERT INTO spelers VALUES (500, 'Elfring2', 'K', '1948-09-01', 'M', 1975, 'Kakweg', '43', '3575NH', 'ldfjgldfgjlf', '070-237893', '2443');
delete from spelers where spelersnr = 500;

create table insert_log (
   ts timestamp 
);

create or replace function log_insert()
returns trigger
as $$
begin
    insert into insert_log values (now());
    return null;
end;
$$ language plpgsql;

create trigger trigger_log_insert
after insert
on spelers
for each row execute procedure log_insert();

















