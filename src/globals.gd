extends Node


const CELL_SIZE = 100

enum PLAYER {
	ONE, TWO
}

enum COLORS {
	BLACK, WHITE
}

enum PIECE_TYPES {
	ROOK,
	KNIGHT,
	BISHOP,
	QUEEN,
	KING,
	PAWN,
}


const SPRITE_MAPPING = {
	COLORS.BLACK : {
		PIECE_TYPES.ROOK : "res://pieces/blackRook.png",
		PIECE_TYPES.BISHOP : "res://pieces/blackBishop.png",
		PIECE_TYPES.KNIGHT : "res://pieces/blackKnight.png",
		PIECE_TYPES.QUEEN : "res://pieces/blackQueen.png" ,
		PIECE_TYPES.KING : "res://pieces/blackKing.png" ,
		PIECE_TYPES.PAWN : "res://pieces/blackPawn.png"
	},
	COLORS.WHITE : {
		PIECE_TYPES.ROOK : "res://pieces/whiteRook.png",
		PIECE_TYPES.BISHOP : "res://pieces/whiteBishop.png",
		PIECE_TYPES.KNIGHT : "res://pieces/whiteKnight.png",
		PIECE_TYPES.QUEEN : "res://pieces/whiteQueen.png" ,
		PIECE_TYPES.KING : "res://pieces/whiteKing.png" ,
		PIECE_TYPES.PAWN : "res://pieces/whitePawn.png"
	}
}

enum TARGETS {
	ROW,
	COLUMN,
	PIECE,
	ENEMY_PIECE,
	FRIENDLY_PIECE,
	SQUARE,
	NONE
}



const INITIAL_PIECE_SET_SINGLE = [
	[PIECE_TYPES.ROOK, 0, 0],
	[PIECE_TYPES.KNIGHT, 4, 0],
	[PIECE_TYPES.BISHOP, 1, 0],
	[PIECE_TYPES.QUEEN, 2, 0],
	[PIECE_TYPES.KING, 3, 0],
	#[PIECE_TYPES.BISHOP, 5, 0],
	#[PIECE_TYPES.KNIGHT, 6, 0],
	#[PIECE_TYPES.ROOK, 7, 0],
	[PIECE_TYPES.PAWN, 0, 1],
	[PIECE_TYPES.PAWN, 1, 1],
	[PIECE_TYPES.PAWN, 2, 1],
	[PIECE_TYPES.PAWN, 3, 1],
	[PIECE_TYPES.PAWN, 4, 1],
	#[PIECE_TYPES.PAWN, 5, 1],
	#[PIECE_TYPES.PAWN, 6, 1],
	#[PIECE_TYPES.PAWN, 7, 1]
]
