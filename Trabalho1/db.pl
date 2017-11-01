:-use_module(library(lists)).

board([[1,1,0,1,0],[1,1,2,0,0],[2,1,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]).
initialBoard([[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]).
board_size(5).

initGamePvP(Game):-
	initialBoard(Board),
	WhiteInfo = [10,3,0],
	BlackInfo = [10,2,0],
	Player = whitePlayer,
	Mode = pvp,
	Game = [Board, WhiteInfo, BlackInfo, Player, Mode].

nextPlayer(Current, Next):-
	ite(Current == whitePlayer, Next = blackPlayer, Next = whitePlayer).


%IF THEN ELSE UTILS
ite(If,Then,_):- If, !, Then.
ite(_,_,Else):- Else.

getCurrentPlayer(Game,CurPlayer):-
	selectAtIndex(Game, 4, CurPlayer).

setCurrentPlayer(Game, CurPlayer, GameRes):-
	replaceAtIndex(Game, 4, CurPlayer, GameRes).

getWhiteInfo(Game, WhiteInfo):-
	selectAtIndex(Game, 2, WhiteInfo).

setWhiteInfo(Game, WhiteInfo, GameRes):-
	replaceAtIndex(Game, 2, WhiteInfo, GameRes).

getBlackInfo(Game, BlackInfo):-
	selectAtIndex(Game, 3, BlackInfo).

setBlackInfo(Game, BlackInfo, GameRes):-
	replaceAtIndex(Game, 3, BlackInfo, GameRes).

getRegPieces(Info, RegPieces):-
	selectAtIndex(Info, 1, RegPieces).

getHengePieces(Info, HengePieces):-
	selectAtIndex(Info, 2, HengePieces).

setRegPieces(Info, NewPieces, NewInfo):-
	replaceAtIndex(Info, 1, NewPieces, NewInfo).

setHengePieces(Info, NewPieces, NewInfo):-
	replaceAtIndex(Info, 2, NewPieces, NewInfo).

decRegPieces(Info, NewInfo):-
	getRegPieces(Info, Old),
	New is Old-1,
	setRegPieces(Info, New, NewInfo).

decHengePieces(Info, NewInfo):-
	getHengePieces(Info, Old),
	New is Old-1,
	setHengePieces(Info, New, NewInfo).


%--------------------PRINT--------------------------
%UTIL
convert(0,' ').
convert(1,'B').
convert(2,'W').
convert(3,'H').

p_u:- write(' ___ ___ ___ ___ ___ '), nl.
p_s:- write('|___|___|___|___|___|'), nl.
p_m([]).
p_m([L|T]):- p_l(L), p_m(T).
p_l([C|[]]):- convert(C,S),write('| '), write(S), write(' |'), nl, p_s.
p_l([C|T]):- convert(C,S),write('| '), write(S), write(' '), p_l(T).
print_state(State):- p_u, p_m(State).
%/UTIL
 
 
%-----------------------OPERATIONS-----------------------------
%UTIL
invert_Y(Y,YInv):- YInv is 6 - Y.

%SELECT AT INDEX
selectAtIndex(List, Index, Elem):-
	nth1(Index, List, Elem).

%SELECT_POS
select_pos(State,X,Y,Elem):- 
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
%/UTIL



%CHECK_IF_SURROUNDED

comp_piece(Curr, _):- Curr = 3.
comp_piece(Curr, _):- Curr = -1.
comp_piece(Curr, Opponent):- Curr = Opponent.

rodeado(State,X,Y,_,_):-
	select_pos(State,X,Y,Elem),
	Elem = 0, !, fail.

rodeado(_,6,Y,_,_) :- Y \= 6.
rodeado(_,0,Y,_,_) :- Y \= 0.
rodeado(_,X,6,_,_) :- X \= 6.
rodeado(_,X,0,_,_) :- X \= 0.

rodeado(State,X,Y,_,Opponent):- 
	select_pos(State,X,Y,Elem),
	comp_piece(Elem,Opponent).
	

rodeado(State,X,Y,Player,Opponent):-
	replace_pos(State,X,Y,-1,TmpState),
	LeftX is X-1,
	RightX is X+1,
	DownY is Y-1,
	UpY is Y+1,
	rodeado(TmpState,LeftX,Y,Player,Opponent),
	rodeado(TmpState,RightX,Y,Player,Opponent),
	rodeado(TmpState,X,DownY,Player,Opponent),
	rodeado(TmpState,X,UpY,Player,Opponent).
	
	
is_surrounded(X,Y,Player,Opponent):- board(G), rodeado(G,X,Y,Player,Opponent).


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


clearScreen:-
	write('\33\[2J').
	
readInput(X,Y,Type):- 
	repeat,
		write('Coords (X-Y): '), 
		read(X-Y), 
		write('Type: '), 
		read(Type).

readPlay:-
	repeat,
		readInput(X,Y,Type).
		%validInput(X,Y,Type,Board).




game:- %game(Game) usar Game como uma lista (Board, whitePieces, blackPieces), whitePieces lista com (white, henge), blackPieces lista com (black, henge).
	initialBoard(Board),
	repeat,
		clearScreen,
		print_state(Board),
		readPlay.

game(Game):-
	initialBoard(Game).


%peças dos jogadores
%printPieces:-






%menu -> playgame(mode) -> init -> pvp(Board) -> loop -> clearScreen -> print_state -> readPlay.
