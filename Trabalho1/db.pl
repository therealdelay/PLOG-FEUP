:-use_module(library(lists)).
:-include('utils.pl').
:-include('getsandsets.pl').
:-include('menu.pl').

board([[1,1,0,1,0],[1,1,2,0,0],[2,1,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]).
initialBoard([[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]).
board_size(5).
 
 
%-----------------------OPERATIONS-----------------------------
%UTIL
invert_Y(Y,YInv):- YInv is 6 - Y.

%SELECT AT INDEX
selectAtIndex(List, Index, Elem):-
	nth1(Index, List, Elem).

%SELECT POS
selectPos(State,X,Y,Elem):- 
	nth1(Y,State,Row), 
	nth1(X,Row,Elem).

%REPLACE AT INDEX
replaceAtIndex(Src, Index, NewVal, Res) :-
   replaceAtIndex0(Src, 1, Index, NewVal, Res).

replaceAtIndex0([_|Es], I , I, X, [X|Es]).
replaceAtIndex0([E|Es], I0, I, X, [E|Xs]) :-
   I1 is I0+1,
   replaceAtIndex0(Es, I1,I, X, Xs).
   
%REPLACE_PIECE ON BOARD
replacePiece(State,X,Y,NewElem,Res):-
	replacePiece_index_column(State,X,1,Y,NewElem,Res).
	
replacePiece_index_column([H|Es],X,Y,Y,NewElem,[NewRow|Es]):- 
	replaceAtIndex(H, X, NewElem, NewRow).
	
replacePiece_index_column([E|Es], X, Y0, Y, NewElem, [E|Xs]):-
	Y1 is Y0+1,
	replacePiece_index_column(Es,X,Y1,Y,NewElem, Xs).
	
playerPiece(blackPlayer,1).
playerPiece(whitePlayer,2).

%UTIL

%CHECK_IF_SURROUNDED

compPiece(Curr, _):- Curr == 3.
compPiece(Curr, _):- Curr == -1.
compPiece(Curr, Opponent):- Curr == Opponent.


rodeado(State,X,Y,Player,_):-
	selectPos(State,X,Y,Elem),
	Elem == 0, fail, !.

rodeado(_,6,Y,_,_) :- Y \= 6.
rodeado(_,0,Y,_,_) :- Y \= 0.
rodeado(_,X,6,_,_) :- X \= 6.
rodeado(_,X,0,_,_) :- X \= 0.

rodeado(State,X,Y,_,Opponent):- 
	selectPos(State,X,Y,Elem),
	playerPiece(Opponent,OpponentPiece),
	compPiece(Elem,OpponentPiece).
	

rodeado(State,X,Y,Player,Opponent):-
	replacePiece(State,X,Y,-1,TmpState),
	LeftX is X-1,
	RightX is X+1,
	DownY is Y-1,
	UpY is Y+1,
	rodeado(TmpState,LeftX,Y,Player,Opponent),
	rodeado(TmpState,RightX,Y,Player,Opponent),
	rodeado(TmpState,X,DownY,Player,Opponent),
	rodeado(TmpState,X,UpY,Player,Opponent).
	
	
isSurrounded(X,Y,Player,Opponent):- board(G), rodeado(G,X,Y,Player,Opponent).


%AULA
/*
leChars(Frase):-
	get_char(Ch),
	leTodosOsChars(Ch, ListaChar),
	name(Frase, [Ch,ListaChar]).
	
leTodosOsChars(hass(10,[])).
leTodosOsChars(hass(13,[])).
leTodosOsChars(hass(Ch,[Ch|MaisChars])):-
	get_char(NovoChar),
	leTodosOsChars(NovoChar,MaisChars).
	
	
leInteiro(Prompt,Inteiro):-
	repeat,
		write(Prompt),
		once(leChars(Inteiro)),
		number(Inteiro).
	

jogo:-
	jogada(Jogador, TabInicial):-
	jogaJogo(Jogador,TabInicial,TabFinal),
	mostraResultado(TabFinal).
	
jogaJogo(Jogador,TabInicial,TabFinal):-
	endGame(Jogador,TabInicial).
	
jogaJogo(Jogador,TabInicial,TabFinal):-
	jogadasLegais(Jogador,Tabuleiro,ListaJogadas),
	melhorJogada(Jogador,ListaJogadas,Melhor),
	aplicaJogada(TabInicial,Melhor,NovoTab),
	proximaJogador(Jogador,Proximo),
	jogaJogo(Proximo,NovoTab,TabFinal).
	
jogar:-
	estadoJogo(Jogador,TabInicial),
	assert(estadoJogo(Jogador,TabInicial)),
	repeat,
		retract(estadoJogo(Jogador,Tab)),
		once(jogaJogo(Jogador,Tab,NovoJogador,NovoTab)),
		assert(estadoJogo(NovoJogador,NovoTab)),
		endOfGame(NovoJogador,NovoTab),
		mostraResultado(NovoJogador,NovoTab).

*/
		
/* 	1. Nao sei o que quer dizer com o predicado hass, mas acho que e isso que ele escreveu...
*	Tentei procurar na documentacao por ha(...) e nao encontrei nada de util por isso vou assumir que e algo definido por nos, mas nao estou a ver o que.
*  	2. Na linha 124 faltava o segundo argumento do jogaJogo (nao me lembro porque xD) mas acho que faz sentido ser o NovoTab. 
*	Mas nao sei porque o TabFinal nunca e usado...
*
*/

/*
*/

checkInBoard(Play):-
	getPlayXCoord(Play,X),
	getPlayYCoord(Play,Y),
	X > 0, X < 6,
	Y > 0, Y < 6.
	
checkEmptyCell(Game,Play):-
	getPlayXCoord(Play,X),
	getPlayYCoord(Play,Y),
	getBoardCell(Game,X,Y,Cell),
	Cell == 0.

checkRegPieceStock(Game):-
	getCurrentPlayer(Game,Player),
	getPlayerInfo(Game,Player,Info),
	getRegPieces(Info,Pieces),
	Pieces > 0.
	
checkHengePieceStock(Game):-
	getCurrentPlayer(Game,Player),
	getPlayerInfo(Game,Player,Info),
	getHengePieces(Info,Pieces),
	Pieces > 0.
	
checkPieceStock(Game,Play):-
	getPlayType(Play,Type),
	ite(Type == 'h',
		checkHengePieceStock(Game),
		
		checkRegPieceStock(Game)
	).

/*
checkValidPos(Game,Play):-
	getPlayXCoord(Play,X),
	getPlayYCoord(Play,Y),
	getPlayType(Play,Type),
	ite(Type \= 'h',
		ite(isSurrounded(Game,X,Y)
			checkHigherScore(Game,Play),
			
			true
		),
		true
	).
*/
	
validPlay(Game,Play):-
	checkInBoard(Play),
	checkPieceStock(Game,Play),
	checkEmptyCell(Game,Play).
	%checkValidPos(Game,Play).

getPlay(Game,Play):-
	repeat,
		readPlay(Game,Play),
		validPlay(Game,Play).


applyPlay(Game,Play,GameRes):-
	getPlayXCoord(Play,X),
	getPlayYCoord(Play,Y),
	getPlayPiece(Game,Play,Piece,GameTmp),
	setBoardCell(GameTmp,X,Y,Piece,GameRes).


checkInvalidMovesLeft(Game,Winner):-
	getCurrentPlayer(Game,Player),
	getPlayerInfo(Game,Player,Info),
	getRegPieces(Info,RegPieces),
	getHengePieces(Info,HengePieces),
	ite((RegPieces == 0,HengePieces == 1),(getNextPlayer(Player,Winner)),fail).
	

checkPiecesLeft(Game,Winner):-
	getPlayerInfo(Game,whitePlayer,WhiteInfo),
	getPlayerInfo(Game,blackPlayer,BlackInfo),
	getRegPieces(BlackInfo,BRegPieces),
	getHengePieces(BlackInfo,BHengePieces),
	getScore(BlackInfo,BScore),
	getRegPieces(WhiteInfo,WRegPieces),
	getHengePieces(WhiteInfo,WHengePieces),
	getScore(WhiteInfo,WScore),
	ite(
		(BRegPieces == 0, BHengePieces == 0, WRegPieces == 0, WHengePieces == 0),
		
			ite(WScore >= BScore, Winner = whitePlayer, Winner = blackPlayer),
			
			fail
	).
	

endOfGame(Game,Winner):-
	checkInvalidMovesLeft(Game,Winner).

	
endOfGame(Game,Winner):-
	checkPiecesLeft(Game,Winner).
	
updateGame(Game):-
	true.
	
	
play:-
	initGamePvP(Game),
	playPvP(Game,Winner),
	printWinner(Winner).
	
playPvP(Game,Winner):-
	endOfGame(Game,Winner).
	
playPvP(Game,Winner):-
	updateGame(Game),
	printGame(Game),
	getPlay(Game,Play),
	applyPlay(Game,Play,GameRes),
	updateGame(Game),
	setNextPlayer(GameRes, GameRes2),
	playPvP(GameRes2,Winner).
	
	
	


/*
game:- %game(Game) usar Game como uma lista (Board, whitePieces, blackPieces), whitePieces lista com (white, henge), blackPieces lista com (black, henge).
	initialBoard(Board),
	repeat,
		clearScreen,
		printBoard(Board),
		readPlay.

game(Game):-
	initialBoard(Game).


%peças dos jogadores
%printPieces:-






%menu -> playgame(mode) -> init -> pvp(Board) -> loop -> clearScreen -> print_state -> readPlay.
*/

initGamePvP(Game):-
	initialBoard(Board),
	WhiteInfo = [10,3,0],
	BlackInfo = [10,2,0],
	Player = whitePlayer,
	Mode = pvp,
	Game = [Board, WhiteInfo, BlackInfo, Player, Mode].