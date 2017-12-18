%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% MENUS %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

doppelblock:-
	clearScreen,
	mainMenu.

mainMenu:-
	write('*********************'),nl,
	write('*****Doppelblock*****'),nl,
	write('*********************'),nl,
	write('*                   *'),nl,
	write('*    Main   Menu    *'),nl,
	write('*                   *'),nl,
	write('* 1 - Play          *'),nl,
	write('*                   *'),nl,
	write('* 0 - Exit          *'),nl,
	write('*                   *'),nl,
	write('*********************'),nl,
	write('*Option:            *'),nl,
	readOption(Option),
	write(Option),nl,
	integer(Option), Option >= 0, Option < 2, !,
	clearScreen,
	mainMenuOption(Option).

mainMenu:-
	clearScreen,
	write('Error: invalid input.'), nl,
	mainMenu.
	
playMenu:-
	write('**************************'),nl,
	write('********Doppelblock*******'),nl,
	write('**************************'),nl,
	write('*                        *'),nl,
	write('*       Play  Menu       *'),nl,
	write('*                        *'),nl,
	write('**************************'),nl,
	write('*                        *'),nl,
	write('*Choose board size (4-10)*'),nl,
	write('*Option:                 *'),nl,
	readOption(Size),
	write('Here'),nl,
	integer(Size), Size >= 4, Size < 11, !,
	clearScreen,
	rcMenu(Size).

playMenu:-
	clearScreen,
	write('Error: invalid input.'), nl,
	playMenu.

rcMenu(Size):-
	write('**************************'),nl,
	write('********Doppelblock*******'),nl,
	write('**************************'),nl,
	write('*                        *'),nl,
	write('*       Play  Menu       *'),nl,
	write('*                        *'),nl,
	write('**************************'),nl,
	write('*                        *'),nl,
	write('*Do you want to choose   *'),nl,
	write('*rows and columns sums?  *'),nl,
	write('*Option (1-yes 0-no):    *'),nl,
	readOption(Option),
	integer(Option), Option >= 0, Option < 2, !,
	rcMenuOption(Option,Size).

readArray(Array):-
	read(Array).

rcMenuOption(0,Size):-
	write('Gerar aleatorio'),nl.


getRows(Rows,Size):-
	write('Rows sums ([R1,R2,R3,...]):'),nl,
	readArray(Rows),
	length(Rows, Size),!.

getRows(Rows,Size):-
	write('Error: wrong array size.'), nl,
	getRows(Rows,Size).

getCols(Cols,Size):-
	write('Columns sums ([C1,C2,C3,...]):'),nl,
	readArray(Cols),
	length(Cols, Size),!.

getCols(Cols,Size):-
	write('Error: wrong array size.'), nl,
	getCols(Cols,Size).

rcMenuOption(1,Size):-
	getRows(Rows,Size),
	verifyInts(Rows),
	verifySums(Rows,Size),
	getCols(Cols,Size),
	verifyInts(Cols),
	verifySums(Cols,Size),!.

rcMenuOption(1,Size):-
	write('Error: array must have only integers less than the sum of all integers from 1 to Size-2.'),nl,
	rcMenuOption(1,Size).

verifyInts([]).
verifyInts([H|T]):-
	integer(H),
	verifyInts(T).
	
verifySums([],_).
verifySums([H|T],Size):-
	Sum is ((Size-2)*(Size-1)/2),
	H =< Sum,
	verifySums(T,Size).


mainMenuOption(0):- !.
mainMenuOption(1):- 
	playMenu.