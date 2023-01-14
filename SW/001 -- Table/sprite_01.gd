"""
#------------------------------------------------------------------------------|
# Данный скрипт вешается на каждый спрайт клетки таблицы в
# функции func create_sprite(v)
# в файле global.gd
#------------------------------------------------------------------------------:
"""

extends Sprite

var szh : Vector2 = Global.size_cell / (Global.size_cell_ration * 2)

#-----------------------------------|
# Не важно, какой у спрайта оттенок.|
#-----------------------------------:
var mem : Color
var on  = false

func _ready():
	#print("szh = ", szh)
	
	#szh = Vector2(. \
	
	pass

func _input(event):
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):

		var pos = self.get_local_mouse_position()
		
		#-------------------------------------|
		# Проверка попадания на спрайт.       |
		#-------------------------------------:
		if -szh.x < pos.x && pos.x < szh.x && \
		   -szh.y < pos.y && pos.y < szh.y :
			
			if on:
				self_modulate = mem
			else:
				mem           = self_modulate
				var        id = get_meta("ID")
				self_modulate = Global.get_color_sprite\
							 (id %  Global.color.size())
							
			on = false if on else true

			print("Click position = ", Vector2(int(pos.x), int(pos.y)))
			print("szh            = ", Vector2(int(szh.x), int(szh.y)))

			print("ID = ", get_meta("ID"))

	pass
