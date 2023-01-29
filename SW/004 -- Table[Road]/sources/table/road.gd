"""
#------------------------------------------------------------------------------|
# road
#	- var glob_center_cam_pos Позиция центра камеры в глобальном пространстве.
#------------------------------------------------------------------------------:
"""
class_name road extends Node2D

var sounds_obj  : sounds
var gui_obj     : gui
var cameras_obj : cameras
var CFG : cfg_default = cfg_default.new()

var icount : int = 0
var xpos   = Vector2()

var md     = []

var SEEDSTART : int = 0

func _init():
	name       = "Tablebase"
	sounds_obj = sounds.new(self)
	seed(SEEDSTART)
	CFG.size_cell .y = Mylib.rrandi( 20, 32)
	CFG.size_table.y = Mylib.rrandi( 10, 20)
	pass


func _ready():
	pass


func start_road():

	xpos.x = 0
	var  x = -CFG.WIDTH
	
	for i in 3:
		add_chank(x)
		x += CFG.WIDTH
		pass
		
		
	#--------------------------|
	# cameras.                 |
	#--------------------------:
	cameras_obj = cameras.new(self)
	grid_cross_red(cameras_obj)
	
	cameras_obj.CFG = CFG
	
	#--------------------------|
	# gui.                     |
	#--------------------------:
	gui_obj = gui.new(self)
	pass


func add_chank(x):

	var chank = tableboats.new()
	md.append(chank)
	var back = md.size() - 1
	add_child(md[back])
	
	chank.CFG = CFG
	chank.SEEDROAD = back + SEEDSTART
	chank.RANDTYPE = chank.CFG.eRUND.TIME
	chank.go()
	chank.set_position(Vector2(x, 0))
	pass


func move_cam_left(pos):
	
	if pos[0].x < (xpos.x - CFG.WIDTH):
		xpos.x -= CFG.WIDTH
		Mylib.ror(md)
		
		var p = Vector2(md[0].position.x - CFG.WIDTH * 3, 0)
		
		md[0].position = p
		
		icount -= 1
		seed(icount)
		md[0].boats_set()
		pass

	print("signal_move_cam_left = ", pos[0].x)
	pass


func move_cam_right(pos):
	
	if pos[0].x > (xpos.x + CFG.WIDTH):
		xpos.x += CFG.WIDTH
		Mylib.rol(md)
		
		var p = Vector2(md[2].position.x + CFG.WIDTH * 3, 0)
		
		md[2].position = p
		
		icount += 1
		seed(icount)
		md[2].boats_set()
		pass
	
	print("signal_move_cam_right = ", pos[0].x)
	pass
	

"""
#-----------------------------------------------|
# Юзер контрол этим нодом.
#-----------------------------------------------:
"""
const speed = 0.3
func _process(delta):
	
	if Input.is_action_pressed("ui_page_up"):
		delta = 1 + delta * speed
		self.scale *= Vector2(delta, delta)
		pass
	if Input.is_action_pressed("ui_page_down"):
		delta = 1 - delta * speed
		self.scale *= Vector2(delta, delta)
		pass
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			self.scale *= Vector2(1.08, 1.08)
			pass
		if (event.button_index == BUTTON_WHEEL_DOWN and event.pressed):
			self.scale *= Vector2(0.92, 0.92)
			pass
		CFG.scale_road = self.scale
		pass
	pass
	

var node_grid_cross : Node2D

func grid_cross_red(parent : Node):
	node_grid_cross      = Node2D.new()
	node_grid_cross.name = "grid_cross_red"
	parent.add_child(node_grid_cross)
	
	var lineX   = Line2D.new()
	lineX.width = 1
	lineX.default_color = Color(1,0,0)
	lineX.add_point(Vector2( -300, 0))
	lineX.add_point(Vector2(  300, 0))
	node_grid_cross.add_child(lineX)
	
	var lineY   = Line2D.new()
	lineY.width = 1
	lineY.default_color = Color(1,0,0)
	lineY.add_point(Vector2( 0, -300))
	lineY.add_point(Vector2( 0,  300))
	node_grid_cross.add_child(lineY)
	
	node_grid_cross.visible = true
	pass
	

func on_grid_cross_red():
	sounds_obj.Play("s01.wav")
	node_grid_cross.visible = false if node_grid_cross.visible else true
	#node_grid      .visible = false if node_grid      .visible else true
	pass
	
	
func tables_new():
	
	for i in md.size():
		md[i].RANDTYPE = md[i].CFG.eRUND.ROAD
		md[i].table_new()
		pass
	pass
