-- Groundwater Monitoring WebGis
-- PostgreSQL Analysis Queries Library
-- Database: PostgreSQL + PostGIS
-- Author: Gkalina Borisevits

-- ===============================================================
-- CONTENTS

-- Query 01 - List all monitoring wells
-- Query 02 - Active monitoring wells
-- Query 03 - Wells deeper than 30 meters
-- Query 04 - Active wells deeper than 30 meters
-- Query 05 - Count monitoring wells
-- Query 06 - Average monitoring well depth
-- Query 07 - Minimum and maximum well depth
-- Query 08 - Count wells by status
-- Query 09 - Active wells using CTE
-- ===============================================================


-- ===============================================================
-- Query 01
-- List all monitoring wells
-- Purpose: Display all monitoring wells with their current status

SELECT 
   well_id,
   well_name,
   status
FROM monitoring wells;

-- ================================================================
-- Query 02
-- Active monitoring wells
-- Purpose: Display only active monitoring wells

SELECT
   well_name,
   status
FROM monitoring_wells
WHERE status = 'active';

-- =================================================================
-- Query 03
-- Wells deeper than 30 meters
-- Purpose: Display monitoring wells with total depth greater than 30 m

SELECT
    well_name,
    total_depth_m
FROM monitoring_wells
WHERE total_depth_m > 30;

-- ==================================================================
-- Query 04
-- Active wells deeper than 30 meters
-- Purpose: Display active monitoring wells deeper than 30 meters

SELECT
   well_name,
   status,
   total_depth_m
FROM monitoring_wells
WHERE status = 'active'
AND total_depth_m > 30;

-- ===================================================================
-- Query 05 
-- Count monitoring wells
-- Purpose: Count the total number of monitoring wells

SELECT
   COUNT(*) AS total_monitoring_wells
FROM monitoring_wells;

-- ====================================================================
-- Query 06
-- Average monitoring well depth
-- Purpose: Calculate the average total depth of monitoring wells

SELECT 
   ROUND (AVG(total_depth_m), 2)
     AS average_depth_m
FROM monitoring_wells;

-- =====================================================================
-- Query 07
-- Minimum and maximum well depth
-- Purpose: Display the minimum and maximum well depth

SELECT 
   MIN(total_depth_m) AS minimum_depth_m,
   MAX(total_depth_m) AS maximum_depth_m
FROM monitoring_wells;

-- ======================================================================
-- Query 08
-- Count wells bei status
-- Purpose: Count monitoring wells for each status

SELECT 
   status,
   COUNT(*) AS number_of_wells
FROM monitoring_wells
GROUP BY status
ORDER BY status DESC;   

-- =======================================================================
-- Query 09
-- Active wells using Common Table Expression (CTE)
-- Purpose: Demonstrate the use of WITH (CTE)

WITH active_wells AS (
    SELECT
       well_name,
       total_depth_m
    FROM monitoring_wells
    WHERE status = 'active'   
)
SELECT 
   well_name,
   total_depth_m
FROM active_wells
WHERE total_depth_m > 30
ORDER BY total_depth_m DESC;   