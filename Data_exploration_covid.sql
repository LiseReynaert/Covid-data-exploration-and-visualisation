-- ------------
-- SQL data exploration of covid dataset
-- Link to dataset : https://ourworldindata.org/covid-deaths
-- Tableau visualisation to follow !
---------------
-- Importing the csv death file
.mode csv
.import C:/Users/vakas/Desktop/SQL/covid_death.csv death
.schema death

--Selecting variables of interest, and ordering by location and date
select location, date, total_cases, new_cases, total_deaths, population
from death
order by 1,2;

--Looking at total cases vs total deaths
--Probability of dying if you contract covid in Switzerland ?
select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as deathpct
from death
where location = 'Switzerland'
order by 1,2;
-- 5 % of people who contracted covid died in june 2020
--0,34 % of people who contracted covid died in september 2022

--Looking at total cases vs population
--Shows what percentage of population got covid
select location, date, population, total_cases, (total_cases/population)*100 as casepct
from death
where location = 'Switzerland'
order by 1,2;

--Looking at countries with highest infection rate compared to population
select location, population, MAX(total_cases) as highestinfectioncount,
    (total_cases/population)*100 as percentpopulationinfected
from death
group by location
order by percentpopulationinfected desc;

--Showing the countries with the highest death count by population
select location, population, MAX(cast(total_deaths as integer)) as totaldeathcount
from death
where continent != ""
group by location
order by totaldeathcount desc;

--By continent
select location, population, MAX(cast(total_deaths as integer)) as totaldeathcount
from death
where location in ("Europe", "North America", "Asia", "South America", "Africa", "Oceania")
group by location
order by totaldeathcount desc;

--World
select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as deathpct
from death
where location = 'World';

--check that it matches the aggregation 
select date, sum(total_cases), sum(total_deaths), (sum(total_deaths)/sum(total_cases))*100 as deathpct
from death
where continent != ""
group by date;

------------------------
-- importing the vaccines file

.mode csv
.import C:/Users/vakas/Desktop/SQL/covid_vaccines.csv vaccines
--.schema vaccines

--Joining death and vaccinations tables
----Looking at total population vs vaccinations
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
    SUM(cast(v.new_vaccinations as integer)) over (Partition by d.location order by d.location,d.date)as cumulatednumbervacc
from death d
join vaccines v
on d.location = v.location and d.date = v.date
order by 2,3;

--Using CTE to create a temporary table
with popvsvacc(continent, location, date, population, new_vaccinations,cumulatednumbervacc)
as
(
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
    SUM(cast(v.new_vaccinations as integer)) over (Partition by d.location order by d.location,d.date) as cumulatednumbervacc
from death d
join vaccines v
on d.location = v.location and d.date = v.date
order by 2,3
)

select *, (cumulatednumbervacc/population)*100
from popvsvacc ;

-- Create view to store data for later visualisation in tableau
create view percentpopulationvacc as 
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
    SUM(cast(v.new_vaccinations as integer)) over (Partition by d.location order by d.location,d.date) as cumulatednumbervacc
from death d
join vaccines v
on d.location = v.location and d.date = v.date;