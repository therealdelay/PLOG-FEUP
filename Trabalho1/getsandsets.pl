%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% GETS AND SETS %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

getBoard(Game, Board):-
	selectAtIndex(Game, 1, Board).

setBoard(Game, Board, GameRes):-
	replaceAtIndex(Game, 1, Board, GameRes).

getBoardCell(Game, X, Y, BoardCell):-
	getBoard(Game, Board),
	selectPos(Board, X, Y, BoardCell).

setBoardCell(Game, X, Y, BoardCell, GameRes):-
	getBoard(Game, Board),
	replacePiece(Board,X, Y, BoardCell, BoardRes),
	setBoard(Game, BoardRes, GameRes).

nextPlayer(Current, Next):-
	ite(Current == whitePlayer, Next = blackPlayer, Next = whitePlayer).

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
	
getScore(Info, Score):-
	selectAtIndex(Info, 3, Score).

setRegPieces(Info, NewPieces, NewInfo):-
	replaceAtIndex(Info, 1, NewPieces, NewInfo).

setHengePieces(Info, NewPieces, NewInfo):-
	replaceAtIndex(Info, 2, NewPieces, NewInfo).
	
setScore(Info, NewScore, NewInfo):-
	replaceAtIndex(Info, 3, NewScore, NewInfo).

decRegPieces(Info, NewInfo):-
	getRegPieces(Info, Old),
	New is Old-1,
	setRegPieces(Info, New, NewInfo).
	
incRegPieces(Info, NewInfo):-
	getRegPieces(Info, Old),
	New is Old+1,
	setRegPieces(Info, New, NewInfo).

decHengePieces(Info, NewInfo):-
	getHengePieces(Info, Old),
	New is Old-1,
	setHengePieces(Info, New, NewInfo).
	
incHengePieces(Info, NewInfo):-
	getHengePieces(Info, Old),
	New is Old+1,
	setHengePieces(Info, New, NewInfo).

decScore(Info, NewInfo):-
	getScore(Info, Old),
	New is Old-1,
	setScore(Info, New, NewInfo).

incScore(Info, NewInfo):-
	getScore(Info, Old),
	New is Old+1,
	setScore(Info, New, NewInfo).
	

%WHITE_INTERFACE	
decWhiteRegPieces(Game, GameRes):-
	getWhiteInfo(Game,Info),
	decRegPieces(Info, NewInfo),
	setWhiteInfo(Game, NewInfo).
	
incWhiteRegPieces(Game, GameRes):-
	getWhiteInfo(Game,Info),
	incRegPieces(Info, NewInfo),
	setWhiteInfo(Game, NewInfo).

decWhiteHengePieces(Info, NewInfo):-
	getWhiteInfo(Game,Info),
	decHengePieces(Info, NewInfo),
	setWhiteInfo(Game, NewInfo).
	
incWhiteHengePieces(Info, NewInfo):-
	getWhiteInfo(Game,Info),
	incHengePieces(Info, NewInfo),
	setWhiteInfo(Game, NewInfo).

decWhiteScore(Info, NewInfo):-
	getWhiteInfo(Game,Info),
	decScore(Info, NewInfo),
	setWhiteInfo(Game, NewInfo).

incWhiteScore(Info, NewInfo):-
	getWhiteInfo(Game,Info),
	incScore(Info, NewInfo),
	setWhiteInfo(Game, NewInfo).
	
	
%BLACK_INTERFACE	
decBlackRegPieces(Game, GameRes):-
	getBlackInfo(Game,Info),
	decRegPieces(Info, NewInfo),
	setBlackInfo(Game, NewInfo).
	
incBlackRegPieces(Game, GameRes):-
	getBlackInfo(Game,Info),
	incRegPieces(Info, NewInfo),
	setBlackInfo(Game, NewInfo).

decBlackHengePieces(Info, NewInfo):-
	getBlackInfo(Game,Info),
	decHengePieces(Info, NewInfo),
	setBlackInfo(Game, NewInfo).
	
incBlackHengePieces(Info, NewInfo):-
	getBlackInfo(Game,Info),
	incHengePieces(Info, NewInfo),
	setBlackInfo(Game, NewInfo).

decBlackScore(Info, NewInfo):-
	getBlackInfo(Game,Info),
	decScore(Info, NewInfo),
	setBlackInfo(Game, NewInfo).

incBlackScore(Info, NewInfo):-
	getBlackInfo(Game,Info),
	incScore(Info, NewInfo),
	setBlackInfo(Game, NewInfo).

getMode(Game, Mode):-
	selectAtIndex(Game, 5, Mode).
