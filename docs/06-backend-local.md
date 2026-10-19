# Copia local del Backend — actualización del 19/10/2026

Se localizó la copia que clonó Airton en:

```text
C:\Users\airto\OneDrive\Documents\repositorios\Nueva carpeta\Nueva carpeta\objetos-personales
```

Ruta relativa desde el Frontend: `..\Nueva carpeta\objetos-personales`. Se reutilizó esa copia; no se creó otro clon ni se modificaron sus archivos.

## Comprobado en esta revisión

- Commit local: **d8f9799**, mensaje `config`; árbol de trabajo sin cambios según Git.
- Frente al commit inspeccionado el 18/10 (`ded2115c`), cambian únicamente `WebConfig.java`, `AuthorizationFilter.java` y `application.properties`. El contrato de autenticación permanece igual en esta comparación.
- `WebConfig` ya configura CORS mediante Spring MVC y la propiedad externa `app.cors_origins`, separada por comas. Por defecto permite `http://localhost:5173` y `http://localhost:4173`.
- Los métodos CORS configurados son GET, POST, PUT, DELETE y OPTIONS; cabeceras Authorization, Content-Type, Accept y tracer_id. Se eliminó del filtro la configuración anterior de origen comodín y credenciales.
- El Frontend se ha estado abriendo en `127.0.0.1`. Ese origen es distinto de `localhost`: el ejemplo de configuración del Backend incluye ambos nombres para los dos puertos. Esto está preparado, no aplicado a un ambiente en ejecución.
- El Backend conserva puerto **9090** y sigue leyendo `C:\Makro\conf\makroapp.properties` directamente mediante SingletonProperties.
- Ese archivo no existe en el equipo al revisar. La copia no contiene archivos SQL ni una configuración externa completa. No se encontró MySQL mediante los comandos, servicios y carpetas habituales revisados; esto no descarta una instalación en otra ubicación.
- No se volvió a afirmar un login exitoso ni CORS operativo a partir de esta lectura. La compilación y el arranque registrados anteriormente corresponden al commit anterior.

## Lo que hace falta para ejecutarlo localmente

1. Obtener de Developer 2 el esquema/backup de **desarrollo** y los datos que contienen la cuenta de pruebas real proporcionada.
2. Obtener o completar con él `makroapp.properties`: conexión MySQL, clave JWT y tiempos de expiración. El [archivo de ejemplo](../config/backend/makroapp.properties.example) inventaría las propiedades, pero no reemplaza la configuración real.
3. Instalar o identificar MySQL y cargar el esquema en un ambiente local de desarrollo. No se ha fabricado un esquema a partir de los modelos ni creado una cuenta con contraseña supuesta.
4. En la configuración externa, permitir los orígenes de Frontend que se utilizarán. La nueva propiedad real admite:

```properties
app.cors_origins=http://localhost:5173,http://localhost:4173,http://127.0.0.1:5173,http://127.0.0.1:4173
```

5. Desde la carpeta del Backend, compilar y arrancar después de preparar esas dependencias:

```powershell
.\mvnw.cmd -DskipTests package
java -jar target\system-objetos-perdidos.jar
```

Estos comandos están preparados para esta copia; **todavía no se ejecutaron sobre d8f9799**. La omisión de tests en la compilación debe mantenerse explícita. Una compilación no demuestra conexión con MySQL ni autenticación.

6. Abrir Swagger en la dirección local que compartió el equipo: `http://localhost:9090/swagger-ui/index.html#/`. Ejecutar después la sonda del Frontend y el recorrido de navegador con la cuenta real. Con ambos servicios en este equipo, la dirección de API por defecto del Frontend ya es `http://localhost:9090`.

La clonación da acceso al código para preparar el ambiente propio. La ejecución y la validación completas permanecen bloqueadas por la configuración externa y la BD/datos de pruebas faltantes. Las reglas de negocio y permisos del compañero se conservan.
