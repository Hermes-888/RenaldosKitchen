extends Area


# Declare member variables here. Examples:
var animPlayerH


# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayerH = get_parent_spatial().get_node("AnimationPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _AreaTrigger_entered(_body):
	animPlayerH.play("OpenHotholdoor")


func _AreaTrigger_exited(_body):
	animPlayerH.play_backwards("OpenHotholdoor")
