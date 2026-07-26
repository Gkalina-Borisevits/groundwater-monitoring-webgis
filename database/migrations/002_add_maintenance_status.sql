BEGIN;

ALTER TABLE monitoring_wells
DROP CONSTRAINT chk_monitoring_wells_status;

ALTER TABLE monitoring_wells
ADD CONSTRAINT chk_monitoring_wells_status
CHECK (status IN ('active', 'inactive', 'maintenance'));

COMMIT;