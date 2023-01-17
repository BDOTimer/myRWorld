"""
#------------------------------------------------------------------------------|
# Данный скрипт вешается на каждый спрайт клетки таблицы в
# функции func create_sprite(v)
# в файле global.gd
#------------------------------------------------------------------------------:
"""

extends Sprite

var szh : Vector2 = Table.size_cell / (Table.size_cell_ration * 2)

#-----------------------------------|
# Не важно, какой у спрайта оттенок.|
#-----------------------------------:
var mem : Color
var on  = false

var test : String = "Sprite-2023"


func _ready():
	pass


func _input(event : InputEvent):
	
	if event.is_action_pressed("ms_left_press"):

		var pos = self.get_local_mouse_position()

		#-------------------------------------|
		# Проверка попадания на спрайт.       |
		#-------------------------------------:
		if -szh.x < pos.x && pos.x < szh.x && \
		   -szh.y < pos.y && pos.y < szh.y    :

			if on:
				self_modulate = mem
			else:
				mem           = self_modulate
				var        id = get_meta("ID")
				self_modulate = Table.get_color_sprite\
							 (id %  Table.color.size())
				
				get_tree().get_root().get_node(
					"Table/sounds").Play("s02.wav")
				pass

			on = false if on else true

			#print("Click position = ", Vector2(int(pos.x), int(pos.y)))
			#print("szh            = ", Vector2(int(szh.x), int(szh.y)))
			print("ID = ", get_meta("ID"))
			pass
		pass
	pass


