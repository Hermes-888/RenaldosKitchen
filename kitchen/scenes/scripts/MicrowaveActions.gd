extends Area


# Declare member variables here. Examples:
var animPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayer = get_parent_spatial().get_node("AnimationPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# connected signal nodes
func _AreaTrigger_entered(_body):
	animPlayer.play("OpenMicDoor")


func _AreaTrigger_exited(_body):
	animPlayer.play_backwards("OpenMicDoor")
