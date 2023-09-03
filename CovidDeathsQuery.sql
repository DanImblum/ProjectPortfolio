Select *
From ProjectPortfolio..CovidDeaths
Order by 3,4


--Select *
--FROM ProjectPortfolio..CovidVaccinations
--order by 3,4

-- Select Data that we are going to be using

Select Location, continent, date, total_cases, new_cases, total_deaths, population
From ProjectPortfolio..CovidDeaths
Order by 1,2

-- Looking at Total Cases vs Total Deaths to indicate what date had highest Total Deaths per Total Cases in the United States.
-- Shows likelihood of death if a person contracts covid over time
Select Location,continent, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From ProjectPortfolio..CovidDeaths
Where location = 'United States'
Order by 5 DESC

-- Looking at Total Cases vs Population
-- Shows what percentage of population contracted covid and sorted by highest PercentPopulationInfected
Select Location,continent,Population,MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as PercentPopulationInfected
From ProjectPortfolio..CovidDeaths
Group by Location, Population --This groups the data by the "Location" and "Population" columns. 
--It means that the query will calculate the maximum infection count and percentage of population infected for each unique combination of "Location" and "Population."
Order by PercentPopulationInfected Desc


-- Showing Countries with Highest Death Count per Population
Select Location,continent,MAX(cast(total_deaths as int)) as TotalDeathCount --This calculates the maximum value of the "total_deaths" column after casting it to an integer
From ProjectPortfolio..CovidDeaths
where continent is not null --This allows only countries to be returned in the results for a proper comparison
Group by Location
Order by TotalDeathCount Desc


-- Breaking the data down by continet
Select location,MAX(cast(total_deaths as int)) as TotalDeathCount 
From ProjectPortfolio..CovidDeaths
where continent is null --The data includes continent in the locations, however continent is null for locations that represent a continent
Group by location
Order by TotalDeathCount Desc

-- Global Numbers showing which date had the highest total percentage of deaths per cases

Select date, SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathsPerCases
From ProjectPortfolio..CovidDeaths
Where continent is not null
Group by date
Order by DeathsPerCases DESC


-- Use CTE
-- Looking at Total Population vs Vaccinations with rolling total for new vaccinations
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location  Order by dea.location, dea.date) as RollingPeopleVaccinated
--Partition sums the values partitioned by "dea.location" and ordered by "dea.location" and "dea.date." 
--The result represents the cumulative number of people vaccinated up to a specific date for each location.
From ProjectPortfolio..coviddeaths dea
Join ProjectPortfolio..covidvaccinations vac
	on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Temp Table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location  Order by dea.location, dea.date) as RollingPeopleVaccinated
From ProjectPortfolio..coviddeaths dea
Join ProjectPortfolio..covidvaccinations vac
	on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null 

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location  Order by dea.location, dea.date) as RollingPeopleVaccinated
From ProjectPortfolio..coviddeaths dea
Join ProjectPortfolio..covidvaccinations vac
	on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null 

Select *
From PercentPopulationVaccinated