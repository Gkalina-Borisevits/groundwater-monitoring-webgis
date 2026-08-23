CREATE OR REPLACE VIEW groundwater_monitoring_summary AS

WITH measurement_stats AS (
    SELECT
        well_id,
        COUNT(*) AS measurement_count,
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
        ROUND(
            water_level_elevation_m
            -
            LAG(water_level_elevation_m) OVER (
                PARTITION BY well_id
                ORDER BY measurement_datetime
            ),
            2
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
    w.well_id,
    w.well_name,
    ms.measurement_count,
    ms.avg_water_level_m,

    lm.measurement_datetime AS latest_measurement_date,
    ROUND(
        lm.water_level_elevation_m,
        2
    ) AS latest_water_level_m,

    rr.water_level_change_m AS max_rise_m,
    rr.measurement_datetime AS max_rise_date,

    rf.water_level_change_m AS max_fall_m,
    rf.measurement_datetime AS max_fall_date,

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
    END AS movement_summary,

    w.geometry

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
    AND rf.fall_rank = 1;