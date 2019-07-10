alter database home  set search_path to proc;

-- 05_4_PROCEDURELE_SQL_OEF.PDF

--------------------------------------------------------------------------------

-- 1. Schrijf een functie waarbij je gegevens uit een transactie tabel
-- verwijdert die ouder zijn dan 10 dagen

drop table transactions;
create table transactions
(
	id numeric,
	pid numeric,
	d date
);

insert into transactions (id, pid, d) values
(30, 01, '06-04-2019'),
(07, 30, '06-04-2019'),
(24, 44, '06-04-2019'),
(92, 98, '06-04-2019'),
(04, 16, '06-04-2019'),
(26, 95, '06-04-2019'),
(21, 65, '06-04-2019'),
(20, 09, '06-04-2019'),
(21, 43, '06-04-2019'),
(75, 29, '06-04-2019'),
(76, 09, '06-04-2019'),
(98, 17, '09-30-2018'),
(54, 77, '09-30-2018'),
(52, 81, '09-30-2018'),
(55, 17, '09-30-2018'),
(41, 87, '09-30-2018'),
(75, 74, '09-30-2018'),
(04, 93, '09-30-2018'),
(80, 25, '09-30-2018'),
(88, 66, '09-30-2018'),
(94, 98, '09-30-2018'),
(89, 52, '09-30-2018'),
(62, 28, '09-30-2018'),
(49, 93, '09-30-2018'),
(49, 07, '09-30-2018')
;

select cast(now() as date) - '05-26-2019';

create or replace procedure trim_archive()
language sql
as $$
	delete from transactions where (cast(now() as date) - d) > 10;
$$;

call trim_archive();

--------------------------------------------------------------------------------

-- Schrijf een functie die drie getallen optelt en teruggeeft.

create or replace function add_three (numeric, numeric, numeric)
returns numeric
as $$
	select $1 + $2 + $3;
$$ language sql;

select add_three(1, 1, 2);

--------------------------------------------------------------------------------

-- Geef 3 mogelijke procedurale talen op postgresql en vind een overeenkomst
-- met een ander software pakket (dbsoftware) op minstens 1 van die procedurale
-- talen.

-- PL/pgSQL (Chapter 40)
-- PL/Tcl (Chapter 41)
-- PL/Perl (Chapter 42)
-- PL/Python (Chapter 43)

-- In Mysql is de default create proc equivlaent aan pqSQL

--------------------------------------------------------------------------------

-- 4. Zou het mogelijk zijn een aggregatie functie te schrijven? Hoe zou je dit
-- dan moeten doen en is dit sql standaard?

-- CREATE AGGREGATE is a PostgreSQL language extension. The SQL standard does
-- not provide for user-defined aggregate functions.

create or replace function add_withdouble (numeric, numeric)
returns numeric
as $$
	select $1 + $2 * 2;
$$ language sql;

select add_withdouble(1, 1);

CREATE AGGREGATE sum_withdouble (numeric)
(
    sfunc = add_withdouble,
    stype = numeric,
    initcond = 0
);

select sum(id), sum_withdouble(id) from transactions;

select array_agg(id) from transactions;

--------------------------------------------------------------------------------

-- 7. Schrijf een  functie die nuttig is voor jouw persoonlijke databank.

create or replace procedure clone_schema(_schema_name text)
as $$
declare
	_table_name text;
	_clone_name text := _schema_name || '_clone';
begin
	raise notice 'Creating schema: %', _clone_name;
	execute 'create schema ' || _clone_name;
	for _table_name in 
	EXECUTE 'select tablename from pg_catalog.pg_tables where schemaname = $1;'
	USING _schema_name loop
		raise notice 'Creating table: %', _table_name;
		EXECUTE 'create table '
			|| _clone_name || '.' || _table_name
			|| ' as select * from '
			|| _schema_name || '.' || _table_name;
	end loop;
end;
$$ language plpgsql;

--------------------------------------------------------------------------------

-- 6. Schrijf een functie met als input parameter een tabel, die als output een
-- overzicht geeft van alle kolommen op de volgende wijze:
-- table A (x text, y int, z char(4)) - - tabel A met 3 kolommen als input
-- output: drie lijnen met een opsomming van de kolommen en hun datatypes.
-- x_value text;
-- y_value int;
-- z_value char;
-- tip: check table information about pg_attribute


select *
from information_schema.columns
where table_name = 'spelers'
;

create or replace procedure list_columns(_table_name text)
as $$
declare
	_columns record;
begin
	for _columns in 
	EXECUTE 'select column_name, data_type
		from information_schema.columns where table_name = $1'
	USING _table_name loop
		raise notice '%: %', _columns.column_name, _columns.data_type;
	end loop;
end;
$$ language plpgsql;

call list_columns('spelers');

create or replace function get_columns(_table_name text)
returns table (colname text, datatype text)
as $$
declare
	_columns record;
begin
	for _columns in 
	EXECUTE 'select column_name, data_type
		from information_schema.columns where table_name = $1'
	USING _table_name loop
		raise notice '%: %', _columns.column_name, _columns.data_type;
		return query select _columns.column_name::text, _columns.data_type::text;
	end loop;
	return;
end;
$$ language plpgsql;

select * from get_columns('spelers');
select get_columns('spelers');

--------------------------------------------------------------------------------


















