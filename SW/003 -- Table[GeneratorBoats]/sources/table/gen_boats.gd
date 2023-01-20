"""
#------------------------------------------------------------------------------|
# Генератор расстановки кораблей.
#------------------------------------------------------------------------------:
"""
#------------------------------------------------------------------------------|
# Морской бой[ГЕНЕРАТОР РАССТАНОВКИ]. (конверт с С++)
#
# Расстановка кораблей на поле клеток C x R.
#
# Правила:
#   - палубы должны соединяться строго по вертикали или строго по горизонтали.
#   - палубы соседних лодок должны иметь расстояние между собой в одну клетку.
#   - нет требования расположения всех палуб лодки в одну линию.
#
# Алгоритм:
#   - на вход генератора подаётся само поле + состав флотилии.
#   - точка - место на поле адресуемое двумя числами по X и Y.
#   - аура  - соседние 8 точек рядом с выделенной.
#   - ...
#
# Гарантия успешной генерации:
#   - опытным путём на 100'000 генерациях было установленно,
#     что общее кол-во палуб к кол-ву клеток поля должно быть < ~24.3%
#
#------------------------------------------------------------------------------:
class_name gen_noats extends Reference

const P = '*'	# Клетка с ПАЛУБОЙ.
const E = '.'	# Клетка свободная от ПАЛУБЫ.

"""
#-----------------------------------------------|
# ИНТЕРФЕЙС.                                    |
#-----------------------------------------------:
"""
#------------------------------------|
# Правило на состав флотилии.        |
# Размер -> кол-во лодок.            |
# Число  -> кол-во палуб в лодке.    |
#------------------------------------:
const rule_default = [5, 4,4, 3,3,3, 2,2,2,2, 1,1,1,1,1];
#const rule_default = [75, 75, 50, 50];
var   rule         = rule_default

func _init():
	#test000()
	pass

#-------------------------|
# Размер матрицы.         |<--- Для удобства.
#-------------------------:
var sz  = Vector2()

# public:
#-------------------------|
# Матрица размером sz.    |<--- Это не для удобства...
#-------------------------:
var mat = PoolStringArray()

# ...
var self_ref =  weakref(self)


# public:
func generator(SZ : Vector2) -> String:
	sz = SZ
	
	if 2 > sz.x && sz.x > 200 && 2 > sz.y && sz.y > 200:
		return "ERROR: size field no corrected ..."
	
	get_matrix_instance (sz)

	#print("...mat   .size() = ", mat   .size())
	
	for n in rule:
		
		var ready : bool = true

		#------------------------------|
		# Счётчик попыток(для защиты). |
		#------------------------------:
		var cnt : int = 0

		#------------------------------|
		# Ставим корабль.              |
		#------------------------------:
		#do
		while(true):
		#{
			#------------------------------|
			# На поле только такое ".z*"   |
			# mayused должен быть пустой.  |
			#------------------------------:
			ship_start_set()
			
			#------------------------------|
			# Ставим первую палубу-макет...|
			#------------------------------:
			var p = self.rrand(sz)
			
			while(true):
			#{
				#------------------------------|
				# Защита от вечного цикла.     |
				#------------------------------:
				cnt += 1
				
				if 500 == cnt :
					return "ERROR generate fail"
					pass

				p = self.rrand(sz)
				
				if mat[p.y][p.x] == '.': break
				
			#} while(mat[p.y][p.x] != '.');
		
			mat[p.y][p.x] = '!' #<------ тут.

			#------------------------------|
			# Варианты для остальных палуб.|
			#------------------------------:
			add2mayused(p)
		
			#------------------------------|
			# Ставим остальные палубы.     |
			#------------------------------:
			
			for i in n - 1:
			#{
				#------------------------------|
				# Нет места - Начать заново!   |
				#------------------------------:
				if mayused.empty() :
					ready = false
					break

				#------------------------------|
				# Рандом возможного варианта.  |
				#------------------------------:
				var         k = Mylib.rrandi(0, mayused.size())
				p = mayused[k];

				#------------------------------|
				# Удаляем использованный варик.|
				#------------------------------:
				del_from_mayused(k)

				#------------------------------|
				# Добавляем варианты для палуб.|
				#------------------------------:
				add2mayused(p)

				#------------------------------|
				# Ставим палубу-макет.         |
				#------------------------------:
				mat[p.y][p.x] = '!'
			#}
			
			if ready: break
			pass
		#} while(!ready)

		#------------------------------|
		# Узакониваем макет: '!' -> '*'|
		# Ауру переводим в запрет.     |
		#------------------------------:
		ship_end_set()
	#}
	#------------------------------|
	# Все корабли расставлены!     |
	#------------------------------:
	clear_for_user()

	return "Good!"
	

