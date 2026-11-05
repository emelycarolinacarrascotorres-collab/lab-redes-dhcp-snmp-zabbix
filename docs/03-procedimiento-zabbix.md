# 📡 Procedimiento: Zabbix, cliente DHCP y monitoreo SNMP

## 1. Requisitos previos

| Requisito | Detalle |
|---|---|
| Sistema | Ubuntu 24.04.3 LTS (`noble`), hostname `emely` |
| Red del servidor | `ens33` como cliente DHCP de R1 |
| Internet | Necesario solo para instalar paquetes. Se logró conectando un nodo **NAT1** de GNS3 a `Fa0/0` de R1 y configurando NAT en R1 |
| Herramientas SNMP | Paquete `snmp` (`snmpget`, `snmpset`, `snmpwalk`) |

## 2. Servidor como cliente DHCP

Script: [`scripts/03_configurar_cliente_dhcp.sh`](../scripts/03_configurar_cliente_dhcp.sh)

Contenido final de `/etc/netplan/50-cloud-init.yaml` (verificado en la captura final):

```yaml
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: true
      dhcp-identifier: mac
```

* `dhcp4: true` convierte la interfaz en cliente DHCP.
* `dhcp-identifier: mac` hace que el cliente se identifique con su MAC. Sin esto, R1 registró al mismo servidor con dos identificadores y le entregó dos IPs (ver troubleshooting).

Verificación: `ip -4 addr show ens33`, `networkctl status ens33` y, en R1, `show ip dhcp binding`.

## 3. Instalación de Zabbix

Scripts: [`01_instalar_zabbix.sh`](../scripts/01_instalar_zabbix.sh) y [`02_configurar_bd_zabbix.sh`](../scripts/02_configurar_bd_zabbix.sh)

| Paso | Qué se hace |
|---|---|
| 1 | Agregar el repositorio oficial de **Zabbix 7.0 LTS** para Ubuntu 24.04 |
| 2 | Instalar servidor, frontend PHP, configuración de Apache, scripts SQL y base de datos |
| 3 | Crear la base `zabbix` y su usuario; importar el esquema |
| 4 | Escribir `DBPassword` en `/etc/zabbix/zabbix_server.conf` |
| 5 | Reiniciar y habilitar `zabbix-server`, `zabbix-agent2` y `apache2` |
| 6 | Completar el asistente web (`http://IP_DEL_SERVIDOR/zabbix`) |

> ⚠️ La contraseña de la base de datos debe ser **idéntica** en el usuario de la BD, en `zabbix_server.conf` y en el asistente web.

## 4. Agregar R1, SW1 y SW2

Menú: **Recopilación de datos → Equipos → Crear equipo**.

| Campo | R1 | SW1 | SW2 |
|---|---|---|---|
| Nombre del equipo | `R1` | `SW1` | `SW2` |
| Plantilla | Cisco IOS by SNMP | Cisco IOS by SNMP | Cisco IOS by SNMP |
| Grupo | Network devices | Network devices | Network devices |
| Interfaz | SNMP · `20.25.6.97` · puerto `161` | SNMP · `20.25.6.98` · puerto `161` | SNMP · `20.25.6.99` · puerto `161` |
| Versión SNMP | SNMPv2 | SNMPv2 | SNMPv2 |
| Comunidad SNMP | `{$SNMP_COMMUNITY}` | `{$SNMP_COMMUNITY}` | `{$SNMP_COMMUNITY}` |

En la pestaña **Macros** de cada equipo: `{$SNMP_COMMUNITY}` = comunidad SNMP de solo lectura del laboratorio.

> ℹ️ Plantilla e IP:puerto de cada equipo están **comprobados** en la captura de la lista de equipos. La versión SNMP, el macro y el grupo siguen el procedimiento aplicado, pero **no se capturó el formulario**; ver [05-pendientes-y-limitaciones.md](05-pendientes-y-limitaciones.md).

## 5. Verificación de datos SNMP

1. **Recopilación de datos → Equipos**: el indicador **SNMP** de R1, SW1 y SW2 debe estar en verde.
2. **Monitorización → Últimos datos**: filtrar por **Equipos** (R1, SW1 o SW2). Para ver solo los datos básicos del sistema, escribir `System` en **Nombre**.
3. Comparar con la terminal usando [`scripts/04_verificar_snmp.sh`](../scripts/04_verificar_snmp.sh).

> 💡 En *Últimos datos*, el campo **Nombre** filtra por el nombre del **elemento** (por ejemplo `System`), no por el del equipo. Para filtrar por equipo se usa el campo **Equipos**.
