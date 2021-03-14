extends Area


# Declare member variables here. Examples:
var emitter

# Called when the node enters the scene tree for the first time.
func _ready():
	emitter = get_parent_spatial().get_node("CPUParticles")

func _AreaTrigger_entered(_body):
	emitter.emitting = true

func _AreaTrigger_exited(_body):
	emitter.emitting = false
