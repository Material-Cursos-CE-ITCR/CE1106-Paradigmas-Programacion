# Taller de Prolog: Block Blast

Taller de **2 horas y 15 minutos**, en parejas, para completar seis predicados que comprueban y generan jugadas en un tablero de 5×5.

## Archivos

- [Guia_Taller_Prolog.md](Guia_Taller_Prolog.md): temas, explicaciones, actividades y consultas de comprobación.
- [block_blast_base.pl](block_blast_base.pl): programa base con seis `TODO` por completar.
- [block_blast_tkinter.py](block_blast_tkinter.py): demostración visual interactiva para mostrar las jugadas.

## Temas

Relaciones vs. funciones; hechos y consultas; cálculo de predicados; dominios, términos compuestos y listas; unificación; backtracking y orden de descripción; corte y `fail`.

## Ejecutar el programa de Prolog

1. Abra [OneCompiler Prolog](https://onecompiler.com/prolog).
2. Pegue el contenido de `block_blast_base.pl` y pulse **Run**.
3. El `main` inicial muestra un tablero y las ocho piezas sin llamar a los ejercicios pendientes. Complete los predicados según la guía. Los `TODO` fallan intencionalmente hasta implementarlos.
4. Modifique el objetivo `main` para ejecutar las consultas. Mantenga una sola directiva `:- initialization(main).` y una sola definición de `main`.

Para probar los ejercicios, sustituya solamente `main :- demo_main.` por `main :- test_student_code.`. Mantenga la directiva `initialization(main)` al inicio del archivo. Las consultas fallidas se muestran como `failure` o `[]`, sin hacer fallar la inicialización.

La impresión utiliza `write/1` seguido de `nl/0`. También se proporciona un auxiliar `writeln/1` para compatibilidad con ejemplos anteriores. `run_query/2` imprime todas las respuestas y `check_goal/2` comprueba éxito o fallo.

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

## Modelo compartido

Ambos programas utilizan coordenadas de 1 a 5 y el mismo catálogo de ocho piezas, sin rotaciones ni reflejos:

`single`, `horizontal2`, `vertical2`, `square2`, `corner3`, `horizontal3`, `t4`, `z4`.

En el tablero vacío existen **136 jugadas** del catálogo completo. La T y la Z tienen 12 posiciones válidas cada una. Se modelan las piezas que caben, sin reproducir el algoritmo comercial de selección de piezas.
