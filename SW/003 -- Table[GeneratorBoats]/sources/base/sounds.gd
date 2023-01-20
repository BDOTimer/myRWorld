"""
#------------------------------------------------------------------------------|
# class_name sounds
#------------------------------------------------------------------------------:
"""
class_name sounds extends Node
 
var snd : Array
var m   = [PoolIntArray()]


const filename_snds = \
{	"s01.wav" : 0,
	"s02.wav" : 1,
	"s03.mp3" : 2
}

func _init(parent : Node):
	
	self.name =  "sounds"
	parent.add_child(self)
	
	var pathes = filename_snds.keys()

	for i in filename_snds.size():

		snd   .push_back(AudioStreamPlayer2D.new())
		snd[i].stream = load("res://res/snd/" + pathes[i])
		self  .add_child(snd[i])

		#snd[i].connect("finished", self, "Stop")
		#snd[i].loop = false
		pass
	pass


func Playi(  i :  int):
	
	stopall()
	if 0 <= i && i < snd.size():
		snd[i].play()
		pass
	else:
		print("ERROR: sounds.gd->Play(", i, "): ")
		pass
	pass
	

func Play(name : String):
	
	var i : int = filename_snds[name]
	
	if 0 <= i && i < self.get_child_count():
		self.get_child(i).play()
		#snd[i].play()
		pass
	else:
		print("ERROR: sounds.gd->Play(", i, "): ")
		pass
	pass


func stopall():
	for i in filename_snds.size():
		snd[i].stop()
		pass
	pass


func Stop():
	print("Stop ...")
	pass

