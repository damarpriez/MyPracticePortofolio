SELECT *
FROM CovidDeaths$

SELECT DEATH.continent, DEATH.location, DEATH.date, DEATH.population, VAC.new_vaccinations
, SUM(CONVERT(int,VAC.new_vaccinations )) OVER (PARTITION BY DEATH.location ORDER BY DEATH.location, DEATH.date) 
AS RollingPeopleVaci
FROM CovidDeaths$ AS DEATH
JOIN CovidVaccinations$ AS VAC
	ON DEATH.location = VAC. location
	and DEATH.date = VAC.date
WHERE DEATH.continent IS NOT NULL
ORDER BY 2,3 DESC

--USE CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVac ) AS
(SELECT DEATH.continent, DEATH.location, DEATH.date, DEATH.population, VAC.new_vaccinations
, SUM(CONVERT(int,VAC.new_vaccinations )) OVER (PARTITION BY DEATH.location ORDER BY DEATH.location, DEATH.date) 
AS RollingPeopleVaci
FROM CovidDeaths$ AS DEATH
JOIN CovidVaccinations$ AS VAC
	ON DEATH.location = VAC. location
	and DEATH.date = VAC.date
WHERE DEATH.continent IS NOT NULL
--ORDER BY 2,3 DESC
)

SELECT *, (RollingPeopleVac/population)*100 AS RollingPeoplePercentage
FROM PopvsVac
WHERE location LIKE '%Albania%'
--FINISH METHOD

--Using TEMP TABLE
DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar (255), location nvarchar (255), date DATETIME, population numeric, new_vaccination numeric,
RollingPeopleVaci numeric);

INSERT INTO #PercentPopulationVaccinated
SELECT DEATH.continent, DEATH.location, DEATH.date, DEATH.population, VAC.new_vaccinations
, SUM(CONVERT(int,VAC.new_vaccinations )) OVER (PARTITION BY DEATH.location ORDER BY DEATH.location, DEATH.date) 
AS RollingPeopleVaci
FROM CovidDeaths$ AS DEATH
JOIN CovidVaccinations$ AS VAC
	ON DEATH.location = VAC. location
	and DEATH.date = VAC.date
WHERE DEATH.continent IS NOT NULL
--ORDER BY 2,3 DESC

SELECT *, (RollingPeopleVaci/population)*100 AS RollingPeoplePercentage
FROM #PercentPopulationVaccinated
--this method finished here also--



--create view to store data later vizualtion
CREATE VIEW PercentPopulationVaccinated as
SELECT DEATH.continent, DEATH.location, DEATH.date, DEATH.population, VAC.new_vaccinations
, SUM(CONVERT(int,VAC.new_vaccinations )) OVER (PARTITION BY DEATH.location ORDER BY DEATH.location, DEATH.date) 
AS RollingPeopleVaci
FROM CovidDeaths$ AS DEATH
JOIN CovidVaccinations$ AS VAC
	ON DEATH.location = VAC. location
	and DEATH.date = VAC.date
WHERE DEATH.continent IS NOT NULL
--ORDER BY 2,3 DESC

SELECT *
FROM PercentPopulationVaccinated