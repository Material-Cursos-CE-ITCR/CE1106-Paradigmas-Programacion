# Taller: asistente de jugadas para Block Blast

**Instituto Tecnológico de Costa Rica**\
**Ingeniería en Computadores — Paradigmas de Programación**\
**Duración:** 2 horas y 15 minutos. **Modalidad:** parejas. **Lenguaje:** Prolog.\
**Página de trabajo:** https://onecompiler.com/prolog

## Objetivo

Completar un asistente que encuentre cuáles piezas pueden colocarse en un tablero y en qué posiciones, aplicando relaciones, reglas, unificación y control de la búsqueda.

## Temas a evaluar

### 4.1. Relaciones vs. funciones

Una función asocia cada entrada de su dominio con un único resultado. Una relación describe combinaciones de valores que cumplen una condición y puede admitir varias respuestas. En Prolog, `piece(Name,Cells)` permite consultar las celdas de una pieza o buscar qué pieza tiene ciertas celdas. Esto no significa que todo predicado pueda ejecutarse en cualquier dirección: las operaciones aritméticas requieren entradas instanciadas.

### 4.2. Hechos y consultas

Los hechos describen información conocida, como el catálogo de piezas. Una consulta pregunta si una condición puede demostrarse o qué valores la satisfacen. Por ejemplo, `piece(square2,Cells)` busca la representación de una pieza y `piece(Name,Cells)` busca todas las piezas del catálogo.

### 4.3. Cálculo de predicados

Un predicado expresa una propiedad o una relación. Una regla permite demostrar una conclusión a partir de condiciones: `Head :- Condition1, Condition2.`. La coma representa conjunción. En este taller, una pieza cabe cuando existe en el catálogo, sus celdas se trasladan al origen indicado y todas quedan dentro del tablero y libres. Prolog intenta demostrar estas condiciones mediante sus hechos y reglas; una consulta que falla no establece por sí sola falsedad en un mundo abierto.

### 4.4. Dominios, datos compuestos y listas

El dominio indica los valores admitidos: las coordenadas del tablero son enteros de 1 a 5 y los nombres de piezas pertenecen al catálogo. Estos dominios se describen mediante hechos y condiciones, sin declaraciones de tipos obligatorias. `cell(Row,Col)` es un término compuesto. El tablero y cada pieza se representan con listas; el patrón `[Head|Tail]` permite procesarlas recursivamente.

### 4.5. Unificación

La unificación busca hacer coincidir términos y enlaza variables cuando es posible. `cell(R,C) = cell(2,4)` enlaza `R` con 2 y `C` con 4. `cell(X,X) = cell(2,3)` falla porque una misma variable no puede ser simultáneamente 2 y 3. El operador `=` no calcula: `X = 2+3` construye un término, mientras que `X is 2+3` produce el número 5.

### 4.6.1. Backtracking y orden de descripción

Cuando existen alternativas, Prolog puede retroceder para buscar más respuestas. En su ejecución habitual, prueba las cláusulas en el orden escrito y los objetivos de una regla de izquierda a derecha. Cambiar el orden puede alterar la secuencia de respuestas y el trabajo realizado. En este taller debe generar una pieza y un origen antes de validar coordenadas mediante aritmética.

### 4.6.2. Corte y `fail`

El corte `!` descarta las alternativas creadas desde la entrada al predicado actual. Se utilizará para conservar la primera jugada válida. `fail` hace fallar un objetivo y activa el retroceso hacia alternativas disponibles. Se utilizará para imprimir todas las jugadas, con una segunda cláusula que permita terminar con éxito. El corte puede eliminar soluciones válidas si se coloca en un predicado que debería enumerarlas todas.

## Preparación

Abra https://onecompiler.com/prolog, copie el archivo completo `block_blast_base.pl` y pulse **Run**. Conserve `:- initialization(main).` y una sola definición de `main`.

