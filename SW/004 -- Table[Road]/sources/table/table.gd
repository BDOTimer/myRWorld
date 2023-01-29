"""
#------------------------------------------------------------------------------|
# Рисуем таблицу спрайтами.
#------------------------------------------------------------------------------:
"""
class_name table extends Node2D

signal signal_boats_set()

"""
#-----------------------------------------------|
# Конфиг.
#-----------------------------------------------:
"""

#----------------|
# Цвет выбора.   |
#----------------:
var select_LKM = Color(1, 0, 0)

var root: Node
var CFG : cfg_default
var SEEDROAD  = 0
var SEEDSTART = 0
var RANDTYPE


func _init():
	pass


func _ready():
	#print("Main.get_node(\"Tablebase\").name_class = ",\
	#   Main.get_node( "Tablebase").name)
		
	if not tableD: print("tableD == null")
	pass


var tableD : Node2D

"""
#-----------------------------------------------|
# ЗАПУСК СТОЛА!
#-----------------------------------------------:
"""
func start():
	
	#--------------------------|
	# Нод work.                |
	#--------------------------:
	var  work = Node2D.new()
	work.name = "work"
	add_child   (work)
	
	restart()
	
	pass
	
	
var  mat
func restart(cfg_rand = CFG.eRUND.DEFAULT):
	
	CFG.Get_rand_congig(cfg_rand, SEEDROAD)
	
	#------|
	# new  |
	#------;
	#align_xy_size_table()
	
	CFG.calc()
	
	print("run GENERATOR")
	print("    CFG.size_cell  = ", CFG.size_cell )
	print("    CFG.size_table = ", CFG.size_table)
	print("    CFG.size_zazor = ", CFG.size_zazor)
	print()
	
	#----------------|
	# Для SW.        |
	#----------------:
	mat = Mylib.create_matrix(CFG.size_table)
	
	print("(mat   .size() = ", mat   .size())
	print("(mat[0].size() = ", mat[0].size())
	
	#----------------|
	# Добавим нод.   |
	# На этот нод будем вешать спрайты.
	#----------------:
	tableD      = Node2D.new()
	tableD.name = "tableD"
	# root/work/table
	get_node("work").add_child(tableD)

	table_generator()
	grid     (tableD)

	emit_signal("signal_boats_set")
	pass


"""
#-----------------------------------------------|
# Генератор таблицы.
#-----------------------------------------------:
"""
var id : int = 0


#----------------|
# Один спрйт.    |
#----------------:
func create_sprite(v) -> mysprite:
	id      += 1
	var Ncol = id % CFG.color.size()
	
	var \
	spr               =  mysprite.new()
	spr.cfg           =  CFG
	spr.texture       =  CFG.textureIcon
	spr.self_modulate =  CFG.color[Ncol]
	spr.scale         =  CFG.scale_txtr
	spr.translate (v) 

	tableD.add_child(spr)
	return spr


#----------------|
# Все спрйты.    |
#----------------:
func table_generator():
	id = 0
	
	for     y in CFG.size_table.y:
		for x in CFG.size_table.x:
			var spr = create_sprite(
				  Vector2((0.5 + x) * CFG.size_cell.x - CFG.sz2.x,
						  (0.5 + y) * CFG.size_cell.y - CFG.sz2.y)
			)
			spr.set_meta("ID", id)
			
			mat[y][x] = spr
			pass
		pass
	pass


#-----------------|
# Для road.       |
#-----------------:
func align_xy_size_table():
	
	var         dv = Mylib.SIZEWINDOW / CFG.size_cell + Vector2(2, 2)
	CFG.size_table = Vector2(int(dv.x), CFG.size_cell.y)
	pass


"""
#-----------------------------------------------|
# Доп.фичи.
#-----------------------------------------------:
"""
#-----------------|
# Сетка из линий. |
#-----------------:
var node_grid
func grid(parent : Node2D):
	
	node_grid      = Node2D.new()
	node_grid.name = "grid_table"
	parent.add_child(node_grid)
	
	for i in CFG.size_table.x + 1:
		var line   = Line2D.new()
		line.width = 1
		line.add_point(Vector2( (i) * CFG.size_cell.x - CFG.sz2.x, -CFG.sz2.y))
		line.add_point(Vector2( (i) * CFG.size_cell.x - CFG.sz2.x,  CFG.sz2.y))
		node_grid.add_child(line)
		pass
		
	for i in CFG.size_table.y + 1:
		var line   = Line2D.new()
		line.width = 1
		line.add_point(Vector2(-CFG.sz2.x, (i) * CFG.size_cell.y  - CFG.sz2.y))
		line.add_point(Vector2( CFG.sz2.x, (i) * CFG.size_cell.y  - CFG.sz2.y))
		node_grid.add_child(line)
		pass
	pass
	

#-----------------|
# Новая таблица.  |
#-----------------:
func table_new():
	get_parent().sounds_obj.Play("s03.mp3")
	
	#cameras_obj.position = Vector2(0, 0)
	self.scale           = Vector2(1, 1)
	
	print("func table_new(): node = ", tableD.name)

	#remove_child(tableD)
	
	if is_instance_valid(tableD):
		tableD.queue_free()
	
	restart(RANDTYPE)
	pass


