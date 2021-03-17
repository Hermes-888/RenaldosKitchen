extends Spatial


# Manager:
# Mouse enter/exit Hot and Cold faucet handles see GUI names
# Mouse enter SpoutArea, toggle rotate left or right

# https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# transform.basis = Basis(Vector3(1, 0, 0), PI) * transform.basis
# animate Camera

# Declare member variables
var animPlayer
var spoutEmitter
var spoutRotated = false # toggle animation
var spoutRotation = 213 # direction
var paperEmitter


# Called when the node enters the scene tree for the first time.
func _ready():
	spoutEmitter = get_node("SpoutBase/CPUParticles")
	# ERR: spoutEmitter.color(0,0,1,0.8)
	
	paperEmitter = get_node("Triggers/CPUPaperParticles")
	
	animPlayer = get_node("AnimationPlayer")
	animPlayer.play("MoveCamera")# Start: move toward sink
	# at End: move back and rotate left to look at door handle


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Handle_Hot_mouse_entered():
	#spoutEmitter.color(0.25,0,0,0.5)# make the color blue?
	spoutEmitter.emitting = true


func _on_Handle_Hot_mouse_exited():
	pass # Replace with function body.


func _on_Handle_Cold_mouse_entered():
	# https://www.youtube.com/watch?v=ytL9nIYfcn0
	#spoutEmitter.mesh.material.albedo.color(0,0,1,0.8)# make the color blue?
	spoutEmitter.emitting = false


func _on_Handle_Cold_mouse_exited():
	pass # Replace with function body.


func _on_SpoutArea_mouse_entered():
	# toggle Tween rotate spout and SpoutBase left or right
	 
	if (spoutRotated):
		get_node("SpoutBase").transform.basis = Basis(Vector3(0, 1, 0), spoutRotation)
		get_node("hand_sink/Faucet_spout").transform.basis = Basis(Vector3(0, 1, 0), spoutRotation)
	if (!spoutRotated):
		get_node("SpoutBase").transform.basis = Basis(Vector3(0, 1, 0), -spoutRotation)
		get_node("hand_sink/Faucet_spout").transform.basis = Basis(Vector3(0, 1, 0), -spoutRotation)
		
	spoutRotated = !spoutRotated
	# combine sink & legs Rename and re-import!


func _on_Soap_mouse_entered():
	print("soap dispenses particle blob once?")
	pass # Replace with function body.


func _on_Paper_Towels_mouse_entered():
	print("Paper towels dispenses animated paper?")
	paperEmitter.emitting =  true;# one shot
	pass # Replace with function body.
