BEGIN;

INSERT INTO groundwater_level_measurements (
    well_id,
    measurement_datetime,
    depth_to_water_m,
    water_level_elevation_m,
    measurement_method,
    water_temperature_c,
    measured_by,
    quality_flag,
    notes
)
VALUES
    -- =========================================================
    -- MW-01
    -- Groundwater level gradually rises
    -- Ground elevation: 38.9 m
    -- =========================================================

    (
        1,
        '2026-04-20 09:00:00+02',
        4.45,
        34.45,
        'electric water level meter',
        10.2,
        'Demo Operator',
        'valid',
        'Demo monitoring measurement'
    ),
    (
        1,
        '2026-05-20 09:00:00+02',
        4.38,
        34.52,
        'electric water level meter',
        10.8,
        'Demo Operator',
        'valid',
        'Demo monitoring measurement'
    ),
    (
        1,
        '2026-06-20 09:00:00+02',
        4.30,
        34.60,
        'electric water level meter',
        11.4,
        'Demo Operator',
        'valid',
        'Demo monitoring measurement'
    ),
    (
        1,
        '2026-08-05 09:00:00+02',
        4.15,
        34.75,
        'electric water level meter',
        12.1,
        'Demo Operator',
        'valid',
        'Demo monitoring measurement'
    ),

    -- =========================================================
    -- MW-02
    -- Small seasonal fluctuations
    -- Ground elevation: 37.2 m
    -- =========================================================

    (
        2,
        '2026-04-20 10:15:00+02',
        5.18,
        32.02,
        'electric water level meter',
        10.0,
        'Demo Operator',
        'valid',
        'Demo monitoring measurement'
    ),
    (
        2,
        '2026-05-20 10:15:00+02',
        5.08,
        32.12,
        'electric water level meter',
        10.7,
        'Demo Operator',
        'valid',
        'Demo monitoring measurement'
    ),
    (
        2,
        '2026-06-20 10:15:00+02',
        5.14,
        32.06,
        'electric water level meter',
        11.3,
        'Demo Operator',
        'valid',
        'Demo monitoring measurement'
    ),
    (
        2,
        '2026-08-05 10:15:00+02',
        5.02,
        32.18,
        'electric water level meter',
        12.0,
        'Demo Operator',
        'valid',
        'Demo monitoring measurement'
    ),

    -- =========================================================
    -- MW-03
    -- Relatively stable deep groundwater level
    -- Ground elevation: 41.6 m
    -- =========================================================

    (
        3,
        '2026-04-20 11:30:00+02',
        12.72,
        28.88,
        'electric water level meter',
        9.8,
        'Demo Operator',
        'valid',
        'Demo monitoring measurement'
    ),
    (
        3,
        '2026-05-20 11:30:00+02',
        12.66,
        28.94,
        'electric water level meter',
        10.2,
        'Demo Operator',
        'valid',
        'Demo monitoring measurement'
    ),
    (
        3,
        '2026-06-20 11:30:00+02',
        12.63,
        28.97,
        'electric water level meter',
        10.7,
        'Demo Operator',
        'valid',
        'Demo monitoring measurement'
    ),
    (
        3,
        '2026-08-05 11:30:00+02',
        12.55,
        29.05,
        'electric water level meter',
        11.2,
        'Demo Operator',
        'valid',
        'Demo monitoring measurement'
    );

COMMIT;