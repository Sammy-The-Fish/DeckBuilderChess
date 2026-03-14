extends Node

# list of card names in all caps seperated by commas
enum CARDS {
	JUMP
}

# dictionay of CARDS to CardStat objects
var cardList = {
	CARDS.JUMP : CardStats.new(CARDS.JUMP, 3, "this is jymp", "Jump", "res://...", Globals.TARGETS.PIECE, 1)
}
