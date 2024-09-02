
/*
As we discussed today, please go to https://mft.rrc.texas.gov/link/d4eda8c4-9ff0-43b7-8f19-da0a57f10fd2 to get the shapefiles of pipelines by county.

Please download the shapefiles for 4 counties: Jefferson, Orange, Chambers and Galveston.  You may see the county code here. For example, Jefferson is 245, so you can download the zip file with the number of 245. 
https://www.rrc.texas.gov/about-us/locations/oil-gas-counties-districts/

The following is the topic
Try to import the shapefiles to PgSQL as tables in the database. 
Try to identify how many types of pipelines and how many operation companies in these 4 counties
Try to get the length of each segment of pipeline in the attribute table (now that attribute is 0)
Try to summarize the data: in each county, for each type and under each operation company, what is the total length of the pipelines? 
Also, try to identify the total length of pipelines under each operation company (for each type) located offshore (in the Gulf of Mexico)

*/


--step 1: Import the shapefiles to PgSQL as tables in the database. 

--cd C:\Program Files (x86)\PostgreSQL\9.0\bin

--shp2pgsql -s 4267 D:\CVEN5370_GIS\shp\Fall2022_project\pipeline245\pipe245l public.pipeline_Jefferson | psql -d GIS_example1 -U postgres
--shp2pgsql -s 4267 D:\CVEN5370_GIS\shp\Fall2022_project\pipeline071\pipe071l public.pipeline_Chambers | psql -d GIS_example1 -U postgres
--shp2pgsql -s 4267 D:\CVEN5370_GIS\shp\Fall2022_project\pipeline167\pipe167l public.pipeline_Galveston | psql -d GIS_example1 -U postgres
--shp2pgsql -s 4267 D:\CVEN5370_GIS\shp\Fall2022_project\pipeline361\pipe361l public.pipeline_Orange | psql -d GIS_example1 -U postgres

--step 2: Identify how many types of pipelines and how many operation companies in these 4 counties

--2a. Types of pipelines 
/*
--In Jefferson County
select count (distinct gid) as no,cmdty_desc
from public.pipeline_Jefferson
group by cmdty_desc
order by no
*/

/*
--In Chambers County
select count (distinct gid) as no,cmdty_desc
from public.pipeline_Chambers
group by cmdty_desc
order by no
*/

/*
--In Galveston County
select count (distinct gid) as no,cmdty_desc
from public.pipeline_Galveston
group by cmdty_desc
order by no
*/

/*
--In Orange County
select count (distinct gid) as no,cmdty_desc
from public.pipeline_Orange
group by cmdty_desc
order by no
*/

--2b. Number of Operating Companies
/*
--In Jefferson County
select distinct oper_nm from public.pipeline_Jefferson
*/

/*
--In Chambers County
select distinct oper_nm from public.pipeline_chambers
*/

/*
--In Galveston County 
select distinct oper_nm from public.pipeline_galveston
*/

/*
--In Orange County 
select distinct oper_nm from public.pipeline_orange
*/

--Step 3: Get the length of each segment of pipeline in the attribute table (now that attribute is 0)

--3a. Obtain srid 
--select * from spatial_ref_sys where srtext like '%Texas South Central%' --(srid =2278 for Chambers, Galveston, Jefferson) 
--select * from spatial_ref_sys where srtext like '%Texas Central%'--(srid =2277, Orange) 

--3b: transform the global coordinate system to local coordinate system
--select st_transform(the_geom,2278) from pipeline_Jefferson
--select st_transform(the_geom,2278) from pipeline_Chambers
--select st_transform(the_geom,2278) from pipeline_Galveston
--select st_transform(the_geom,2277) from pipeline_Orange

--3c: determine length of each pipe from the geometry data (divide by 5280 to convert from ft to miles)
--select st_length(st_transform(the_geom,2278))/5280 from pipeline_Jefferson --for each of the pipes in Jefferson county

--select st_length(st_transform(the_geom,2278))/5280 from pipeline_Chambers --for each of the pipes in Chambers county

--select st_length(st_transform(the_geom,2278))/5280 from pipeline_Galveston --for each of the pipes in Galveston county

--select st_length(st_transform(the_geom,2277))/5280 from pipeline_Orange --for each of the pipes in Orange county


