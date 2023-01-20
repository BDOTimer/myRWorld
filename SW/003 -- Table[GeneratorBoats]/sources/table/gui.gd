"""
#------------------------------------------------------------------------------|
# no global
#------------------------------------------------------------------------------:
"""

signal signal_table_new        ()
signal signal_on_grid_cross_red()

class_name gui extends CanvasLayer

func _init(node : Node2D):
	
	self.name = "canvas_layer"
	node.add_child(self)
	
	add_button_generator()
	add_button_grid     ()
	
	pass


func _ready():
	pass


var SIZEBUTTON = Vector2(100, 30)
var SIZEWINDOW = Vector2(                                    \
	ProjectSettings.get_setting("display/window/size/width" ),
	ProjectSettings.get_setting("display/window/size/height"))

#-----------------|
# Индекс кнопки.  |
#-----------------:
var cnt : int = 1

#-----------------|
# Button.         |
#-----------------:
func add_button_generator():
	
	var  b = Button.new()
	b.text = "Generator"
	b.show_on_top = true
	b.set_size(Vector2(SIZEBUTTON.x, SIZEBUTTON.y))

	b.set_position(Vector2(SIZEWINDOW.x - cnt*(SIZEBUTTON.x + 10),
						   SIZEWINDOW.y -     (SIZEBUTTON.y + 10)))
	b.connect("button_down", self, "_on_button_generator")

	self.add_child(b)
	cnt += 1
	pass


func _on_button_generator():
	#print("_on_button_generator() ...")
	emit_signal("signal_table_new")
	pass
	
	
#-----------------|
# Button grid.    |
#-----------------:
func add_button_grid():
	
	var  b = Button.new()
	b.text = "Grid"
	b.show_on_top = true
	b.set_size(Vector2(SIZEBUTTON.x, SIZEBUTTON.y))
	
	b.set_position(Vector2(SIZEWINDOW.x - cnt*(SIZEBUTTON.x + 10),
						   SIZEWINDOW.y -     (SIZEBUTTON.y + 10)))

	b.connect("button_down", self, "_on_grid_cross_red")
	
	self.add_child(b)
	cnt += 1
	pass
	
func _on_grid_cross_red():
	#print("_on_grid_cross_red() ...")
	emit_signal("signal_on_grid_cross_red")
	pass
	



