# 📝 Pendientes, limitaciones y decisiones de documentación

Este documento separa **lo comprobado con evidencia** de **lo que falta o no se pudo verificar**. No se inventaron direcciones IP, configuraciones ni resultados.

## ⏳ Pendiente de completar

| Tema | Qué falta | Dónde se nota |
|---|---|---|
| 🎬 Video demostrativo | No se entregó el video ni su enlace | `README.md` y `video/README.md` (marcador `REEMPLAZAR_ID_DEL_VIDEO`) |
| Formulario de alta de equipos en Zabbix | No hay captura de la pantalla *Crear equipo*, ni de la pestaña *Macros* | Sección 10 del README: se documenta el procedimiento y se comprueba el resultado con la lista de equipos |
| Puertos reales de cada enlace | Falta `show cdp neighbors` en R1, SW1 y SW2 | El diagrama no muestra números de puerto entre switches |
| Uptime en Zabbix | Las capturas de *Últimos datos* no incluyen el elemento *Uptime*, por lo que no se puede comparar con el `snmpget` | Se compara solo el nombre del sistema |

## ❓ Observaciones sin confirmar

| Observación | Estado |
|---|---|
| `sysName` de R1 cambió de `R1` a `R1.localdomain` | Causa **no verificada**; el running-config no tiene `ip domain name` |
| Motor de base de datos | El asistente indica *MySQL*. El procedimiento instaló MariaDB, pero **ninguna captura identifica el motor exacto** |
| Equipo `20.25.6.102` / `.105` | Por su MAC (`0c29.a0bf.69`) parece ser la VM Windows 10 del laboratorio, pero no se verificó con `ipconfig` |
| Cliente `20.25.6.126` | Aparece en estado *Selecting* en un binding inicial. No se identificó el equipo |
| SNMP *contact* en los switches | R1 tiene `snmp-server contact`; SW1 y SW2 **no**. Por eso Zabbix muestra *System contact details* vacío en ellos |
| *Operating system* en SW1/SW2 | Sin valor en Zabbix (en SW1 con icono de error). Es un elemento no soportado en IOSv; no afecta a los datos principales |

## 🔒 Capturas no publicadas

Se retiraron del repositorio las capturas que **mostraban contraseñas** (pantallas de terminal con la clave de la base de datos) y las duplicadas o sin valor documental (pantalla de login fallido, filtros de *Últimos datos* mal configurados, consultas a la tabla `users`).

## 🔐 Seguridad

* Comunidad SNMP `lectura0697`: valor de laboratorio presente en los running-configs.
* Los scripts **no contienen** la contraseña de la base de datos; se solicita al ejecutarlos.
* Las running-configs se publican **sin modificar**, tal como se exportaron.

## 🧾 Sobre los scripts

* `scripts/cisco/*.txt` se **reconstruyeron a partir de los running-configs**; no son un registro literal de lo tecleado.
* `scripts/*.sh` recogen los comandos usados durante el laboratorio, organizados y con comprobaciones adicionales. Se verificó su sintaxis con `bash -n`, pero **no se volvieron a ejecutar** sobre un servidor limpio.
