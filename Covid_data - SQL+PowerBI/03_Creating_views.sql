-- In this section I'll be creating MySQL Views mainly from the Basic_queries file, in order to visualize them later in PowerBI.

-- Looking at the vaccination rate and the death rate for each country
SELECT dea.location, max(vac.total_vaccinations)/max(dea.population) as 'Vaccination_rate', 
max(dea.total_deaths)/max(dea.total_cases) as 'Death_rate'
FROM project_portfolio.covid_deaths as dea
JOIN project_portfolio.covid_vaccinations as vac
	ON dea.location = vac.location and dea.date = vac.date
Where dea.continent is not NULL
GROUP BY dea.location
ORDER BY 3 DESC; 

-- Checking what percentage of each country is fully vaccinated, partly vaccinated and also the number of total deaths per million
SELECT dea.location, max(vac.people_fully_vaccinated)/max(dea.population)*100 as 'Fully_Vaccinated',
max(vac.people_vaccinated)/max(dea.population)*100 as 'Partly_Vaccinated',
max(dea.total_deaths_per_million) as 'Total_deaths_per_million'
FROM project_portfolio.covid_deaths as dea
JOIN project_portfolio.covid_vaccinations as vac
	ON dea.location = vac.location and dea.date = vac.date
Where dea.continent is not NULL
GROUP BY dea.location
ORDER BY 4 DESC; 

-- Presenting the number of new vaccinations each day by country, and also and number of total vaccinations for each location
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER(PARTITION by dea.location) as 'total_vaccinations'
FROM project_portfolio.covid_deaths as dea
JOIN project_portfolio.covid_vaccinations as vac
	ON dea.location = vac.location and dea.date = vac.date
Where dea.continent is not NULL
ORDER BY 6 DESC,3; 

-- Checking the date of the beginning of the vaccinations for each country, and their number of total deaths per million
SELECT dea.location, min(dea.date) as date, max(dea.total_deaths_per_million) as 'Total_deaths_per_million'
FROM project_portfolio.covid_deaths as dea
JOIN project_portfolio.covid_vaccinations as vac
	ON dea.location = vac.location and dea.date = vac.date
WHERE vac.new_vaccinations IS NOT NULL and dea.continent is not NULL
GROUP BY dea.location
ORDER BY 2;

-- Checking the date of the beginning of the vaccinations for each country, and their number of total cases per million
SELECT dea.location, min(dea.date) as date, max(dea.total_cases_per_million) as 'Total_cases_per_million'
FROM project_portfolio.covid_deaths as dea
JOIN project_portfolio.covid_vaccinations as vac
	ON dea.location = vac.location and dea.date = vac.date
WHERE vac.new_vaccinations IS NOT NULL and dea.continent is not NULL
GROUP BY dea.location
ORDER BY 2;

-- Number of cases by continent
CREATE VIEW CasesByContinent AS 
SELECT dea.location, max(dea.total_cases) as 'Total_cases', max(dea.total_cases)/max(dea.population) as 'Infection rate' 
FROM project_portfolio.covid_deaths as dea
JOIN project_portfolio.covid_vaccinations as vac
	ON dea.location = vac.location and dea.date = vac.date
Where dea.continent is NULL AND dea.location not like '%income%' and dea.location not like ('International')
and dea.location not like 'World' and dea.location not like 'European Union'
GROUP BY dea.location
ORDER BY 2 DESC;

-- Countries with the 10 largest death rate
CREATE VIEW Top10_countries_deathRate AS 
SELECT dea.location, max(dea.total_deaths)/max(dea.total_cases) as 'Infection rate' 
FROM project_portfolio.covid_deaths as dea
JOIN project_portfolio.covid_vaccinations as vac
	ON dea.location = vac.location and dea.date = vac.date
Where dea.continent is not NULL 
GROUP BY dea.location
ORDER BY 2 DESC
LIMIT 10;
