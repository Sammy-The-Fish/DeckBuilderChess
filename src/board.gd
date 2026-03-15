extends Node2D


@export var pieces = [];

@export var piece_scene = preload("res://src/piece.tscn")
@export var white_king_pos: Vector2
@export var black_king_pos: Vector2

@export var white_cell_color: Color = Color("#AAAAAA")
@export var black_cell_color: Color = Color("#222222")
@export var frozen_cell_color: Color = Color("86c3feff")

const CELL_SIZE = Globals.CELL_SIZE
const rows = 6
const collums = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_board()
	init_pieces()


func draw_board():
	for x in range(collums):
		for y in range(rows):
				draw_cell(x, y)
			
			
func draw_cell(x: int, y: int):
	var rect = ColorRect.new()
	var color = ((x+y) % 2) == 0
	
	rect.color = black_cell_color if color else white_cell_color
	
	rect.size = Vector2(CELL_SIZE, CELL_SIZE)
	rect.position = Vector2(x * CELL_SIZE, y * CELL_SIZE)
	rect.z_index = -10
	add_child(rect)
	
	
func init_pieces():
	for piece_tuple in Globals.INITIAL_PIECE_SET_SINGLE:
		var piece_type = piece_tuple[0]
		var black_piece_pos = Vector2(piece_tuple[1], piece_tuple[2])
		var white_piece_pos = Vector2(piece_tuple[1], rows -  1 - piece_tuple[2])
		
		# Create black piece
		var black_piece = piece_scene.instantiate()
		add_child(black_piece)
		black_piece.init_piece(
			piece_type,
			Globals.COLORS.BLACK,
			black_piece_pos,
			self
		)
		pieces.append(black_piece)
		
		# Create white piece
		var white_piece = piece_scene.instantiate()
		add_child(white_piece)
		white_piece.init_piece(
			piece_type,
			Globals.COLORS.WHITE,
			white_piece_pos,
			self
		)
		pieces.append(white_piece)
		
		if piece_type == Globals.PIECE_TYPES.KING:
			register_king(white_piece_pos, Globals.COLORS.WHITE)
			register_king(black_piece_pos, Globals.COLORS.BLACK)
			



func get_piece(pos: Vector2):
	for piece in pieces:
		if piece.board_position == pos:
			return piece

func set_piece(pos: Vector2, piece) -> void:
	piece.board_position = pos

func get_pos_under_mouse():
	var pos = get_global_mouse_position()
	pos.x = int((pos.x - position.x) / Globals.CELL_SIZE)
	pos.y = int((pos.y - position.y) / Globals.CELL_SIZE)
	if (pos.x < 0 || pos.x > collums):
		return null
	if (pos.y <0 || pos.y > rows):
		return null
	return pos


func delete_piece(piece):
	for i in range(len(pieces)):
		if pieces[i] == piece:
			var popped = pieces.pop_at(i)
			popped.queue_free()
			return

func clone():
	var board = self.duplicate()
	for i in range(len(pieces)):
		var piece = pieces[i].clone(board)
		board.pieces[i] = piece
	return board


func register_king(pos, col):
	match col:
		Globals.COLORS.WHITE:
			white_king_pos = pos
		Globals.COLORS.BLACK:
			black_king_pos = pos
			
			
	
# searching 
func spot_search_threat(
	own_color, 
	cur_x, cur_y, 
	inc_x, inc_y,
	threat_only = false, free_only = false
):
	# Do a single move and check if move is valid or threatens a piece
	cur_x += inc_x
	cur_y += inc_y
	
	if cur_x >= rows or cur_x < 0 or cur_y >= collums or cur_y < 0: #CHECK THIS PLEASE GOD
		return
	
	var cur_pos = Vector2(cur_x, cur_y)
	var cur_piece = get_piece(cur_pos)
	
	if cur_piece != null:
		if free_only:
			return
		return cur_pos if cur_piece.color != own_color else null
	return cur_pos if not threat_only else null


func beam_search_threat(own_color, cur_x, cur_y, inc_x, inc_y):
	# Moves a pointer in a line in given inc_x/y direction
	# to find the thratened pieces
	var threat_pos = []
	
	cur_x += inc_x
	cur_y += inc_y
	
	# Keep moving in increment direction to find either a blocked pieces
	# or out of board
	while cur_x >= 0 and cur_x < 5 and cur_y >= 0 and cur_y < 6:
		var cur_pos = Vector2(cur_x, cur_y)
		var cur_piece = get_piece(cur_pos)
		if cur_piece != null:
			if cur_piece.color != own_color:
				threat_pos.append(cur_pos)
			break
		threat_pos.append(cur_pos)
		cur_x += inc_x
		cur_y += inc_y
	
	return threat_pos
	
var grid = []

func electricute(x, y) -> void:
	if (grid == []):
		grid.resize(5)
		for i in range(5):
			grid[i] = []
			grid[i].resize(6)
	
	grid[x][y] = true;
	
func getElectricute(x, y) -> bool:
	return grid[x][y];
	
func deElectricute(x, y) -> void:
	grid[x][y] = false;
