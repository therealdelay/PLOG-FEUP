:-use_module(library(lists)).
:-use_module(library(clpfd)).



reset_timer :- statistics(walltime,_).	
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.

%CONVERTS the list symbol to the board symbol
convert(X,X).

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

p_u:- write('  ___ ___ ___ ___ ___ ___ '), nl.
p_s:- write(' |___|___|___|___|___|___|'), nl.

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


maplistelem(Pos, Xs, Ys) :-
    (   foreach(X,Xs),
        foreach(Y,Ys),
        param(element)
    do  call(element, Pos, X, Y)
    ).

createMatrix(N, N, []).

createMatrix(N, RowIdx, [Row|OtherRows]):-
	length(Row,N),
	NextRowIdx #= RowIdx + 1,
	createMatrix(N, NextRowIdx, OtherRows).

	
defNDomain(N, Matrix):-
	Max #= N-2,
	defDomain(Max, Matrix).
	
defDomain(_, []).

defDomain(Max, [H|T]):-
	domain(H,0,Max),
	defDomain(Max, T).
	
labelMatrix([],[]).

labelMatrix([H|T],[H|T2]):-
	labeling([],H),
	labelMatrix(T,T2).
	

/* AUTOMATON */

createArc(Src, Dest, Val, true, Counter, Arc):-
	Arc = arc(Src,Val,Dest,[Counter+Val]).
	
createArc(Src, Dest, Val, false,_,Arc):-
	Arc = arc(Src,Val,Dest).
	
createArcs(Src, Dest, Max, WithCounter, Counter, Arcs):-
	createArc(Src,Dest,0,false,_,ToDestArc),
	ArcToDest = [ToDestArc],
	createSelfArcs(Src, Max, 1, WithCounter,Counter,SelfArcs),
	append(ArcToDest, SelfArcs, Arcs).
	
createSelfArcs(Src, Max, Max, WithCounter, Counter, [Last]):-
	createArc(Src,Src,Max,WithCounter,Counter,Last).
	
createSelfArcs(Src, Max, Curr, WithCounter,Counter,[Arc|Others]):-
	createArc(Src,Src,Curr,WithCounter,Counter,Arc),
	Next #= Curr + 1,
	createSelfArcs(Src,Max,Next,WithCounter,Counter,Others).
	
createAllArcs(Max,Counter,Arcs):-
	createArcs(q0,q1,Max,false,_,Q0Arcs),
	createArcs(q1,q2,Max,true,Counter,Q1Arcs),
	createSelfArcs(q2,Max,1,false,_,Q2Arcs),
	append(Q0Arcs,Q1Arcs,TmpArcs),
	append(TmpArcs,Q2Arcs,Arcs), !.

restrictLine(Vars, Max, Sum):-
	createAllArcs(Max,C,Arcs),
	automaton(Vars, _, Vars, [source(q0), sink(q2)], Arcs, [C], [0], [Sum]).
	
/*	
testThing(Vars, Max, DiffValues, Sum):-
	createAllArcs(Max,C,Arcs),
	write(Arcs),
	tRestrictLine(Vars,Max, DiffValues, Sum, C, Arcs).
	
tRestrictLine(Vars, Max, DiffValues, Sum, C, Arcs):-
	domain(Vars,0,Max),
	nvalue(DiffValues,Vars),
	automaton(Vars, _, Vars, [source(q0), sink(q2)], Arcs, [C], [0], [Sum]),
	labeling([],Vars).
	
aut(Vars, Sum) :-
	automaton(Vars,_, Vars, 
	[source(q0), sink(q2)],
	[arc(q0,0,q1), arc(q0,1,q0), arc(q0,2,q0), arc(q0,3,q0), arc(q0,4,q0), 
	 arc(q1,0,q2), arc(q1,1,q1,[C+1]), arc(q1,2,q1,[C+2]), arc(q1,3,q1,[C+3]), arc(q1,4,q1,[C+4]),
     arc(q2,1,q2), arc(q2,2,q2), arc(q2,3,q2), arc(q2,4,q2)],
	[C],[0],[Sum]).
	
aut(Vars, Sum) :- 
	domain(Vars, 0, 1), 
	nvalue(2, Vars), 
	automaton(Vars,_, Vars, 
			 [source(q0), sink(q2)], 
			 [arc(q0,0,q1), arc(q0,1,q0), 
			  arc(q1,0,q2), arc(q1,1,q1,[C+1]), 
			  arc(q2,1,q2)], 
			  [C],[0],[Sum]), 
	labeling([],Vars), write(Vars),
*/
	
	
restrictRows([],[],_,_).

restrictRows([Row|OtherRows], [Value|OtherValues], DiffValues, DomainMax):-
	nvalue(DiffValues,Row),
	restrictLine(Row,DomainMax,Value),
	/*global_cardinality(Row,[0-2,1-1,2-1,3-1,4-1]),*/
	restrictRows(OtherRows,OtherValues,DiffValues,DomainMax).

restrictColumnsIdx(Matrix, Values, DiffValues, DomainMax):-
	restrictColumns(Matrix,1,Values,DiffValues,DomainMax).
	
restrictColumns(_,_,[_|[]],_,_).

restrictColumns(Matrix, ColIndex, [Value|OtherValues], DiffValues, DomainMax):-
	maplistelem(ColIndex,Matrix,Col),
	nvalue(DiffValues,Col),
	restrictLine(Col,DomainMax,Value),
	NextIdx #= ColIndex + 1,
	restrictColumns(Matrix, NextIdx,OtherValues,DiffValues,DomainMax).


doppelblock(N,Rows,Columns):-
	createMatrix(N, 0, Matrix),
	defNDomain(N,Matrix),
	DiffValues #= N-1,
	DomainMax #= N-2,
	restrictRows(Matrix,Rows,DiffValues,DomainMax),
	restrictColumnsIdx(Matrix,Columns,DiffValues,DomainMax),
	reset_timer,
	labelMatrix(Matrix,Res),printBoard(Res),
	print_time,
	fd_statistics.
