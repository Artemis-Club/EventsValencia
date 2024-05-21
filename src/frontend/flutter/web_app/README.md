# web_app - Flutter Subproject

Este subproyecto es la aplicación para las pantallas de las calles (web). A continuación, se detallan las instrucciones para la configuración inicial y el uso de claves de API necesarias.

## Configuración Inicial

### 1. Configuración del Archivo .env

El proyecto utiliza un archivo `.env` para manejar las variables de entorno. Esto incluye la clave de API de Mapbox. Se proporciona un archivo de ejemplo `.env.example` en el repositorio.

#### Pasos para Configurar el Archivo .env

1. Copia el archivo `.env.example` y renómbralo a `.env`.

```bash
cp .env.example .env
```

2. Obten una clave pública de https://www.mapbox.com/

```dotenv
...
MAPBOX_KEY=PUBLIC_KEY
```

3. Obten una clave secreta de https://www.mapbox.com/ con el campo `DOWNLOADS:READ` marcado y ponlo en este directorio `~/.gradle/gradle.properties`

```txt
SDK_REGISTRY_TOKEN=SECRET_KEY
```
