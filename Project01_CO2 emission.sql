--1.1. Data description:
--This dataset captures the details of how CO2 emissions by a vehicle can vary with the different features. 
--The dataset has been taken from Canada Government official open data website. This is a compiled version. This contains data over a period of 7 years.
--The following list gives some descriptions of our key variables:

-- + "Make": The company of the vehicle
-- + "Model": The model of car - 4WD/4X4 = Four-wheel driveAWD = All-wheel drive, FFV = Flexible-fuel vehicle, SWB = Short wheelbase, LWB = Long wheelbase, EWB = Extended wheelbase
-- + "Vehicle_Class": Class of vehicle depending on their utility, capacity and weight
-- + "Engine Size": The size of engine used in Litre
-- + "Cylinders": The number of cylinders
-- + "Transmission": The transmission type with number of gears - A = automatic, AM = automated manual, AS = automatic with select shift, AV = continuously variable, M = manual, 3 - 10 = Number of gears
-- + "Fuel_Type": The type of Fuel used - X = regular gasoline, Z = premium gasoline, D = diesel, E = ethanol (E85), N = natural gas
-- + "Fuel_Consumption_City_L_100km": The fuel consumption in city roads (L/100 km)
-- + "Fuel_Consumption_Hwy_L_100km": The fuel consumption in highways (L/100 km)
-- + "Fuel_Consumption_comb_L_100km": The combined fuel consumption (55% city, 45% highway) is shown in L/100 km
-- + "Fuel_Consumption_comb_mpg": The combined fuel consumption in both city and highway is shown in mile per gallon(mpg)
-- + "CO2_emission_g_km": The tailpipe emissions of carbon dioxide (in grams per kilometre) for combined city and highway driving

--1.2. Exploratory data analysis
--First, we import the dataset to Oracle. Then we clean the data (check for issues and missing values) and find some key variables for analysis. This will help us to understand and control our data.

--Check missing values
select * from co2_emission;

Select
    sum (case when make is null then 1 else 0 end ) make,
    sum (case when model is null then 1 else 0 end) model,
    sum (case when vehicle_class is null then 1 else 0 end) vehicle_class,
    sum (case when engine_size is null then 1 else 0 end) engine_size,
    sum (case when cylinders is null then 1 else 0 end) cylenders,
    sum (case when transmission is null then 1 else 0 end) transmission,
    sum (case when fuel_type is null then 1 else 0 end) fuel_type,
    sum (case when fuel_consumption_city_l_100km is null then 1 else 0 end) fuel_consumption_city_l_100km,
    sum (case when fuel_consumption_hwy_l_100km is null then 1 else 0 end) fuel_consumption_hwy_l_100km,
    sum (case when fuel_consumption_comb_l_100km is null then 1 else 0 end) fuel_consumption_comb_l_100km,
    sum (case when fuel_consumption_comb_mpg is null then 1 else 0 end) fuel_consumption_comb_mpg,
    sum (case when co2_emissions_g_km is null then 1 else 0 end) co2_emissions_g_km
from co2_emission; ---> there is no NULL value in the dataset

--check the data_type of each column
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    DATA_LENGTH
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME = 'CO2_EMISSION'; --> the data_type is suitable with the data in dataset

--check the misspelling, inconsistent, extra spaces values
select make 
from co2_emission
group by make; --> there is no brand name in "make" column is misspelling

select transmission
from co2_emission
where substr(transmission,1,1) not in ('A','M') and substr(transmission,Length(transmission),1) not in (3,4,5,6,7,8,9,10); --> all the values in "transmission" column are in the correct range

select fuel_type
from co2_emission
where fuel_type not in ('X','Z','D','E','N'); --> all the values in "fuel_type" column are in the correct range

--check some basic statistics in dataset
select 
    count(engine_size),round(avg(engine_size),2), stats_mode(engine_size), min(engine_size), max(engine_size)
from co2_emission;

select 
    count(cylinders),round(avg(cylinders),2), stats_mode(cylinders), min(cylinders), max(cylinders)
