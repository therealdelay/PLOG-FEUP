menu:-
	clearScreen,
	mainMenu.

mainMenu:-
	write('********************'),nl,
	write('*******GoRoGo*******'),nl,
	write('********************'),nl,
	write('*                  *'),nl,
	write('*    Main  Menu    *'),nl,
	write('*                  *'),nl,
	write('* 1 - Play         *'),nl,
	write('* 2 - Rules        *'),nl,
	write('*                  *'),nl,
	write('* 0 - Exit         *'),nl,
	write('*                  *'),nl,
	write('********************'),nl,
	write(' Option:            '),nl,
	read(Option),
	integer(Option), Option >= 0, Option < 3, !,
	processOption(Option).
mainMenu:-
	clearScreen,
	write('Error: invalid input.'), nl,
	mainMenu.

processOption(0):- !.
processOption(Option):-
	ite(Option == 1, playMenu, rulesMenu), !, nl,
	read(_).

playMenu:-
	play, !.


rulesMenu:-
	write('********************'),nl,
	write('*******GoRoGo*******'),nl,
	write('********************'),nl,
	write('*                  *'),nl,
	write('*      Rules       *'),nl,
	write('*                  *'),nl,
	write('-> Each player starts with 10 regular pieces and 2 Henge. The remaining Henge piece is played by the White to begin the game.'),nl,
	write('-> Henge pieces are considered both Black and White, according to the current player, i.e. while White plays, Henge are considered White, while Black plays, Henge are considered Black.'),nl,
	write('-> Pieces can\'t be moved once they are played.'),nl,
	write('-> A piece or a group of pieces chained with paths are conquered when they have no adjacent empty places. When conquered, pieces are removed from the board.'),nl,
	write('-> Henge pieces are never conquered.'),nl,
	write('-> A regular piece can\'t be played in a place surrounded by enemy pieces, unless that results in conquering enemy pieces or at least 1 of the surrounding pieces is Henge.'),nl,
	write('-> Players must play all Henge pieces before their last move.'),nl,
	write('-> It is not possible to pass a turn, so if a player has no valid moves, he loses.'),nl,
	write('-> Press enter to get back.'),nl,
	read(_),
	menu.