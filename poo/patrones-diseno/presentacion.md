---
marp: true
theme: default
paginate: true
size: 16:9
---

# POO: Patrones de diseño
CE1106 · Paradigmas de Programación

**120 minutos · 8 patrones · C# en material separado**
---

# Objetivos

- Identificar problemas recurrentes de diseño.
- Interpretar participantes y relaciones UML.
- Relacionar soluciones con SOLID.
- Seleccionar patrones con criterio, sin sobreingeniería.
---

# ¿Qué es un patrón?

Una **solución de diseño reutilizable**, no un algoritmo ni código listo para copiar.

- Nombre e intención.
- Problema y contexto.
- Estructura y consecuencias.

**Pregunta:** ¿Qué diferencia hay entre reutilizar código y reutilizar un diseño?
---

# Clasificación y SOLID

| Creacionales | Estructurales | Comportamiento |
|---|---|---|
| Factory Method, Builder | Adapter, Decorator, Facade | Strategy, Observer, Command |

SOLID aporta criterios para evaluar un diseño; los patrones son posibles formas de estructurarlo.
---

# Factory Method · problema

**Creacional**

La lógica de logística no debería depender directamente de Camion.

**Para debatir:** ¿Qué responsabilidad está mal ubicada y qué cambio futuro resulta difícil?
---

# Factory Method · estructura UML

**Relaciones de participantes (esquema conceptual):**

```text
Creador abstracto → Creadores concretos → ITransporte → Camion/Barco.
```

En una implementación formal, precisar interfaces, composiciones y métodos.

La subclase elige el producto. OCP/DIP.
---

# Factory Method · aplicación

**Idea central:** La subclase elige el producto. OCP/DIP.

**Trade-off:** La jerarquía agrega clases.

**Discusión:** ¿Cuándo sería innecesario utilizar este patrón?

Ejemplo completo: `codigo/Program.cs`.
---

# Builder · problema

**Creacional**

Un reporte configurable tiene demasiados parámetros y combinaciones.

**Para debatir:** ¿Qué responsabilidad está mal ubicada y qué cambio futuro resulta difícil?
---

# Builder · estructura UML

**Relaciones de participantes (esquema conceptual):**

```text
Cliente → ReporteBuilder → Reporte (Director opcional).
```

En una implementación formal, precisar interfaces, composiciones y métodos.

Construcción paso a paso mediante una interfaz fluida.
---

# Builder · aplicación

**Idea central:** Construcción paso a paso mediante una interfaz fluida.

**Trade-off:** Innecesario para objetos simples.

**Discusión:** ¿Cuándo sería innecesario utilizar este patrón?

Ejemplo completo: `codigo/Program.cs`.
---

# Adapter · problema

**Estructural**

Una API de pagos externa tiene una interfaz incompatible.

**Para debatir:** ¿Qué responsabilidad está mal ubicada y qué cambio futuro resulta difícil?
---

# Adapter · estructura UML

**Relaciones de participantes (esquema conceptual):**

```text
Cliente → IProcesadorPago ← AdaptadorPago → PasarelaExterna.
```

En una implementación formal, precisar interfaces, composiciones y métodos.

Traduce la interfaz ajena sin alterar los clientes. DIP.
---

# Adapter · aplicación

**Idea central:** Traduce la interfaz ajena sin alterar los clientes. DIP.

**Trade-off:** Necesita una capa de traducción.

**Discusión:** ¿Cuándo sería innecesario utilizar este patrón?

Ejemplo completo: `codigo/Program.cs`.
---

# Decorator · problema

**Estructural**

Agregar auditoría opcional al notificador genera subclases combinatorias.

**Para debatir:** ¿Qué responsabilidad está mal ubicada y qué cambio futuro resulta difícil?
---

# Decorator · estructura UML

**Relaciones de participantes (esquema conceptual):**

```text
INotificador ← Email y AuditoriaDecorator; Decorator contiene INotificador.
```

En una implementación formal, precisar interfaces, composiciones y métodos.

Extiende comportamiento por composición. OCP.
---

# Decorator · aplicación

**Idea central:** Extiende comportamiento por composición. OCP.

**Trade-off:** El orden de decoradores puede importar.

**Discusión:** ¿Cuándo sería innecesario utilizar este patrón?

Ejemplo completo: `codigo/Program.cs`.
---

# Facade · problema

**Estructural**

Finalizar una compra exige coordinar inventario, pagos y facturas.

