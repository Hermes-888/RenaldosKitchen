extends Area


# https://www.youtube.com/watch?v=USfmkHbIRyE&list=PLS9MbmO_ssyDk79j9ewONxV88fD5e_o5d&index=18
# Declare member variables here.
var animPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayer = get_parent_spatial().get_node("AnimationPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass # Replace with function body.


# connected signal nodes
func _AreaTrigger_entered(_body):
	animPlayer.play("OpenDoors")
	#print('Open fridge doors triggered by ' + _body.name)


func _AreaTrigger_exited(_body):
	animPlayer.play_backwards("OpenDoors")
	pass # Replace with function body.
