"""
#------------------------------------------------------------------------------|
# no global
#------------------------------------------------------------------------------:
"""
class_name gui extends CanvasLayer

signal signal_table_new        ()
signal signal_on_grid_cross_red()

func _init(parent : Node2D):
	
	self.name = "canvas_layer"
	parent.add_child  (self)
	
	#--------------------------|
	# Нод gui.                 |
	#--------------------------:
	var  gui_node = Node2D.new()
	gui_node.name = "gui"
	self.add_child  (gui_node)

	add_button_generator(gui_node)
	add_button_grid     (gui_node)

	var tbl = Main.get_node("Tablebase")
	
	var    \
	err    = [0,0]
	err[0] = self.connect("signal_table_new"        , tbl, "tables_new"        )
	err[1] = self.connect("signal_on_grid_cross_red", tbl, "on_grid_cross_red")

	if(err[0]):
		print("ERROR: connect 0: ", err[0])
		pass
	if(err[1]):
		print("ERROR: connect 1: ", err[1])
		pass
	pass


func _ready():
	pass


var SIZEBUTTON = Vector2(100, 30)
var SIZEWINDOW = Mylib.SIZEWINDOW


#-----------------|
# Индекс кнопки.  |
#-----------------:
var cnt : int = 1

#-----------------|
# Button.         |
#-----------------:
func add_button_generator(parent : Node2D):
	
	var  b = Button.new()
	b.text = "Generator"
	b.show_on_top = true
	b.set_size(Vector2(SIZEBUTTON.x, SIZEBUTTON.y))

	b.set_position(Vector2(SIZEWINDOW.x - cnt*(SIZEBUTTON.x + 10),
						   SIZEWINDOW.y -     (SIZEBUTTON.y + 10)))
	b.connect("button_down", self, "_on_button_generator")

	parent.add_child(b)
	cnt += 1
	pass


func _on_button_generator():
	emit_signal("signal_table_new")
	pass
	
	
#-----------------|
# Button grid.    |
#-----------------:
func add_button_grid(parent : Node2D):
	
	var  b = Button.new()
	b.text = "Grid"
	b.show_on_top = true
	b.set_size(Vector2(SIZEBUTTON.x, SIZEBUTTON.y))
	
	b.set_position(Vector2(SIZEWINDOW.x - cnt*(SIZEBUTTON.x + 10),
						   SIZEWINDOW.y -     (SIZEBUTTON.y + 10)))

	b.connect("button_down", self, "_on_grid_cross_red")
	
	parent.add_child(b)
	cnt += 1
	pass
	
func _on_grid_cross_red():
	emit_signal("signal_on_grid_cross_red")
	pass
	
