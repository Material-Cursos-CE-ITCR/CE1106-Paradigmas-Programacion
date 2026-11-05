# CE1106 — Paradigmas de Programación
## Actividad de diseño orientado a objetos: infraestructura de software

**Instituto Tecnológico de Costa Rica — Escuela de Ingeniería en Computadores**  
**Modalidad:** trabajo grupal en clase  
**Duración:** 120 minutos  
**Lenguaje de referencia:** C#  
**Participantes:** 14 estudiantes en cuatro grupos (dos de cuatro y dos de tres)

### Propósito
Analizar un problema de infraestructura de software y proponer un diseño orientado a objetos que resuelva las necesidades actuales y facilite cambios futuros.

### Organización
- Cada equipo escoge **un problema** de los diez. No se repiten problemas entre equipos.
- La elección es libre y se confirma con el docente.
- **No se requiere implementar ni ejecutar código.** Los diagramas deben utilizar convenciones de C# para nombres y firmas de métodos.
- La solución debe responder a los requisitos sin incorporar subsistemas innecesarios.

### Entregables por grupo
1. **Análisis breve:** problema de diseño central, requisitos e implicaciones de extensibilidad y mantenimiento.
2. **Diagrama de clases UML:** clases, interfaces, responsabilidades, asociaciones, herencia/realización y operaciones principales con firmas de C#.
3. **Descripción del flujo:** de cuatro a seis pasos que expliquen cómo colaboran los objetos en una operación representativa.
4. **Justificación:** decisión principal de diseño, relación con al menos un principio SOLID y una desventaja de la solución.

**Restricción:** no resolver todos los requisitos mediante una única clase que centralice las decisiones. El diseño es conceptual y no necesita infraestructura real.

### Agenda sugerida
| Etapa | Tiempo |
|---|---:|
| Lectura de indicaciones y elección | 15 min |
| Análisis de requisitos | 20 min |
| Diseño y revisión de UML | 40 min |
| Justificación y preparación | 15 min |
| Presentación: cuatro grupos × cinco minutos | 20 min |
| Retroalimentación | 10 min |

---

## Problema 01 — Agentes para entornos de ejecución
Una plataforma interna administra despliegues en distintos tipos de entornos. En el entorno local se utiliza un agente que ejecuta procesos en la máquina; en otro entorno se utiliza un agente que envía trabajos a un clúster. Ambos agentes permiten iniciar una tarea y consultar su resultado, pero requieren implementaciones distintas.

El procedimiento general de despliegue es común: validar la solicitud, obtener el agente correspondiente, iniciar la tarea y registrar el resultado. El equipo espera incorporar nuevos entornos sin modificar ese procedimiento general ni añadir condiciones en cada una de sus etapas.

**Diseñen** las clases e interfaces necesarias para representar las variantes de la plataforma, sus agentes y el procedimiento común de despliegue. Muestren cómo se incorporaría un tercer entorno.

## Problema 02 — Definiciones de ambientes de prueba
Una herramienta de infraestructura prepara descripciones de ambientes de prueba. Una descripción puede incluir nombre, región, límite de memoria, variables de entorno, puertos y reglas de monitoreo. Algunas opciones son obligatorias; otras aparecen solo en ciertos escenarios. Antes de utilizarse, la descripción debe validarse y quedar lista para su consulta.

Actualmente se entregan todos los valores a una operación con una lista extensa de argumentos, donde abundan valores vacíos o por defecto. Se desea que distintas configuraciones sean fáciles de leer y que la definición final no quede parcialmente configurada.

**Diseñen** una forma de producir descripciones de ambientes para escenarios simples y avanzados, indicando cómo se establecen los valores y cuándo se considera válida una definición.

## Problema 03 — Recepción de métricas externas
Un panel de observabilidad registra métricas mediante el contrato interno `IMetricSink`, que contempla la operación `Record(string metric, double value, DateTime timestamp)`. Una nueva biblioteca de terceros solamente ofrece `PushMeasurement(string key, long unixMilliseconds, string serializedValue)`.

La biblioteca no puede modificarse. Los módulos existentes del panel no deben conocer sus particularidades, y el sistema podría cambiar de proveedor en el futuro. Es necesario conservar el contrato interno de registro y realizar las conversiones de fecha y valor requeridas.

**Diseñen** la integración entre los módulos del panel y la biblioteca externa. Indiquen dónde residirán las conversiones y qué parte del sistema debe conocer el proveedor.

## Problema 04 — Capacidades opcionales de un cliente de almacenamiento
Una aplicación de infraestructura ya dispone de un componente que expone `Put(string key, byte[] data)` y `Get(string key)` para almacenar objetos. Distintos proyectos utilizan el mismo contrato, pero algunos necesitan registrar cada operación, otros medir su duración y otros emplear ambas capacidades.

No se desea multiplicar variantes del cliente de almacenamiento para cada combinación posible. Las capacidades adicionales deben poder habilitarse al configurar la aplicación, sin cambiar el contrato que utilizan sus consumidores.

