
--												PROJECT COVID
select *
from CovidDeaths$
where continent IS NOT NULL
ORDER BY 3,4

----select fromvacinationsn
--select *
--from CovidVaccinations$
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths$
ORDER BY 1,2

-- looking at total cases vs total death
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentages
FROM CovidDeaths$
WHERE location LIKE '%indonesia%'
ORDER BY 1,2


--looking at total cases vs population
--shows that percentage population got covid
Select location,date, total_cases, population , (total_cases/population)*100 AS Infectedpopulationpercentage
FROM CovidDeaths$
WHERE location LIKE '%indonesia%'
ORDER BY 1,2

--looking at countries with higest infection rate compared to population

Select location, population, MAX(total_cases) as HingestInfectionCount, MAX(total_cases/population)*100 AS INFECTIONRATEPERCENTAGE
FROM CovidDeaths$
GROUP BY location, population
ORDER BY INFECTIONRATEPERCENTAGE DESC

--LETSBREAK DOWN BY CONTINENT
Select continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths$
where continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC



--Showing Countries with HIGHEST death counts per population
Select location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths$
where continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

--GLOBAL NUMBERS
SELECT  date, SUM(new_cases) AS totalnewcase ,SUM(cast(new_deaths as int)) AS totaldeath, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS percentagedeath--total_deaths, (total_deaths/total_cases)*100 AS DeathPercentages
FROM CovidDeaths$
--WHERE location LIKE '%indonesia%'
WHERE continent IS NOT NULL
GROUP BY DATE
ORDER BY 1,2 DESC


SELECT  SUM(new_cases) AS totalnewcase ,SUM(cast(new_deaths as int)) AS totaldeath, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS percentagedeath--total_deaths, (total_deaths/total_cases)*100 AS DeathPercentages
FROM CovidDeaths$
--WHERE location LIKE '%indonesia%'
--WHERE continent IS NOT NULL
--GROUP BY DATE
ORDER BY 1,2 DESC

--Death and vaccination by location and date
SELECT DEATH.continent, DEATH.location, DEATH.date, DEATH.population, VAC.new_vaccinations
, SUM(CONVERT(int,VAC.new_vaccinations )) OVER (PARTITION BY DEATH.location ORDER BY DEATH.location, DEATH.date) 
AS RollingPeopleVaci
FROM CovidDeaths$ AS DEATH
JOIN CovidVaccinations$ AS VAC
	ON DEATH.location = VAC. location
	and DEATH.date = VAC.date
WHERE DEATH.continent IS NOT NULL
ORDER BY 2,3 DESC