El `main` ejecuta explícitamente los seis grupos de pruebas:

```prolog
main :-
    write('PRUEBAS DEL TALLER BLOCK BLAST'), nl,
    write('Un TODO pendiente puede provocar fallos posteriores.'), nl,
    test_free_cell,
    test_all_free,
    test_fits,
    test_legal_move,
    test_first_move,
    test_show_moves,
    nl, write('FIN DE LAS PRUEBAS'), nl.
```

Para ejecutar un solo entregable, reemplace temporalmente el cuerpo de `main`, por ejemplo: `main :- test_fits.`. También puede comentar las llamadas que desee omitir, conservando el punto final de la cláusula.

Cada prueba imprime `OK`, `FALLO` o `error(...)`. Un fallo o error capturado no impide continuar con las demás pruebas. Los TODO pendientes generan fallos esperados; algunas pruebas de rechazo pueden mostrar OK aunque el predicado todavía falle siempre.

Los ejercicios dependen de los anteriores. Complete y pruebe cada uno en orden. En `show_moves/1`, revise también las jugadas impresas: las pruebas automáticas comprueban la terminación con éxito y una sola solución, pero no capturan el texto. Revise en el código el uso del corte, la recursión y el bucle dirigido por fallo.

No pegue `?-` dentro del archivo. Para consultas adicionales desde `main`, están disponibles `run_query(Template,Goal)`, que imprime todas las respuestas, y `check_goal(Label,Goal)`, que muestra success o failure. Se conserva `writeln/1` como auxiliar de compatibilidad con OneCompiler.

## Reglas del modelo

- El tablero es de 5×5; las coordenadas van de 1 a 5.
- `#` indica una celda ocupada y `.` una libre.
- El tablero es una lista de celdas ocupadas, sin duplicados.
- Las piezas son listas de desplazamientos desde un origen; sus desplazamientos comienzan en 0.
- Las orientaciones del catálogo son fijas, sin rotaciones ni reflejos.
- El catálogo incluye `single`, `horizontal2`, `vertical2`, `square2`, `corner3`, `horizontal3`, `t4` y `z4`.
- `t4` ocupa `[cell(0,0),cell(0,1),cell(0,2),cell(1,1)]`: tres celdas arriba y una debajo del centro.
- `z4` ocupa `[cell(0,0),cell(0,1),cell(1,1),cell(1,2)]`: dos celdas arriba y dos abajo desplazadas a la derecha.
- En el tablero vacío, `t4` y `z4` tienen 12 posiciones válidas cada una.
- Una jugada válida debe estar dentro del tablero y no superponerse con celdas ocupadas.
- El asistente identifica piezas que caben; no reproduce el algoritmo comercial que decide cuáles aparecen.

Se proporcionan el catálogo, los tableros de prueba, la impresión, la traducción de coordenadas, la recopilación de jugadas y la construcción del tablero resultante. Usted completará seis predicados breves.

En las firmas, `+` indica entrada instanciada, `-` salida y `?` entrada o salida. Use coordenadas numéricas conocidas al validar una celda o una colocación. Utilice `legal_move/3` para generar coordenadas.

## Actividades

### 1. Explore los datos y la unificación

Consulte el catálogo y compare una pregunta con nombre conocido con una pregunta que busque todas las piezas. Prediga cuáles de estas unificaciones tienen solución:

```prolog
cell(R,C) = cell(2,4).
cell(X,X) = cell(2,3).
[Head|Tail] = [cell(1,1),cell(1,2)].
```

Utilice `run_query` para imprimir enlaces o `check_goal` para comprobar éxito o fallo. Identifique los términos compuestos, las listas y las variables. Explique a su compañero la diferencia entre una relación y una función.

### 2. Determine si una celda está libre

Complete `free_cell/2` (TODO 1). Use `inside_board/1` y `occupied/2` para exigir que la celda esté dentro del tablero y no esté ocupada.

