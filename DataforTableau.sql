/*
Queries used for Tableau Project
*/


.mode csv
.import C:/Users/vakas/Desktop/SQL/covid_death.csv death

-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From death
where continent in ("Europe", "North America", "Asia", "South America", "Africa", "Oceania")
order by 1,2;

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From death
--Where location like '%states%'
where location = 'World'
--Group By date
order by 1,2;


-- 2. 

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From death
Where continent = ''
and location in ("Europe", "North America", "Asia", "South America", "Africa", "Oceania")
Group by location
order by TotalDeathCount desc;


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From death
Group by Location, Population
order by PercentPopulationInfected desc;


-- 4.

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From death
Group by Location, Population, date
order by PercentPopulationInfected desc;
