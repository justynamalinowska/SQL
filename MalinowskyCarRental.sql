use master
GO

IF EXISTS(select name from sys.databases where name = 'MalinowskyCarRental')
	drop database MalinowskyCarRental
GO

create database MalinowskyCarRental
GO

use MalinowskyCarRental;

create table Pracownicy(
	id_pracownika int constraint pk_id_pracownika primary key identity(1, 1)
);

create table Bazy(
	id_bazy int constraint pk_id_bazy primary key identity(1, 1),
	id_pracownika int constraint ref_Bazy_id_pracownika references Pracownicy(id_pracownika), -- kierownik bazy
	kraj char(50),
	miasto char(50),
	ulica char(60),
	numer_domu char(6),
	numer_lokalu char(6),
);

alter table Pracownicy add
	id_bazy int constraint ref_Pracownicy_id_bazy references Bazy(id_bazy), -- baza w której pracuje pracownik
	pesel char(11) unique not null,
	imie char(30),
	nazwisko char(50),
	data_urodzenia date check(datediff(year, data_urodzenia, getdate()) >= 15),
	nr_telefonu char(15),
	data_zatrudnienia date,
	stanowisko char(50),
	stawka_godzinowa smallint check(stawka_godzinowa > 0),
	kraj char(50),
	miasto char(50),
	ulica char(60),
	numer_domu char(6),
	numer_lokalu char(6)
;

insert into Pracownicy(pesel, imie, nazwisko, data_urodzenia, nr_telefonu, data_zatrudnienia, stanowisko, stawka_godzinowa, kraj, miasto, ulica, numer_domu, numer_lokalu)
values
    ('03221341278', 'Mateusz', 'Malinowski', '2003-04-03', '+48123456789', '2022-12-01', 'kierownik', 30, 'Polska', 'Warszawa', 'Pawia', '14', '8'),
    ('01271999566', 'Justyna', 'Malinowska', '2001-12-11', '+48987654321', '2022-12-01', 'kierownik', 25, 'Polska', 'Warszawa', 'Pawia', '14', '8'),
    ('01021657321', 'Iga', 'Lis', '2001-05-13', '+48125125125', '2022-12-20', 'sekretarka', 15, 'Polska', 'Katowice', 'Sienna', '3', null),
    ('96011213577', 'Dariusz', 'Sikorski', '1996-10-12', '+48777111222', '2022-12-21', 'mechanik', 10, 'Polska', 'Katowice', 'Orzeszkowej', '1B', null),
    ('99083051663', 'Eliza', 'Krupa', '1999-02-01', '+48567666111', '2022-12-22', 'konsultant', 20, 'Polska', 'Katowice', 'Krakowska', '18A', '6')
;

insert into Bazy(id_pracownika, kraj, miasto, ulica, numer_domu, numer_lokalu)
values(1, 'Polska', 'Katowice', 'Pawia', '2', null);

update Pracownicy set id_bazy = 1; -- ka¿dy pracownik do jednej bazy, bo nie ma innych baz

create table Klienci(
	id_klienta int constraint pk_id_klienta primary key identity(1, 1),
	pesel char(11) unique not null,
	imie char(30),
	nazwisko char(50),
	data_urodzenia date check(datediff(year, data_urodzenia, getdate()) >= 15),
	nr_telefonu char(15),
	kraj char(50),
	miasto char(50),
	ulica char(60),
	numer_domu char(6),
	numer_lokalu char(6),
);

insert into Klienci(pesel, imie, nazwisko, data_urodzenia, nr_telefonu, kraj, miasto, ulica, numer_domu, numer_lokalu)
values
    ('04301531438', 'Kajetan', 'Andrzejewski', '2004-07-15', '+48125411255', 'Polska', 'Katowice', 'Wiœlana', '7C', '8'),
    ('77112611444', 'Aniela', 'Kowalska', '1977-02-04', '+48869921125', 'Polska', 'Sosnowiec', 'Abstrakcyjna', '6', '10'),
    ('88012714195', 'Denis', 'Wojciechowski', '1988-01-02', '+48165017401', 'Polska', 'Katowice', 'Grodzka', '123', null),
    ('78071664689', 'Maja', 'Laskowska', '1978-03-09', '+48696453803', 'Polska', 'Chorzów', 'Konopnicka', '223', null),
    ('80062693626', 'Paulina', 'Duda', '1980-03-23', '+48608524123', 'Polska', 'Katowice', 'Rzymska', '17', '6')
;

create table [Modele samochodow]( -- powi¹zanie marki z modelem
	id_modelu int constraint pk_id_modelu primary key identity(1, 1),
	marka char(30),
	model char(50)
);

insert into [Modele samochodow](marka, model)
values
	('Audi', 'RS3'),
	('Toyota', 'GR Yaris'),
	('Peugeot', '508'),
	('Jaguar', 'XF'),
	('Porsche', 'Taycan 4S')
;

create table [Rodzaje paliwa](
	id_rodzaju_paliwa int constraint pk_id_rodzaju_paliwa primary key identity(1, 1),
	rodzaj_paliwa char(30)
);

insert into [Rodzaje paliwa](rodzaj_paliwa)
values
	('Benzyna'),
	('Diesel'),
	('Elektryczny'),
	('Benzyna + Elektryczny'),
	('Diesel + Elektryczny'),
	('Wodorowy'),
	('Benzyna + LPG')
;

