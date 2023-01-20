"""
#------------------------------------------------------------------------------|
# no global
#------------------------------------------------------------------------------:
"""

class_name tableboats extends "res://sources/table/table.gd"

var name_class = "tableboats"

func _init(parent : Node):
	name = "Tablebase"
	parent.add_child(self)
	pass
	
func go():
	
	var\
	err = connect("signal_boats_set", self, "boats_set")
	if(err):
		print("ERROR: connect 0")
		pass
		
	start()
	pass
	
"""
#-----------------------------------------------|
# Растановка лодок в таблице.
#-----------------------------------------------:
"""
func boats_set():
	#Mylib.debug_matrix(mat)
	
	var gen_boat = preload("res://sources/table/gen_boats.gd").new()
	var ERROR    = gen_boat.generator(size_table)
	
	for     y in size_table.y:
		for x in size_table.x:
			if(gen_boat.mat[y][x] == gen_boat.P):
				mat[y][x].self_modulate = Color(1, 1, 0)
				pass
			pass
		pass
	
	print("Status boats_set(): ",  ERROR)
	pass
	
	
	
	
	
	
