""" TEST!
#------------------------------------------------------------------------------|
# Генератор расстановки кораблей.
#------------------------------------------------------------------------------:
"""
extends Node

func _init():
	go()
	pass
	
	
func _ready():
	pass
	

func go():
	print("#--------------------------|")
	print("# Генератор gen_boats.gd   |")
	print("#--------------------------:")
	
	var \
	gen_boat_obj = preload("res://sources/table/gen_boats.gd").new()
	gen_boat_obj.generator(Vector2(17, 7))
	gen_boat_obj.debugo(gen_boat_obj)
	
	print("Status: ",  gen_boat_obj.ERROR)
	print()
	pass
