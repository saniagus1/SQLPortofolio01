SELECT *
FROM PortofolioProjects. .CovidDeaths
where continent is not null
order by 3,4

--Select *
--From PortofolioProjects. . CovidVaccinations
--order by 3,4

-- Select Important Data
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortofolioProjects. .CovidDeaths
where continent is not null
order by 1,2


-- Death over Case Percentage
SELECT location, date, total_cases, total_deaths, 
	case 
		when total_deaths is null then null
		else CONCAT(round(total_deaths/total_cases*100,2),'%')
	end as DeathPercentage
FROM PortofolioProjects. .CovidDeaths
Where location = 'Indonesia'
order by 1,2


-- Total Case over Population
SELECT location, date, total_cases, population, 
	case 
		when total_cases is null then null
		else CONCAT(round(total_cases/population*100,4),'%')
	end as TotalCaseOverPopulation
FROM PortofolioProjects. .CovidDeaths
--Where location = 'Indonesia'
order by 1,2


-- Countries with highest infection rate over population
SELECT location, population, max(total_cases) as TotalCase,
	case
		when population is null then null
		when max(total_cases) is null then null
		else concat(max(total_cases/population)*100,'%') 
	end as PercentPopulationInfected
FROM PortofolioProjects. .CovidDeaths
group by location, population
order by max(total_cases/population) desc


-- Country with highest Deathcount over population
SELECT location, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortofolioProjects. .CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc



-- Death by continent
SELECT location, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortofolioProjects. .CovidDeaths
where continent is null
and iso_code not like '%C'
group by location
order by TotalDeathCount desc


--Continent with highest death count
SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortofolioProjects. .CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


--death percentage globally
select date, sum(new_cases) as NewCase, sum(cast(new_deaths as int)) as NewDeath,
		sum(cast(new_deaths as int))/sum(new_cases)*100
from PortofolioProjects. . CovidDeaths
where continent is not null
group by date
order by 1, 2


--Vaccination Table
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.date) as VaccTotal
from PortofolioProjects..CovidDeaths dea
join PortofolioProjects..CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Compare vaccine into population
--by CTE 1:02:00