"""
#------------------------------------------------------------------------------|
# no global
#------------------------------------------------------------------------------:
"""

class_name tableboats extends "res://sources/table/table.gd"

var name_class = "tableboats"

func _init():
	pass
	
func go():
	
	var err = connect("signal_boats_set", self, "boats_set")
	if (err):
		print("ERROR: connect 0", err)
		pass
		
	start()
	pass
	
"""
#-----------------------------------------------|
# Растановка лодок в таблице.
#-----------------------------------------------:
"""
var gen_boat
func boats_set():
	#Mylib.debug_matrix(mat)
	
	gen_boat   = preload("res://sources/table/gen_boats.gd").new()
	var ERROR  = gen_boat.generator(CFG.size_table)
	
	for     y in CFG.size_table.y:
		for x in CFG.size_table.x:
			if(gen_boat.mat[y][x] == gen_boat.P):
				mat[y][x].self_modulate = Color(1, 1, 0)
				pass
			else:
				mat[y][x].self_modulate = Color(0.1, 0.1, 0) # ???
				pass
		pass
	
	print("Status boats_set(): ",  ERROR)
	pass
	
func xxxboats_set_start():
	
	for     y in CFG.size_table.y:
		for x in CFG.size_table.x:
			gen_boat.mat[y][x] = ' '
			pass
		pass
	pass
	
	
	
	
	
	
