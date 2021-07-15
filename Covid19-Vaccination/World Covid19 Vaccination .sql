-- Import the Covid_world_deaths dataset

-- data with continent value not empty

SELECT *
FROM COVID19..Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY 3,4 ;



-- selecting the required columns only

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM COVID19..Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY 1,2 ;



-- calculating Death-percentage based on Total-deaths and Total-cases

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
FROM COVID19..Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY 1,2 ;



-- calculating Infected-Population-percentage based on Total-cases and Total-population

SELECT location, date, total_cases, population, (total_cases/population)*100 as Infection_Percentage
FROM COVID19..Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY 1,2 ;



-- Country-wise Infection-percentage based on Maximum of Total-cases by Total-population

SELECT location, population, MAX(total_cases) as Total_Cases, MAX((total_cases/population)*100) as Infection_Percentage
FROM COVID19..Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Infection_Percentage desc ;



-- Country-wise Death-count based on Maximum of Total-deaths

SELECT location, population, MAX(total_cases) as Total_Cases, MAX(cast(total_deaths as INT)) as Total_Deaths
FROM COVID19..Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Total_Deaths desc ;



-- Continent-wise Total-deaths, Total-cases and Population based on grouping data on location only

SELECT location, MAX(cast(total_deaths as INT)) as Total_Deaths, MAX(total_cases) as Total_Cases, SUM(population) as Population
FROM COVID19..Covid_Deaths
WHERE continent IS NULL and location not like 'World'
GROUP BY location
ORDER BY Total_Deaths desc ;



-- World's Total-cases, Total-deaths and Death-percentage ( based on Sum of New-deaths by Sum of New-cases )

SELECT SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as INT)) as Toatl_Deaths, SUM(cast(new_deaths as INT))/SUM(new_cases)*100 as Death_Percentage
FROM COVID19..Covid_Deaths
WHERE continent IS NOT NULL ;



-- Import the Covid_world_vacinations dataset

-- Country-wise Total-Vaccination daily with Rolling-sum of Vaccination

SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(cast(new_vaccinations as INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as Cummulative_Vaccinations
FROM COVID19..Covid_Deaths cd
JOIN COVID19..Covid_Vaccinations cv
	ON cd.location = cv.location
	and cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3 ;



-- creating CTE to calculate Cummulative-Vaccination-percentage

WITH Pop_vs_Vac ( Continent, Location, Date, Population, New_Vaccinations, Cummulative_Vaccinations )
as
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(cast(new_vaccinations as INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as Cummulative_Vaccinations
FROM COVID19..Covid_Deaths cd
JOIN COVID19..Covid_Vaccinations cv
	ON cd.location = cv.location
	and cd.date = cv.date
WHERE cd.continent IS NOT NULL
)

SELECT *, (Cummulative_Vaccinations/Population)*100 
FROM Pop_vs_Vac ;




-- creating Temp Table to calculate Cummulative Vaccinations Percentage

DROP TABLE if exists #CUMMULATIVE_VACCINATIONS ;

CREATE TABLE #CUMMULATIVE_VACCINATIONS (
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Cummulative_Vaccinations numeric
)

INSERT INTO #CUMMULATIVE_VACCINATIONS
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(cast(new_vaccinations as INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as Cummulative_Vaccinations
FROM COVID19..Covid_Deaths cd
JOIN COVID19..Covid_Vaccinations cv
	ON cd.location = cv.location
	and cd.date = cv.date ;

SELECT *, (Cummulative_Vaccinations/Population)*100 
FROM #CUMMULATIVE_VACCINATIONS ;



-- creating View for CUMMULATIVE_VACCINATIONS

CREATE VIEW CUMMULATIVE_VACCINATIONS AS
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(cast(new_vaccinations as INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as Cummulative_Vaccinations
FROM COVID19..Covid_Deaths cd
JOIN COVID19..Covid_Vaccinations cv
	ON cd.location = cv.location
	and cd.date = cv.date
WHERE cd.continent IS NOT NULL ;

SELECT *, (Cummulative_Vaccinations/Population)*100 
FROM CUMMULATIVE_VACCINATIONS ;

