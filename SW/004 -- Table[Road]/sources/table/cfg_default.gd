"""
#------------------------------------------------------------------------------|
# no global
#------------------------------------------------------------------------------:
"""
class_name cfg_default extends Object

const name = "cfg_default"

func _init():
	#-----------------|
	# Размер текстуры.|<--- TODO: Можно ли узнать проще?
	#-----------------:
	var spr     = Sprite.new()
	spr.texture = textureIcon
	sz_txtr = spr.texture.get_size()
	
	spr.free()
	
	calc()
	pass


func _ready():
	pass


func test():
	print("object of class cfg_default exist.")
	pass


"""
#-----------------------------------------------|
# Конфиг.
#-----------------------------------------------:
"""
#----------------|
# Размеры клетки.|
# Размер таблицы.|
# Размер зазора. |
#----------------:
const SIZE_CELL  = Vector2(  40,   40)
const SIZE_TABLE = Vector2(  15,   10)
const SIZE_ZAZOR = Vector2( 0.1,  0.1)

var size_cell  = SIZE_CELL
var size_table = SIZE_TABLE
var size_zazor = SIZE_ZAZOR

#----------------|
# Скейл?         |
#----------------:
var size_cell_ration : Vector2

func reset_to_default():
	size_cell  = SIZE_CELL
	size_table = SIZE_TABLE
	size_zazor = SIZE_ZAZOR
	pass
	
var szh        : Vector2
var sz2        : Vector2
var scale_txtr : Vector2
var sz_txtr    : Vector2
var scale_road = Vector2(1,1)


var WIDTH : float = 0

const textureIcon = preload("res://res/icon.png")

func calc():
	#-----------------|
	# Скейл текстуры. |
	#-----------------:
	size_cell_ration = size_cell / sz_txtr
	scale_txtr       =  Vector2(
		size_cell_ration.x * (1 - size_zazor.x),
		size_cell_ration.y * (1 - size_zazor.y)
	)
	
	szh   = size_cell / (size_cell_ration * 2)
	sz2   = Vector2(
		size_cell.x * size_table.x,
		size_cell.y * size_table.y) / 2
		
	WIDTH = size_cell.x * size_table.x
	pass

#----------------|
# Массив цветов. |
#----------------:
const intensive : float = 0.1
const color   = \
[
	Color(intensive,         0,         0),
	Color(        0, intensive,         0),
	Color(        0,         0, intensive),
	Color(        0, intensive, intensive),
	Color(intensive,         0, intensive)
]


func get_color_sprite(i : int) -> Color:
	return Color(1 if color[i].r else 0,
				 1 if color[i].g else 0,
				 1 if color[i].b else 0)


enum eRUND \
{	DEFAULT,
	   SEED,
	   TIME,
	   ROAD
}

var RANDMODE = eRUND.DEFAULT


func Get_rand_congig(cfg_rand, SEED):
	
	var is_cfg_rand : bool = RANDMODE != cfg_rand
	
	if  is_cfg_rand :
		RANDMODE = cfg_rand
		
		match RANDMODE:
			eRUND.TIME:
				randomize()
				pass
			eRUND.SEED:
				seed(SEED)
				pass
			eRUND.DEFAULT:
				pass
			eRUND.ROAD:
				seed(SEED)
				pass
		pass
	pass
	
	if RANDMODE == eRUND.DEFAULT:
		reset_to_default()
		pass
	elif RANDMODE == eRUND.TIME:
		size_cell .x = Mylib.rrandi( 10, 20)
		size_cell .y = Mylib.rrandi( 20, 32)
		size_table.x = Mylib.rrandi( 10, 11)
		size_table.y = Mylib.rrandi( 10, 20)
		pass
	pass

