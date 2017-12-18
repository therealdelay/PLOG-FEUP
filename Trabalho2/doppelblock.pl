:-use_module(library(lists)).
:-use_module(library(clpfd)).
:-include('menu.pl').
:-include('utils.pl').

%CONVERTS the list symbol to the board symbol
convert(X,X).

%PRINT_BOARD
p_u:- write('  ___ ___ ___ ___ ___ ___ '), nl.
p_s:- write(' |___|___|___|___|___|___|'), nl.
p_m([],_).
p_m([L|T],C):- write(C), C1 is C+1, p_l(L), p_m(T,C1).
p_l([C|[]]):- convert(C,S),write('| '), write(S), write(' |'), nl, p_s.
p_l([C|T]):- convert(C,S),write('| '), write(S), write(' '), p_l(T).
printBoard(Board):- p_u, p_m(Board,1).


maplistelem(Pos, Xs, Ys) :-
        (   foreach(X,Xs),
          	foreach(Y,Ys),
          	param(element)
        do  call(element, Pos, X, Y)
        ).

/*
element(Block1Idx,Col1,0),
	element(Block2Idx,Col1,0),
	Block1Idx #\= Block2Idx,
*/

defDomain([]).

defDomain([H|T]):-
	domain(H,0,4),
	defDomain(T).
	
labelMatrix([],[]).

labelMatrix([H|T],[H|T2]):-
	labeling([all],H),
	labelMatrix(T,T2).
	

aut(Vars, Sum) :-
	automaton(Vars,_, Vars, 
	[source(q0), sink(q2)],
	[arc(q0,0,q1), arc(q0,1,q0), arc(q0,2,q0), arc(q0,3,q0), arc(q0,4,q0), 
	 arc(q1,0,q2), arc(q1,1,q1,[C+1]), arc(q1,2,q1,[C+2]), arc(q1,3,q1,[C+3]), arc(q1,4,q1,[C+4]),
     arc(q2,1,q2), arc(q2,2,q2), arc(q2,3,q2), arc(q2,4,q2)],
	[C],[0],[Sum]).	
	
getCellsInBetween(_,StartIdx,StartIdx,[]).
	
getCellsInBetween(Row,StartIdx,EndIdx,[Cell|OtherCells]):-
	NextIdx #= StartIdx + 1,
	/*write(NextIdx),nl,*/
	element(NextIdx,Row,Cell),
	getCellsInBetween(Row,NextIdx,EndIdx,OtherCells).
	
getCellsNotBlocks(_,StartIdx,StartIdx,_,_,[]).

getCellsNotBlocks(Row,StartIdx,EndIdx,Block1Idx,Block2Idx,[Cell|OtherCells]):-
	StartIdx #\= Block1Idx,
	StartIdx #\= Block2Idx,
	element(StartIdx,Row,Cell),
	NextIdx #= StartIdx + 1,
	write(NextIdx),nl,
	getCellsNotBlocks(Row,NextIdx,EndIdx,Block1Idx,Block2Idx,OtherCells).
	
getCellsNotBlocks(Row,StartIdx,EndIdx,Block1Idx,Block2Idx,Cells):-
	NextIdx #= StartIdx + 1,
	getCellsNotBlocks(Row,NextIdx,EndIdx,Block1Idx,Block2Idx,Cells).
	
restrictRows([],[]).

restrictRows([Row|OtherRows], [Value|OtherValues]):-
	nvalue(5,Row),
	aut(Row, Value),
	
	/*
	count(0,Row,#=,2),
	element(Block1Idx,Row,0),
	element(Block2Idx,Row,0),
	Block1Idx #< Block2Idx,
	
	
	
	getCellsInBetween(Row,Block1Idx,Block2Idx,CellsInBetween),
	sum(CellsInBetween,#=,Value),
	
	getCellsNotBlocks(Row,1,5,Block1Idx,Block2Idx,CellsNotBlocks),
	all_distinct(CellsNotBlocks),
	*/
	
	restrictRows(OtherRows,OtherValues).

restrictColumnsIdx(Matrix,Values):-
	restrictColumns(Matrix,1,Values).
	
restrictColumns(_,_,[_|[]]).

restrictColumns(Matrix, ColIndex, [Value|OtherValues]):-
	maplistelem(ColIndex,Matrix,Col),
	nvalue(5,Col),
	
	aut(Col, Value),
	/*
	count(0,Col,#=,2),
	element(Block1Idx,Col,0),
	element(Block2Idx,Col,0),
	Block1Idx #< Block2Idx,
	
	getCellsInBetween(Col,Block1Idx,Block2Idx,CellsInBetween),
	sum(CellsInBetween,#=,Value),
	
	getCellsNotBlocks(Col,1,5,Block1Idx,Block2Idx,CellsNotBlocks),
	all_distinct(CellsNotBlocks),
	*/
	
	NextIdx #= ColIndex + 1,
	restrictColumns(Matrix, NextIdx,OtherValues).
	
doppelblock(N,Rows,Columns):-
	length(Row1,6),
	length(Row2,6),
	length(Row3,6),
	length(Row4,6),
	length(Row5,6),
	length(Row6,6),
	Matrix = [Row1,Row2,Row3,Row4,Row5,Row6],
	/*
	domain(Row1,0,4),
	domain(Row2,0,4),
	domain(Row3,0,4),
	domain(Row4,0,4),
	domain(Row5,0,4),
	domain(Row6,0,4),
	MaxDomain #= N - 2,
	write(MaxDomain),
	defDomain(MaxDomain, Matrix),
	*/
	defDomain(Matrix),
	/*maplistelem(1,Matrix,Col1),
	count(0, Col1, #=, 2),
	element(1,Row1,4),
	all_distinct(Row1),*/
	restrictRows(Matrix, Rows),
	restrictColumnsIdx(Matrix,Columns),
	labelMatrix(Matrix,Res),write(Res),nl,nl,printBoard(Res).
	

at_most_two_consecutive_ones(Vars) :-
	automaton(Vars,[ source(n),sink(n),sink(n1),sink(n2) ],
	[ arc(n, 0, n),arc(n, 1, n1),arc(n1, 1, n2),arc(n1, 0, n), arc(n2, 0, n) ]).

	
