BEGIN;

UPDATE monitoring_wells
SET
    status = 'active',
    purpose = 'groundwater monitoring',
    owner = 'City of Düsseldorf',
    operating_organization = 'Environmental Monitoring Department',
    total_depth_m = 28.0
WHERE well_name = 'MW-01';

UPDATE monitoring_wells
SET
    status = 'maintenance',
    purpose = 'groundwater monitoring',
    owner = 'City of Düsseldorf',
    operating_organization = 'Environmental Monitoring Department',
    total_depth_m = 32.0
WHERE well_name = 'MW-02';

UPDATE monitoring_wells
SET
    status = 'inactive',
    purpose = 'deep aquifer monitoring',
    owner = 'Regional Water Authority',
    operating_organization = 'Hydrogeology Department',
    total_depth_m = 68.0
WHERE well_name = 'MW-03';

COMMIT;