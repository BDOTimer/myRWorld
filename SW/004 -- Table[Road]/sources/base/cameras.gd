"""
#------------------------------------------------------------------------------|
# no global
#------------------------------------------------------------------------------:
"""
class_name cameras extends Camera2D

enum eMove{
	LEFT,
	RIGHT
}

var CFG : cfg_default

signal signal_move_cam_left (pos)
signal signal_move_cam_right()


func _init(parent : Node):
	self.name     = "camera_test_01"
	self.current  =  true
	parent.add_child(self)
	pass


func _ready():
	var base = Main.get_node("Tablebase")
	
	print("... ", base.name)
	
	var \
	err = connect("signal_move_cam_left", base, "move_cam_left", [])
	if (err): print("ERROR: connect 0", err)

	err = connect("signal_move_cam_right", base, "move_cam_right")
	if (err): print("ERROR: connect 0", err)
	pass

var speed : float = 60.0

func _process(delta):

	if Input.is_action_pressed("ui_right"):
		self.position += (Vector2(speed, 0)) * delta
		
		emit_signal("signal_move_cam_right",[self.position])
		pass
	if Input.is_action_pressed("ui_left"):
		self.position += (Vector2(-speed, 0)) * delta
		
		emit_signal("signal_move_cam_left", [self.position])
		pass
		
	if Input.is_action_pressed("ui_down"):
		self.position += (Vector2(0, speed)) * delta
		pass
		
	if Input.is_action_pressed("ui_up"):
		self.position += (Vector2(0, -speed)) * delta
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
