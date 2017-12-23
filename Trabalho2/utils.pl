%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% UTILS %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic(find_n_solution/1).
:- dynamic(find_n_counter/1).

%CONVERTS the list symbol to the board symbol
convert(0,'#').
convert(X,X).

%IF_THEN_ELSE
ite(If,Then,_):- If, !, Then.
ite(_,_,Else):- Else.

%SELECT_AT_INDEX
selectAtIndex(List, Index, Elem):-
	nth1(Index, List, Elem).

%SELECT_POS
selectPos(State,X,Y,Elem):- 
	nth1(Y,State,Row), 
	nth1(X,Row,Elem).

%CLEAR_SCREEN	
clearScreen:-
	write('\33\[2J').

	
%USER_I/O
		
%CONVERT_ASCII_CODE_TO_NUMBER
codeToNumber(Code,Value):-
	Value is Code-48 .

%READ_STRING
readString([Char|OtherChars]):-
	get_code(Char),
	ite(Char = 10, (OtherChars = [],true), readString(OtherChars)).
	
%READ_MENU_OPTION
readOption(Option):-
	readString(String),
	selectAtIndex(String,1,OptionCode),
	codeToNumber(OptionCode,Option).
	
readArray(Array):-
	read(Array).
	
getRows(Rows,Size):-
	write('Rows sums ([R1,R2,R3,...])  '),
	write('Size = '),write(Size),write(':'),nl,
	readArray(Rows),
	length(Rows, Size),!.

getRows(Rows,Size):-
	write('Error: wrong array size.'), nl,
	getRows(Rows,Size).

getCols(Cols,Size):-
	write('Columns sums ([C1,C2,C3,...])  '),
	write('Size = '),write(Size),write(':'),nl,
	readArray(Cols),
	length(Cols, Size),!.

getCols(Cols,Size):-
	write('Error: wrong array size.'), nl,
	getCols(Cols,Size).

verifyInts([]).
verifyInts([H|T]):-
	integer(H),
	verifyInts(T).
	
verifySums([],_).
verifySums([H|T],Size):-
	Sum is ((Size-2)*(Size-1)/2),
	H =< Sum,
	verifySums(T,Size).	


%WAIT_FOR_ENTER	
waitForEnter:-
	readString(_).	
	
%PRINT_MATRIX
printVal(X):-
	X < 10,
	write(X),write('   ').
	
printVal(X):-
	write(X),write('  ').
	
printColumns(Columns):-
	write('      '),
	maplist(printVal,Columns), nl.
	
printBorderTimes(_, Times, Times).

printBorderTimes(Separator, Curr, Times):-
	write(Separator),
	Next is Curr+1,
	printBorderTimes(Separator, Next, Times).

printBorder(Init, Separator, Times):-
	write(Init),
	printBorderTimes(Separator, 0, Times),
	nl.

p_m([],_).
p_m([L|T],[Row|Rows]):- 
	printVal(Row),
	proper_length(L,Length),
	p_l(L,Length), 
	p_m(T,Rows).

p_l([C|[]],Length):- convert(C,S),write('| '), write(S), write(' |'), nl, printBorder('    |','___|',Length).
p_l([C|T],Length):- convert(C,S),write('| '), write(S), write(' '), p_l(T,Length).

printMatrix(Rows,Columns,Matrix):-
	proper_length(Matrix,Length),
	printColumns(Columns),
	printBorder('     ', '___ ',Length),
	p_m(Matrix,Rows),!.
	

printMatrixWithStats(Rows,Columns,Matrix):-
	printMatrix(Rows,Columns,Matrix),
	print_time,
	fd_statistics.

	
%STATISTICS

reset_timer :- statistics(walltime,_).	

print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.

%CREATE_CLEAR_MATRIX

clearVal(X):-
	X = ' '.

clearLine(N,Line):-
	length(Line, N),
	maplist(clearVal,Line).
	

createClearMatrix(N,Matrix):-
	length(Matrix,N),
	maplist(clearLine(N), Matrix).
	
	
%MAP_LIST_ELEM

maplistelem(Pos, Xs, Ys) :-
    (   foreach(X,Xs),
        foreach(Y,Ys),
        param(element)
    do  call(element, Pos, X, Y)
    ).
	
%FIND_N_SOLUTIONS

find_n(N, Filter, Term, Goal, Solutions) :-
    (   set_find_n_counter(N),
        retractall(find_n_solution(_)),
        once((
            call(Goal),
			dec_find_n_counter(M),
			/*write(M),nl,*/
			Sol is mod(M,Filter),
			ite(Sol == 0,
				assertz(find_n_solution(Term)),
				true
			),
            M =:= 0
        )),
        fail
    ;   findall(Solution, retract(find_n_solution(Solution)), Solutions)
    ).

set_find_n_counter(N) :-
    retractall(find_n_counter(_)),
    assertz(find_n_counter(N)).

dec_find_n_counter(M) :-
    retract(find_n_counter(N)),
    M is N - 1,
    assertz(find_n_counter(M)).