%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% DOPPEL %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

createDoppel(Size,Rows,Columns,Doppel):-
	Doppel = [Size,Rows,Columns,_].

getDoppelMatrix(Doppel,Matrix):-
	selectAtIndex(Doppel,4,Matrix).
	
getDoppelColumns(Doppel,Columns):-
	selectAtIndex(Doppel,3,Columns).
	
getDoppelRows(Doppel,Rows):-
	selectAtIndex(Doppel,2,Rows).
	
getDoppelSize(Doppel,Size):-
	selectAtIndex(Doppel,1,Size).