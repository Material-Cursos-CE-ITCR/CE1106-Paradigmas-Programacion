% ITCR - Paradigmas de Programacion
% Taller Block Blast: 2 horas y 15 minutos, en parejas.
% Complete los seis TODO. Conserve las firmas.
% Los TODO fallan intencionalmente mientras estan pendientes.
% Coordenadas de 1 a 5. Offsets desde 0. Sin rotaciones.

:- initialization(main).

board_size(5).

piece(single, [cell(0,0)]).
piece(horizontal2, [cell(0,0),cell(0,1)]).
piece(vertical2, [cell(0,0),cell(1,0)]).
piece(square2, [cell(0,0),cell(0,1),cell(1,0),cell(1,1)]).
piece(corner3, [cell(0,0),cell(1,0),cell(1,1)]).
piece(horizontal3, [cell(0,0),cell(0,1),cell(0,2)]).
piece(t4, [cell(0,0),cell(0,1),cell(0,2),cell(1,1)]).
piece(z4, [cell(0,0),cell(0,1),cell(1,1),cell(1,2)]).

board(empty, []).
board(center, [cell(3,3)]).
board(almost, [cell(1,1),cell(1,2),cell(1,3),
               cell(2,5),cell(3,5),cell(4,5),cell(5,5)]).
board(full, Cells) :-
    board_size(N),
    findall(cell(R,C), (between(1,N,R),between(1,N,C)), Cells).

position(cell(R,C)) :-
    board_size(N), between(1,N,R), between(1,N,C).

occupied(Board, Cell) :- memberchk(Cell, Board).

print_board(Board) :-
    board_size(N), print_rows(1,N,Board).
print_rows(R,N,_) :- R > N, !.
print_rows(R,N,Board) :-
    print_columns(R,1,N,Board), nl,
    Next is R+1, print_rows(Next,N,Board).
print_columns(_,C,N,_) :- C > N, !.
print_columns(R,C,N,Board) :-
    (occupied(Board,cell(R,C)) -> write('# ') ; write('. ')),
    Next is C+1, print_columns(R,Next,N,Board).

demo :-
    board(almost,B), print_board(B),
    write('Complete los seis TODO indicados en la guia.'), nl.

inside_board(cell(R,C)) :-
    board_size(N), R >= 1, R =< N, C >= 1, C =< N.

% TODO 1: celda dentro del tablero y desocupada.
free_cell(_Board,_Cell) :- fail.

% TODO 2: recursion; la lista vacia tiene exito.
all_free(_Board,_Cells) :- fail.

translate_cells([],_,[]).
translate_cells([cell(DR,DC)|Rest],cell(R,C),[cell(NR,NC)|Cells]) :-
    NR is R+DR, NC is C+DC,
    translate_cells(Rest,cell(R,C),Cells).

% TODO 3: buscar pieza, traducir y validar sus celdas.
fits(_Board,_Name,_Origin,_Cells) :- fail.

% TODO 4: generar pieza y posicion antes de validar.
legal_move(_Board,_Name,_Origin) :- fail.

all_moves(Board,Moves) :-
    findall(move(Name,Origin),legal_move(Board,Name,Origin),Moves).

% TODO 5: primera jugada move(Name,Origin), usando corte.
first_move(_Board,_Move) :- fail.

% TODO 6: dos clausulas, bucle dirigido por fallo y exito final.
show_moves(_Board) :- fail.

place_piece(Board,Name,Origin,NewBoard) :-
    fits(Board,Name,Origin,Cells), append(Board,Cells,NewBoard).

run_query(Template,Goal) :-
    findall(Template,Goal,Results), write(Results), nl.
check_goal(Label,Goal) :-
    (call(Goal) -> Status=success ; Status=failure),
    format('~w: ~w~n',[Label,Status]).

writeln(Term) :-
    write(Term), nl.


% MAIN: comente una llamada para omitir ese grupo de pruebas.
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

test(Label, Goal) :-
    catch(
        (\+ \+ call(Goal) -> Result = 'OK' ; Result = 'FALLO'),
        Error,
        Result = error(Error)
    ),
    write(Label), write(': '), write(Result), nl.

test_free_cell :-
    nl, write('TODO 1: free_cell/2'), nl,
    test(celda_libre, free_cell([], cell(1,1))),
    test(esquina_valida, free_cell([], cell(5,5))),
    test(celda_ocupada, \+ free_cell([cell(3,3)], cell(3,3))),
    test(otra_celda_libre, free_cell([cell(3,3)], cell(2,2))),
    test(fila_cero, \+ free_cell([], cell(0,1))),
    test(columna_cero, \+ free_cell([], cell(1,0))),
    test(fila_fuera, \+ free_cell([], cell(6,1))),
    test(columna_fuera, \+ free_cell([], cell(1,6))).

test_all_free :-
    nl, write('TODO 2: all_free/2'), nl,
    test(lista_vacia, all_free([], [])),
    test(lista_vacia_en_tablero_lleno,
        (board(full, B), all_free(B, []))),
    test(una_celda, all_free([], [cell(2,2)])),
    test(todas_libres,
        all_free([cell(3,3)], [cell(1,1),cell(2,2),cell(5,5)])),
    test(ocupada_al_inicio,
        \+ all_free([cell(3,3)], [cell(3,3),cell(1,1),cell(2,2)])),
    test(ocupada_en_medio,
        \+ all_free([cell(3,3)], [cell(1,1),cell(3,3),cell(2,2)])),
    test(ocupada_al_final,
        \+ all_free([cell(3,3)], [cell(1,1),cell(2,2),cell(3,3)])),
    test(celda_fuera, \+ all_free([], [cell(1,1),cell(5,6)])).

