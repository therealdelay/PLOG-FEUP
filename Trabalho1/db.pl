:-use_module(library(lists)).
:-use_module(library(random)).
:-include('utils.pl').
:-include('getsandsets.pl').
:-include('menu.pl').
:-include('point2d.pl').

board([[1,1,1,0,0],[1,1,2,1,2],[2,2,0,2,0],[0,0,0,0,0],[0,0,0,0,0]]).

board2([[0,0,0,0,0],[0,0,0,2,2],[0,0,2,1,1],[0,2,1,3,1],[2,1,1,1,0]]).

board3([[0,0,1,3,0],[0,0,1,0,1],[2,2,0,1,0],[0,0,0,0,0],[0,0,0,0,0]]).

board4([[0,0,0,1,0],[0,0,3,0,1],[0,0,0,1,0],[0,0,0,0,0],[0,0,0,0,0]]).

%board([[0,0,2,1,2],[1,2,1,1,2],[2,1,2,2,0],[0,0,0,0,0],[0,0,0,0,0]]).

initialBoard([[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]).

boardSize(5).

player(human).
player(easyBot).
player(hardBot).


playType(n).
playType(h).
 
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

compPiece(Curr,_,t):- Curr == 3.
compPiece(Curr,_,_):- Curr == -1.
compPiece(Curr,Opponent,_):- Curr == Opponent.

surrounded(_,6,Y,_,_,_) :- Y \= 6.
surrounded(_,0,Y,_,_,_) :- Y \= 0.
surrounded(_,X,6,_,_,_) :- X \= 6.
surrounded(_,X,0,_,_,_) :- X \= 0.

surrounded(State,X,Y,_,Opponent,Henge):- 
	selectPos(State,X,Y,Elem),
	playerPiece(Opponent,OpponentPiece),
	compPiece(Elem,OpponentPiece,Henge).
	
surrounded(State,X,Y,_,_,_):-
	selectPos(State,X,Y,Elem),
	%playerPiece(Player,PlayerPiece),
	Elem == 0, !, fail.
	
surrounded(State,X,Y,Player,Opponent,Henge):-
	replacePiece(State,X,Y,-1,TmpState),
	%printBoard(State),
	LeftX is X-1,
	RightX is X+1,
	DownY is Y-1,
	UpY is Y+1,
	%write('1st'),nl,
	surrounded(TmpState,LeftX,Y,Player,Opponent,Henge), !,
	%write('2nd'),nl,
	surrounded(TmpState,RightX,Y,Player,Opponent,Henge), !,
	%write('3rd'),nl,
	surrounded(TmpState,X,DownY,Player,Opponent,Henge), !,
	%write('4th'),nl,
	surrounded(TmpState,X,UpY,Player,Opponent,Henge), !.
	
isSurroundedOpponent(Game,Point,Henge):-
	getBoard(Game,Board),
	getCurrentPlayer(Game,Player),
	getNextPlayer(Player,Opponent),
	getPoint2DXCoord(Point,X),
	getPoint2DYCoord(Point,Y),
	selectPos(Board,X,Y,Elem),
	playerPiece(Opponent,OpponentPiece),
	Elem == OpponentPiece,
	surrounded(Board,X,Y,Opponent,Player,Henge).
	
isSurroundedPlayer(Game,Point,Invert,Henge):-
	getBoard(Game,Board),
	getCurrentPlayer(Game,Player),
	getNextPlayer(Player,Opponent),
	/*
	write('BEFORE:'),
	write(Player), nl,
	write(Opponent), nl,
	ite(Invert == invert, (Tmp is Player, Player is Opponent), Opponent is Tmp),
	write(Player), nl,
	write(Opponent), nl,
	*/
	getPoint2DXCoord(Point,X),
	getPoint2DYCoord(Point,Y),
	selectPos(Board,X,Y,Elem),
	playerPiece(Player,PlayerPiece),
	Elem == PlayerPiece,
	surrounded(Board,X,Y,Player,Opponent,Henge).

/*	
isSurrounded(Point,Player,Opponent):- 
	board(B), 
	getPoint2DXCoord(Point,X),
	getPoint2DYCoord(Point,Y),
	rodeadoComp(B,X,Y,Player,Opponent).


*/
	
getAllPoints:-
	initGamePvP(Game),
	printGame(Game),
	%createPoint2D(2,5,Point),
	%isSurrounded(Game,Point).
	findall(Point,isSurroundedPlayer(Game,Point,_,t), Points),
	write(Points),nl.
	

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

checkPosSurroundedWithoutHenges(Game,Play):-
	getPlayPoint(Play,Point),
	isSurroundedPlayer(Game,Point,invert,f).
	
checkSameScoreAfterPlay(Game):-
	getCurrentPlayer(Game,Player),
	getPlayerInfo(Game,Player,PreviousInfo),
	getScore(PreviousInfo,PreviousScore),
	updateGame(Game,GameRes),
	getPlayerInfo(GameRes,Player,FutureInfo),
	getScore(FutureInfo,FutureScore),
	PreviousScore == FutureScore.
	
checkInvalidPosRequirements(Game,Play):-
	checkPosSurroundedWithoutHenges(Game,Play),
	checkSameScoreAfterPlay(Game).

checkValidPos(Game,Play):-
	getPlayType(Play,Type),
	ite(Type == 'h',	
		true,
		
		(	
			applyPlay(Game,Play,GameRes),
			ite(checkInvalidPosRequirements(GameRes,Play),fail,true)
		)
	).
	
	
checkValidType(Play):-
	getPlayType(Play,Type),
	Type = 'n'.
	
checkValidType(Play):-
	getPlayType(Play,Type),
	Type = 'h'.

validPlay(Game,Play):-
	checkValidType(Play),
	checkEmptyCell(Game,Play),
	checkPieceStock(Game,Play),
	checkInBoard(Play),
	checkValidPos(Game,Play).

getUserPlay(Game,Play):-
	repeat,
		readPlay(Game,Play),
		validPlay(Game,Play).

	
getRandomPlay(Plays,ResPlay):-
	%proper_length(Plays,Length),
	%random_between(1,Length,PlayIndex),
	%selectAtIndex(Plays,PlayIndex,ResPlay).
	random_member(ResPlay,Plays).
	
getEasyBotPlay(Game,ResPlay):-
	findall(Play,validPlay(Game,Play),Plays),
	write(Plays), nl,
	getRandomPlay(Plays,ResPlay).
	
getPlay(Game,Play):-    				%TODO/ Por isto bonito
	getCurrentPlayer(Game,Player),
	getPlayerInfo(Game,Player,Info),
	getPlayerType(Info,PlayerType),
	ite(PlayerType == human, getUserPlay(Game,Play), true),
	ite(PlayerType == easyBot, getEasyBotPlay(Game,Play), true).
	
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
	ite((RegPieces == 0,HengePieces == 1),
		getNextPlayer(Player,Winner),
		
		fail
	).
	

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

	
clearBoard(Game,[],Game).

clearBoard(Game, [Point|T], GameRes):-
	getPoint2DXCoord(Point,X),
	getPoint2DYCoord(Point,Y),
	setBoardCell(Game,X,Y,0,GameTmp1),
	getCurrentPlayer(Game,Player),
	getPlayerInfo(GameTmp1,Player,Info),
	incScore(Info,InfoRes),
	setPlayerInfo(GameTmp1,Player,InfoRes,GameTmp2),
	clearBoard(GameTmp2,T,GameRes).
	
	
updateGame(Game,GameRes):-
	findall(Point, isSurroundedOpponent(Game,Point,t), Points),
	%write(Points),nl,
	clearBoard(Game,Points,GameRes).
	
updateGameCycle(Game,GameRes):-
	updateGame(Game,GameTmp1),
	setNextPlayer(GameTmp1,GameTmp2),
	updateGame(GameTmp2,GameRes).
	
		
play:-
	initGamePvP(Game),
	playPvP(Game,Winner),
	printWinner(Winner).

playPvP(Game,Winner):-
	endOfGame(Game,Winner),
	printGame(Game).
	
playPvP(Game,Winner):-
	printGame(Game),
	getPlay(Game,Play),
	applyPlay(Game,Play,GameTmp1),
	updateGameCycle(GameTmp1,GameTmp2),
	playPvP(GameTmp2,Winner).


initGamePvP(Game):-
	%board4(Board),
	initialBoard(Board),
	WhiteInfo = [10,3,0,human],
	BlackInfo = [0,2,0,easyBot],
	Player = whitePlayer,
	Mode = pvp,
	Game = [Board, WhiteInfo, BlackInfo, Player, Mode].