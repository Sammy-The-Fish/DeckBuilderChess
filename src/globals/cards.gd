extends Node

# list of card names in all caps seperated by commas
enum CARDS {
	#JUMP,
	ASSASSINATE,
	ELECTROCUTE,
	#FREEZE,
	#HARDCOREPAWN,
	#NUDGE,
	POTOGREED,
	#REANIMATE,
	#EBIRTH,
	RITUAL,
	SACRIFICE,
	#SHIELDWALL,
	#SPEAR,
	#SWAP,
	#TRIP
}

# dictionay of CARDS to CardStat objects
var cardList = {
	#CARDS.JUMP : CardStats.new(CARDS.JUMP, 2, "Ignore all units when moving this turn, must end in a empty space", "Jump", "res://cards/Jump.png", Globals.TARGETS.FRIENDLY_PIECE, 1),
	CARDS.ASSASSINATE : CardStats.new(CARDS.ASSASSINATE, -1, "If one of your units could move and kill this piece this turn, instead kill it instantly. X is piece's value", "Assassinate", "res://cards/AssassinateFinal.png", Globals.TARGETS.PIECE, 1),
	CARDS.ELECTROCUTE : CardStats.new(CARDS.ELECTROCUTE, 3, "Choose target tile, at the beginning of your next turn, if a unit is on this tile it is destroyed. This includes your own pieces", "Electrocute", "res://cards/electrocuteFinal.png", Globals.TARGETS.SQUARE, 1),
	#CARDS.FREEZE : CardStats.new(CARDS.FREEZE, 3, "Choose target enemy piece, until your next turn that piece cannot be moved", "Freeze", "res://cards/Freeze.png", Globals.TARGETS.ENEMY_PIECE, 1),
	#CARDS.HARDCOREPAWN : CardStats.new(CARDS.HARDCOREPAWN, 2, "Target pawn you control can move and take as if it were a king this turn", "Hardcore Pawn", "res://cards/hardcorepawn.png", Globals.TARGETS.FRIENDLY_PIECE, 1),
	#CARDS.NUDGE : CardStats.new(CARDS.NUDGE, 2, "Target friendly piece can move into one adjacent empty horizontol or vertical tile", "Nudge", "res://cards/nudgeFinal.png", Globals.TARGETS.FRIENDLY_PIECE, 1),
	CARDS.POTOGREED : CardStats.new(CARDS.POTOGREED, 2, "Draw two cards. Legally distinct entity and completely different from Pot Of Greed", "Pot Of Greed", "res://cards/potogreed.png", Globals.TARGETS.NONE, 0),
	#CARDS.REANIMATE : CardStats.new(CARDS.REANIMATE, -1, "Bring one of your dead pieces back on your back rank. Must have valid location to place. X is piece's value", "Reanimate", "res://cards/reanimate.png", Globals.TARGETS.SQUARE, 1),
	#CARDS.REBIRTH : CardStats.new(CARDS.REBIRTH, -1, "Convert one of your pawns into one of your dead pieces reborn! X is piece's value", "Rebirth", "res://cards/rebirth.png", Globals.TARGETS.FRIENDLY_PIECE, 1),
	CARDS.SACRIFICE : CardStats.new(CARDS.SACRIFICE, 0, "Sacrifice one of your pieces and gain X mana where X is the piece's mana value", "Sacrifice", "res://cards/Sacrifice.png", Globals.TARGETS.FRIENDLY_PIECE, 1),
	CARDS.RITUAL : CardStats.new(CARDS.RITUAL, 0, "End your turn instantly, not being able to play any more cards or make a chess move. However, on the beginning of your next turn gain however much energy you had when you play this card", "Ritual", "res://cards/ritualFinal.png", Globals.TARGETS.NONE, 0),
	#CARDS.SHIELDWALL : CardStats.new(CARDS.SHIELDWALL, 3, "Move up to three unique pawns this turn, if you play this you cannot move any other pieces this turn.", "Shield Wall", "res://cards/shieldwall.png", Globals.TARGETS.NONE, 0),
	#ARDS.SPEAR : CardStats.new(CARDS.SPEAR, 1, "Pawns can also take directly in front of them this turn", "Spear", "res://cards/spear.png", Globals.TARGETS.PIECE, 1),
	#CARDS.SWAP : CardStats.new(CARDS.SWAP, 5, "Switch any two pieces, however when you play this you cannot play any more cards this turn or make a chess move (End your turn instantly)", "Swap", "res://cards/swap.png", Globals.TARGETS.PIECE, 2),
	#CARDS.TRIP : CardStats.new(CARDS.TRIP, 2, "Target friendly piece can move into one adjacent empty diagonal tile", "Trip", "res://cards/tripFinal.png", Globals.TARGETS.FRIENDLY_PIECE, 1)
}
#Spelling mistake in ritual, instanly -> instantly
