"""
#------------------------------------------------------------------------------|
# Рисуем таблицу спрайтами.
#------------------------------------------------------------------------------:
"""

extends Node2D

var CFG_default_class = preload("res://sources/table/cfg_default.gd")
var CFG_default       = CFG_default_class.new()

var gui_class         = preload("res://sources/table/gui.gd")
var gui_obj           : gui

var cameras_class     = load("res://sources/base/cameras.gd")
var cameras_obj

var sounds_obj

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
var size_cell  : Vector2
var size_table : Vector2
var size_zazor = CFG_default.SIZE_ZAZOR

#----------------|
# Цвет выбора.   |
#----------------:
var select_LKM = Color(1, 0, 0)

#----------------|
# Скейл?         |
#----------------:
var size_cell_ration : Vector2

enum eRUND \
{	DEFAULT,
	   SEED,
	   TIME,
}
var CFG_RAND = eRUND.DEFAULT


func _init():
	pass


func _ready():
	pass


func myinit(parent):
	cameras_obj = cameras_class.new(parent)
	sounds_obj  = preload("res://sources/base/sounds.gd").new(
										get_tree().get_root())
	pass


"""
#-----------------------------------------------|
# ЗАПУСК СТОЛА!
#-----------------------------------------------:
"""
func start():
	
	#print("CFG_default.SIZE_CELL = ", CFG_default.SIZE_CELL) # good
	#CFG_default.test() # good
	
	#--------------------------|
	# Нод work.                |
	#--------------------------:
	var  work = Node2D.new()
	work.name = "work"
	add_child   (work)
	
	#--------------------------|
	# Нод gui.                 |
	#--------------------------:
	var  gui = Node2D.new()
	gui.name = "gui"
	add_child  (gui)

	#--------------------------|
	# new.                     |<--- ?
	#--------------------------:
	gui_obj = gui_class.new(gui)
	gui_obj.connect("signal_table_new"        , self, "table_new")
	gui_obj.connect("signal_on_grid_cross_red", self, "on_grid_cross_red")
	
	run   (    )
	myinit(self)
	grid_cross_red(get_node("/root/Table/camera_test_01"))
	pass


func _test_Get_mess(mess):
	print(mess)
	pass
	

func run(cfg_rand = eRUND.DEFAULT):

	Get_rand_congig(cfg_rand)

	print("run GENERATOR")
	print("    size_cell  = ", size_cell )
	print("    size_table = ", size_table)
	print()
	
	#----------------|
	# Добавим нод.   |
	# На этот нод будем вешать спрайты.
	#----------------:
	var  table = Node2D.new()
	table.name = "table"
	# root/work/table
	get_child(0).add_child(table)
	
	#-----------------|
	# Размер текстуры.|<--- TODO: Можно ли узнать проще?
	#-----------------:
	var spr     = Sprite.new()
	spr.texture = textureIcon
	var sz      = spr.texture.get_size()
	
	spr.free()
	
	#-----------------|
	# Скейл масштаба. |
	#-----------------:
	size_cell_ration.x = size_cell.x / sz.x
	size_cell_ration.y = size_cell.y / sz.y
	
	table_generator()
	
	grid          (table)
	pass


func Get_rand_congig(cfg_rand):
	
	var is_cfg_rand : bool = CFG_RAND != cfg_rand
	
	if  is_cfg_rand :
		CFG_RAND = cfg_rand
		
		match CFG_RAND:
			eRUND.TIME:
				randomize()
				pass
			eRUND.SEED:
				seed(8)
				pass
			eRUND.DEFAULT:
				pass
		pass
	pass
	
	if CFG_RAND == eRUND.DEFAULT:
		size_cell  = CFG_default.SIZE_CELL
		size_table = CFG_default.SIZE_TABLE
		size_zazor = CFG_default.SIZE_ZAZOR
		pass
	else:
		size_cell .x = Mylib.rrandi(20, 80)
		size_cell .y = Mylib.rrandi(20, 80)
		size_table.x = Mylib.rrandi( 1,  9)
		size_table.y = Mylib.rrandi( 1,  9)
		pass
	pass


"""
#-----------------------------------------------|
# Генератор таблицы.
#-----------------------------------------------:
"""
const textureIcon = preload("res://res/icon.png")
const sprite_01   = preload("res://sources/table/sprite_01.gd")

