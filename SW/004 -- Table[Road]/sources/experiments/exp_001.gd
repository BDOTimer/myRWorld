""" exp_001.gd
#------------------------------------------------------------------------------|
# .
#------------------------------------------------------------------------------:
"""
class_name exp_001 extends Node

func _init():
	self.name = "exp_001"
	go()
	pass


func _ready():
	pass


func go():
	print("#--------------------------|")
	print("# exp_001.gd               |")
	print("#--------------------------:")
	
	print("get_tree().get_root() ---> ", Main.get_tree().get_root().name)
	
	#Main.add_child(self)
	Main.add_child(self)

	print()
	pass
