# 🎯 Propósito y objetivos

## Propósito

Construir una red LAN pequeña sobre **GNS3 + VMware Workstation** en la que:

1. Un **router Cisco** y dos **switches Cisco** reciben direccionamiento IP propio, derivado de la matrícula **2025-0697**.
2. El **router actúa como servidor DHCP** de la LAN.
3. Los tres equipos de red exponen datos de gestión mediante **SNMP v2c con una comunidad de solo lectura**.
4. Un **servidor Zabbix** (Ubuntu 24.04), configurado como **cliente DHCP**, consulta esos equipos y permite **verificar los datos SNMP** del router y de los switches.

La práctica reproduce, a escala de laboratorio, el flujo básico de monitoreo de infraestructura de red: *direccionar → asignar IPs automáticamente → exponer métricas → recolectarlas y visualizarlas*.

## Objetivos específicos

| # | Objetivo | Cómo se comprueba |
|---|----------|-------------------|
| 1 | Configurar direccionamiento IP en el router y en los switches | `show ip interface brief` en R1, SW1 y SW2; pings entre equipos |
| 2 | Configurar un servidor DHCP en el router para la LAN | `show ip dhcp pool` y `show ip dhcp binding` en R1 |
| 3 | Configurar SNMP con comunidad de solo lectura | `snmpget` funciona y `snmpset` falla con `noAccess` |
| 4 | Configurar el servidor Zabbix como cliente DHCP | `ip -4 addr show ens33`, `networkctl status ens33`, netplan y binding en R1 |
| 5 | Agregar router y switches a Zabbix | Lista de equipos con el indicador SNMP en verde |
| 6 | Verificar en Zabbix los datos SNMP | Pantalla *Últimos datos* de R1, SW1 y SW2 |
| 7 | Documentar el proyecto de forma profesional | Este repositorio |

