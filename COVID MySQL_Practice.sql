Select *
From PortfolioProject.coviddeatf
order by 3,4

Select *
From PortfolioProject.covidvaccination
order by 3,4


-- Looking at total Cases vs Total Deaths
-- Shows likelihood of dying
Select Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage 
From PortfolioProject.coviddeatf
Where location like '%Brazil%'
order by total_cases


-- looking at total Cases vs Population
Select Location, date, total_cases, Population, (total_cases/population)*100 as DeathPercentage 
From PortfolioProject.coviddeatf
Where location like '%states%'
order by total_cases

-- Looking at Countryis with Hiest infection

Select Location, Population, MAX(total_cases) as HihestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfeccted 
From PortfolioProject.coviddeatf
-- Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfeccted desc

-- Showing Countries with Hiest Death Count per Population

-- Let's Break Thinh Down

Select Location, MAX(cast(Total_deaths as SIGNED)) as TotalDeathCount 
From PortfolioProject.coviddeatf
-- Where location like '%states%'
Where continet is not null
Group by Location
order by TotalDeathCount desc

Select location,continent, MAX(cast(Total_deaths as SIGNED)) as TotalDeathCount 
From PortfolioProject.coviddeatf
-- Where location like '%states%'
Where continent != ''
Group by Location, continent
order by TotalDeathCount desc


Select continent, MAX(cast(Total_deaths as SIGNED)) as TotalDeathCount 
From PortfolioProject.coviddeatf
-- Where location like '%states%'
Where continent != ''
Group by continent
order by TotalDeathCount desc


-- Global Numbers
Select SUM(new_cases) as total_deaths, SUM(cast(new_deaths as SIGNED)) as total_deaths,SUM(cast(new_deaths as SIGNED))/SUM(New_Cases)*100 as DeathPercentage 
From PortfolioProject.coviddeatf
-- Where location like '%Brazil%'
Where continent != ''
-- Group by date
order by 1,2

-- Looking total at Total Population vs Vaccination

Select *
From PortfolioProject.coviddeatf dea
Join PortfolioProject.covidvaccination vac
	On dea.location = vac.location
    and dea.date = vac.date
    
    
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as SIGNED)) OVER (Partition by dea.location Order by dea.location, dea.Date) as Total_newVac 
From PortfolioProject.coviddeatf dea
Join PortfolioProject.covidvac vac
	On dea.location = vac.location
    and dea.date = vac.date
Where vac.new_vaccinations != ''
Order by Date


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as SIGNED)) OVER (Partition by dea.location Order by dea.location, dea.Date) as Total_newVac 
From PortfolioProject.coviddeatf dea
Join PortfolioProject.covidvac vac
	On dea.location = vac.location
    and dea.date = vac.date
Where vac.new_vaccinations != ''
Order by Date


-- Use CTE

With PopvsVac(Continent,Location,Date,Population, new_vaccinations, Total_newVac)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as SIGNED)) OVER (Partition by dea.location Order by dea.location, dea.Date) as Total_newVac 
From PortfolioProject.coviddeatf dea
Join PortfolioProject.covidvac vac
	On dea.location = vac.location
    and dea.date = vac.date
Where vac.new_vaccinations != ''
-- Order by Date
)
Select *, (Total_newVac/Population)*100 as Total_vac_Procent
From PopvsVac

-- TEMP Table
Drop Table if exist #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Total_newVac numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as SIGNED)) OVER (Partition by dea.location Order by dea.location, dea.Date) as Total_newVac 
From PortfolioProject.coviddeatf dea
Join PortfolioProject.covidvac vac
	On dea.location = vac.location
    and dea.date = vac.date
Where vac.new_vaccinations != ''
-- Order by Date

Select *, (Total_newVac/Population)*100 as Total_vac_Procent
From #PercentPopulationVaccinated

-- creating View to store data for later visualization
use PortfolioProject;
CREATE VIEW PercentPopulation3 AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as SIGNED)) OVER (Partition by dea.location Order by dea.location, dea.Date) as Total_newVac 
From PortfolioProject.coviddeatf dea
Join PortfolioProject.covidvac vac
	On dea.location = vac.location
    and dea.date = vac.date
Where vac.new_vaccinations != ''

Select *
From PercentPopulation3