**Para debatir:** ¿Qué responsabilidad está mal ubicada y qué cambio futuro resulta difícil?
---

# Facade · estructura UML

**Relaciones de participantes (esquema conceptual):**

```text
Cliente → CompraFacade → Inventario, Pagos y Facturación.
```

En una implementación formal, precisar interfaces, composiciones y métodos.

Unifica el acceso sin eliminar subsistemas.
---

# Facade · aplicación

**Idea central:** Unifica el acceso sin eliminar subsistemas.

**Trade-off:** Evitar la fachada monolítica.

**Discusión:** ¿Cuándo sería innecesario utilizar este patrón?

Ejemplo completo: `codigo/Program.cs`.
---

# Strategy · problema

**Comportamiento**

Los descuentos tienen algoritmos variables y condicionales crecientes.

**Para debatir:** ¿Qué responsabilidad está mal ubicada y qué cambio futuro resulta difícil?
---

# Strategy · estructura UML

**Relaciones de participantes (esquema conceptual):**

```text
Carrito → IDescuentoStrategy ← Regular y Premium.
```

En una implementación formal, precisar interfaces, composiciones y métodos.

Intercambia algoritmos con una abstracción. OCP/DIP.
---

# Strategy · aplicación

**Idea central:** Intercambia algoritmos con una abstracción. OCP/DIP.

**Trade-off:** Hay que configurar la estrategia.

**Discusión:** ¿Cuándo sería innecesario utilizar este patrón?

Ejemplo completo: `codigo/Program.cs`.
---

# Observer · problema

**Comportamiento**

Varios servicios reaccionan a cambios de estado de pedidos.

**Para debatir:** ¿Qué responsabilidad está mal ubicada y qué cambio futuro resulta difícil?
---

# Observer · estructura UML

**Relaciones de participantes (esquema conceptual):**

```text
Pedido (publisher) → IObservador → Auditoria/Notificador.
```

En una implementación formal, precisar interfaces, composiciones y métodos.

Suscripciones a cambios; en C# puede usarse event.
---

# Observer · aplicación

**Idea central:** Suscripciones a cambios; en C# puede usarse event.

**Trade-off:** Administrar suscripciones y errores.

**Discusión:** ¿Cuándo sería innecesario utilizar este patrón?

Ejemplo completo: `codigo/Program.cs`.
---

# Command · problema

**Comportamiento**

Los botones conocen directamente operaciones del editor.

**Para debatir:** ¿Qué responsabilidad está mal ubicada y qué cambio futuro resulta difícil?
---

# Command · estructura UML

**Relaciones de participantes (esquema conceptual):**

```text
Boton → ICommand ← GuardarCommand → Editor.
```

En una implementación formal, precisar interfaces, composiciones y métodos.

Encapsula una solicitud ejecutable.
---

# Command · aplicación

**Idea central:** Encapsula una solicitud ejecutable.

**Trade-off:** Más objetos y clases.

**Discusión:** ¿Cuándo sería innecesario utilizar este patrón?

Ejemplo completo: `codigo/Program.cs`.
---

# Ejercicio 1: identificar el patrón (5 min)

1. Calcular costo de envío con algoritmos alternativos.
2. Integrar un proveedor de pago con otra interfaz.
3. Agregar auditoría opcional a un notificador.

En cada caso: **patrón + intención + justificación**.
---

# Comparación de patrones

| Patrones | Distinción |
|---|---|
| Factory Method / Builder | Elección del producto / construcción por pasos |
| Adapter / Facade | Compatibilizar / simplificar |
| Decorator / Adapter | Añadir comportamiento / traducir interfaz |
| Strategy / Command | Algoritmos / solicitudes ejecutables |
| Observer / Command | Notificación / operación |
---

# Ejercicio 2: sistema de pedidos (8 min)

Diseñar un sistema que:

- Aplique distintas políticas de descuento.
- Notifique cambios en pedidos.
- Integre una pasarela de pagos incompatible.
- Coordine inventario, pagos y facturas.

**Entregable:** identificar cuatro patrones y bosquejar las clases/interfaces principales.
---

# Cierre (2 min)

- Primero identificar el problema; después elegir un patrón.
- Preferir abstracciones justificadas a complejidad innecesaria.
- Patrones y SOLID se complementan.
- Una aplicación puede combinar varios patrones.

Referencia: https://refactoring.guru/es/design-patterns
