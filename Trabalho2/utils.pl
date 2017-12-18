%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% UTILS %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

%CONVERTS the list symbol to the board symbol
convert(0,' ').
convert(1,'B').
convert(2,'W').
convert(3,'H').
convert(-1,'N').

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

%PRINT_BOARD
p_u:- write('  ___ ___ ___ ___ ___ ___ '), nl.
p_s:- write(' |___|___|___|___|___|___|'), nl.
p_m([],_).
p_m([L|T],C):- write(C), C1 is C+1, p_l(L), p_m(T,C1).
p_l([C|[]]):- convert(C,S),write('| '), write(S), write(' |'), nl, p_s.
p_l([C|T]):- convert(C,S),write('| '), write(S), write(' '), p_l(T).
printBoard(Board):- p_u, p_m(Board,1).

%WAIT_FOR_ENTER	
waitForEnter:-
	readString(_).