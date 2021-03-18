extends Spatial


# Manager:
# Mouse enter/exit Hot and Cold faucet handles see GUI names
# Mouse enter SpoutArea, toggle rotate left or right

# https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# transform.basis = Basis(Vector3(1, 0, 0), PI) * transform.basis

# Declare member variables
var actionCount = 0 # +1 for each action until completed
var completed = false
# var allowAction = true #EACH STEP? # false can't interact before or after
var waterOn = false
var waterHot = false
var soapUsed = false
var paperTowelUsed = false
var doorOpened = false

var spoutRotated = false # toggle animation
var spoutRotation = 18 # degrees
var spoutEmitter
var paperEmitter
var soapEmitter
var animPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	spoutEmitter = get_node("SpoutBase/CPUWaterParticles") # start w/ blue water color
	spoutEmitter.mesh.material.albedo_color = Color(0.11, 0.29, 0.48, 0.5)
	
	paperEmitter = get_node("Triggers/CPUPaperParticles")
	soapEmitter = get_node("Triggers/CPUSoapParticles")
	
	animPlayer = get_node("AnimationPlayer")
	animPlayer.play("MoveCamera")# Start: move camera toward sink
	# at End: move camera back and rotate left to look at door handle


func checkIfCompleted():
	print(waterOn, waterHot, soapUsed, paperTowelUsed)
	if (actionCount > 15):
		completed = true
	print("completed: ", completed, " count: ", actionCount)


func resetVariables():
	actionCount = 0 # +1 for each action until completed
	completed = false
	# allowAction = true #EACH STEP? # false can't interact before or after
	waterOn = false
	waterHot = false
	soapUsed = false
	paperTowelUsed = false
	doorOpened = false


func _on_Handle_Hot_mouse_entered():
	if (!waterHot):
		waterHot = true
		# +1 water must be hot
		actionCount = actionCount + 1
		checkIfCompleted()
	
	if (waterOn and completed):
		spoutEmitter.emitting = false
		waterOn = false
		return
	
	# HOT gui visible
	# make the color red?
	spoutEmitter.mesh.material.albedo_color = Color(0.48, 0.11, 0.33, 0.5)
	spoutEmitter.emitting = true
	waterOn = true


func _on_Handle_Hot_mouse_exited():
	# HOT gui off?
	pass # UNUSED


func _on_Handle_Cold_mouse_entered():
	if (!waterOn):
		# +1 water must be turned on
		actionCount = actionCount + 1
		checkIfCompleted()
	
	if (waterOn and completed):
		spoutEmitter.emitting = false
		waterOn = false
		return
	
	# COLD gui visible
	# make the color blue?
	spoutEmitter.mesh.material.albedo_color = Color(0.11, 0.29, 0.48, 0.5)
	spoutEmitter.emitting = true
	waterOn = true


func _on_Handle_Cold_mouse_exited():
	# COLD gui off
	pass # UNUSED


func _on_SpoutArea_mouse_entered():
	# +1 simulate handwashing by touching 15 times?  $BUTTON_LEFT = down
	actionCount = actionCount + 1 # WIP
	checkIfCompleted()
	
	var dur = 0.3 # duration
	var rotateTo = spoutRotation # flip if condition
	#var spoutFrom = get_node("SpoutBase").rotation_degrees.y
	var faucetFrom = get_node("hand_sink/Faucet_spout").rotation_degrees.y
	var stween = get_node("World/Tween")
	var ftween = get_node("World/Tween")
	#example: toggle Tween rotate spout and SpoutBase left or right
	#tween.interpolate_property(obj, "position", from, to, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.start()
	
	if (!spoutRotated):
		rotateTo = -rotateTo
	
	# scripted animation
	#get_node("SpoutBase").transform.basis = Basis(Vector3(0, 1, 0), rotateTo)
	stween.interpolate_property(get_node("SpoutBase"), "rotation_degrees", 
		Vector3(0,faucetFrom,0), Vector3(0,rotateTo,0), dur, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) # delay (optional)
	stween.start()
	
	#get_node("hand_sink/Faucet_spout").transform.basis = Basis(Vector3(0, 1, 0), rotateTo)
	ftween.interpolate_property(get_node("hand_sink/Faucet_spout"), "rotation_degrees", 
		Vector3(0,faucetFrom,0), Vector3(0,rotateTo,0), dur, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	ftween.start()
	
	spoutRotated = !spoutRotated


func _on_Soap_mouse_entered():
	#print("soap dispenses particle blob once?")
	if (!soapUsed):
		# +1 must use soap
		soapUsed = true
		actionCount = actionCount + 1
		checkIfCompleted()
	
	soapEmitter.emitting = true


func _on_Paper_Towels_mouse_entered():
	#print("Paper towels dispenses animated paper?")
	if (!paperTowelUsed):
		# +1 use a paper towel to dry hands
		paperTowelUsed = true
		actionCount = actionCount + 1
		checkIfCompleted()
	
	paperEmitter.emitting =  true# one shot
	if (completed):
		# move back and rotate left to look at door handle
		animPlayer.play("LookDoor")


func _on_Door_Handle_mouse_entered():
	# scripted animation rotates door handle
	if (doorOpened):
		get_node("hand_sink/Door_wooden/Door_handle").transform.basis = Basis(Vector3(0, 0, 1), 0)#13
		animPlayer.play_backwards("LookDoor")
		resetVariables()
		return
	
	get_node("hand_sink/Door_wooden/Door_handle").transform.basis = Basis(Vector3(0, 0, 1), -13)
	doorOpened = true
	print("Done")
	# trigger Done GUI
