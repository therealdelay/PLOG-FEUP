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
	mainMenuOption(Option).

mainMenu:-
	clearScreen,
	write('Error: invalid input.'), nl,
	mainMenu.
	
mainMenuOption(0):- !.
mainMenuOption(1):-
	clearScreen,
	playMenu.


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
	write('*Choose board size (4-8)*'),nl,
	write('*Option:                 *'),nl,
	readOption(Size),
	integer(Size), Size >= 4, Size < 9, !,
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
	
rcMenu(Size):-
	clearScreen,
	write('Error: invalid input.'), nl,
	rcMenu(Size).

rcMenuOption(0,Size):-
	nl,nl,write('Generating...'),
	getRandomDoppel(Size,Doppel),
	clearScreen,
	nl,write('Randomly generated puzzle: '),nl,nl,
	solveMenu(Doppel).
	
rcMenuOption(1,Size):-
	getRows(Rows,Size),
	verifyInts(Rows),
	verifySums(Rows,Size),
	getCols(Cols,Size),
	verifyInts(Cols),
	verifySums(Cols,Size),!,
	clearScreen,
	nl, write('Selected puzzle: '), nl,nl,
	createDoppel(Size,Rows,Cols,Doppel),
	createClearMatrix(Size,Matrix),
	printMatrix(Rows,Cols,Matrix),nl,
	nl, write('Press Enter to solve'), nl,
	waitForEnter,
	waitForEnter,
	solveMenuOption(1,Doppel).
	

rcMenuOption(1,Size):-
	write('Error: array must have only integers less than the sum of all integers from 1 to Size-2.'),nl,
	rcMenuOption(1,Size).
	

solveMenu(Doppel):-
	getDoppelSize(Doppel,Size),
	getDoppelRows(Doppel,Rows),
	getDoppelColumns(Doppel,Columns),
	createClearMatrix(Size,Matrix),
	printMatrix(Rows,Columns,Matrix),nl,
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
	
solveMenu(Doppel):-
	clearScreen,
	write('Error: invalid input.'), nl,
	solveMenu(Doppel).
	
solveMenuOption(1,Doppel):-
	getDoppelSize(Doppel,Size),
	getDoppelRows(Doppel,Rows),
	getDoppelColumns(Doppel,Columns),
	nl, write('Solving...'),
	doppelblock(Size,Rows,Columns,false,Matrix),
	clearScreen,
	printSolutionText,
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
	printSolutionText,
	printMatrix(Rows,Columns,Matrix),
	nl, write('Press Enter to continue...'),
	waitForEnter,
	clearScreen,
	mainMenu.
	
printSolutionText:-
	nl,nl,
	write('       **********************'),nl,
	write('       *      SOLUTION      *'),nl,
	write('       **********************'),nl,
	nl,nl,nl.