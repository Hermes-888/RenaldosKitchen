extends Area


# Declare member variables here. Examples:
var animPlayerFD


# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayerFD = get_parent_spatial().get_node("AnimationPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# TODO: why do the front doors jitter if they have colliders
func _AreaTrigger_entered(_body):
	animPlayerFD.play("OpenFrontDoors")
	#pass


func _AreaTrigger_exited(_body):
	#animPlayerFD.play_backwards("OpenFrontDoors")
	pass
