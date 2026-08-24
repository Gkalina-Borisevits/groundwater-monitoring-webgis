# Groundwater Monitoring WebGIS

A WebGIS project for groundwater monitoring, spatial data management and environmental analysis.

The project demonstrates the development of a groundwater monitoring system using PostgreSQL, 
PostGIS, QGIS and modern web technologies. It combines spatial well data, groundwater level 
measurements and SQL-based analysis in a GIS environment.


## Technologies

- PostgreSQL
- PostGIS
- QGIS
- SQL
- Python
- FastAPI
- Leaflet
- JavaScript

## Current Progress

### Sprint 1 — Database Foundation

- PostgreSQL installation and configuration
- PostGIS extension setup
- Initial database schema
- Monitoring wells and aquifer data
- Spatial geometry storage

### Sprint 2  — QGIS Integration

- PostgreSQL/PostGIS connection in QGIS
- Monitoring well visualization
- OpenStreetMap basemap
- Categorized symbology
- Labels and map styling
- Spatial queries and distance analysis

### Sprint 3 — Groundwater Level Monitoring

- Groundwater level measurement table
- Relationship between monitoring wells and measurements
- Measurement history per well
- Latest groundwater level detection
- Measurement statistics
- Average, minimum and maximum values
- Groundwater level change analysis

### Sprint 4 — SQL Analytics

Analytical SQL queries were developed for groundwater monitoring and stored in:

`database/sql/analysis_queries.sql`

The analysis includes:

- Common Table Expressions (CTEs)
- SQL aggregate functions
- window functions
- `ROW_NUMBER()`
- `LAG()`
- groundwater level change calculations
- maximum groundwater level rise
- maximum groundwater level fall
- trend classification with `CASE WHEN`
- spatial distance queries with PostGIS

### Sprint 5 — Groundwater Monitoring Summary

A PostgreSQL/PostGIS view named `groundwater_monitoring_summary` combines monitoring well geometry with calculated groundwater monitoring indicators.

The view provides:

- monitoring well ID and name
- number of measurements
- average groundwater level
- latest groundwater level
- latest measurement date
- maximum groundwater level rise and date
- maximum groundwater level fall and date
- groundwater movement classification
- PostGIS geometry

The view can be loaded directly into QGIS as a spatial layer.

The monitoring wells can be categorized according to their calculated groundwater level movement:

- `rise only`
- `fall only`
- `rise and fall`
- `no change data`

## QGIS Visualization

The analytical PostGIS view is visualized directly in QGIS.

Each monitoring well can display:

- well name
- latest groundwater level
- groundwater movement classification

[Groundwater monitoring summary](screenshots/qgis-groundwater-monitoring-summary.png)

## Project Structure

```text
groundwater-monitoring-webgis/
├── database/
│   └── sql/
│       ├── analysis_queries.sql
│       └── views.sql
├── docs/
│   ├── qgis/
│   │   └── groundwater_monitoring_summary.qml
│   └── screenshots/
│       └── qgis-groundwater-monitoring-summary.png
└── README.md