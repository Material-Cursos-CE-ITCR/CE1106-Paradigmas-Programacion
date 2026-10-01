# CE1106 - Paradigmas de Programación
## Functional Playlist Workshop

Taller incremental de programación funcional en Racket y Typed Racket.

## Duración

80 minutos, incluyendo explicación, práctica y pausas breves.

## Requisitos

- DrRacket o un compilador en línea con soporte para Racket.
- Conocimientos previos de listas, recursión básica, `lambda`, `map` y `filter`.

## Estructura

```text
workshop/
  01-filtering.rkt
  02-folding.rkt
  03-typed-functions.rkt
  04-parametric-polymorphism.rkt
  05-lazy-streams.rkt
  06-playlist-generator.rkt

solutions/
  01-filtering.rkt
  02-folding.rkt
  03-typed-functions.rkt
  04-parametric-polymorphism.rkt
  05-lazy-streams.rkt
  06-playlist-generator.rkt

quiz/
  quiz.rkt
  solution.rkt
```

Cada archivo de `workshop/` contiene la solución de la etapa anterior y deja una nueva función por implementar. Cada archivo puede ejecutarse de manera independiente.

## Datos

El catálogo se incluye directamente en el código para simular información que ya fue leída desde un archivo externo. No se requiere entrada/salida de archivos durante el taller.

Cada canción contiene:

```text
title
artist
genre
duration      ; segundos
popularity    ; 0 - 100
```

## Secuencia del taller

| Tiempo | Archivo | Concepto principal |
|---:|---|---|
| 0-8 min | Introducción | Modelo funcional y datos inmutables |
| 8-20 min | `01-filtering.rkt` | `filter`, `lambda`, funciones puras |
| 20-30 min | `02-folding.rkt` | `foldl` / reducción |
| 30-34 min | Pausa | Revisión conceptual |
| 34-46 min | `03-typed-functions.rkt` | Typed Racket y firmas |
| 46-57 min | `04-parametric-polymorphism.rkt` | `All (A)` |
| 57-61 min | Pausa | Dudas / revisión |
| 61-71 min | `05-lazy-streams.rkt` | Streams y evaluación perezosa |
| 71-80 min | `06-playlist-generator.rkt` | Integración |

## Ejecución

En DrRacket, abra el archivo correspondiente y presione **Run**.

Desde consola:

```bash
racket workshop/01-filtering.rkt
```

## Restricciones generales

Durante el taller no se utiliza:

- `set!`
- estructuras mutables
- ciclos imperativos

El procesamiento se realiza mediante composición de funciones y transformación de datos.

## Quiz

El quiz parte de la aplicación terminada y agrega una nueva función `recommend-playlists` que debe:

- conservar las condiciones existentes de una playlist válida;
- evitar artistas repetidos;
- exigir una popularidad promedio mínima recibida por parámetro;
- operar directamente sobre un `Streamof Playlist`;
- retornar solo las primeras `N` playlists que cumplen las condiciones.
