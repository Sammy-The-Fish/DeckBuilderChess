class_name CardStats
extends Resource




@export var id: int
@export var mana_cost:int
@export var desc: String
@export var card_name: String
@export var sprite_path: String
@export var target_type: Globals.TARGETS
@export var target_quantity : int


func _init(pid, pmana_cost, pdesc, pcard_name, psprite_path, ptarget, ptarget_quantity) -> void:
	id = pid
	mana_cost = pmana_cost
	desc = pdesc
	card_name = pcard_name
	sprite_path = psprite_path
	target_type = ptarget
	target_quantity = ptarget_quantity
