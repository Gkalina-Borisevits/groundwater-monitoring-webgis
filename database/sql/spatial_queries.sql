-- Groundwater Monitoring WebGis
-- PostgreSQL Analysis Queries Library
-- Database: PostgreSQL + PostGIS
-- Author: Gkalina Borisevits

-- ===============================================================
-- CONTENTS

-- Query 01 - Display monitoring well coordinates
-- Query 02 - Display SRID
-- Query 03 - Distance between two wells
-- Query 04 - Create 500 m buffer
-- Query 05 - Wells within 3000m

-- ===============================================================
-- Query 01 
-- Display monitoring well coordinates 
-- Purpose: Display the geometry of monitoring wells in WKT format

SELECT 
   well_name,
   ST_AsText(geometry)
FROM monitoring_wells;

-- ===============================================================
-- Query 02 
-- Display Spatial Reference System
-- Purpose: Check the SRID of monitoring well geometries

SELECT
   well_name,
   ST_SRID(geometry)
FROM monitoring_wells; 

-- ===============================================================
-- Query 03 
-- Distance between MW - 01 and MW - 02
-- Purpose: Calculate the distance between two monitoring wells

SELECT 
ROUND (
    ST_Distance(
        ST_Transform(a.geometry, 25832),
        ST_Transform(b.geometry, 25832)
    )::numeric,
    2
) AS distance_m
FROM monitoring_wells a,
     monitoring_wells b

WHERE a.well_name = 'MW-01'
AND b.well_name = 'MW-02';  

-- ===============================================================
-- Query 04 
-- Create 500 m buffer
-- Purpose: Create a 500 m buffer around monitoring wells

SELECT 
   well_id,
   well_name,
   ST_Buffer(
      ST_Transform(geometry, 25832),
      500
   ) AS geometry
FROM monitoring_wells;

-- ===============================================================
-- Query 05
-- Active wells distance to MW - 01
-- Purpose: Calculate the distance from active monitoring wells to 
-- the reference well MW - 01

WITH active_wells AS (
   SELECT
      well_id,
      well_name,
      total_depth_m,
      ST_Transform(geometry, 25832) AS geometry
   FROM monitoring_wells
   WHERE status = 'active' 
),
reference_well AS (
    SELECT
       ST_Transform(geometry, 25832) AS geometry
    FROM monitoring_wells
    WHERE well_name = 'MW-01'   
)
SELECT 
   active_wells.well_name,
   active_wells.total_depth_m,
   ROUND(
       ST_Distance(
          active_wells.geometry,
          reference_well.geometry
       ):: numeric,
       2
   ) AS distance_to_mw01_m
FROM active_wells
CROSS JOIN reference_well
ORDER BY distance_to_mw01_m;   

-- ===============================================================

-- ===============================================================