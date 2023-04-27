CREATE TABLE covid_deaths (
  iso_code varchar(20),
  continent varchar(50),
  location varchar(100),
  date date,
  population bigint,
  total_cases int,
  new_cases int,
  new_cases_smoothed decimal(14,3),
  total_deaths int,
  new_deaths int,
  new_deaths_smoothed decimal(14,3),
  total_cases_per_million decimal(14,3),
  new_cases_per_million decimal(14,3),
  new_cases_smoothed_per_million decimal(14,3),
  total_deaths_per_million decimal(14,3),
  new_deaths_per_million decimal(14,3),
  new_deaths_smoothed_per_million decimal(14,3),
  reproduction_rate decimal(14,3),
  icu_patients int,
  icu_patients_per_million decimal(14,3),
  hosp_patients int,
  hosp_patients_per_million decimal(14,3),
  weekly_icu_admissions int,
  weekly_icu_admissions_per_million decimal(14,3),
  weekly_hosp_admissions int,
  weekly_hosp_admissions_per_million decimal(14,3)
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\covid_deaths_real.csv'
INTO TABLE covid_deaths
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS 
(iso_code, continent, location, date, population, total_cases, new_cases, new_cases_smoothed, total_deaths, new_deaths, new_deaths_smoothed, total_cases_per_million, new_cases_per_million, new_cases_smoothed_per_million, total_deaths_per_million, new_deaths_per_million, new_deaths_smoothed_per_million, reproduction_rate, icu_patients, icu_patients_per_million, hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million, weekly_hosp_admissions, weekly_hosp_admissions_per_million);
