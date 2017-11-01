:-use_module(library(lists)).

gamestate([[1,1,0,1,0],[1,1,2,0,0],[2,1,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]).
board_size(5).


%--------------------PRINT--------------------------
convert(Dado, Simbolo):- Dado = 0, Simbolo = ' '.
convert(Dado, Simbolo):- Dado = 1, Simbolo = 'B'.
convert(Dado, Simbolo):- Dado = 2, Simbolo = 'W'.
convert(Dado, Simbolo):- Dado = 3, Simbolo = 'H'.

p_u:- write(' ___ ___ ___ ___ ___ '), nl.
p_s:- write('|___|___|___|___|___|'), nl.
p_m([]).
p_m([L|T]):- p_l(L), p_m(T).
p_l([C|[]]):- convert(C,S),write('| '), write(S), write(' |'), nl, p_s.
p_l([C|T]):- convert(C,S),write('| '), write(S), write(' '), p_l(T).
print_state(State):- p_u, p_m(State).
 
 
 
%-----------------------OPERATIONS-----------------------------


invert_X(X,XInv):- XInv is 6 - X.

%SELECT_POS
select_pos(State,X,Y,Elem):- 
	
	nth1(Y,State,Row), 
	nth1(X,Row,Elem).


%REPLACE_POS
list_nth1_item_replaced_NEW(Src, Index, NewVal, Res) :-
   list_index0_index_item_replaced(Src, 1, Index, NewVal, Res).

list_index0_index_item_replaced([_|Es], I , I, X, [X|Es]).
list_index0_index_item_replaced([E|Es], I0, I, X, [E|Xs]) :-
   I1 is I0+1,
   list_index0_index_item_replaced(Es, I1,I, X, Xs).
   

replace_pos(State,X,Y,NewElem,Res):- 
	replace_pos_index_column(State,X,1,Y,NewElem,Res).
	
replace_pos_index_column([H|Es],X,Y,Y,NewElem,[NewRow|Es]):- 
	list_nth1_item_replaced_NEW(H, X, NewElem, NewRow).
	
replace_pos_index_column([E|Es], X, Y0, Y, NewElem, [E|Xs]):-
	Y1 is Y0+1,
	replace_pos_index_column(Es,X,Y1,Y,NewElem, Xs).


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
	
	
is_surrounded(X,Y,Player,Opponent):- gamestate(G), rodeado(G,X,Y,Player,Opponent).


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
*  	2. Na linha 123 faltava o segundo argumento do jogaJogo (nao me lembro porque xD) mas acho que faz sentido ser o NovoTab. 
*	Mas nao sei porque o TabFinal nunca e usado...
*
*/

	
