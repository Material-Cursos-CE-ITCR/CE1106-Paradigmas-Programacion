# Taller de Prolog: Block Blast

Taller de **2 horas y 15 minutos**, en parejas, para completar seis predicados que comprueban y generan jugadas en un tablero de 5×5.

## Archivos

- [Guia_Taller_Prolog.md](Guia_Taller_Prolog.md): temas, explicaciones, actividades y consultas de comprobación.
- [block_blast_base.pl](block_blast_base.pl): programa base con seis `TODO`, un main explícito y pruebas por entregable.
- [block_blast_solucion.pl](block_blast_solucion.pl): solución docente completa con las mismas pruebas.
- [block_blast_tkinter.py](block_blast_tkinter.py): demostración visual interactiva para mostrar las jugadas.

## Temas

Relaciones vs. funciones; hechos y consultas; cálculo de predicados; dominios, términos compuestos y listas; unificación; backtracking y orden de descripción; corte y `fail`.

## Ejecutar el programa de Prolog

1. Abra [OneCompiler Prolog](https://onecompiler.com/prolog).
2. Pegue el contenido de `block_blast_base.pl` y pulse **Run**.
3. El `main` ejecuta los seis grupos de pruebas. Complete los TODO en orden; las pruebas pendientes pueden mostrar FALLO.
4. Para probar un único entregable, reemplace el cuerpo de `main`, por ejemplo: `main :- test_free_cell.`. Conserve una sola definición de `main` y la directiva de inicialización.
5. Para ejecutar la referencia completa, copie `block_blast_solucion.pl` en lugar del archivo base.

Las pruebas muestran `OK`, `FALLO` o `error(...)` y continúan después de un fallo. Algunas pruebas de rechazo pueden mostrar OK aunque el TODO todavía falle siempre. Los ejercicios posteriores dependen de los anteriores.

En `show_moves/1`, revise también las jugadas impresas: el test automático comprueba terminación y una sola solución, pero no captura la salida. El uso del corte y del bucle dirigido por fallo se revisa en el código.

Se conservan `run_query/2`, `check_goal/2` y `writeln/1` para las consultas de la guía. Resultados esperados: **136** jugadas en vacío, **113** con el centro ocupado y **0** en un tablero lleno.

## Ejecutar la demostración visual

Necesita Python 3 con Tkinter. No requiere paquetes de `pip`.

Desde la raíz del repositorio:

```bash
python prolog/block-blast/block_blast_tkinter.py
```

Si su sistema utiliza `python3`, cambie el nombre del comando. Seleccione una pieza y haga clic sobre la celda que será su origen. Puede mostrar posiciones válidas, deshacer acciones, cargar tableros de ejemplo y copiar el tablero como un hecho de Prolog.

Las filas y columnas completas se resaltan. Se eliminan únicamente al pulsar **Eliminar líneas completas**, para facilitar la explicación paso a paso.

Para comprobar la lógica sin abrir una ventana:

```bash
python prolog/block-blast/block_blast_tkinter.py --self-test
```

### Cargar un tablero desde Prolog

Pulse **Cargar tablero de Prolog**, pegue el hecho completo y pulse **Cargar tablero**. Puede usar **Pegar del portapapeles** o pegar directamente en el campo de texto.

```prolog
board(demo_board, [cell(1,1),cell(2,3),cell(5,5)]).
```

Se acepta el mismo formato de **Copiar tablero para Prolog**, con espacios y saltos de línea, un nombre de tablero como `demo_board` y el punto final. Para vaciarlo, use `board(empty, []).`

Las coordenadas deben ser enteros entre 1 y 5 y no pueden repetirse. Una entrada inválida muestra un mensaje y conserva el tablero actual. La carga actualiza las jugadas y las líneas completas; puede revertirse con **Deshacer**.

## Modelo compartido

Ambos programas utilizan coordenadas de 1 a 5 y el mismo catálogo de ocho piezas, sin rotaciones ni reflejos:

`single`, `horizontal2`, `vertical2`, `square2`, `corner3`, `horizontal3`, `t4`, `z4`.

En el tablero vacío existen **136 jugadas** del catálogo completo. La T y la Z tienen 12 posiciones válidas cada una. Se modelan las piezas que caben, sin reproducir el algoritmo comercial de selección de piezas.
