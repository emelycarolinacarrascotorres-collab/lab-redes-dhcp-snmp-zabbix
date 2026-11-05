#!/bin/bash
# =====================================================================
# Crea la base de datos de Zabbix, importa el esquema y arranca servicios.
# La contrasena NO esta en este archivo: se pide al ejecutarlo.
# Uso: sudo ./02_configurar_bd_zabbix.sh
#
# IMPORTANTE: la MISMA contrasena debe quedar en tres sitios:
#   1) usuario 'zabbix' de la base de datos        (este script)
#   2) DBPassword en /etc/zabbix/zabbix_server.conf (este script)
#   3) asistente web de Zabbix, paso "Conexion de BD" (manual)
# Si no coinciden, la web abre pero el servidor Zabbix queda detenido
# ("Access denied for user 'zabbix'@'localhost'"). Ver docs/04-troubleshooting.md
# =====================================================================
set -euo pipefail

[[ $EUID -eq 0 ]] || { echo "Ejecuta con sudo/root"; exit 1; }

if [[ -z "${ZBX_DB_PASS:-}" ]]; then
  read -r -s -p "Contrasena para el usuario 'zabbix' de la BD: " ZBX_DB_PASS; echo
fi

mysql -uroot -e "CREATE DATABASE IF NOT EXISTS zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
mysql -uroot -e "CREATE USER IF NOT EXISTS 'zabbix'@'localhost' IDENTIFIED BY '${ZBX_DB_PASS}';"
mysql -uroot -e "ALTER USER 'zabbix'@'localhost' IDENTIFIED BY '${ZBX_DB_PASS}';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost'; FLUSH PRIVILEGES;"
mysql -uroot -e "SET GLOBAL log_bin_trust_function_creators = 1;"

echo "Importando esquema (puede tardar 1-2 minutos)..."
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | \
  MYSQL_PWD="${ZBX_DB_PASS}" mysql --default-character-set=utf8mb4 -uzabbix zabbix

mysql -uroot -e "SET GLOBAL log_bin_trust_function_creators = 0;"

sed -i '/^DBPassword=/d' /etc/zabbix/zabbix_server.conf
echo "DBPassword=${ZBX_DB_PASS}" >> /etc/zabbix/zabbix_server.conf

systemctl restart zabbix-server zabbix-agent2 apache2
systemctl enable  zabbix-server zabbix-agent2 apache2

echo "Verificando..."
sleep 5
systemctl is-active zabbix-server apache2
tail -n 5 /var/log/zabbix/zabbix_server.log
echo "Abre http://IP_DEL_SERVIDOR/zabbix y completa el asistente con la MISMA contrasena."
