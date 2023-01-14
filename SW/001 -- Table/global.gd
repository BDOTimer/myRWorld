"""
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
var size_cell  = Vector2(   40,   30)
var size_table = Vector2(    7,    4)
var size_zazor = Vector2(  0.1,  0.1)

#----------------|
# Цвет выбора.   |
#----------------:
var select_LKM = Color(1, 0, 0)

#----------------|
# Скейл?         |
#----------------:
var size_cell_ration : Vector2

var width  : int = ProjectSettings.get_setting("display/window/size/width" )
var height : int = ProjectSettings.get_setting("display/window/size/height")
	
var SIZEWINDOW = Vector2(width, height)

"""
#-----------------------------------------------|
# ТОЧКА ЗАПУСКА ВСЕЙ ПРОГРАММЫ!
#-----------------------------------------------:
"""
func _ready():
	randomize ()
	
	#--------------------------|
	# Нод для спрайтов.        |
	#--------------------------:
	add_child (Node2D.new())
	
	add_button()
	run       ()
	pass


func run():
	print("Hello, myRimWorld")
	print(size_cell)
	print(size_table)
	
	size_cell .x = rrand(20, 80)
	size_cell .y = rrand(20, 80)
	size_table.x = rrand( 1,  9)
	size_table.y = rrand( 1,  9)
	
	#----------------|
	# Добавим нод.   |
	# На этот нод будем вешать спрайты.
	#----------------:
	get_child(0).add_child (Node2D.new())
	var  node = get_child(0).get_child(0)
	node.name = "This for sprites ..."
	
	print("get_child_count() = ", get_child_count())
	
	#--------------------------|
	# Теперь можно двигать всю |
	# ветку со всеми спрайтами.|
	#--------------------------:
	node.translate(set_table_center())
	
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
	
	grid(node)
	pass


"""
#-----------------------------------------------|
# Генератор таблицы.
#-----------------------------------------------:
"""
const textureIcon = preload("res://icon.png"    )
const sprite_01   = preload("res://sprite_01.gd")

var id : int = 0

#-----------------|
# Массив цветов.  |
#-----------------:
const color = \
[
	Color(0, 1, 0),
	Color(0, 0, 1),
	Color(1, 1, 0),
	Color(0, 1, 1),
	Color(1, 0, 1)
]

#-----------------|
# Один спрйт.     |
#-----------------:
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


#-----------------|
# Все спрйты.     |
#-----------------:
func table_generator():
	for y in size_table.y:
		for x in size_table.x:
			var spr : Sprite
			spr = create_sprite(                           \
				  Vector2(x * size_cell.x, y * size_cell.y))
			spr.set_meta("ID", id)
	pass


"""
#-----------------------------------------------|
# Добавленные фичи.
#-----------------------------------------------:
"""
#-----------------|
# Случайное число.|
#-----------------:
func rrand(from, to) -> int:
	return randi() % (to - from) + from


#-----------------|
# По центру.      |
#-----------------:
func set_table_center() -> Vector2:
	
	var SIZETABLE  = Vector2(size_cell.x * size_table.x, \
							 size_cell.y * size_table.y)
	
	var trans = (SIZEWINDOW - SIZETABLE) / 2
	
	print("SIZEWINDOW = ", SIZEWINDOW)
	print("SIZETABLE  = ", SIZETABLE )
	print("trans      = ", trans     )

	return trans


#-----------------|
# Button.         |
#-----------------:
func add_button():
	
	var  b = Button.new()
	b.text = "Generator"
	b.show_on_top = true
	b.set_size(Vector2(100, 30))
	
	b.set_position(Vector2(SIZEWINDOW.x - 100 - 10,
						   SIZEWINDOW.y -  30 - 10))
	b.connect("button_down", self, "_on_Button_button_down")
	
	add_child(b)
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
	remove_child(node)
	node.free()
	run ()
	pass
	
	
#-----------------|
# Сетка из линий. |
#-----------------:
func grid(dest):
	
	var h2 = size_cell / 2
	
	for i in size_table.x + 1:
		var line   = Line2D.new()
		line.width = 3
		line.add_point(Vector2( (i - 1) * size_cell.x + h2.x, -300))
		line.add_point(Vector2( (i - 1) * size_cell.x + h2.x,  600))
		dest.add_child(line)
		pass
		
	for i in size_table.y + 1:
		var line   = Line2D.new()
		line.width = 3
		line.add_point(Vector2(-300, (i - 1) * size_cell.y + h2.y))
		line.add_point(Vector2( 600, (i - 1) * size_cell.y + h2.y))
		dest.add_child(line)
		
		pass
	pass


