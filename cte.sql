with recursive f(a, b) as (
    -- select 0, 1
    values(0, 1)
    union all
    select b, a+b from f where a+b < 100
)
select b from f;

--------------------------------------------------------------------------------

alter database home set search_path = familie;

CREATE TABLE familieboom(
    bijnaam varchar(16) NOT NULL,
    vader
    varchar(16),
    moeder
    varchar(16),
    CONSTRAINT familieboom_pk 
    PRIMARY KEY (bijnaam),
    CONSTRAINT vader_fk 
    FOREIGN KEY (vader) 
    REFERENCES familieboom(bijnaam),
    CONSTRAINT moeder_fk 
    FOREIGN KEY (moeder) 
    REFERENCES familieboom(bijnaam)
);

INSERT INTO familieboom VALUES 
('bofh','bofh','bofh'),
('moeder','bofh','bofh'),
('vader','bofh','bofh'),
('kindje','vader','moeder'),
('nog_een_kindje','vader','moeder'),
('lelijk_nestje','kindje','nog_een_kindje'),
('lelijker_nestje','kindje','nog_een_kindje'),
('markske','vader','kindje'),
('prutske','lelijk_nestje','lelijker_nestje');

select * from familieboom;

with recursive kleindkinderen(bijnaam, vader, moeder) as (
    select bijnaam, vader, moeder
    from familieboom
    where vader = 'vader'
    union all
    select f.bijnaam, f.vader, f.moeder
    from familieboom f, kleindkinderen kk
    where f.vader = kk.bijnaam
)
select * from kleindkinderen;

with recursive kleindkinderen(bijnaam, vader, moeder, boom, diepte) as (
    select bijnaam, vader, moeder, 'vader', 1
    from familieboom
    where vader = 'vader'
    union all
    select f.bijnaam, f.vader, f.moeder, kk.boom || '-' || f.vader, diepte + 1
    from familieboom f, kleindkinderen kk
    where f.vader = kk.bijnaam
    -- and diepte < 500
)
select * from kleindkinderen;




















