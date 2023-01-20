"""
#------------------------------------------------------------------------------|
# no global
#------------------------------------------------------------------------------:
"""
class_name cameras extends Camera2D


func _init(parent : Node):
	self.name     = "camera_test_01"
	self.current  =  true
	parent.add_child(self)
	pass


func _ready():
	pass


func _process(delta):
	
	if Input.is_action_pressed("ui_right"):
		self.position += (Vector2(1, 0))
		pass
	if Input.is_action_pressed("ui_left"):
		self.position += (Vector2(-1, 0))
		pass
		
	if Input.is_action_pressed("ui_down"):
		self.position += (Vector2(0, 1))
		
		pass
	if Input.is_action_pressed("ui_up"):
		self.position += (Vector2(0, -1))
		pass
		
	#if Input.is_action_pressed("ui_page_up"):
	#	self.scale *= Vector2(1.05, 1.05)
	#	pass
	#if Input.is_action_pressed("ui_page_down"):
	#	self.scale *= Vector2(0.95, 0.95)
	#	pass
	pass


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
		

func foo(event):
	if event.pressed and event.scancode == KEY_W:
		self.scale *= Vector2(1.05, 1.05)
	if event.pressed and event.scancode == KEY_S:
		self.scale *= Vector2(0.95, 0.95)
	pass