#----------------|
# Массив цветов. |
#----------------:
const intensive : float = 0.2
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
	

var id : int = 0

#----------------|
# Один спрйт.    |
#----------------:
func create_sprite(v) -> Sprite:
	id      += 1
	var Ncol = id % color.size()
	
	var spr           =  Sprite.new()
	spr.texture       =  textureIcon
	spr.self_modulate =  color[Ncol]
	spr.scale         =  Vector2(size_cell_ration.x * (1 - size_zazor.x), \
								 size_cell_ration.y * (1 - size_zazor.y))
	spr.translate (v)
	spr.set_script(sprite_01)

	get_child(0).get_child(0).add_child(spr)
	return spr


#----------------|
# Все спрйты.    |
#----------------:
func table_generator():
	id = 0
	
	var sz2 = Vector2(size_cell.x * size_table.x, \
					  size_cell.y * size_table.y) / 2
	
	for     y in size_table.y:
		for x in size_table.x:
			var spr : Sprite
			spr = create_sprite(                           \
				  Vector2((0.5 + x) * size_cell.x - sz2.x, \
						  (0.5 + y) * size_cell.y - sz2.y) )
			spr.set_meta("ID", id)
			pass
		pass
	pass


"""
#-----------------------------------------------|
# Доп.фичи.
#-----------------------------------------------:
"""
#-----------------|
# Сетка из линий. |
#-----------------:
func grid(parent : Node2D):
	
	var node_grid  = Node2D.new()
	node_grid.name = "grid_table"
	parent.add_child(node_grid)
	
	var sz2 = Vector2( size_cell.x * size_table.x, \
					   size_cell.y * size_table.y) / 2
	
	for i in size_table.x + 1:
		var line   = Line2D.new()
		line.width = 3
		line.add_point(Vector2( (i) * size_cell.x - sz2.x, -sz2.y))
		line.add_point(Vector2( (i) * size_cell.x - sz2.x,  sz2.y))
		node_grid.add_child(line)
		pass
		
	for i in size_table.y + 1:
		var line   = Line2D.new()
		line.width = 3
		line.add_point(Vector2(-sz2.x, (i) * size_cell.y  - sz2.y))
		line.add_point(Vector2( sz2.x, (i) * size_cell.y  - sz2.y))
		node_grid.add_child(line)
		pass
	pass

var node_grid_cross

func grid_cross_red(parent : Node):
	var node_grid  = Node2D.new()
	node_grid.name = "grid_cross_red"
	parent.add_child(node_grid)
	
	node_grid_cross = node_grid
	
	var lineX   = Line2D.new()
	lineX.width = 1
	lineX.default_color = Color(1,0,0)
	lineX.add_point(Vector2( -300, 0))
	lineX.add_point(Vector2(  300, 0))
	node_grid.add_child(lineX)
	
	var lineY   = Line2D.new()
	lineY.width = 1
	lineY.default_color = Color(1,0,0)
	lineY.add_point(Vector2( 0, -300))
	lineY.add_point(Vector2( 0,  300))
	node_grid_cross.add_child(lineY)
	pass


func on_grid_cross_red():
	sounds_obj.Play("s01.wav")
	node_grid_cross.visible = false if node_grid_cross.visible else true
	pass

#-----------------|
# Новая таблица.  |
#-----------------:
func table_new():
	sounds_obj.Play("s03.mp3")
	
	cameras_obj.position = Vector2(0, 0)
	self.scale           = Vector2(1, 1)
	
	var node = get_child(0).get_child(0)
	
	#print("node.free(): ", get_child(0).get_child(0).name)

	remove_child(node)
	node.free()
	
	run (eRUND.TIME)

	#print("node.free(): ", get_child(0).get_child(0).name)
	pass
	

"""
#-----------------------------------------------|
# _notification
#-----------------------------------------------:
"""
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		destructor()
	
func destructor():
	print("Programm FINISHED!")
	pass
	
	
func _process(delta):
	
	if Input.is_action_pressed("ui_page_up"):
		self.scale *= Vector2(1.05, 1.05)
		pass
	if Input.is_action_pressed("ui_page_down"):
		self.scale *= Vector2(0.95, 0.95)
		pass
	pass
