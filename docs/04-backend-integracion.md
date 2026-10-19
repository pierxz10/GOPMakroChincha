# Inspección del Backend e integración mínima

> Actualización 19/10/2026: se encontró una copia local más reciente, commit d8f9799, que ya implementa CORS configurable. Véase [Backend local](06-backend-local.md). Las observaciones y ejecuciones siguientes documentan el corte anterior ded2115c; no deben interpretarse como ausencia de CORS en la nueva versión.

## Procedencia y alcance de la inspección

[Referencia real de Bitbucket](https://bitbucket.org/technologycenter1/objetos-personales/commits/branch/master). Se verificó acceso Git y se clonó `master` en una carpeta temporal, sin modificar el repositorio del compañero ni incorporarlo a este Frontend. HEAD comprobado y reconfirmado: **ded2115cb0c645f4c64f6ad771759f2e6627db2b**.

Se inspeccionaron README, pom.xml, Maven Wrapper, archivos application*.properties, controllers, DTO de acceso, BaseResponse, GlobalControllerAdvice, filtros, configuración de seguridad/datasource/correo, AuthService, TokenService y repositorios/modelos de usuarios, roles, permisos, refresh token y bitácora. No se encontraron Frontend, migraciones ni archivos SQL en este checkout. No se examinó una base de datos externa.

## Tecnología y requisitos comprobados

- Java objetivo 17, Spring Boot 3.5.13 y Maven Wrapper 3.9.16 según los archivos del proyecto. JDK disponible usado: 21.0.12.1. Compilación `mvnw.cmd -DskipTests package` exitosa; no se ejecutaron los tests del Backend.
- Spring Web/Tomcat, Validation, Data JDBC, MySQL Connector/J, Mail, Lombok, JJWT 0.11.5 y springdoc OpenAPI 2.5.0. Las versiones transitivas se resuelven por Maven; no se dedujo una versión del servidor MySQL.
- Puerto configurado: **9090**, perfil por defecto `dev`. Swagger configurado en `/swagger-ui.html`, JSON esperado por springdoc en `/v3/api-docs`; no se pudo comprobar su disponibilidad HTTP.
- `DataSourceConfig` construye `jdbc:mysql://host:port/database?useSSL=false&serverTimezone=UTC`. No utiliza las variables del Frontend ni la configuración estándar spring.datasource de forma automática.
- `SingletonProperties` carga el archivo indicado dentro de application.properties: **C:\Makro\conf\makroapp.properties**. Lo lee directamente desde el classpath y después desde disco. Un simple argumento `--app.url.integrationproperties=...` no cambia esa lectura en el código actual. No se afirmó que funcionara ese override.
- Existe configuración multipart de 5 MB por archivo y 6 MB por solicitud. No se encontraron endpoints de foto, mapeo de `/fotos` ni uso implementado de `C:\makro\fotos` en este commit. La carpeta viene de las instrucciones del equipo, como diseño posterior.

## Contrato real de autenticación

Las rutas de esta tabla existen **en código**. Ninguna se presenta como funcional en ejecución completa en este ambiente.

| Método y ruta | Entrada real | Resultado/uso |
|---|---|---|
| POST `/api/auth/login` | JSON: `username`, `password` obligatorios; `channelCode` opcional, no usado por AuthService inspeccionado | BaseResponse con AuthResponse. Implementado en el Frontend |
| POST `/api/auth/refresh` | JSON: `username`, `refreshToken` obligatorios | Sesión renovada; rota y revoca el refresh token anterior. Implementado en el servicio Frontend |
| POST `/api/auth/logout` | JSON: `refreshToken` obligatorio | BaseResponse con data null. Revoca refresh; implementado en el cierre mínimo de sesión |
| GET `/api/auth/validate?token=...` | Query: token | Existe en código; no se consume para evitar poner un token en URL. No hay endpoint `/me` en este commit |
| POST `/api/auth/recuperar` | JSON: `correo` | Respuesta genérica; genera clave temporal y envía correo cuando corresponde. Solo documentado, no conectado en esta entrega |
| PUT `/api/auth/cambiar-clave` | Bearer; JSON: `currentPassword`, `newPassword`, `confirmPassword` | Cambia clave del usuario extraído del JWT. Solo documentado; formulario posterior |

`BaseResponse<T>` contiene `isSuccess`, `isWarning`, `message`, `errorCode` y `data`. En éxito, `isSuccess=true`, `isWarning=false`, `message=OK`, `errorCode=0`. AuthResponse incluye exactamente:

```text
token: string                  refreshToken: string
typeToken: string              expireTimeToken: string
role: string                   names: string
username: string               idUser: number
permisos: string[]             cambiarClave: boolean
```

No se incluye un ejemplo de respuesta fabricado como si proviniera del servidor. Los dobles sintéticos utilizados por las pruebas unitarias están identificados y nunca se importan en la aplicación.

`GlobalControllerAdvice` responde **HTTP 200 con isSuccess=false** ante credenciales inválidas, token expirado y varios errores de aplicación. Validaciones de AuthRequest devuelven 400; errores generales, 500. El cliente comprueba HTTP y sobre JSON; no considera éxito solo un 200. El acceso usa un mensaje genérico para errores de credenciales, sin exponer mensajes internos de servidor.

## Autenticación y permisos comprobados en código

JWT firmado HS512 con clave del archivo externo y expiración configurada en milisegundos. BCrypt con coste 10 valida las contraseñas. El refresh token es un UUID persistido con vencimiento; refresh comprueba usuario, pertenencia y estado activo y rota el token anterior. Logout revoca el refresh token. No se comprobó revocación inmediata de access tokens por logout.

AuthService consulta el usuario por `usuario`, exige activo, registra accesos/fallos y auditoría. La configuración tiene máximo de intentos por defecto 5. Una cuenta de pruebas real debe proporcionarla Developer 2, sin adivinar credenciales ni crear usuarios en una base ajena.

El Backend ya impone política de nueva clave de 8–64 caracteres con mayúscula, minúscula y número, distinta de la actual y confirmada. Es **comportamiento implementado**, no aprobación de María. `CambiarClaveRequest` y `RecuperarRequest` no tienen las anotaciones de obligatorios que sí tiene AuthRequest: sus validaciones y errores ante null requieren revisión por Developer 2 antes de desarrollar esos formularios.

`PermisoInterceptor` actúa sobre métodos/clases con `@RequierePermiso`, valida Bearer, consulta usuario activo y permisos en BD en cada solicitud y rechaza `cambiar_clave=1`. Usuarios requieren `USUARIO_GESTIONAR`; listar roles admite `ROL_GESTIONAR` o `USUARIO_GESTIONAR`; reasignar permisos y catálogo de permisos requieren `ROL_GESTIONAR`. RolService protege los permisos mínimos del código `ADMIN`. Estos son controles técnicos existentes; no prueban qué permisos tiene cada rol en la BD actual.

Otros endpoints encontrados: GET/POST `/api/usuarios`; GET/PUT/DELETE `/api/usuarios/{id}`; PUT `/api/usuarios/{id}/rol`; PUT `/api/usuarios/{id}/activar`; GET `/api/roles`, GET `/api/roles/{id}`, PUT `/api/roles/{id}/permisos`; GET `/api/permisos`. No se consumen en esta entrega. Hay persistencia de auditoría, pero no controller de consulta de bitácora encontrado.

No se encontraron endpoints de objetos, reclamaciones, verificación, entregas, reportes, categorías o lugares. Por ello no se confirmó una implementación de los permisos de devolución/entrega, edición de ENTREGADO o cambios manuales de estado. La matriz almacenada en MySQL no está disponible. Todo ello sigue pendiente de María; los resúmenes del diagrama no autorizan acciones por sí mismos.

## CORS y direcciones

`AuthorizationFilter` agrega `Access-Control-Allow-Origin: *`, `Access-Control-Allow-Credentials: true`, métodos GET/POST/DELETE/PUT/PATCH/HEAD/OPTIONS y cabeceras Content-Type, Accept y Authorization, entre otras. No se encontró una configuración CORS MVC adicional. El filtro deja pasar la cadena y no implementa una respuesta OPTIONS explícita. Swagger se excluye de este filtro.

El cliente usa `credentials: omit`: el contrato usa Bearer, no cookies. Esto evita depender de credenciales de navegador con un origen comodín. **La aceptación del preflight y de CORS en navegador no se pudo verificar**, porque el servicio no arrancó. No se introdujo un proxy para ocultar un fallo de CORS.

Si la prueba real falla por CORS, Developer 2 deberá configurar explícitamente el origen del Frontend y manejo de OPTIONS, permitiendo POST, Content-Type y Authorization, y revisar si la cabecera de credenciales es necesaria. Es un ajuste de infraestructura propuesto, no aplicado ni aprobado como cambio de negocio. El origen de desarrollo es `http://127.0.0.1:5173`; `http://localhost:5173` es otro origen y debe configurarse si se utiliza.

## Ejecución observada y bloqueo

La copia temporal se compiló sin cambios de código. Para intentar arrancar solo se sustituyó la carpeta de logs por una temporal y se limitó la escucha a localhost:

```powershell
.\mvnw.cmd -DskipTests package
java -jar target\system-objetos-perdidos.jar "--app.url.logpath=<carpeta-temporal>" --server.address=127.0.0.1 --server.port=9090
```

El arranque terminó con código 1: `NumberFormatException: Cannot parse null string`, constructor de `JwtTokenComponent`, línea 22. Faltaba `seguridad.token.expiration_time` porque el archivo externo no existe en el entorno. Tomcat se detuvo; no hubo API disponible. [Extracto de ejecución](evidencias/backend-arranque.txt).

No había escucha comprobada en 3306 y no se encontró MySQL en PATH; esto no demuestra que no exista una instalación en otra ruta. Sin esquema, configuración ni credenciales no se intentó fabricar una BD compatible. La [sonda HTTP](evidencias/api-local.json) recibió ECONNREFUSED. El navegador envió la solicitud de login real y mostró error de conexión: [captura](evidencias/login-error-conexion.png).

## Pasos concretos para desbloquear

1. **Developer 2:** facilitar un ambiente de pruebas o el esquema/migraciones y datos mínimos reales de MySQL. Confirmar servidor, puerto, nombre de base y una cuenta de pruebas gestionada por él.
2. **Developer 2:** completar en su ambiente el archivo externo con las claves del [inventario de configuración](../config/backend/makroapp.properties.example). El ejemplo contiene nombres reales de propiedades, valores públicos ilustrativos y secretos vacíos; no es una configuración ejecutable. Los vencimientos del ejemplo son propuestas, no valores observados.
3. **Developer 2:** arrancar el mismo commit en 9090 y comprobar login desde su cliente API. Si debe cambiar la ruta del archivo, modificar su application.properties local y recompilar, o acordar una mejora de configuración; no basta con pasar una variable VITE.
4. **Airton + Developer 2:** copiar .env.example a .env.local con la URL real, iniciar Vite y ejecutar `npm run verify:api`; comprobar preflight desde navegador. Corregir CORS en el Backend solo si la ejecución lo requiere.
5. **Airton:** realizar acceso con cuenta válida proporcionada por Developer 2 y un único caso de credenciales inválidas autorizado, verificar `isSuccess`, UI, renovación, salida y que no se guarda el token. No almacenar contraseñas, JWT ni cuerpos de éxito completos en evidencias.
6. **María/Developer 2:** para una cuenta con `cambiarClave=true`, mantenerla restringida. La pantalla conectada de cambio de clave es posterior; no se desactiva la restricción para mostrar una demostración.
7. **Patricia:** reevaluar prototipos y resultados. Actualizar el registro de pruebas solo con lo observado.

La integración está **implementada contra el contrato leído** y su camino de fallo fue **verificado**. El acceso exitoso, credenciales inválidas reales, renovación y salida remotas permanecen **bloqueados**.
