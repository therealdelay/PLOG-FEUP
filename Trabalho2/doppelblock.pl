:-use_module(library(lists)).
:-use_module(library(clpfd)).
:-use_module(library(random)).
:-use_module(library(between)).
:-include('menu.pl').
:-include('utils.pl').
:-include('doppel.pl').

%GENERATE
	
generateDoppel(N,Res):-
	ColsLength is N+1,
	length(Rows,N),
	length(Columns,ColsLength),
	doppelblock(N,Rows,Columns,Sol),
	last(CleanCols,_,Columns),
	Res = [N,Rows,CleanCols,Sol].
	
getRandomDoppel(N,Doppel):-
	find_n(100,Res,generateDoppel(N,Res),Doppels),
	random_member(Doppel,Doppels).
	

%SOLVE

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
	labeling([bisect, down],H),
	labelMatrix(T,T2).
	

%AUTOMATON

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
	
%CARDINALITY

createCardinalityRestraints(MaxDomain,MaxDomain,[Card]):-
	Card = MaxDomain-1.
	
createCardinalityRestraints(0,MaxDomain,[Card|Others]):-
	Card = 0-2,
	createCardinalityRestraints(1,MaxDomain,Others).

createCardinalityRestraints(Val,MaxDomain,[Card|Others]):-
	Card = Val-1,
	NextVal #= Val+1,
	createCardinalityRestraints(NextVal,MaxDomain,Others).

createCardinalityRestraints(DomainMax, Cardinality):-
	createCardinalityRestraints(0,DomainMax,Cardinality).
	

%RESTRICTIONS
	
restrictLine(Vars, Max, Sum):-
	createAllArcs(Max,C,Arcs),
	automaton(Vars, _, Vars, [source(q0), sink(q2)], Arcs, [C], [0], [Sum]).
		
restrictRows([],[],_,_,_).

restrictRows([Row|OtherRows], [Value|OtherValues], DiffValues, DomainMax, Cardinality):-
	global_cardinality(Row, Cardinality),
	restrictLine(Row,DomainMax,Value),
	restrictRows(OtherRows,OtherValues,DiffValues,DomainMax, Cardinality).

restrictColumns(Matrix, Values, DiffValues, DomainMax,Cardinality):-
	restrictColumnsIdx(Matrix,1,Values,DiffValues,DomainMax,Cardinality).
	
restrictColumnsIdx(_,_,[_|[]],_,_,_).

restrictColumnsIdx(Matrix, ColIndex, [Value|OtherValues], DiffValues, DomainMax, Cardinality):-
	maplistelem(ColIndex,Matrix,Col),
	global_cardinality(Col,Cardinality),
	restrictLine(Col,DomainMax,Value),
	NextIdx #= ColIndex + 1,
	restrictColumnsIdx(Matrix, NextIdx,OtherValues,DiffValues,DomainMax,Cardinality).


doppelblock(N,Rows,Columns,Res):-
	createMatrix(N, 0, Matrix),
	defNDomain(N,Matrix),
	DiffValues #= N-1,
	DomainMax #= N-2,
	createCardinalityRestraints(DomainMax,Cardinality),
	restrictRows(Matrix,Rows,DiffValues,DomainMax,Cardinality),
	restrictColumns(Matrix,Columns,DiffValues,DomainMax,Cardinality),
	reset_timer,
	labelMatrix(Matrix,Res).
