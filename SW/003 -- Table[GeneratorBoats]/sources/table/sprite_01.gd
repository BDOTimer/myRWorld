"""
#------------------------------------------------------------------------------|
# Данный скрипт вешается на каждый спрайт клетки таблицы в
# функции func create_sprite(v)
# в файле global.gd
#------------------------------------------------------------------------------:
"""

extends Sprite

var szh : Vector2

#-----------------------------------|
# Не важно, какой у спрайта оттенок.|
#-----------------------------------:
var mem : Color
var on  = false

var test : String = "Sprite-2023"


var Tablebase : Node

func _init():
	Tablebase = Main.get_node("Tablebase")
	szh = Tablebase.size_cell / (Tablebase.size_cell_ration * 2)
	pass


func _ready():
	pass


func _input(event : InputEvent):
	
	if event.is_action_pressed("ms_left_press"):

		var pos = self.get_local_mouse_position()

		#-------------------------------------|
		# Проверка попадания на спрайт.       |
		#-------------------------------------:
		if Mylib.is_point_in_sprite(pos, szh):

			if on:
				self_modulate = mem
			else:
				mem           = self_modulate
				var        id = get_meta("ID")
				self_modulate = Tablebase.get_color_sprite\
							 (id %  Tablebase.color.size())
				
				Main.get_node("Tablebase/sounds").Play("s02.wav")
				pass

			on = false if on else true

			#print("Click position = ", Vector2(int(pos.x), int(pos.y)))
			#print("szh            = ", Vector2(int(szh.x), int(szh.y)))
			print("ID = ", get_meta("ID"))
			pass
		pass
	pass


