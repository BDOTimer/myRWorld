"""
#------------------------------------------------------------------------------|
# ТОЧКА ЗАПУСКА.
#------------------------------------------------------------------------------:
"""

extends Node

"""
#-----------------------------------------------|
# Конфиг.
#-----------------------------------------------:
"""
const name_project = "myRWorld"

const on_table = true
var   objsw

"""
#-----------------------------------------------|
# ТОЧКА ЗАПУСКА ВСЕЙ ПРОГРАММЫ ТУТ!
#-----------------------------------------------:
"""
func _ready():
	print("Hello, " + name_project)
	
	#-----------------|
	# tableboats.     |
	#-----------------:
	if on_table:
		objsw = preload("res://sources/table/tableboats.gd").new()
		add_child(objsw)
		objsw.go()
		pass
	
	#------|
	# off  |
	#------:
	#testers()
	
	#------|
	# off  |
	#------:
	#experiments()
	
	#------|
	# off  |
	#------:
	#Debug.tests()
	

	Debug.info_node_root()
	pass


func testers():
	print("#---------------------------------|")
	print("# Тестеры классов.                |")
	print("#---------------------------------:")

	var gen_boats_TEST = load(
		"res://sources/tester/gen_boats_TEST.gd"
	).new()

	print()
	pass
	

func experiments():
	print("#---------------------------------|")
	print("# Эксперименты.                   |")
	print("#---------------------------------:")

	var exp_001 = preload(
		"res://sources/experiments/exp_001.gd"
	).new()
	
	print()
	pass
	

func foo():
	var r = [0, 8]
	
	for i in 5:
		r = rand_seed(r[1])
		print(r)
		
	#[ 1718564384,  5689015801109435130]
	#[ -265521200, -7064991721301281404]
	#[  881077750, -4622665850863747642] <---|
	#[ 1997893239, -2959191413593657504]
	#[-1722749153,  -115549716438299278]

	print()

	seed(-4622665850863747642)
	print(randi()) # 1997893239
	pass
