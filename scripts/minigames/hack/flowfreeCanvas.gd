
extends Control

const Tile = preload("res://resources/scenes/minigames/hack/tile.tscn")
const Core = preload("res://resources/scenes/minigames/hack/core.tscn")

const tile_side = 60
const recoil = 10
const board_side = 340

## Paleta de cores pré-definidas
const DarkCyan = Color(0, 0.5, 0.5)
const Yellow = Color(1, 1, 0)
const White = Color(1, 1, 1)
const Red = Color(1, 0, 0)
const Gray = Color(0.5, 0.5, 0.5)
const Black = Color(0, 0, 0)

signal ended

class Stack:
	var vect = []
	func isEmpty():
		return vect.size() == 0
	func top():
		if vect.size() == 0:
			return null
		return vect[vect.size()-1]
	func first():
		if vect.size() == 0:
			return null
		return vect[0]
	func size():
		return vect.size()
	func push(item):
		vect.append(item)
	func pop():
		vect.remove(vect.size()-1)

var board = [[], [], [], [], []]
var boardCorners = [Vector2(0, 0), Vector2(0, board_side), Vector2(board_side, board_side), Vector2(board_side, 0)]
var activeTiles = [Stack.new(), Stack.new()]
var check = true
var mouse_color = White

func _ready():
	set_size(Vector2(board_side, board_side))
	get_node("Background").set_polygon(boardCorners)
	get_node("Background").set_color(DarkCyan)
	for i in range(5):
		for j in range(5):
			board[i].append(Tile.instance())
			board[i][j].set_pos(Vector2(i*(tile_side+5)+recoil, j*(tile_side+5)+recoil))
			add_child(board[i][j])
	board[0][3].queue_free()
	board[0][3] = Core.instance()
	board[0][3].set_pos(Vector2(recoil, 3*(tile_side+5)+recoil))
	board[0][3].set_color(Yellow)
	add_child(board[0][3])
	board[0][0].queue_free()
	board[0][0] = Core.instance()
	board[0][0].set_pos(Vector2(recoil, recoil))
	board[0][0].set_color(Yellow)
	add_child(board[0][0])
	board[0][4].queue_free()
	board[0][4] = Core.instance()
	board[0][4].set_pos(Vector2(recoil, 4*(tile_side+5)+recoil))
	board[0][4].set_color(Red)
	add_child(board[0][4])
	board[4][4].queue_free()
	board[4][4] = Core.instance()
	board[4][4].set_pos(Vector2(4*(tile_side+5)+recoil, 4*(tile_side+5)+recoil))
	board[4][4].set_color(Red)
	add_child(board[4][4])
	set_fixed_process(true)

func _fixed_process(delta):
	if is_solved():
		print("Gotcha")
		emit_signal("ended")
		set_fixed_process(false)
	if (Input.is_mouse_button_pressed(BUTTON_LEFT) == true):
		var i = 0
		var j = 0
		var last
		var cd
		var itIs = mouse_is_on_tile(i, j)
		while (itIs == false and i < 5):
			j = 0
			while (itIs == false and j < 5):
				itIs = mouse_is_on_tile(i, j)
				if (itIs == false):
					j += 1
			if (itIs == false):
				i += 1
		if (itIs == true and i < 5 and j < 5):
			if (board[i][j].get_color() == White and mouse_color == White):
				return
			elif (board[i][j].get_color() != White):
				mouse_color = board[i][j].get_color()
			cd = code(mouse_color)
			if (board[i][j].get_type() == "Tile" or activeTiles[cd].first() == Vector2(i, j)):
				while (board[i][j].get_color() != White and (not activeTiles[cd].isEmpty())):
					last = activeTiles[cd].top()
					if last != Vector2(i, j):
						if (board[last.x][last.y].get_type() != "Core"):
							board[last.x][last.y].set_color(White)
						activeTiles[cd].pop()
					else:
						break
			last = activeTiles[cd].top()
			if (activeTiles[cd].isEmpty() and board[i][j].get_type() == "Core"):
				activeTiles[cd].push(Vector2(i ,j))
			elif (activeTiles[cd].size() == 1 and activeTiles[cd].top() != Vector2(i, j)):
				if (board[i][j].get_type() == "Tile" and board[i][j].get_color() == White and is_the_next(i, j, cd)):
					board[i][j].set_color(mouse_color)
					activeTiles[cd].push(Vector2(i ,j))
				elif (board[i][j].get_type() == "Core"):
					activeTiles[cd].pop()
					activeTiles[cd].push(Vector2(i, j))
			elif (activeTiles[cd].size() > 1 and activeTiles[cd].top() != Vector2(i, j) and board[last.x][last.y].get_type() != "Core" and is_the_next(i, j, cd)):
				if (board[i][j].get_type() == "Tile" and board[i][j].get_color() == White):
					board[i][j].set_color(mouse_color)
					activeTiles[cd].push(Vector2(i ,j))
				elif (board[i][j].get_type() == "Core"):
					activeTiles[cd].push(Vector2(i ,j))
			update()

func code(col):
	if col == Yellow:
		return 0
	elif col == Red:
		return 1
	return 2
	
func decode(num):
	if num == 0:
		return Yellow
	elif num == 1:
		return Red
	return White
	
func is_solved():
	var last
	for i in range(board.size()):
		for j in range(board[0].size()):
			if board[i][j].get_color() == White:
				return false
	for i in range(activeTiles.size()):
		last = activeTiles[i].top()
		if board[last.x][last.y].get_type() != "Core":
			return false
	return true

## Retorna true se o mouse está na tile board[i][j]
func mouse_is_on_tile(i, j):
	var pos = get_local_mouse_pos()
	if (pos.x > i*(tile_side+5)+recoil and pos.y > j*(tile_side+5)+recoil and pos.x < (i+1)*tile_side+recoil and pos.y < (j+1)*tile_side+recoil):
		return true
	return false

#adicionar a checagem na cor da tile
## Verifica se a Tile atual é vizinha da última Tile pintada
func is_the_next(i, j, colorNo):
	if (activeTiles[colorNo].isEmpty()):
		return true
	var tile = activeTiles[colorNo].top()
	if (tile.x == i+1 and tile.y == j):
		return true
	if (tile.x == i-1 and tile.y == j):
		return true
	if (tile.x == i and tile.y == j+1):
		return true
	if (tile.x == i and tile.y == j-1):
		return true
	return false
	
func _draw():
	for i in range(activeTiles.size()):
		var vect = activeTiles[i].vect
		var to = null
		for j in range(1, vect.size()):
			var first = vect[j-1]
			var second = vect[j]
			var from = Vector2((first.x+0.5)*(tile_side+5)+recoil, (first.y+0.5)*(tile_side+5)+recoil)
			to = Vector2((second.x+0.5)*(tile_side+5)+recoil, (second.y+0.5)*(tile_side+5)+recoil)
			draw_line(from, to, Black, 10)
			draw_circle(from, 4, Black)
		if to != null:
			draw_circle(to, 4, Black)