test_fits :-
    nl, write('TODO 3: fits/4'), nl,
    test(single,
        (fits([], single, cell(5,5), Cells),
         Cells == [cell(5,5)])),
    test(horizontal2,
        (fits([], horizontal2, cell(5,4), Cells),
         Cells == [cell(5,4),cell(5,5)])),
    test(vertical2,
        (fits([], vertical2, cell(4,5), Cells),
         Cells == [cell(4,5),cell(5,5)])),
    test(square2,
        (fits([], square2, cell(2,3), Cells),
         Cells == [cell(2,3),cell(2,4),cell(3,3),cell(3,4)])),
    test(corner3,
        (fits([], corner3, cell(2,3), Cells),
         Cells == [cell(2,3),cell(3,3),cell(3,4)])),
    test(horizontal3,
        (fits([], horizontal3, cell(5,3), Cells),
         Cells == [cell(5,3),cell(5,4),cell(5,5)])),
    test(t4,
        (fits([], t4, cell(2,2), Cells),
         Cells == [cell(2,2),cell(2,3),cell(2,4),cell(3,3)])),
    test(z4,
        (fits([], z4, cell(2,2), Cells),
         Cells == [cell(2,2),cell(2,3),cell(3,3),cell(3,4)])),
    test(desborde_horizontal,
        \+ fits([], horizontal2, cell(1,5), _)),
    test(desborde_vertical,
        \+ fits([], vertical2, cell(5,1), _)),
    test(origen_fuera, \+ fits([], single, cell(0,1), _)),
    test(colision_en_origen,
        \+ fits([cell(2,2)], square2, cell(2,2), _)),
    test(colision_en_otra_celda,
        \+ fits([cell(3,3)], square2, cell(2,2), _)),
    test(hueco_de_corner3,
        fits([cell(2,3)], corner3, cell(2,2), _)),
    test(pieza_inexistente, \+ fits([], unknown, cell(1,1), _)).

test_legal_move :-
    nl, write('TODO 4: legal_move/3'), nl,
    test(jugada_valida, legal_move([], t4, cell(4,3))),
    test(jugada_fuera, \+ legal_move([], t4, cell(5,3))),
    test(jugada_ocupada,
        \+ legal_move([cell(1,1)], single, cell(1,1))),
    test(genera_pieza,
        (findall(Name, legal_move([], Name, cell(5,5)), Names),
         Names == [single])),
    test(genera_15_origenes_horizontal3,
        (findall(Origin, legal_move([], horizontal3, Origin), Origins),
         findall(cell(R,C), (between(1,5,R),between(1,3,C)), Expected),
         length(Origins, 15),
         sort(Origins, ActualSet),
         sort(Expected, ExpectedSet),
         ActualSet == ExpectedSet)),
    test(vacio_136_jugadas_exactas,
        (all_moves([], Actual),
         expected_empty_moves(Expected),
         length(Actual, 136),
         sort(Actual, ActualSet),
         sort(Expected, ExpectedSet),
         ActualSet == ExpectedSet)),
    test(center_113_jugadas_sin_duplicados,
        (board(center, B),
         all_moves(B, Moves), length(Moves, 113),
         sort(Moves, Unique), length(Unique, 113))),
    test(lleno_sin_jugadas,
        (board(full, B), all_moves(B, Moves), Moves == [])).

origin_limits(single,      5, 5).
origin_limits(horizontal2, 5, 4).
origin_limits(vertical2,   4, 5).
origin_limits(square2,     4, 4).
origin_limits(corner3,     4, 4).
origin_limits(horizontal3, 5, 3).
origin_limits(t4,          4, 3).
origin_limits(z4,          4, 3).

expected_empty_moves(Moves) :-
    findall(
        move(Name,cell(R,C)),
        (origin_limits(Name, MaxR, MaxC),
         between(1,MaxR,R), between(1,MaxC,C)),
        Moves
    ).

test_first_move :-
    nl, write('TODO 5: first_move/2'), nl,
    test(vacio_una_sola_solucion,
        (findall(Move, first_move([], Move), Moves),
         Moves == [move(single,cell(1,1))])),
    test(salta_celda_ocupada,
        (findall(Move, first_move([cell(1,1)], Move), Moves),
         Moves == [move(single,cell(1,2))])),
    test(tablero_almost,
        (board(almost, B),
         findall(Move, first_move(B, Move), Moves),
         Moves == [move(single,cell(1,4))])),
    test(ultima_celda_disponible,
        (board(full, Full), select(cell(5,5), Full, B),
         findall(Move, first_move(B, Move), Moves),
         Moves == [move(single,cell(5,5))])),
    test(lleno_sin_solucion,
        (board(full, B),
         findall(Move, first_move(B, Move), Moves),
         Moves == [])).

test_show_moves :-
    nl, write('TODO 6: show_moves/1'), nl,
    write('Revise tambien las jugadas impresas.'), nl,
    nl, write('CASO 1: no debe imprimir ninguna jugada.'), nl,
    test(lleno_termina_con_exito,
        (board(full, B),
         findall(ok, show_moves(B), Results),
         Results == [ok])),
    nl, write('CASO 2: debe imprimir solamente:'), nl,
    write('move(single,cell(5,5))'), nl,
    write('Salida del estudiante:'), nl,
    test(una_jugada_termina_con_exito,
        (board(full, Full), select(cell(5,5), Full, B),
         findall(ok, show_moves(B), Results),
         Results == [ok])),
    nl, write('CASO 3: debe imprimir 136 jugadas sin repetir.'), nl,
    write('Salida del estudiante:'), nl,
    test(vacio_termina_con_exito,
        (findall(ok, show_moves([]), Results),
         Results == [ok])).
