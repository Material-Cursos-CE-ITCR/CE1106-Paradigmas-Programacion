% ITCR - Paradigmas de Programacion
% Taller Block Blast: 2 horas y 15 minutos, en parejas.
% Complete los seis TODO. Conserve las firmas.
% Los TODO fallan intencionalmente mientras estan pendientes.
% Coordenadas de 1 a 5. Offsets desde 0. Sin rotaciones.

% Mantenga esta directiva al copiar TODO el archivo en OneCompiler.
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

% Auxiliares proporcionados.
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

% +Cell: compruebe coordenadas numericas ya instanciadas.
inside_board(cell(R,C)) :-
    board_size(N), R >= 1, R =< N, C >= 1, C =< N.

% +Board, +Cell: dentro del tablero y sin ocupacion.
free_cell(_Board,_Cell) :- fail. % TODO 1

% +Board, +Cells: recursion, incluida la lista vacia.
all_free(_Board,_Cells) :- fail. % TODO 2

% +Offsets, +Origin, -Cells: sume origen a cada offset.
translate_cells([],_,[]).
translate_cells([cell(DR,DC)|Rest],cell(R,C),[cell(NR,NC)|Cells]) :-
    NR is R+DR, NC is C+DC,
    translate_cells(Rest,cell(R,C),Cells).

% +Board, +Name, +Origin, -Cells: traduzca y valide.
fits(_Board,_Name,_Origin,_Cells) :- fail. % TODO 3

% +Board, ?Name, ?Origin: genere pieza y posicion antes de validar.
legal_move(_Board,_Name,_Origin) :- fail. % TODO 4

% +Board, -Moves: obtenga move(Name,Origin) con findall/3.
all_moves(Board,Moves) :-
    findall(move(Name,Origin),legal_move(Board,Name,Origin),Moves).

% +Board, -Move: primera jugada valida, utilice un corte.
first_move(_Board,_Move) :- fail. % TODO 5

% +Board: imprima todas las jugadas con un bucle dirigido por fallo.
% Sustituya el TODO por dos clausulas; la ultima permite terminar con exito.
show_moves(_Board) :- fail. % TODO 6

% +Board, +Name, +Origin, -NewBoard: coloque una pieza valida.
% Obtenga sus celdas con fits/4 y combine las listas con append/3.
place_piece(Board,Name,Origin,NewBoard) :-
    fits(Board,Name,Origin,Cells), append(Board,Cells,NewBoard).


% Ejecucion en https://onecompiler.com/prolog
run_query(Template,Goal) :-
    findall(Template,Goal,Results), write(Results), nl.
check_goal(Label,Goal) :-
    (call(Goal) -> Status=success ; Status=failure),
    format('~w: ~w~n',[Label,Status]).

% Compatibilidad para ejemplos que utilicen writeln/1.
writeln(Term) :-
    write(Term), nl.

% MAIN DE DEMOSTRACION: no llama a ningun TODO.
% Funciona desde el inicio, aunque los seis ejercicios esten pendientes.
main :-
    demo_main.

demo_main :-
    write('VERSION ESTUDIANTES - MAIN DE DEMOSTRACION'), nl, nl,
    Board = [cell(1,1),cell(1,2),cell(3,4)],
    write('TABLERO: # ocupado, . libre'), nl,
    print_board(Board), nl,
    write('CATALOGO DE OCHO PIEZAS (incluye T y Z)'), nl,
    run_query(piece(Name,Cells),piece(Name,Cells)), nl,
    check_goal(bounds_example,inside_board(cell(5,5))),
    write('Complete los seis TODO. Para probarlos ejecute test_student_code.'), nl.

% PRUEBAS DE LOS ESTUDIANTES.
% Cuando quiera probar, sustituya SOLO la llamada de main:
% main :- test_student_code.
% check_goal captura el fallo: un TODO pendiente no hace fallar main.
test_student_code :-
    board(empty,Board),
    check_goal(free_cell_example,free_cell(Board,cell(1,1))),
    check_goal(empty_list,all_free(Board,[])),
    check_goal(fits_example,fits(Board,t4,cell(1,1),_)),
    write('Jugadas obtenidas: '),
    run_query(move(Name,Origin),legal_move(Board,Name,Origin)),
    write('Primera jugada: '),
    run_query(Move,first_move(Board,Move)),
    check_goal(show_moves_example,show_moves(Board)).
