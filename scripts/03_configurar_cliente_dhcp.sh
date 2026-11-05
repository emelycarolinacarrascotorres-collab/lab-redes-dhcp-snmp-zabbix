#!/bin/bash
# =====================================================================
# Deja ens33 como cliente DHCP, identificado por MAC.
#
# Por que dhcp-identifier: mac ?
#   Sin esa opcion, systemd-networkd se identifica con un DUID. El servidor
#   DHCP de R1 puede entonces registrar al mismo equipo mas de una vez y
#   entregarle dos IPs (ver screenshots/09-troubleshooting/06-...).
#
# Uso (desde la CONSOLA de la VM, no por SSH): sudo ./03_configurar_cliente_dhcp.sh [interfaz]
# =====================================================================
set -euo pipefail
[[ $EUID -eq 0 ]] || { echo "Ejecuta con sudo/root"; exit 1; }

IFACE="${1:-ens33}"
NETPLAN="/etc/netplan/50-cloud-init.yaml"

[[ -f "$NETPLAN" ]] && cp "$NETPLAN" "${NETPLAN}.bak.$(date +%s)"

cat > "$NETPLAN" <<YAML
network:
  version: 2
  ethernets:
    ${IFACE}:
      dhcp4: true
      dhcp-identifier: mac
YAML
chmod 600 "$NETPLAN"

# Evita que cloud-init regenere la red y pise este archivo
echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

netplan apply
sleep 5
networkctl reconfigure "$IFACE"   # NO usar 'ip addr flush': networkd no se entera y no vuelve a pedir IP
sleep 8
ip -4 addr show "$IFACE"
networkctl status "$IFACE" --no-pager | sed -n '1,40p'
