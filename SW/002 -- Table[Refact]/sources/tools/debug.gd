"""
#------------------------------------------------------------------------------|
# Набор дебажных процедур.
#------------------------------------------------------------------------------:
"""
extends Node


func  info_node(node, spaces : String = "    ") -> int:

	var begskip = true
	var cnt     = 0
	for n in node.get_child_count():
		
		if 2 < n && node.get_child(n).name[0] == '@':
			
			if begskip:
				print(spaces, "[...]")
				begskip = false
				pass
			pass
			
		else:
			begskip = true
			print(spaces, n, " -->  ", node.get_child(n).name,
							 " : "   , node.get_child(n).get_child_count())
						
			cnt += info_node(node.get_child(n), spaces + "    ")
			pass
		pass
	return cnt + node.get_child_count()


func  info_node_root():
	print()
	print("#-------------------------------------|")
	print("# Дерево нодов root.                  |")
	print("#-------------------------------------:")
	print("|-->  ", get_tree().get_root().name,
		  " : "   , get_tree().get_root().get_child_count())
	var \
	total_count_nodes : int = 0
	total_count_nodes += info_node(get_tree().get_root   ())
	print("total_count_nodes = ", total_count_nodes)
	print()
	pass


"""
#------------------------------------------------|
# Тесты.                                         |
#------------------------------------------------:
"""
func  tests():
	
	#-----|
	# OFF |
	#-----:
	#return
	
	info_node_root()
	
	print("#-------------------------------------|")
	print("# Тесты.                              |")
	print("#-------------------------------------:")
	test_path   ()
	test_2DArray()
	print       ()
	pass


func  test_path():
	print("\ntest_01():")
	print(     "get_tree().get_root().name = ",
				get_tree().get_root().name)
	var root =  get_tree().get_root()
	#var node =  root.get_node ("Table/work/table")
	#var node =  Table.get_node("gui")

	var node =  root.get_node ("Table")
	#var node =  Table.get_node("root/work/table")

	if  node == null:
		print("ERROR: node is null")
		pass
	else:
		print("node: ",   node.name)
		pass
	pass
	

	
func test_2DArray():
	
	var a = Vector2(3, 4)
	
	var matrix = []
	matrix.resize(a.y)
	for y in range(a.y):
		matrix[y]= []
		matrix[y].resize(a.x)
		for x in range(a.x):
			matrix[y][x]=0
			
	info_2DArray(matrix)
	pass
	
func info_2DArray(arr2d):
	var     s : String
	for     y in arr2d.size():
		for x in arr2d[y].size():
			s += str(arr2d[y][x])
			pass
		s += "\n"
		pass
		
	print(s)
	pass
