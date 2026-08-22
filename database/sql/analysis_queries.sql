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
-- Query 10 - Latest groundwater level measurement per well
-- Query 11 - Groundwater level statistic per well
-- Query 12 - Groundwater level changes between measurements
-- Query 13 - Groundwater level trend classification
-- Query 14 - Maximum groundwater level rise and fall
-- Query 15 - Groundwater monitoring summary per well

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

-- =======================================================================
-- Query 10
-- Latest groundwater level measurement per well
-- Purpose: Return the most recent groundwater level measurement 
-- for each monitoring well 

WITH ranked_measurements AS (
   SELECT 
      w.well_name,
      m.measurement_datetime,
      m.depth_to_water_m,
      m.water_level_elevation_m,
      ROW_NUMBER() OVER (
         PARTITION BY m.well_id
         ORDER BY m.measurement_datetime DESC  
      ) AS measurement_rank
   FROM groundwater_level_measurements m
   JOIN monitoring_wells w
      ON m.well_id = w.well_id
)
SELECT
   well_name,
   measurement_datetime,
   depth_to_water_m,
   water_level_elevation_m
FROM ranked_measurements
WHERE measurement_rank = 1
ORDER BY well_name;

-- =======================================================================
-- Query 11
-- Groundwater level statistic per monitoring well
-- Purpose: Calculate summary statistics for groundwater level
-- measurements for each monitoring well

SELECT 
   w.well_name,
   COUNT(*) AS measurement_count,
   MIN(m.depth_to_water_m) AS min_depth_m,
   MAX(m.depth_to_water_m) AS max_depth_m,
   ROUND (
      AVG(m.depth_to_water_m),
      2
   ) AS avg_depth_m
FROM groundwater_level_measurements m 
JOIN monitoring_wells w
   ON m.well_id = w.well_id
GROUP BY
   w.well_id,
   w.well_name
ORDER BY
   w.well_name; 

-- =======================================================================
-- Query 12 
-- Groundwater level changes between measurements
-- Purpose: Calculate the change in groundwater elevation between each
-- measurement and the previous measurement for the same well

SELECT
   w.well_name,
   m.measurement_datetime,
   m.water_level_elevation_m,

   LAG (m.water_level_elevation_m) OVER (
      PARTITION BY m.well_id
      ORDER BY m.measurement_datetime
   ) AS previous_water_level_m,

   ROUND (
      (
         m.water_level_elevation_m
         -
         LAG (m.water_level_elevation_m) OVER (
            PARTITION BY m.well_id
            ORDER BY m.measurement_datetime
         )
      ),
      2
   ) AS water_level_change_m

FROM groundwater_level_measurements m 
JOIN monitoring_wells w 
   ON m.well_id = w.well_id
ORDER BY 
   w.well_name,
   m.measurement_datetime;      

-- =======================================================================
-- Query 13
-- Groundwater level trend classification
-- Purpose: Classify groundwater level movement for each measurement as:
-- rising, falling, stable, no previous measurement
-- A threshold of +/- 0.02 meters is used to classify small changes as stable

WITH water_level_changes AS (
   SELECT 
      w.well_name,
      m.measurement_datetime,
      m.water_level_elevation_m,

      ROUND (
         m.water_level_elevation_m
         -
         LAG (m.water_level_elevation_m) OVER (
            PARTITION BY m.well_id
            ORDER BY m.measurement_datetime
         ),
         2
      ) AS water_level_change_m

   FROM groundwater_level_measurements m 
   JOIN monitoring_wells w 
      ON m.well_id = w.well_id   
)

SELECT 
   well_name,
   measurement_datetime,
   water_level_elevation_m,
   water_level_change_m,

   CASE
      WHEN water_level_change_m IS NULL
        THEN 'no previous measurement'

      WHEN water_level_change_m BETWEEN -0.02 AND 0.02
        THEN 'stable'  

      WHEN water_level_change_m > 0.02
        THEN 'rising'

      WHEN water_level_change_m < -0.02
        THEN 'falling'
   
   END AS water_level_trend

   FROM water_level_changes
   ORDER BY 
      well_name,
      measurement_datetime;  

-- =======================================================================
-- Query 14
-- Maximum groundwater level rise and fall
-- Purpose: Identify the largest groundwater level rise and fall for each
-- monitoring well, including the date of each event.
-- Positive changes represent rises.
-- Negative changes represent falls

WITH water_level_changes AS (
    SELECT
        m.well_id,
        m.measurement_datetime,

        m.water_level_elevation_m
        -
        LAG(
            m.water_level_elevation_m
        ) OVER (
            PARTITION BY m.well_id
            ORDER BY m.measurement_datetime
        ) AS water_level_change_m

    FROM groundwater_level_measurements m
),

