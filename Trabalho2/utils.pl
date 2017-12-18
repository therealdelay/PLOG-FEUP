%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% UTILS %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

%CONVERTS the list symbol to the board symbol
convert(X,X).

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
printBorderTimes(_, Times, Times).

printBorderTimes(Separator, Curr, Times):-
	write(Separator),
	Next is Curr+1,
	printBorderTimes(Separator, Next, Times).

printBorder(Init, Separator, Times):-
	write(Init),
	printBorderTimes(Separator, 0, Times),
	nl.

p_m([],_).
p_m([L|T],C):- 
	write(C), 
	C1 is C+1, 
	proper_length(L,Length),
	p_l(L,Length), 
	p_m(T,C1).

p_l([C|[]],Length):- convert(C,S),write('| '), write(S), write(' |'), nl, printBorder(' |','___|',Length).
p_l([C|T],Length):- convert(C,S),write('| '), write(S), write(' '), p_l(T,Length).

printBoard(Board):- 
	proper_length(Board,Length),
	printBorder('  ', '___ ',Length),
	p_m(Board,1).
	

%WAIT_FOR_ENTER	
waitForEnter:-
	readString(_).
	
%STATISTICS

reset_timer :- statistics(walltime,_).	

print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.