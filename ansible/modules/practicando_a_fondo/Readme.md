# LAB Setup Script

Este script está diseñado para configurar un entorno de laboratorio completo que incluye la instalación y configuración de un servidor IPA, NFS, Samba, y ajustes de red en sistemas basados en RedHat.

## Arquitectura

        +-----------+
        |  Servidor |
        |     A     |
        +-----+-----+
              |
        +-----v-----+
        |           |
        |   Switch  +----------------+
        |           |                |
        +-----^-----+                |
              |                      |
        +-----+-----+                |
        |  Servidor |                |
        |     B     |                |
        +-----+-----+                |
                                     |
        +-----------+                |
        |  Servidor |                |
        |     C     |                |
        +-----+-----+                |
              |                      |
              +----------------------+

## Derechos de Autor

- Copyright (C) 2023 Fidel Dominguez Valero

## Modificaciones Recientes

- **14/01/2023** - Adaptaciones por @eefloresb

## Requisitos

- El script está destinado a ser ejecutado en sistemas RedHat, CentOS o Rocky Linux.
- Se debe tener privilegios de superusuario para ejecutar el script.

## Configuración antes de la ejecución

Antes de ejecutar el script, asegúrate de modificar las siguientes líneas según tu entorno específico:

- **Línea 19:** Dirección IP del servidor.

```bash
IP_ADDR=$(ip a | grep -Ewo "192.168.(20|56).(50|80)")
```

- **Línea 20:** Nombre completo del host.

```bash
HOSTNAME=$(hostname)
```

- **Línea 21:** Nombre corto del host.

```bash
SHORTNAME=$(hostname -s)
```

- **Línea 22:** Dominio del servidor.

```bash
  DOMAIN=labrhel.com
```

- **Línea 23:** Realm para configuraciones de IPA.

```bash
  REALM=LABRHEL.COM
```

- **Línea 24:** Directorio home para usuarios de LDAP.

```bash
  LDAPHOME=/home/ldap
```

- **Línea 42:** Dirección IP de la zona inversa.
- **Línea 106:** Comprobación del archivo `resolv.conf`.
- **Línea 164-166:** Comprobación de la configuración de red.
- **Línea 168:** Verificar la ruta al repositorio local.
- **Línea 174:** Revisar las líneas de configuración del repositorio.

Para ejecutar el script:

1. Abre una terminal como usuario root.
2. Navega al directorio donde está almacenado el script.
3. Ejecuta el script con el siguiente comando:

   ```bash
   ./script_rhel_rhcsa.sh
   ```
