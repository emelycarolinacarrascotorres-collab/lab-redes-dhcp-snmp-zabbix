#!/bin/bash
# =====================================================================
# Verifica SNMP v2c desde el servidor Zabbix:
#   - snmpget  (lectura)  -> debe FUNCIONAR
#   - snmpset  (escritura)-> debe FALLAR con noAccess (comunidad solo lectura)
# Uso: ./04_verificar_snmp.sh [comunidad]
# Guarda las salidas en ./evidencias/
# =====================================================================
set -uo pipefail
COMMUNITY="${1:-lectura0697}"     # valor de laboratorio
HOSTS=(20.25.6.97 20.25.6.98 20.25.6.99)
OID_SYSNAME="1.3.6.1.2.1.1.5.0"
OID_UPTIME="1.3.6.1.2.1.1.3.0"
OID_SYSLOC="1.3.6.1.2.1.1.6.0"
mkdir -p evidencias

for h in "${HOSTS[@]}"; do
  echo "=== ${h} : LECTURA (snmpget) ==="
  snmpget -v2c -c "$COMMUNITY" "$h" "$OID_SYSNAME" "$OID_UPTIME" 2>&1 | tee "evidencias/snmpget-${h}.txt"
  echo "=== ${h} : ESCRITURA (snmpset) - se espera noAccess ==="
  snmpset -v2c -c "$COMMUNITY" "$h" "$OID_SYSLOC" s "prueba" 2>&1 | tee "evidencias/snmpset-${h}.txt"
  echo
done
