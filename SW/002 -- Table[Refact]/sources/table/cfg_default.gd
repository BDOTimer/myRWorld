"""
#------------------------------------------------------------------------------|
# no global
#------------------------------------------------------------------------------:
"""

extends Node

class_name cfg_default

func _init():
	pass
	
func _ready():
	pass
	
func test():
	print("class_name cfg_default call: ", Main.name_project)
	pass

"""
#-----------------------------------------------|
# Конфиг.
#-----------------------------------------------:
"""
#----------------|
# Размеры клетки.|
# Размер таблицы.|
# Размер зазора. |
#----------------:
const SIZE_CELL  = Vector2(  64,   64)
const SIZE_TABLE = Vector2(   7,    4)
const SIZE_ZAZOR = Vector2( 0.1,  0.1)