--3d: update length for each segment of pipeline in the attribute table
--update pipeline_chambers set length = st_length(st_transform(the_geom,2278))/5280 --to update the length attribute of pipeline_chambers table

--update pipeline_Jefferson set length = st_length(st_transform(the_geom,2278))/5280  --to update the length attribute of pipeline_Jefferson table

--update pipeline_Galveston set length = st_length(st_transform(the_geom,2278))/5280  --to update the length attribute of pipeline_Galveston table

--update pipeline_Orange set length = st_length(st_transform(the_geom,2277))/5280  --to update the length attribute of pipeline_Orange table


--step 4: Summarize the data: in each county, for each type and under each operation company, what is the total length of the pipelines? 
--summary of length of pipe in each county:
--select sum(st_length(st_transform(the_geom,2278))/5280) from pipeline_Jefferson --for sum of pipes in Jefferson county (in miles)
--select sum(st_length(st_transform(the_geom,2278))/5280) from pipeline_Galveston --for sum of pipes in Galveston county (in miles)
--select sum(st_length(st_transform(the_geom,2278))/5280) from pipeline_Chambers --for sum of pipes in Chambers county (in miles)
--select sum(st_length(st_transform(the_geom,2277))/5280) from pipeline_Orange --for sum of pipes in Orange county (in miles)

/*
select distinct oper_nm from pipeline_Jefferson
select distinct cmdty_desc, oper_nm, sum(length) 
from pipeline_Jefferson
group by cmdty_desc, oper_nm
order by sum desc

select distinct oper_nm from pipeline_Chambers
select distinct cmdty_desc, oper_nm, sum(length) 
from pipeline_Chambers
group by cmdty_desc, oper_nm
order by sum

select distinct cmdty_desc, oper_nm, sum(length) 
from pipeline_Galveston
group by cmdty_desc, oper_nm
order by sum

select distinct cmdty_desc, oper_nm, sum(length) 
from pipeline_Orange
group by cmdty_desc, oper_nm
order by sum
*/

--Step 5:Identify the total length of pipelines under each operation company (for each type) located offshore (in the Gulf of Mexico)
--a. Draw polygons in ArcGIS to capture the offshore areas containing pipelines
--b. Create shapefiles for the offshore pipelines polygons using Clip in ArcGIS. Use pipelines as input feature and offshore areas as clip feature.
--c. Transfer the shapefiles to tables in PgSQL using the codes below:

--shp2pgsql -s 4267 D:\CVEN5370_GIS\shp\Fall2022_project\clips\offsh_Chambers public.offsh_Chambers | psql -d GIS_example1 -U postgres
--update offsh_Chambers set length = st_length(st_transform(the_geom,2278))/5280  --to update the length attribute of offsh_Chambers table

--shp2pgsql -s 4267 D:\CVEN5370_GIS\shp\Fall2022_project\clips\offsh_Galveston public.offsh_Galveston | psql -d GIS_example1 -U postgres
--update offsh_Galveston set length = st_length(st_transform(the_geom,2278))/5280  --to update the length attribute of offsh_Galveston table

--shp2pgsql -s 4267 D:\CVEN5370_GIS\shp\Fall2022_project\clips\offsh_Jefferson public.offsh_Jefferson | psql -d GIS_example1 -U postgres
--update offsh_Jefferson set length = st_length(st_transform(the_geom,2278))/5280  --to update the length attribute of offsh_Galveston table

--shp2pgsql -s 4267 D:\CVEN5370_GIS\shp\Fall2022_project\clips\offsh_Orange public.offsh_Orange | psql -d GIS_example1 -U postgres
--update offsh_orange set length = st_length(st_transform(the_geom,2277))/5280  --to update the length attribute of offsh_orange table

--d. Merge all 4 offshore pipeline areas in ArcGIS and create the shapefile. Also transfer the created shapefile from ArcGIS to PgSQL in form of table "all_offsh_pl"
--shp2pgsql -s 4267 D:\CVEN5370_GIS\shp\Fall2022_project\Merge\all_offsh_pl public.all_offsh_pl | psql -d GIS_example1 -U postgres

--e. update the new table in PgSQL with length of the pipes
--update all_offsh_pl set length = st_length(st_transform(the_geom,2277))/5280  --to update the length attribute of offsh_orange table

select distinct oper_nm, cmdty_desc, sum(length) 
from all_offsh_pl
group by oper_nm, cmdty_desc
order by sum