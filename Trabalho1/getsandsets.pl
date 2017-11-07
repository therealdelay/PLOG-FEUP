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

getNextPlayer(Current, Next):-
	ite(Current == whitePlayer, Next = blackPlayer, Next = whitePlayer).
	
getOpponent(Game,Opponent):-
	getCurrentPlayer(Game,Player),
	getNextPlayer(Player,Opponent).

getCurrentPlayer(Game,CurPlayer):-
	selectAtIndex(Game, 4, CurPlayer).

setCurrentPlayer(Game, CurPlayer, GameRes):-
	replaceAtIndex(Game, 4, CurPlayer, GameRes).
	
setNextPlayer(Game, GameRes):-
	getCurrentPlayer(Game,Current),
	getNextPlayer(Current,Next),
	setCurrentPlayer(Game,Next,GameRes).

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
	
getPlayerType(Info, PlayerType):-
	selectAtIndex(Info, 4, PlayerType).
	
setRegPieces(Info, NewPieces, NewInfo):-
	replaceAtIndex(Info, 1, NewPieces, NewInfo).

setHengePieces(Info, NewPieces, NewInfo):-
	replaceAtIndex(Info, 2, NewPieces, NewInfo).
	
setScore(Info, NewScore, NewInfo):-
	replaceAtIndex(Info, 3, NewScore, NewInfo).
	
setPlayerType(Info, NewPlayerType, NewInfo):-
	replaceAtIndex(Info, 4, NewPlayerType, NewInfo).

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

getPlayerInfo(Game,Player,Info):-
	ite(Player == whitePlayer, getWhiteInfo(Game,Info), getBlackInfo(Game,Info)).
	
setPlayerInfo(Game,Player,Info,GameRes):-
	ite(Player == whitePlayer, setWhiteInfo(Game,Info,GameRes), setBlackInfo(Game,Info,GameRes)).
	
%WHITE_INTERFACE
decWhiteRegPieces(Game, GameRes):-
	getWhiteInfo(Game,Info),
	decRegPieces(Info, NewInfo),
	setWhiteInfo(Game, NewInfo, GameRes).
	
incWhiteRegPieces(Game, GameRes):-
	getWhiteInfo(Game,Info),
	incRegPieces(Info, NewInfo),
	setWhiteInfo(Game, NewInfo, GameRes).

decWhiteHengePieces(Game, GameRes):-
	getWhiteInfo(Game,Info),
	decHengePieces(Info, NewInfo),
	setWhiteInfo(Game, NewInfo, GameRes).
	
incWhiteHengePieces(Game, GameRes):-
	getWhiteInfo(Game,Info),
	incHengePieces(Info, NewInfo),
	setWhiteInfo(Game, NewInfo, GameRes).

decWhiteScore(Game, GameRes):-
	getWhiteInfo(Game,Info),
	decScore(Info, NewInfo),
	setWhiteInfo(Game, NewInfo, GameRes).

incWhiteScore(Game, GameRes):-
	getWhiteInfo(Game,Info),
	incScore(Info, NewInfo),
	setWhiteInfo(Game, NewInfo, GameRes).
	
	
%BLACK_INTERFACE	
decBlackRegPieces(Game, GameRes):-
	getBlackInfo(Game,Info),
	decRegPieces(Info, NewInfo),
	setBlackInfo(Game, NewInfo, GameRes).
	
incBlackRegPieces(Game, GameRes):-
	getBlackInfo(Game,Info),
	incRegPieces(Info, NewInfo),
	setBlackInfo(Game, NewInfo, GameRes).

decBlackHengePieces(Game, GameRes):-
	getBlackInfo(Game,Info),
	decHengePieces(Info, NewInfo),
	setBlackInfo(Game, NewInfo, GameRes).
	
incBlackHengePieces(Game, GameRes):-
	getBlackInfo(Game,Info),
	incHengePieces(Info, NewInfo),
	setBlackInfo(Game, NewInfo, GameRes).

decBlackScore(Game, GameRes):-
	getBlackInfo(Game,Info),
	decScore(Info, NewInfo),
	setBlackInfo(Game, NewInfo, GameRes).

incBlackScore(Game, GameRes):-
	getBlackInfo(Game,Info),
	incScore(Info, NewInfo),
	setBlackInfo(Game, NewInfo, GameRes).
	

getMode(Game, Mode):-
	selectAtIndex(Game, 5, Mode).

		
createPlay(X,Y,Type,Play):-
	createPoint2D(X,Y,Point),
	Play = [Point,Type].

getPlayPoint(Play, Point):-
	selectAtIndex(Play,1,Point).
	
getPlayXCoord(Play,X):-
	getPlayPoint(Play,Point),
	getPoint2DXCoord(Point,X).
	
getPlayYCoord(Play,Y):-
	getPlayPoint(Play,Point),
	getPoint2DYCoord(Point,Y).

getPlayType(Play,Type):-
	selectAtIndex(Play,2,Type).
	
getPlayPiece(Game,Play,Piece,GameRes):-
	getCurrentPlayer(Game,Player),
	getPlayType(Play,Type),
	ite(Player == whitePlayer,
		ite(Type == 'h',
			(Piece = 3, decWhiteHengePieces(Game,GameRes)),
			
			(Piece = 2, decWhiteRegPieces(Game,GameRes))
		),
		
		ite(Type == 'h',
			(Piece = 3, decBlackHengePieces(Game,GameRes)),
			
			(Piece = 1, decBlackRegPieces(Game,GameRes))
		)
	).