**Diseñen** las responsabilidades y relaciones necesarias para formar las configuraciones descritas, manteniendo la implementación de almacenamiento existente.

## Problema 05 — Inicio coordinado de un servicio
Para arrancar un servicio de infraestructura se deben cargar la configuración, verificar certificados, configurar el registro de eventos y abrir un canal de comunicación. Cada operación la realiza un componente especializado, y el orden es importante.

Actualmente, cada aplicación consumidora conoce los cuatro componentes y repite la secuencia. Se pretende ofrecer a las aplicaciones una operación de inicio sencilla, manteniendo la posibilidad de probar o utilizar individualmente los componentes especializados.

**Diseñen** una API orientada a objetos para que una aplicación arranque el servicio sin conocer los detalles del proceso interno. Indiquen qué sucede si falla la verificación de certificados.

## Problema 06 — Política de reintentos de solicitudes
Un cliente de infraestructura envía solicitudes a servicios remotos. Algunos servicios deben reintentarse a intervalos fijos; otros necesitan intervalos crecientes; y otros no deben reintentarse ante fallos. La decisión depende de la configuración de cada cliente y puede cambiar entre ambientes.

Actualmente, el cliente contiene un bloque grande de condiciones que determina el intervalo y si debe hacer otro intento. Se incorporarán nuevas políticas, pero el envío de solicitudes y el tratamiento general de resultados deben conservarse.

**Diseñen** las responsabilidades del cliente y de las alternativas de cálculo, incluyendo cómo se seleccionaría la política antes de ejecutar una solicitud.

## Problema 07 — Cambios en la configuración activa
Un servidor mantiene una configuración activa de infraestructura. Cuando ciertos valores cambian, tres módulos distintos necesitan reaccionar: el módulo de conexiones ajusta límites, el registro de eventos actualiza su nivel y el módulo de monitoreo recalcula umbrales.

La configuración no debe depender de las clases concretas de estos módulos. Además, pueden aparecer o desaparecer módulos mientras el servidor está funcionando, y no todos los módulos están interesados en el mismo tipo de cambio.

**Diseñen** cómo se comunican los cambios y cómo se administra la participación de los módulos, evitando llamadas directas desde la configuración a cada implementación concreta.

## Problema 08 — Operaciones administrativas programables
Una consola de administración permite reiniciar un servicio, limpiar archivos temporales y refrescar certificados. Las operaciones pueden iniciarse desde botones, tareas programadas o una cola de ejecución. Algunas deben registrar sus parámetros y poder ejecutarse posteriormente, sin mantener abierta la interfaz que las solicitó.

Actualmente cada origen contiene condiciones específicas para cada tipo de operación. Se planea ampliar el catálogo de tareas y conservar un historial básico de lo solicitado.

**Diseñen** un modelo que represente las operaciones y sus destinatarios, y expliquen cómo una cola podría almacenar y ejecutar una solicitud de reinicio.

## Problema 09 — Ciclo de vida de una tarea de infraestructura
Una tarea de aprovisionamiento pasa por las condiciones **Pendiente, Ejecutándose, Pausada, Finalizada o Fallida**. Las acciones permitidas dependen de su condición actual: por ejemplo, una tarea finalizada no puede reanudarse; una tarea pausada puede reanudarse o cancelarse; una tarea pendiente puede iniciarse.

Actualmente la clase de tarea contiene numerosos bloques condicionales que revisan su condición cada vez que recibe una acción. Se anticipan nuevas condiciones y reglas de transición, y se busca mantener controladas las acciones inválidas.

**Diseñen** cómo distribuir las responsabilidades del ciclo de vida. Incluyan al menos una transición válida y una operación rechazada en su explicación.

## Problema 10 — Administración de recursos jerárquicos
Una herramienta de infraestructura presenta recursos agrupados por organización, proyecto y servicio. Cada grupo puede contener recursos individuales y otros grupos. El operador necesita consultar el costo estimado total, suspender elementos seleccionados y mostrar un resumen estructurado de cualquier nivel de la jerarquía.

Actualmente las pantallas deben preguntar si un elemento es un grupo o un recurso individual y ejecutar recorridos especiales para cada tipo. Se busca simplificar la interacción, sin perder la estructura de agrupación.

**Diseñen** un modelo orientado a objetos para representar la jerarquía y realizar operaciones sobre elementos individuales o agrupaciones. Consideren qué operaciones deben tener restricciones.

---

### Criterios de evaluación (100 puntos)
| Criterio | Puntos |
|---|---:|
| Identificación de requisitos y problema de diseño | 20 |
| Responsabilidades, abstracciones y calidad del UML | 35 |
| Flujo de interacción coherente | 20 |
| Justificación y conexión con SOLID | 20 |
| Claridad de presentación | 5 |

**Nota:** Se valorará que el diseño resuelva el problema, no la cantidad de clases. No se indican soluciones en este documento.
