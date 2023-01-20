"""
#------------------------------------------------------------------------------|
# self == "Mylib"
#------------------------------------------------------------------------------:
"""

extends Node


func _init():
	pass
	
	
func _ready():
	pass


#-----------------|
# Случайное число.|
#-----------------:
func rrandi(from, to) -> int:
	return randi() % (to - from) + from

#-----------------|
# Где точка?.     |
#-----------------:
func is_point_in_rect(point : Vector2, rect : Rect2):
	return (
		point.x > rect.position.x               and
		point.x < rect.position.x + rect.size.x and
		point.y > rect.position.y               and
		point.y < rect.position.y + rect.size.y
	)
	
func is_point_in_sprite(point : Vector2, half : Vector2):
	return (
		-half.x < point.x && point.x < half.x &&
		-half.y < point.y && point.y < half.y
	)

	
#------------------------------------------------------------------------------|
#   Двумерный массив.
#-------------------------------------------------------------------------- 005:
func create_matrix(sz : Vector2):
	
	var mat = []
	mat.resize (sz.y)
	for y in range(sz.y):
		mat[y]= []
		mat[y].resize(sz.x)
		for x in range  (sz.x):
			mat[y][x]=1
		pass
			
	#debug_matrix(matrix)
	
	return mat
	
func debug_matrix(arr2d):
	print("debug_matrix = ")
	var     s : String
	for     y in arr2d.size():
		for x in arr2d[y].size():
			s += str(arr2d[y][x])
			s += ", "
			pass
		s += "\n"
		pass
		
	print(s)
	pass


func Get_gdnative():
	printraw("-------------\n")
	var lib = GDNative.new()
	lib.library = load("res://draw_circle_library.tres")
	lib.initialize()
	var array = lib.call_native("standard_varcall", "create_circle", [])
	for row in array:
		for ch in row:
			printraw(char(ch))
		printraw("\n")
	lib.terminate()
	printraw("-------------\n")
	pass
