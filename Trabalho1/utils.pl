%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% UTILS %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

% Converts the list symbol to the board symbol
convert(0,' ').
convert(1,'B').
convert(2,'W').
convert(3,'H').

% If Then Else
ite(If,Then,_):- If, !, Then.
ite(_,_,Else):- Else.

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

% Print board
p_u:- write(' ___ ___ ___ ___ ___ '), nl.
p_s:- write('|___|___|___|___|___|'), nl.
p_m([]).
p_m([L|T]):- p_l(L), p_m(T).
p_l([C|[]]):- convert(C,S),write('| '), write(S), write(' |'), nl, p_s.
p_l([C|T]):- convert(C,S),write('| '), write(S), write(' '), p_l(T).
printBoard(Board):- p_u, p_m(Board).