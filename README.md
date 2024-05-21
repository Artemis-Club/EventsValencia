# EventsValencia

EventsValencia es una aplicación para la gestión y exploración de eventos en la ciudad de Valencia. Este repositorio contiene el código fuente tanto para la aplicación móvil desarrollada con Flutter como para el backend desarrollado con NestJS.

## Instalación

Apuntes sobre frontend:
Tanto mobile_app como web_app para conectarse con nuestro servidor necesitan tener en sus .env especificados los siguientes parametros:
BACKEND_SCHEME=http
BACKEND_HOST=montnoirr.ddns.net
BACKEND_PORT=5500

Para utilizar la aplicación móvil, sigue estos pasos:

1. Clona este repositorio en tu máquina local.
2. Abre una terminal y navega hasta el directorio `src/frontend/flutter/common`.
3. Ejecuta el comando `flutter pub get` para instalar todas las dependencias necesarias.
4. Navega hasta el directorio `src/frontend/flutter/mobile_app`.
5. Ejecuta el comando `flutter pub get` para instalar todas las dependencias necesarias.
6. Configura las variables de entorno necesarias para tu entorno de desarrollo (consulta el archivo `.env.example` para más detalles).
7. Una vez completada la instalación de las dependencias, puedes ejecutar la aplicación en un emulador o dispositivo físico con el comando `flutter run`.

-> Notas: en caso de querer usar un dispositivo movil fisico activa la depuracion USB desde las opciones de desarrollador.

Para utilizar la aplicación web, sigue estos pasos:

1. Clona este repositorio en tu máquina local.
2. Abre una terminal y navega hasta el directorio `src/frontend/flutter/common`.
3. Ejecuta el comando `flutter pub get` para instalar todas las dependencias necesarias.
4. Navega hasta el directorio `src/frontend/flutter/web_app`.
5. Ejecuta el comando `flutter pub get` para instalar todas las dependencias necesarias.
6. Configura las variables de entorno necesarias para tu entorno de desarrollo (consulta el archivo `.env.example` para más detalles).
7. Una vez completada la instalación de las dependencias, puedes ejecutar la aplicación en un emulador o dispositivo físico con el comando `flutter run`.

Para utilizar el backend, sigue estos pasos:

1. (Puedes crear tu propio backend localhost o usar nuestro servidor)
 -> 1.1 (En caso de localhost) Instala postgres y crea tu servidor localhost y una DB `events_valencia` y sigue el resto de pasos.
 -> 1.2 (En caso de nuestro servidor) no necesitas instalar nada pero si configurarlo en el .env del frontend.

(localhost)
2. Abre una terminal y navega hasta el directorio `src/backend/events-valencia-api`.
3. Ejecuta el comando `npm i` para instalar todas las dependencias necesarias.
4. Configura las variables de entorno necesarias para tu entorno de desarrollo (consulta el archivo `.env.example` para más detalles).
5. Ejecuta el servidor utilizando el comando `npm run start:dev`.

## Estructura del Proyecto

El repositorio está estructurado de la siguiente manera:

- `src/frontend/flutter/common`: Contiene el código fuente de la aplicación desarrollada con Flutter, es una libreria comun.
- `src/frontend/flutter/mobile_app`: Contiene el código fuente de la aplicacion movil desarrollado en Flutter.
- `src/frontend/flutter/web_app`: Contiene el código fuente de la aplicacion web desarrollado en Flutter.
- `src/backend/events-valencia-api`: Contiene el código fuente del backend desarrollado con NestJS.

## Contribución

Si deseas contribuir a este proyecto, ¡estaremos encantados de recibir tus aportaciones! Siempre es bienvenida cualquier mejora, corrección de errores o nuevas funcionalidades. Solo asegúrate de seguir nuestras pautas de contribución.

## Licencia

Este proyecto está bajo la licencia [MIT](LICENSE).

---

¡Gracias por tu interés en EventsValencia! Si tienes alguna pregunta o sugerencia, no dudes en ponerte en contacto con nosotros.