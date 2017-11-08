%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% UTILS %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

% Converts the list symbol to the board symbol
convert(0,' ').
convert(1,'B').
convert(2,'W').
convert(3,'H').
convert(-1,'N').

% If Then Else
ite(If,Then,_):- If, !, Then.
ite(_,_,Else):- Else.

clearScreen:-
	write('\33\[2J').
	
readInput(X,Y,Type,Game):- 
	repeat,
		write('Coords (X-Y): '), 
		read(X-Y),
		validCoords(X,Y),
		write('Type: '),
		read(Type).
		%validType(Type,Game).

validCoords(X, Y):-
	integer(X),
	integer(Y).

validCoords(_,_):-
	write('Invalid input'), nl, fail.

validType(Type,Game):-
	getCurrentPlayer(Game, Player),
	ite((Player == blackPlayer, (Type == 'w' ; Type == 'W')), fail, true),
	ite((Player == whitePlayer, (Type == 'b' ; Type == 'B')), fail, true).

validType(_,_):-
	write('Invalid input'), nl, fail. 


readPlay(Game,Play):-
	%getBoard(Game, Board),
	repeat,
		%clearScreen,
		%printBoard(Board),
		readInput(X,Y,Type,Game),
		createPlay(X,Y,Type,Play).

% Print board
p_u:- write('  ___ ___ ___ ___ ___ '), nl.
p_s:- write(' |___|___|___|___|___|'), nl.
p_m([],_).
p_m([L|T],C):- write(C), C1 is C+1, p_l(L), p_m(T,C1).
p_l([C|[]]):- convert(C,S),write('| '), write(S), write(' |'), nl, p_s.
p_l([C|T]):- convert(C,S),write('| '), write(S), write(' '), p_l(T).
p_x:-
	write('  *******************'),nl,
	write('  *******GoRoGo******'),nl,
 	write('   1   2   3   4   5'), nl.
p_g:-
	write('  *******GoRoGo******'),nl,
	write('  *******************'),nl.
printBoard(Board):- p_x, p_u, p_m(Board,1), p_g.


printPlayerInfo(Player,Info,Current):-
	getRegPieces(Info,RegPieces),
	getHengePieces(Info,HengePieces),
	getScore(Info,Score),
	format('~s: ~d(R) - ~d(H) - ~d(S)', [Player,RegPieces,HengePieces,Score]),
	ite(Current == 'true', write('       (C)'),true).

%PRINT_PLAYERS_INFO
printPlayersInfo(Game):-
	getWhiteInfo(Game,WhiteInfo),
	getBlackInfo(Game,BlackInfo),
	getCurrentPlayer(Game,Player),
	ite(Player == whitePlayer, (CurrWhite = 'true', CurrBlack = 'false'), ( CurrWhite = 'false', CurrBlack = 'true')),
	printPlayerInfo("WHITE",WhiteInfo,CurrWhite), nl,
	printPlayerInfo("BLACK",BlackInfo,CurrBlack), nl.
	
%PRINT_WINNER
printWinner(Player):-
	ite(Player == whitePlayer, Winner = "WHITE", Winner = "BLACK"),
	format('CONGRATULATIONS: ~s WON',[Winner]).
	
%PRINT_GAME
printGame(Game):-
	getBoard(Game,Board),
	clearScreen,
	printBoard(Board), nl,
	printPlayersInfo(Game), nl.
	
%WAIT_FOR_ENTER	
waitForEnter:-
	repeat,
		get_char('\n').