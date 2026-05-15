-- Kustutab schema (mis põhimõtteliselt kustutab kõik tabelid)
DROP SCHEMA IF EXISTS etas CASCADE;
-- Loob uue schema
CREATE SCHEMA etas;
-- Taastab vajalikud andmebaasi õigused
GRANT ALL ON SCHEMA etas TO postgres;
GRANT ALL ON SCHEMA etas TO PUBLIC;