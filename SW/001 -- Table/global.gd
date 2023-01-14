"""	_04 -- global[_02+ЛКМ].rar
#------------------------------------------------------------------------------|
# Рисуем таблицу спрайтами.
#------------------------------------------------------------------------------:
"""

extends Node


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
var size_cell  = Vector2(  64,   64)
var size_table = Vector2(   7,    4)
var size_zazor = Vector2( 0.1,  0.1)

#----------------|
# Цвет выбора.   |
#----------------:
var select_LKM = Color(1, 0, 0)

#----------------|
# Скейл?         |
#----------------:
var size_cell_ration : Vector2


"""
#-----------------------------------------------|
# ТОЧКА ЗАПУСКА ВСЕЙ ПРОГРАММЫ!
#-----------------------------------------------:
"""
func _ready():
	print("Hello, myRimWorld")
	
	randomize ()
	
	#--------------------------|
	# Щас ты тут.              |
	#--------------------------:
	self.name = "root"
	
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
	add_button_generator(gui)
	add_button_grid     (gui)
	
	run       (    )
	camera_new(self)
	
	debug_info_node_root()
	
	print("get_child(0).name              = ", get_child(0).name             )
	print("get_child(0).get_child_count() = ", get_child(0).get_child_count())
	pass


func run():
	print("run GENERATOR")
	print("    size_cell  = ", size_cell)
	print("    size_table = ", size_table)
	
	size_cell .x = rrandi(20, 80)
	size_cell .y = rrandi(20, 80)
	size_table.x = rrandi( 1,  9)
	size_table.y = rrandi( 1,  9)
	
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
	grid_cross_red(table)
	
	pass


"""
#-----------------------------------------------|
# Генератор таблицы.
#-----------------------------------------------:
"""
const textureIcon = preload("res://icon.png")
const sprite_01   = preload("res://sprite_01.gd")

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
	spr.translate(v)
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


"""
#-----------------------------------------------|
# Доп.фичи.
#-----------------------------------------------:
"""
func camera_new(parent):
	var camera     = Camera2D.new()
	camera.name    = "camera_test_01"
	camera.current = true
	parent.add_child(camera)
	pass


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

var node_grid_cross  = Node2D.new()

func grid_cross_red(parent : Node2D):
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
	print("on_grid_cross_red(): ...")
	
	node_grid_cross.visible = false if node_grid_cross.visible else true
	
	var f = get_tree().get_root().find_node("grid_cross_red")

	if f != null:
		f.visible = false if f.visible else true
		print("find_node(\"grid_cross_red\") == true")
		pass
	pass


"""
#-----------------------------------------------|
# Гуй.
#-----------------------------------------------:
"""

var SIZEBUTTON = Vector2(100, 30)
var SIZEWINDOW = Vector2(                                    \
	ProjectSettings.get_setting("display/window/size/width" ),
	ProjectSettings.get_setting("display/window/size/height")) / 2


#-----------------|
# Button.         |
#-----------------:
func add_button_generator(parent):
	
	var  b = Button.new()
	b.text = "Generator"
	b.show_on_top = true
	b.set_size(Vector2(SIZEBUTTON.x, SIZEBUTTON.y))

	b.set_position(Vector2(SIZEWINDOW.x - SIZEBUTTON.x - 10,
						   SIZEWINDOW.y - SIZEBUTTON.y - 10))
	b.connect("button_down", self, "_on_Button_button_down")

	parent.add_child(b)
	pass


func _on_Button_button_down():
	print("_on_Button_button_down()")
	table_new()
	pass


#-----------------|
# Новая таблица.  |
#-----------------:
func table_new():
	var node = get_child(0).get_child(0)
	
	print("node.free(): ", get_child(0).get_child(0).name)

	remove_child(node)
	node.free()
	run ()

	print("node.free(): ", get_child(0).get_child(0).name)

	pass


#-----------------|
# Button grid.    |
#-----------------:
func add_button_grid(parent):
	
	var  b = Button.new()
	b.text = "Grid"
	b.show_on_top = true
	b.set_size(Vector2(SIZEBUTTON.x, SIZEBUTTON.y))
	
	b.set_position(Vector2(SIZEWINDOW.x - 2 * SIZEBUTTON.x - 2 * 10,
						   SIZEWINDOW.y -     SIZEBUTTON.y -     10))
	b.connect("button_down", self, "on_grid_cross_red")
	
	parent.add_child(b)
	pass


#-----------------|
# Случайное число.|
#-----------------:
func rrandi(from, to) -> int:
	return randi() % (to - from) + from


"""
#-----------------------------------------------|
# Набор дебажных процедур.
#-----------------------------------------------:
"""
func  debug_info_node(node, spaces : String = ""):

	for i in 4:
		spaces += " "
		pass

	for n in node.get_child_count():
		print(spaces, n, " ---> ", node.get_child(n).name,
						 " : "   , node.get_child(n).get_child_count())
						
		debug_info_node(node.get_child(n), spaces)
		
		if 3 < n:
			print(spaces, "[...]")
			break
		pass
	pass

func  debug_info_node_root():
	print("\ndebug_info_node_root():")
	debug_info_node(get_tree().get_root().get_child(0))
	print()
	pass
