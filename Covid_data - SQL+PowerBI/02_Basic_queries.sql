-- Covid_Deaths database

-- Basic data check
SELECT location, date, total_cases, new_cases, total_deaths, population
From project_portfolio.covid_deaths
ORDER BY 1,2;

-- Shows the death rate for Covid, and the number of cases and deaths by day in Hungary
SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 AS 'Death_percentage'
From project_portfolio.covid_deaths
Where location like 'Hungary'
ORDER BY 1,2 ;

-- Shows what percentage of population got infected with Covid by day in Hungary
SELECT location, date, total_deaths, total_cases, population, (total_cases/population)*100 AS 'Infected_percentage'
From project_portfolio.covid_deaths
Where location like 'Hungary'
Order BY 1,2;

-- Shows the highest infection count and the population for each country, ordered by the highest infection rate experienced
SELECT location, max(total_cases) as Highest_Infection_Count, population, max((total_cases/population))*100 AS 'Max_Infected_percentage'
From project_portfolio.covid_deaths
GROUP BY Location, Population
ORDER BY 4 DESC, 1,2;

-- Shows the average death rate for each country in decreasing order
SELECT location, AVG((total_deaths/total_cases)*100) AS 'Average_Death_percentage'
From project_portfolio.covid_deaths
GROUP BY location
ORDER BY 2 DESC;

-- Checking what kind of non-country data types are available in the table (e.g. continent, income)
SELECT continent, location
From project_portfolio.covid_deaths
Where continent is NULL
GROUP BY location, continent
ORDER BY 1,2;

-- Shows the highest death count per population for each country in decreasing order, and also the total number of deaths and the population
SELECT location, population, max(total_deaths) AS 'Total_deaths_max', max(total_deaths)/max(Population)*100 as 'Total_deaths_per_pop_Perc'
From project_portfolio.covid_deaths
Where continent is NULL AND location not like '%income%'
GROUP BY location, population
ORDER BY 4 DESC;

-- Shows the continents by their death rate in decreasing order
SELECT location, max(total_deaths)/max(total_cases)*100 as 'Total_death_percentage'
FROM project_portfolio.covid_deaths
Where continent is NULL AND location not like '%income%'
GROUP BY location
ORDER BY 2 DESC; 


-- Covid_vaccinations database

-- Showing the number of total tests, and fully vaccinated people in each country, in order of their above 65 years old population
SELECT cov.location, sum(cov.new_tests) as 'Total_tests', max(cov.people_fully_vaccinated) as 'People_fully_vaccinated', 
max(cov.aged_65_older) as 'Above_65_population' 
FROM project_portfolio.covid_vaccinations as cov
WHERE cov.continent is not NULL
GROUP BY cov.location
ORDER BY 4 DESC;

-- Showing the countries with the largest rate of extreme poverty and their number of tests per population
SELECT cov.location, max(cov.extreme_poverty), max(cov.total_tests)/max(cov.population) as 'tests_per_pop'
FROM project_portfolio.covid_vaccinations as cov
WHERE continent is not NULL
GROUP by cov.location
ORDER BY 2 DESC;

-- Showing the cardiovascular death rate and hospital beds per thousand people in each country, ordered by their life expectancy
SELECT cov.location, max(cov.cardiovasc_death_rate), max(cov.life_expectancy), max(cov.hospital_beds_per_thousand)
FROM project_portfolio.covid_vaccinations as cov
WHERE continent is not NULL
GROUP by cov.location
ORDER BY 2 DESC;


-- Joined Database

-- Joining the two tables
SELECT *
FROM project_portfolio.covid_deaths dea
JOIN project_portfolio.covid_vaccinations vac
ON dea.location = vac.location and dea.date = vac.date;

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

