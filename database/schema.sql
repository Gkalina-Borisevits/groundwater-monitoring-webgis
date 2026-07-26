-- Groundwater Monitoring WebGIS
-- Initial PostgreSQL/PostGIS database schema
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE aquifers (
    aquifer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    aquifer_name VARCHAR(150) NOT NULL,
    lithology VARCHAR(150),
    aquifer_type VARCHAR(50),
    hydraulic_conductivity_m_s NUMERIC
        CHECK (hydraulic_conductivity_m_s >= 0),
    transmissivity_m2_s NUMERIC
        CHECK (transmissivity_m2_s >= 0),
    storage_coefficient NUMERIC
        CHECK (storage_coefficient >= 0 AND storage_coefficient <= 1),
    thickness_m NUMERIC
        CHECK (thickness_m >= 0),
    depth_top_m NUMERIC
        CHECK (depth_top_m >= 0),
    depth_bottom_m NUMERIC
        CHECK (depth_bottom_m >= 0),
    CONSTRAINT chk_aquifers_depth_interval
        CHECK (
            depth_top_m IS NULL
            OR depth_bottom_m IS NULL
            OR depth_top_m < depth_bottom_m
    )
    
);

CREATE TABLE monitoring_wells (
    well_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    well_name VARCHAR(150) NOT NULL,
    ground_elevation_m NUMERIC,
    measuring_point_elevation_m NUMERIC,
    total_depth_m NUMERIC CHECK (total_depth_m > 0),
    screen_top_depth_m NUMERIC CHECK (screen_top_depth_m >= 0),
    screen_bottom_depth_m NUMERIC CHECK (screen_bottom_depth_m >= 0),
    casing_diameter_mm NUMERIC CHECK (casing_diameter_mm > 0),
    construction_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    aquifer_id INTEGER,
    owner VARCHAR(150),
    operating_organization VARCHAR(150),
    purpose VARCHAR(100),
    geometry GEOMETRY(Point, 4326),

    CONSTRAINT fk_monitoring_wells_aquifer
        FOREIGN KEY (aquifer_id)
        REFERENCES aquifers (aquifer_id),

    CONSTRAINT chk_monitoring_wells_status
        CHECK (status IN ('active', 'inactive')),

    CONSTRAINT chk_monitoring_wells_screen
        CHECK (
            screen_top_depth_m IS NULL
            OR screen_bottom_depth_m IS NULL
            OR screen_top_depth_m < screen_bottom_depth_m
        ),

    CONSTRAINT chk_monitoring_wells_screen_within_depth
        CHECK (
            total_depth_m IS NULL
            OR screen_bottom_depth_m IS NULL
            OR screen_bottom_depth_m <= total_depth_m
        )
);


CREATE TABLE groundwater_level_measurements (
    measurement_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    well_id INTEGER NOT NULL,
    campaign_id INTEGER,
    measurement_datetime TIMESTAMP WITH TIME ZONE NOT NULL,
    depth_to_water_m NUMERIC NOT NULL
        CHECK (depth_to_water_m >= 0),
    water_level_elevation_m NUMERIC,
    measurement_method VARCHAR(100),
    water_temperature_c NUMERIC
        CHECK (water_temperature_c BETWEEN -5 AND 60),
    measured_by VARCHAR(150),
    quality_flag VARCHAR(30),
    notes TEXT,

    CONSTRAINT fk_level_measurements_well
        FOREIGN KEY (well_id)
        REFERENCES monitoring_wells (well_id)
        ON DELETE CASCADE
);