"""
#-----------------------------------------------|
# ПОДЗЕМЕЛЬЕ.                                   |
#-----------------------------------------------:
"""
#-----------------------------------------------|
# Получаем инициализированную '.' матрицу.      |
#-----------------------------------------------:
func get_matrix_instance(sz : Vector2):
	mat = PoolStringArray()
	mat.resize(sz.y)
	
	var row : String = E.repeat(sz.x)
	
	for i in sz.y:
		mat[i] = row
		pass
	
	return mat
	
	
func debug(mat):
	for row in mat:
		print (row)
		pass
	pass


#------------------------------|
# Суть: передача по ссылке.    |
#------------------------------:
func debugo(o):
	print("#debugo--------------------:")
	debug(o.mat)
	pass
	

func foo():
	
	pass


#------------------------------|
# Перед установкой лодки.      |
#------------------------------:
func ship_start_set():
	
	for     y in mat.size():
		for x in mat[0].length():
			var c = mat[y][x]
			if  c == 'a' || c == '!':
				mat[y][x] =  E
			pass
		pass
	mayused.resize(0)
	pass
	
#--------------------------|
# Сбор разрешенных точек.  |
#--------------------------:
var mayused = PoolVector2Array()

func add2mayused(var p : Vector2):
	var m = \
	[
		Vector2(p.x - 1, p.y    ),
		Vector2(p.x    , p.y - 1),
		Vector2(p.x    , p.y + 1),
		Vector2(p.x + 1, p.y    ),

		Vector2(p.x - 1, p.y - 1),
		Vector2(p.x - 1, p.y + 1),
		Vector2(p.x + 1, p.y - 1),
		Vector2(p.x + 1, p.y + 1)
	]

	aura(m);

	var R = sz.y;
	var C = sz.x;
	
	for i in 4:
		if (0 <= m[i].x && m[i].x < C &&
			0 <= m[i].y && m[i].y < R &&
			mat[m[i].y][m[i].x] == 'a' && is_noexist(m[i]) ):
			mayused.push_back(m[i])
			pass
		pass
	pass
	
#--------------------------|
# Без повторов.            |
#--------------------------:
func is_noexist(var p : Vector2) -> bool:
	
	for pp in mayused:
		if p == pp:
			return false
		pass
	return true
	

#--------------------------|
# Аура вокруг палубы.      |
#--------------------------:
func aura(m):

	var R = sz.y
	var C = sz.x

	for i in m.size():
		if  0 <= m[i].x && m[i].x < C && \
			0 <= m[i].y && m[i].y < R && \
			mat[m[i].y][m[i].x] == '.' :

			mat[m[i].y][m[i].x] = 'a'
			pass
		pass
	pass


#--------------------------|
# Удаление исп. точки.     |
#--------------------------:
func del_from_mayused(var i : int):
	mayused.remove(i)
	pass
	
#--------------------------|
# Завершение установки.    |
#--------------------------:
func ship_end_set():
	for     y in sz.y:
		for x in sz.x:
			if  mat[y][x] == 'a':
				mat[y][x] =  'z'
				pass
			elif mat[y][x] == '!':
				mat [y][x] =   P
				pass
			pass
		pass
	pass

	
#--------------------------|
# Очистка от служебн. инфы.|
#--------------------------:
func clear_for_user():
	for     y in sz.y:
		for x in sz.x:

			match mat[y][x]:
				'.':
					pass
				'a':
					mat[y][x] = '.'
					pass
				'z': 
					mat[y][x] = '.'
					pass
			pass
		pass
	pass


#--------------------------|
# Рандомная точка на поле. |
#--------------------------:
func rrand(val : Vector2) -> Vector2:
	return Vector2(
		Mylib.rrandi(0, int(val.x)),
		Mylib.rrandi(0, int(val.y))
	)


"""
#-----------------------------------------------|
# Tutor:                                        |<--- ?
# class instance object.                        |
#-----------------------------------------------:
"""
var object = InnerClass.new(2023)

func test000():
	var getInnerValue = object.getAnother()
	print(getInnerValue)
	pass


class InnerClass:

	var another : int
	
	func _init(val : int):
		another = val
		pass
   
	func getAnother():
		return another

	
"""
#-----------------------------------------------|
# Data_matrix                                   |<--- ?
# Решение завернуь матрицу сюда не принято ...  |
#-----------------------------------------------:
"""
class Data_matrix:

	var sz : Vector2
	
	func _init(SZ : Vector2):
		sz = SZ
		pass


	func getAnother():
		return sz
