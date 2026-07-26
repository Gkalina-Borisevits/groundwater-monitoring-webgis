-- Groundwater Monitoring WebGIS
-- Initial sample data

INSERT INTO aquifers (
    aquifer_name,
    lithology,
    aquifer_type,
    hydraulic_conductivity_m_s,
    thickness_m,
    depth_top_m,
    depth_bottom_m
)
VALUES
(
    'Rhine Terrace Aquifer',
    'Sand and gravel',
    'unconfined',
    0.001,
    25,
    5,
    30
),
(
    'Lower Sand Aquifer',
    'Fine to medium sand',
    'confined',
    0.0001,
    35,
    40,
    75
);

INSERT INTO monitoring_wells (
    well_name,
    ground_elevation_m,
    measuring_point_elevation_m,
    total_depth_m,
    screen_top_depth_m,
    screen_bottom_depth_m,
    casing_diameter_mm,
    construction_date,
    status,
    aquifer_id,
    owner,
    operating_organization,
    purpose,
    geometry
)
VALUES
(
    'MW-01',
    38.4,
    38.9,
    28,
    18,
    25,
    125,
    '2018-05-12',
    'active',
    1,
    'City of Düsseldorf',
    'Environmental Monitoring Department',
    'groundwater monitoring',
    ST_SetSRID(ST_MakePoint(6.7735, 51.2277), 4326)
),
(
    'MW-02',
    36.8,
    37.2,
    32,
    20,
    29,
    125,
    '2019-08-21',
    'active',
    1,
    'City of Düsseldorf',
    'Environmental Monitoring Department',
    'groundwater monitoring',
    ST_SetSRID(ST_MakePoint(6.8012, 51.2154), 4326)
),
(
    'MW-03',
    41.1,
    41.6,
    68,
    48,
    62,
    150,
    '2016-03-17',
    'active',
    2,
    'Regional Water Authority',
    'Hydrogeology Department',
    'deep aquifer monitoring',
    ST_SetSRID(ST_MakePoint(6.7428, 51.2391), 4326)
);

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
(
    1,
    '2026-07-20 09:00:00+02',
    4.2,
    34.7,
    'electric water level meter',
    11.8,
    'Field Team A',
    'validated',
    'Stable reading'
),
(
    2,
    '2026-07-20 10:15:00+02',
    5.1,
    32.1,
    'electric water level meter',
    12.3,
    'Field Team A',
    'validated',
    'No anomalies observed'
),
(
    3,
    '2026-07-20 11:30:00+02',
    12.6,
    29.0,
    'pressure transducer',
    10.4,
    'Field Team B',
    'provisional',
    'Requires laboratory review'
);