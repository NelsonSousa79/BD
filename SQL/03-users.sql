USE nextevents;

CREATE ROLE IF NOT EXISTS 'admin_role';
CREATE ROLE IF NOT EXISTS 'gestor_eventos_role';
CREATE ROLE IF NOT EXISTS 'leitor_relatorios_role';

CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER IF NOT EXISTS 'gestor'@'localhost' IDENTIFIED BY 'gestor123';
CREATE USER IF NOT EXISTS 'leitor'@'localhost' IDENTIFIED BY 'leitor123';

GRANT ALL PRIVILEGES ON nextevents.* TO 'admin_role';
GRANT SELECT, INSERT, UPDATE ON nextevents.* TO 'gestor_eventos_role';
GRANT SELECT ON nextevents.* TO 'leitor_relatorios_role';

GRANT 'admin_role' TO 'admin'@'localhost';
GRANT 'gestor_eventos_role' TO 'gestor'@'localhost';
GRANT 'leitor_relatorios_role' TO 'leitor'@'localhost';

SET DEFAULT ROLE 'admin_role' TO 'admin'@'localhost';
SET DEFAULT ROLE 'gestor_eventos_role' TO 'gestor'@'localhost';
SET DEFAULT ROLE 'leitor_relatorios_role' TO 'leitor'@'localhost';