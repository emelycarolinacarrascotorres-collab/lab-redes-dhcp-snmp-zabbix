#!/bin/bash
# =====================================================================
# Recolecta la evidencia de que el servidor Zabbix es cliente DHCP.
# Uso: ./05_evidencias_cliente_dhcp.sh [interfaz]
# =====================================================================
set -uo pipefail
IFACE="${1:-ens33}"
mkdir -p evidencias
{
  echo "### ip -4 addr show ${IFACE}";           ip -4 addr show "$IFACE"
  echo; echo "### networkctl status ${IFACE}";    networkctl status "$IFACE" --no-pager
  echo; echo "### /etc/netplan/50-cloud-init.yaml"; cat /etc/netplan/50-cloud-init.yaml
  echo; echo "### ip route";                       ip route
} | tee evidencias/cliente-dhcp.txt
