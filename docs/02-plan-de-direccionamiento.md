# 🧮 Plan de direccionamiento

## Criterio de diseño

El direccionamiento se construyó a partir de la matrícula **2025-0697**:

| Parte de la matrícula | Uso en la dirección |
|---|---|
| `2025` | Primeros dos octetos: **20.25** |
| `06` | Tercer octeto: **6** |
| `97` | Último octeto del router (gateway): **.97** |

Red de la LAN: **`20.25.6.0/24`**.

> Es una decisión de diseño del laboratorio. Al ser un rango público, solo es válido dentro de esta red aislada.

## Direcciones configuradas

| Equipo | Interfaz | Dirección | Asignación | Evidencia |
|---|---|---|---|---|
| R1 | Gi1/0 (LAN) | `20.25.6.97/24` | Estática | `running-configs/R1-running-config.txt` |
| R1 | Fa0/0 (WAN → NAT1) | obtenida por DHCP | Dinámica | Capturada como `192.168.111.211` en `r1-ip-interface-brief.png` |
| SW1 | Vlan1 | `20.25.6.98/24` | Estática | `running-configs/SW1-running-config.txt` |
| SW2 | Vlan1 | `20.25.6.99/24` | Estática | `running-configs/SW2-running-config.txt` |
| Switches | Gateway | `20.25.6.97` | Estática (`ip default-gateway`) | Running-configs |
| Servidor Zabbix | ens33 | del pool DHCP | **Dinámica (cliente DHCP)** | Ver tabla de IPs observadas |

## Servidor DHCP (R1)

| Parámetro | Valor |
|---|---|
| Pool | `LAN-0697` |
| Red | `20.25.6.0/24` |
| Direcciones excluidas | `20.25.6.1` a `20.25.6.99` (99 direcciones) |
| Rango asignable | `20.25.6.100` a `20.25.6.254` *(deducido de la exclusión)* |
| Gateway entregado | `20.25.6.97` |
| DNS entregado | `8.8.8.8` |
| Duración de la concesión | 7 días (`lease 7`) |

## IPs observadas del servidor Zabbix

Al ser cliente DHCP, su dirección cambió a lo largo de las pruebas. Esto es **comportamiento esperado**, y las razones de cada cambio están en [04-troubleshooting.md](04-troubleshooting.md):

| Momento | IP del servidor | Fuente |
|---|---|---|
| Primeras pruebas (04-nov) | `20.25.6.121` y también `20.25.6.100` (dos a la vez) | `09-troubleshooting/06-servidor-ens33-dos-ips.png` |
| 05-nov 03:47 | `20.25.6.100` | Registro de `systemd-networkd` |
| 05-nov 03:51 | `20.25.6.102` | Registro de `systemd-networkd` |
| 05-nov 04:29 (captura final) | **`20.25.6.108`** | `06-zabbix-cliente-dhcp/ens33-networkctl-netplan-final.png` y `r1-binding-conflict-pool-final.png` |

Los equipos monitoreados (`.97`, `.98`, `.99`) tienen IP **estática**, por eso Zabbix no se ve afectado por los cambios de IP del propio servidor.

## Conexiones físicas (GNS3)

Según la captura de GNS3: `NAT1 — R1`, `R1 — SW1`, `SW1 — Servidor Zabbix`, `SW1 — SW2`, `SW2 — Windows 10`.

**Puertos exactos de cada enlace: no documentados** (falta la salida de `show cdp neighbors`). Lo único comprobado: en SW1 están activos `Gi0/0`, `Gi0/1` y `Gi0/2`; en SW2, `Gi0/1` y `Gi0/2`.