ranked_rises AS (
    SELECT
        well_id,
        measurement_datetime,
        water_level_change_m,

        ROW_NUMBER() OVER (
            PARTITION BY well_id
            ORDER BY water_level_change_m DESC
        ) AS rise_rank

    FROM water_level_changes

    WHERE water_level_change_m > 0
),

ranked_falls AS (
    SELECT
        well_id,
        measurement_datetime,
        water_level_change_m,

        ROW_NUMBER() OVER (
            PARTITION BY well_id
            ORDER BY water_level_change_m ASC
        ) AS fall_rank

    FROM water_level_changes

    WHERE water_level_change_m < 0
)

SELECT
    w.well_name,

    ROUND(
        rr.water_level_change_m,
        2
    ) AS max_rise_m,

    rr.measurement_datetime AS max_rise_date,

    ROUND(
        rf.water_level_change_m,
        2
    ) AS max_fall_m,

    rf.measurement_datetime AS max_fall_date

FROM monitoring_wells w

LEFT JOIN ranked_rises rr
    ON rr.well_id = w.well_id
    AND rr.rise_rank = 1

LEFT JOIN ranked_falls rf
    ON rf.well_id = w.well_id
    AND rf.fall_rank = 1

ORDER BY
    w.well_name;

-- =======================================================================
-- Query 15
-- Groundwater monitoring summary per well
-- Purpose: Provide a consolidated groundwater monitoring summary for each
-- monitoring well.
--
-- The summary includes:
--
--   * number of measurements
--   * average groundwater level
--   * latest measurement date
--   * latest groundwater level
--   * maximum groundwater level rise
--   * date of maximum rise
--   * maximum groundwater level fall
--   * date of maximum fall
--   * overall movement classification
--
-- Movement classification:
--
--   rise and fall
--   rise only
--   fall only
--   no change data

WITH measurement_stats AS (
    SELECT
        well_id,

        COUNT(
            water_level_elevation_m
        ) AS measurement_count,

        ROUND(
            AVG(water_level_elevation_m),
            2
        ) AS avg_water_level_m

    FROM groundwater_level_measurements

    GROUP BY well_id
),

latest_measurement AS (
    SELECT
        well_id,
        measurement_datetime,
        water_level_elevation_m,

        ROW_NUMBER() OVER (
            PARTITION BY well_id
            ORDER BY measurement_datetime DESC
        ) AS measurement_rank

    FROM groundwater_level_measurements
),

water_level_changes AS (
    SELECT
        well_id,
        measurement_datetime,

        water_level_elevation_m
        -
        LAG(
            water_level_elevation_m
        ) OVER (
            PARTITION BY well_id
            ORDER BY measurement_datetime
        ) AS water_level_change_m

    FROM groundwater_level_measurements
),

ranked_rises AS (
    SELECT
        well_id,
        measurement_datetime,
        water_level_change_m,

        ROW_NUMBER() OVER (
            PARTITION BY well_id
            ORDER BY water_level_change_m DESC
        ) AS rise_rank

    FROM water_level_changes

    WHERE water_level_change_m > 0
),

ranked_falls AS (
    SELECT
        well_id,
        measurement_datetime,
        water_level_change_m,

        ROW_NUMBER() OVER (
            PARTITION BY well_id
            ORDER BY water_level_change_m ASC
        ) AS fall_rank

    FROM water_level_changes

    WHERE water_level_change_m < 0
)

SELECT
    w.well_name,

    ms.measurement_count,

    ms.avg_water_level_m,

    lm.measurement_datetime
        AS latest_measurement_date,

    ROUND(
        lm.water_level_elevation_m,
        2
    ) AS latest_water_level_m,

    ROUND(
        rr.water_level_change_m,
        2
    ) AS max_rise_m,

    rr.measurement_datetime
        AS max_rise_date,

    ROUND(
        rf.water_level_change_m,
        2
    ) AS max_fall_m,

    rf.measurement_datetime
        AS max_fall_date,

    CASE
        WHEN rr.water_level_change_m IS NOT NULL
             AND rf.water_level_change_m IS NOT NULL
            THEN 'rise and fall'

        WHEN rr.water_level_change_m IS NOT NULL
             AND rf.water_level_change_m IS NULL
            THEN 'rise only'

        WHEN rr.water_level_change_m IS NULL
             AND rf.water_level_change_m IS NOT NULL
            THEN 'fall only'

        ELSE 'no change data'
    END AS movement_summary

FROM monitoring_wells w

LEFT JOIN measurement_stats ms
    ON ms.well_id = w.well_id

LEFT JOIN latest_measurement lm
    ON lm.well_id = w.well_id
    AND lm.measurement_rank = 1

LEFT JOIN ranked_rises rr
    ON rr.well_id = w.well_id
    AND rr.rise_rank = 1

LEFT JOIN ranked_falls rf
    ON rf.well_id = w.well_id
    AND rf.fall_rank = 1

ORDER BY
    w.well_name;                     