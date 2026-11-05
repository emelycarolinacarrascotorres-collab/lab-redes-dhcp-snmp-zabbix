#!/bin/bash
# =====================================================================
# Instala Zabbix 7.0 LTS (servidor + frontend Apache + MySQL/MariaDB)
# Sistema probado: Ubuntu 24.04.3 LTS (noble)
# Uso: sudo ./01_instalar_zabbix.sh
# Requiere acceso a internet (ver docs/04-troubleshooting.md, seccion NAT)
# =====================================================================
set -euo pipefail

[[ $EUID -eq 0 ]] || { echo "Ejecuta con sudo/root"; exit 1; }

UBUNTU_VER="$(lsb_release -rs)"     # 24.04
REPO_DEB="zabbix-release_7.0-1+ubuntu${UBUNTU_VER}_all.deb"
REPO_URL="https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/${REPO_DEB}"

echo "[1/4] Verificando salida a internet y DNS..."
ping -c 2 8.8.8.8 >/dev/null
ping -c 2 repo.zabbix.com >/dev/null

echo "[2/4] Agregando el repositorio oficial de Zabbix 7.0..."
wget -q "$REPO_URL" -O "/tmp/${REPO_DEB}"
dpkg -i "/tmp/${REPO_DEB}"
apt update

echo "[3/4] Instalando paquetes..."
apt install -y mariadb-server \
  zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf \
  zabbix-sql-scripts zabbix-agent2 snmp

echo "[4/4] Listo. Siguiente paso: ./02_configurar_bd_zabbix.sh"
