extends Node

# list of card names in all caps seperated by commas
enum CARDS {
	JUMP
}

# dictionay of CARDS to CardStat objectsl
var cardList = {
	CARDS.JUMP : CardStats.new(CARDS.JUMP, 3, "this is jymp", "Jump", "res://cards/Jump.png", Globals.TARGETS.PIECE, 1)
}