Puede utilizar `\+ occupied(Board,Cell)` con la celda instanciada. Este operador comprueba que el objetivo no tiene solución.

En el tablero `center`, `cell(3,3)` debe rechazarse, `cell(3,4)` aceptarse y `cell(6,1)` rechazarse.

### 3. Valide una lista de celdas

Complete `all_free/2` (TODO 2) mediante recursión. La lista vacía debe aceptarse; una lista no vacía requiere que su primera celda esté libre y que el resto también lo esté.

Compruebe una lista vacía, dos celdas libres y una lista que incluya una celda ocupada. Explique cómo la regla describe la condición «todas las celdas están libres».

### 4. Compruebe si una pieza cabe

Complete `fits/4` (TODO 3). Obtenga la pieza con `piece/2`, traslade sus desplazamientos con `translate_cells/3` y valide el resultado con `all_free/2`.

El cuarto argumento devuelve las coordenadas absolutas. En el tablero vacío, `square2` cabe en `cell(4,4)` y no cabe en `cell(5,5)`. En el tablero `center`, no cabe en `cell(2,2)`.

### 5. Genere todas las jugadas

Complete `legal_move/3` (TODO 4). Genere una pieza y una posición antes de comprobar si la pieza cabe. No utilice corte.

Pruebe estas llamadas desde `main`:

```prolog
board(empty,B),
run_query(Origin, legal_move(B,horizontal2,Origin)),
run_query(move(Name,Position), legal_move(B,Name,Position)).
```

El dominó horizontal tiene 20 posiciones en el tablero vacío. El catálogo completo tiene 136 jugadas. En un tablero lleno no hay jugadas.

Intercambie temporalmente el orden de generación de pieza y posición. Observe qué cambia en el orden de respuestas. Mantenga la validación después de ambos generadores y restaure el orden original.

### 6. Seleccione la primera jugada

Complete `first_move/2` (TODO 5). Encuentre una jugada válida y coloque el corte después de encontrarla.

Con el catálogo original, la primera respuesta del tablero vacío debe ser `move(single,cell(1,1))`. Compare con todas las respuestas de `legal_move/3` y explique por qué la primera no es necesariamente la mejor. Cambiar el orden del catálogo puede cambiar esta selección.

### 7. Imprima las alternativas con `fail`

Complete `show_moves/1` (TODO 6) con dos cláusulas. La primera debe generar una jugada, imprimirla con `write/1`, agregar un salto de línea con `nl/0` y fallar para buscar la siguiente. La segunda permite terminar con éxito cuando se agotan las alternativas.

Compruebe que el tablero vacío imprime 136 jugadas y que el lleno no imprime jugadas y termina con éxito. Explique qué sucede si elimina la segunda cláusula.

## Comprobación

Ejecute el archivo completo. La solución debe mostrar OK en las 47 pruebas. Los conteos esperados son 136 jugadas en el tablero vacío, 113 con el centro ocupado y 0 en el tablero lleno.

`first_move/2` debe devolver una sola respuesta: `move(single,cell(1,1))` en el tablero vacío y `move(single,cell(1,4))` en `almost`, respetando el catálogo y el generador proporcionados.

Para `show_moves/1`, compruebe visualmente los tres casos: ninguna jugada en el tablero lleno, únicamente `move(single,cell(5,5))` cuando esa es la única celda libre, y 136 jugadas sin repetir en el tablero vacío.

La referencia completa está en [block_blast_solucion.pl](block_blast_solucion.pl), con el mismo main y las mismas pruebas. Para realizar el taller, trabaje en el archivo base.

## Referencias técnicas

- Página de trabajo y ejemplo de inicialización: https://onecompiler.com/prolog
- Control, corte y fallo: https://www.swi-prolog.org/pldoc/man?section=control
- Recopilación de respuestas: https://www.swi-prolog.org/pldoc/man?predicate=findall%2F3
