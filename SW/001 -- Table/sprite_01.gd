"""
#------------------------------------------------------------------------------|
# Данный скрипт вешается на каждый спрайт клетки таблицы в
# функции func create_sprite(v)
# в файле global.gd
#------------------------------------------------------------------------------:
"""

extends Sprite

var szh = Global.size_cell / 2

#-----------------------------------|
# Не важно, какой у спрайта оттенок.|
#-----------------------------------:
var mem : Color

func _ready():
	#print("szh = ", szh)
	pass

func _input(event):
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):

		var pos = self.get_local_mouse_position()
		
		#-------------------------------------|
		# Проверка попадания на спрайт.       |
		#-------------------------------------:
		if -szh.x < pos.x && pos.x < szh.x && \
		   -szh.y < pos.y && pos.y < szh.y :
			
			if get_self_modulate() == Color(1, 0, 0):
				self_modulate = mem
			else:
				mem           = self_modulate
				self_modulate = Global.select_LKM
			
			print("Click position = ", Vector2(int(pos.x), int(pos.y)))
			print("ID = ", get_meta("ID"))

	pass
