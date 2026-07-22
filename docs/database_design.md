# Database Design

## MVP Entities

## Entity 1

aquifers
  - aquifer_id
  - aquifer_name
  - lithology
  - aquifer_type
  - hydraulic_conductivity_m_s
  - transmissivity_m2_s
  - storage_coefficient
  - thickness_m
  - depth_top_m
  - depth_bottom_m

  ## Entity 2

monitoring_wells
 - well_id
 - well_name
 - ground_elevation_m
 - ground_surface_elevation_m
 - total_depth_m
 - screen_top_depth_m
 - screen_bottom_depth_m
 - casing_diameter_mm
 - construction_date
 - status
 - aquifer_id
 - owner
 - operating_organization
 - purpose
 - geometry


## Entity 3

groundwater_level_measurements
 - measurement_id
 - well_id
 - campaign_id
 - measurement_datetime
 - depth_to_water_m
 - water_level_elevation_m
 - measurement_method
 - water_temperature_c
 - measured_by
 - quality_flag
 - notes

## Entity 4

  monitoring_campaigns
 - campaign_id
 - campaign_name
 - start_date
 - end_date
 - description

## Entity 5

water_quality_samples
 - sample_id
 - well_id
 - campaign_id
 - sample_datetime
 - laboratory
 - sampled_by
 - sample_depth_m
 - quality_flag
 - notes

  ## Entity 6

water_chemistry_results
 - analysis_id
 - sample_id
 - parameter_name
 - result_value
 - result_unit
 - detection_limit
 - analytical_method
 - quality_flag

 ## Entity 7

geological_layers
 - layer_id
 - well_id
 - from_depth_m
 - to_depth_m
 - lithology
 - grain_size
 - color
 - description

   ## Entity 8

   land_use
    - land_use_id
    - land_use_type
    - geometry

    ## Entity 9

    contamination_sources
    - source_id
    - source_name
    - source_type
    - pollutant
    - status
    - geometry




## Relationships

- One aquifer can contain many monitoring wells.
- One monitoring well can have many groundwater level measurements.
- One monitoring well can have many geological layers.
- One monitoring well can have many water quality samples.
- One monitoring campaign can include many level measurements.
- One monitoring campaign can include many water quality samples.
- One water quality sample can have many chemistry results.


aquifers
   1
   |
   └────< monitoring_wells
              |
              ├────< groundwater_level_measurements
              |
              ├────< geological_layers
              |
              └────< water_quality_samples
                            |
                            └────< water_chemistry_results

monitoring_campaigns
       |
       ├────< groundwater_level_measurements
       |
       └────< water_quality_samples


       

     ## Future Scope

      ## Entity 10

      Pumping Test
       - test_id
       - well_id
       - test_date
       - pumping_rate
       - drawdown
       - recovery
       - duration
       - hydraulic_conductivity
       - transmissivity
       - storage_coefficient

     ## Entity 11

     Spring
      - spring_id
      - name
      - discharge
      - water_quality
      - aquifer_id
      - geometry

      ## Entity 12

      Surface Water
       - river_id
       - name
       - type
       - flow
       - geometry

       ## Entity 13

       Meteorological Station and Observation
        - meteorological_stations
        - meteorological_observations
        - rainfall
        - temperature
        - evaporation
        - geometry

        ## Entity 14
        
        Recharge Zone
        - zone_id
        - recharge_rate
        - soil_type
        - geometry

        ## Entity 15

        Groundwater Flow Direction
         - flow_id
         - direction
         - gradient
         - velocity