create table [Stany samochodu](
	id_stanu_samochodu int constraint pk_id_stanu_samochodu primary key identity(1, 1),
	stan_samochodu char(20)
);

insert into [Stany samochodu](stan_samochodu)
values
	('perfekcyjny'),
	('bardzo dobry'),
	('dobry')
;

create table [Typy nadwozia](
	id_typu_nadwozia int constraint pk_id_typu_nadwozia primary key identity(1, 1),
	typ_nadwozia char(20)
);

insert into [Typy nadwozia](typ_nadwozia)
values
	('Hatchback'),
	('Minivan'),
	('SUV'),
	('Coupe'),
	('Pick-up'),
	('Sedan'),
	('Kompakt')
;

create table [Wersje modeli]( -- wersje które wyje¿d¿a³y z fabryki
	id_wersji int constraint pk_id_wersji primary key identity(1, 1),
	id_modelu int constraint ref_Wersje_id_modelu references [Modele samochodow](id_modelu),
	id_paliwa int constraint ref_Wersje_id_paliwa references [Rodzaje paliwa](id_rodzaju_paliwa),
	id_typu_nadwozia int constraint ref_Wersje_id_typu_nadwozia references [Typy nadwozia](id_typu_nadwozia),
	moc_kw smallint check(moc_kw > 0),
	pojemnosc_silnika smallint check(pojemnosc_silnika > 0),
	liczba_miejsc tinyint check(liczba_miejsc > 0),
);

insert into [Wersje modeli](id_modelu, id_paliwa, id_typu_nadwozia, moc_kw, pojemnosc_silnika, liczba_miejsc)
values
	(1, 1, 7, 400, 2500, 5),
	(1, 1, 7, 550, 2500, 5),
	(2, 1, 1, 261, 1600, 4),
	(3, 2, 4, 150, 1900, 5),
	(3, 1, 6, 150, 1900, 5),
	(4, 4, 6, 250, 2000, 5),
	(5, 3, 1, 500, null, 5)
;

create table [Typy samochodow]( -- wersje które posiada wypo¿yczalnia
	id_typu int constraint pk_id_typu primary key identity(1, 1),
	id_wersji int constraint ref_Typy_id_wersji references [Wersje modeli](id_wersji),
	rok_produkcji smallint check(rok_produkcji > 1900), -- te same wersje mog³y byæ produkowane przez kilka lat w fabrykach
	kolor char(30) -- kolor móg³ zostaæ zmieniony/zamówiony na ¿yczenie i nie jest powi¹zany z wersj¹ modelu
);

insert into [Typy samochodow](id_wersji, rok_produkcji, kolor)
values
	(1, 2022, 'B³êkitny'),
	(1, 2021, 'Czerwony'),
    (2, 2021, 'Bia³y'),
    (7, 2022, 'Zielony')
;

create table Samochody( -- samochody posiadane przez wypo¿yczalnie
	id_samochodu int constraint pk_id_samochodu primary key identity(1, 1),
	id_typu int constraint ref_Samochody_id_typu references [Typy samochodow](id_typu),
	id_bazy int constraint ref_Samochody_id_bazy references Bazy(id_bazy),
	id_stanu_samochodu int constraint ref_Samochody_id_stanu_samochodu references [Stany samochodu](id_stanu_samochodu),
	vin char(17) unique not null,
	przebieg int check(przebieg >= 0),
	cena_za_dzien smallint check(cena_za_dzien > 0),
);

insert into [Samochody](id_typu, id_bazy, id_stanu_samochodu, vin, przebieg, cena_za_dzien)
values
	(1, 1, 1, '1B3ES26C43D181177', 300, 75),
	(1, 1, 2, '1G2NF52T51M530732', 1500, 65),
	(2, 1, 1, '2D4RN6DX3AR308230', 0, 80),
	(3, 1, 1, 'JF1GG29604G881038', 100, 50),
	(4, 1, 1, '1GYS4DEF9CR276978', 150, 90)
;

create table Wypozyczenia(
	id_wypozyczenia int constraint pk_id_wypozyczenia primary key identity(1, 1),
	id_klienta int constraint ref_Wypozyczenia_id_klienta references Klienci(id_klienta),
	id_pracownika int constraint ref_Wypozyczenia_id_pracownika references Pracownicy(id_pracownika),
	id_samochodu int constraint ref_Wypozyczenia_id_samochodu references Samochody(id_samochodu),
	data_wypozyczenia date not null,
	planowana_data_zwrotu date not null,
	data_zwrotu date,
	oplata_dodatkowa int
);

insert into [Wypozyczenia](id_klienta, id_pracownika, id_samochodu, data_wypozyczenia, planowana_data_zwrotu, data_zwrotu, oplata_dodatkowa)
values
	(1, 2, 1, '2022-12-15', '2023-01-15', null, null),
	(2, 1, 2, '2022-12-16', '2022-12-20', '2022-12-20', null),
	(3, 1, 3, '2022-12-10', '2022-12-14', '2022-12-20', 600),
	(4, 2, 4, '2022-12-12', '2022-12-16', '2022-12-16', null),
	(5, 2, 5, '2022-12-13', '2022-12-17', '2022-12-17', null)
;

select * from Pracownicy;
select * from Bazy;
select * from Klienci;
select * from [Modele samochodow];
select * from [Rodzaje paliwa];
select * from [Stany samochodu];
select * from [Typy nadwozia];
select * from [Wersje modeli];
select * from [Typy samochodow];
select * from Samochody;
select * from Wypozyczenia;