from co2_emission;

select 
    count(fuel_consumption_comb_l_100km),round(avg(fuel_consumption_comb_l_100km),2), stats_mode(fuel_consumption_comb_l_100km), min(fuel_consumption_comb_l_100km), max(fuel_consumption_comb_l_100km)
from co2_emission;

select 
    count(co2_emissions_g_km),round(avg(co2_emissions_g_km),2), stats_mode(co2_emissions_g_km), min(co2_emissions_g_km), max(co2_emissions_g_km)
from co2_emission;

--1.3. Main analysis
--1.3.1. "Check the correlation between fuel consumption and the emission of CO2"
select corr(fuel_consumption_comb_l_100km, co2_emissions_g_km)
from co2_emission;
--> The more fuel consumption is, the more CO2 is emitted

--1.3.2. "Determine or test the influence of different variables on the emission of CO2."
select corr( avg_fuel_cst_l_100km, avg_co2_ems_g_km) correlation_fuel_co2 
from (
     select fuel_type, 
     round(avg(fuel_consumption_comb_l_100km),2) as avg_fuel_cst_L_100km,
     round(avg(co2_emissions_g_km),2) as avg_co2_ems_g_km
     from co2_emission
     group by fuel_type);
     
select CORR(engine_size,co2_emissions_g_km) correlation_engine_co2, CORR(cylinders,co2_emissions_g_km) correlation_cylinders_co2
from co2_emission; 
--> the correlation between 3 variables and amount of CO2 emission are >0, it proves that all engine size, fuel type and the number of cylinders affect positively with the amount of CO2 emission

select corr( avg_fuel_cst_l_100km, avg_co2_ems_g_km) correlation_fuel_co2
from (
Select transmission,
    round(avg(fuel_consumption_comb_l_100km),2)avg_fuel_cst_L_100km,
    round(avg(co2_emissions_g_km),2) as avg_co2_ems_g_km
from co2_emission
group by transmission
order by avg_co2_ems_g_km);
-->Although the correlation between average fuel consumption and the average CO2 emission >0, but when looking at the transmission type, it cannot confirm that the Automotive transmission omit less CO2 than Manual transmission or vice versa
-->Because the fuel consumption of the transmission also depends on the road and other factors, so it needs to have more variables to figure out the relationship between transmission type and CO2 emission amount.

--1.3.3. "What are the most influencing features that affect the CO2 emission the most?"

-- check the average amount of CO2 emission and average amount of fuel consumption of small engine size (2.0L and less) and big engine size (more than 2.0L)
select engine_size_type,
    round(avg(fuel_consumption_comb_l_100km),2) avg_fuel_cst,
    round(avg(co2_emissions_g_km),2) avg_co2_ems,
    count(*) 
from(
    select c.*, 
    case   
        when engine_size < 2 or engine_size = 2 then 'small_engine_size'
        else 'big_engine_size'
    end engine_size_type
    from co2_emission c)
group by engine_size_type;

1.3.4. "Check the average amount of CO2 emission and average fuel consumption of each type of fuel" 
select fuel_type, 
    round(avg(co2_emissions_g_km),2) avg_co2_ems,
    round(avg(fuel_consumption_comb_l_100km),2) avg_fuel_cmt
from co2_emission
group by fuel_type
order by avg_co2_ems; 

--1.3.5. "Vehicle_class with the lowest and highest average CO2 emissions?"
select a.*,
    rank () over (order by vehicle_class_number asc) rank_vehicle_class_number,
    rank () over (order by avg_co2_ems asc) rank_co2_ems
from(
    Select vehicle_class, 
        count(*) vehicle_class_number,
        round(avg(co2_emissions_g_km),2) avg_co2_ems
    from co2_emission
    group by vehicle_class) a;

--1.3.6. "Car manufacturer with the lowest and highest average CO2 emissions"
select make, round(avg(co2_emissions_g_km),2) avg_co2_ems
from co2_emission
group by make
order by avg_co2_ems;