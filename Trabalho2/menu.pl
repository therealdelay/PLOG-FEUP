%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% MENUS %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

doppelblock:-
	clearScreen,
	mainMenu.

/* 
*  MAIN MENU 
*/	

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

/* 
*  PLAY MENU 
*/	

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

	
/* 
*  RC MENU 
*/

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

rcMenuOption(0,Size):-
	clearScreen,
	nl,write('Random generated puzzle: '),nl,
	getRandomDoppel(Size,Doppel),
	getDoppelRows(Doppel,Rows),
	getDoppelColumns(Doppel,Columns),
	getDoppelMatrix(Doppel,Matrix),
	printMatrix(Rows,Columns,Matrix),
	solveMenu(Doppel).
	
rcMenuOption(1,Size):-
	getRows(Rows,Size),
	verifyInts(Rows),
	verifySums(Rows,Size),
	getCols(Cols,Size),
	verifyInts(Cols),
	verifySums(Cols,Size),!,
	clearScreen,
	write(Rows),nl,
	write(Cols),nl,
	nl, write('Selected puzzle: '), nl,
	createDoppel(Size,Rows,Cols,Doppel),
	write(Doppel),nl,
	nl, write('Press Enter to solve'), nl,
	waitForEnter,
	waitForEnter,
	solveMenuOption(1,Doppel).
	

rcMenuOption(1,Size):-
	write('Error: array must have only integers less than the sum of all integers from 1 to Size-2.'),nl,
	rcMenuOption(1,Size).
	

solveMenu(Doppel):-
	nl,nl,
	write('**************************'),nl,
	write('*                        *'),nl,
	write('* 1 - Solve              *'),nl,
	write('* 2 - Show solution      *'),nl,
	write('*                        *'),nl,
	write('**************************'),nl,
	readOption(Option),
	integer(Option), Option > 0, Option < 3, !,
	solveMenuOption(Option,Doppel).
	
solveMenuOption(1,Doppel):-
	getDoppelSize(Doppel,Size),
	getDoppelRows(Doppel,Rows),
	getDoppelColumns(Doppel,Columns),
	nl, write('Solving...'),
	doppelblock(Size,Rows,Columns,Matrix),
	clearScreen,
	printMatrixWithStats(Rows,Columns,Matrix),
	nl, write('Press Enter to continue...'),
	waitForEnter,
	clearScreen,
	mainMenu.
	
solveMenuOption(2,Doppel):-
	getDoppelRows(Doppel,Rows),
	getDoppelColumns(Doppel,Columns),
	getDoppelMatrix(Doppel,Matrix),
	clearScreen,
	printMatrix(Rows,Columns,Matrix),
	nl, write('Press Enter to continue...'),
	waitForEnter,
	clearScreen,
	mainMenu.

mainMenuOption(0):- !.
mainMenuOption(1):- 
	playMenu.