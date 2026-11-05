# 🎬 Video demostrativo

> ⚠️ **PENDIENTE:** el video no fue entregado junto a las capturas, por lo que esta carpeta aún no contiene el archivo ni el enlace real.

## Cómo publicarlo

1. Sube el video a **YouTube (no listado)** o arrastra el `.mp4` (menos de 100 MB) a un *issue* o al editor de GitHub para obtener un enlace.
2. En el `README.md` principal, reemplaza `REEMPLAZAR_ID_DEL_VIDEO` por el identificador real del video.
3. Si guardas el archivo en el repositorio, colócalo aquí como `video/demostracion-laboratorio.mp4`.

## Guion sugerido (3 a 5 minutos)

| Minuto | Contenido | Comando o pantalla |
|---|---|---|
| 0:00 | Propósito y topología | Topología de GNS3 |
| 0:30 | Direccionamiento IP | `show ip interface brief` en R1, SW1 y SW2 |
| 1:15 | Servidor DHCP | `show ip dhcp pool` y `show ip dhcp binding` |
| 2:00 | Servidor Zabbix como cliente DHCP | `ip -4 addr show ens33` y `networkctl status ens33` |
| 2:45 | SNMP de solo lectura | `snmpget` correcto y `snmpset` con `noAccess` |
| 3:30 | Zabbix | Lista de equipos con SNMP en verde |
| 4:15 | Datos SNMP | *Monitorización → Últimos datos* de R1, SW1 y SW2 |
