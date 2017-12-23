:-use_module(library(lists)).
:-use_module(library(clpfd)).
:-use_module(library(random)).
:-use_module(library(between)).
:-include('menu.pl').
:-include('utils.pl').
:-include('doppel.pl').

%GENERATE

generateDoppel(4,Res):-
	length(Rows,4),
	length(Columns,5),
	doppelblock(4,Rows,Columns,false,Sol),
	last(CleanCols,_,Columns),
	Res = [4,Rows,CleanCols,Sol].
	
generateDoppel(N,Res):-
	ColsLength is N+1,
	length(Rows,N),
	length(Columns,ColsLength),
	doppelblock(N,Rows,Columns,true,Sol),
	last(CleanCols,_,Columns),
	Res = [N,Rows,CleanCols,Sol].
	
getRandomDoppel(N,Doppel):-
	ResultsScale is N-3,
	FilterScale is N-4,
	Results is round(exp(10,ResultsScale)),
	Filter is round(exp(10,FilterScale)),
	find_n(Results,Filter,Res,generateDoppel(N,Res),Doppels),
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
	
createNArcs(Src, Dest, Max, Max, WithCounter, Counter, [Last]):-
	createArc(Src,Dest,Max,WithCounter,Counter,Last).
	
createNArcs(Src, Dest, Max, Curr, WithCounter,Counter,[Arc|Others]):-
	createArc(Src,Dest,Curr,WithCounter,Counter,Arc),
	Next #= Curr + 1,
	createNArcs(Src,Dest,Max,Next,WithCounter,Counter,Others).
	
createNArcs(Src, Dest, Max, Curr, WithCounter,Counter,[Arc|Others]):-
	createArc(Src,Dest,Curr,WithCounter,Counter,Arc),
	Next #= Curr + 1,
	createNArcs(Src,Dest,Max,Next,WithCounter,Counter,Others).
	
createArcs(Src, Dest, Max, WithCounter, Counter, Arcs):-
	createArc(Src,Dest,0,false,_,ToDestArc),
	ArcToDest = [ToDestArc],
	createNArcs(Src, Src, Max, 1, WithCounter,Counter,SelfArcs),
	append(ArcToDest, SelfArcs, Arcs).
	
createSolveArcs(Max,Counter,Arcs):-
	createArcs(q0,q1,Max,false,_,Q0Arcs),
	createArcs(q1,q2,Max,true,Counter,Q1Arcs),
	createNArcs(q2,q2,Max,1,false,_,Q2Arcs),
	append(Q0Arcs,Q1Arcs,TmpArcs),
	append(TmpArcs,Q2Arcs,Arcs), !.
	
createGenerateArcs(Max,Counter,Arcs):-
	createArcs(q0,q1,Max,false,_,Q0Arcs),
	createNArcs(q1,q2,Max,1,true,Counter,Q1Arcs),
	createArcs(q2,q3,Max,true,Counter,Q2Arcs),
	createNArcs(q3,q3,Max,1,false,_,Q3Arcs),
	append(Q0Arcs,Q1Arcs,TmpArcs),
	append(TmpArcs,Q2Arcs,TmpArcs2), 
	append(TmpArcs2,Q3Arcs,Arcs), !.
	
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
	
restrictLine(Vars, Max, Sum, false):-
	createSolveArcs(Max,C,Arcs),
	automaton(Vars, _, Vars, [source(q0), sink(q2)], Arcs, [C], [0], [Sum]).
	
restrictLine(Vars, Max, Sum, true):-
	createGenerateArcs(Max,C,Arcs),
	automaton(Vars, _, Vars, [source(q0), sink(q3)], Arcs, [C], [0], [Sum]).
		
restrictRows([],[],_,_,_,_).

restrictRows([Row|OtherRows], [Value|OtherValues], DiffValues, DomainMax, Cardinality, Generate):-
	global_cardinality(Row, Cardinality),
	restrictLine(Row,DomainMax,Value,Generate),
	restrictRows(OtherRows,OtherValues,DiffValues,DomainMax,Cardinality,Generate).

restrictColumns(Matrix, Values, DiffValues, DomainMax,Cardinality,Generate):-
	restrictColumnsIdx(Matrix,1,Values,DiffValues,DomainMax,Cardinality,Generate).
	
restrictColumnsIdx(_,_,[_|[]],_,_,_,_).

restrictColumnsIdx(Matrix, ColIndex, [Value|OtherValues], DiffValues, DomainMax, Cardinality, Generate):-
	maplistelem(ColIndex,Matrix,Col),
	global_cardinality(Col,Cardinality),
	restrictLine(Col,DomainMax,Value,Generate),
	NextIdx #= ColIndex + 1,
	restrictColumnsIdx(Matrix, NextIdx,OtherValues,DiffValues,DomainMax,Cardinality,Generate).


doppelblock(N,Rows,Columns,Generate,Res):-
	createMatrix(N, 0, Matrix),
	defNDomain(N,Matrix),
	DiffValues #= N-1,
	DomainMax #= N-2,
	createCardinalityRestraints(DomainMax,Cardinality),
	restrictRows(Matrix,Rows,DiffValues,DomainMax,Cardinality,Generate),
	restrictColumns(Matrix,Columns,DiffValues,DomainMax,Cardinality,Generate),
	reset_timer,
	labelMatrix(Matrix,Res).
