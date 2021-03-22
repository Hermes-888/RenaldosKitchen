extends Spatial


# Manager:
# Mouse enter/exit Hot and Cold faucet handles see GUI names
# Mouse enter SpoutArea, toggle rotate left or right

# https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# transform.basis = Basis(Vector3(1, 0, 0), PI) * transform.basis
# ToDo: audio for paper towels, door knob, water, points
#	Theme for UI
#	UI for points graphic floats upwards and fades out w/sound
#	tempSlider adjusts the color of the water? output to temp in ui (R, 0.33, B)
#	Cursor starts as graphic of a hand, 2 hands, png sequence of hands washing, hand w/ towel
#	Cursor changes to paper towel to open door

# Have you discussed if TPC can use employees for another companies projects?
# Will we have access to TPC services and assets?

# Declare variables
var actionCount = 0 # +1 for each action until completed
var stepIndex = 0
var steps = [
	"Step 1: Turn on the water and wet your hands.",
	"Step 2: Use soap from the wall dispenser.",
	"Step 3: Scrub your hands for 15 seconds.",
	"Step 4: Rinse off the soap.",
	"Turn off the water.",
	"Step 5: Use a paper towel.",
	"Open the door with the paper towel.",
	"Throw away the paper towel.",
	"Congratulations! You did it."
]
# set cursor to cursors[stepIndex]
#var cursors = []

var completed = false
var waterOn = false
var waterHot = false
var waterDone = false # stop interaction
var sliderUsed = false
var soapUsed = false
var paperTowelUsed = false
var doorOpened = false

var spoutRotated = false # toggle animation
var spoutRotation = 18 # degrees

# UI
var points = 0
var instructions
var againBtn
var tempSlider
var handCursor = load("res://textures/reachHand.png")
var pointCursor = load("res://textures/pointHand.png")
var grabCursor = load("res://textures/grabHand.png")
# possibly more. cursor changes at certain steps


func _on_GUI_ready():
	print("GUI ready first")
	
	instructions = get_node("GUI/GridRow/CenterUI/instructions")
	tempSlider = get_node("GUI/GridRow/RightUI/tempSlider")
	againBtn = get_node("GUI/GridRow/CenterUI/againBtn")
	
	# connect signals to functions in this script
	var _bn = againBtn.connect("pressed", self, "playAgain")
	var _fn = tempSlider.connect("value_changed", self, "sliderChanged")


# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready fired second")
#	Input.set_custom_mouse_cursor(handCursor, Input.CURSOR_ARROW, Vector2(5,5))
	resetVariables()
	
	$AnimationPlayer.play("MoveCamera")# Start: move camera toward sink
	# at End: move camera back and rotate left to look at door handle


func checkIfCompleted():
	#print(waterOn, waterHot, soapUsed, paperTowelUsed)
	# figure out the best way to determine completed. stepIndex & actionCount?
	if actionCount > 20:
		completed = true
	print("completed: ", completed, " count: ", actionCount)

func resetVariables():
	actionCount = 0 # +1 for each action until completed
	stepIndex = 0
	points = 0
	completed = false
	waterOn = false
	waterHot = false
	waterDone = false
	sliderUsed = false
	soapUsed = false
	paperTowelUsed = false
	doorOpened = false
	tempSlider.value = 80
	$GUI/GridRow/RightUI/temp.text = "80"
	$GUI/GridRow/CenterUI/againBtn.visible = false
	$GUI/GridRow/RightUI.visible = false
	$Pointsprite.visible = false
	$GUI/MarginContainer/thumbHand.visible = false
	changeInstructions(stepIndex) # "Step 1: Turn on the water and wet your hands.",
	# start w/ blue cold water color
	$SpoutBase/CPUWaterParticles.mesh.material.albedo_color = Color(0.11, 0.29, 0.48, 0.5)
	# set cursor to cursors[stepIndex]
	Input.set_custom_mouse_cursor(handCursor, Input.CURSOR_ARROW, Vector2(5,5))

# GUI listeners
func playAgain():
	print("play again btn pressed")
	$GUI/GridRow/CenterUI/againBtn.visible = false
	resetVariables()
	$AnimationPlayer.play("MoveCamera")# Start: move camera toward sink

# GUI tempSlider adjusts water material color (R+, 0.33, B+)
func sliderChanged(value):
	#var e = get_node("GUI/GridRow/RightUI/tempSlider").value
	get_node("GUI/GridRow/RightUI/temp").text = str(value)
	var r = 0.0
	var b = 0.3
	# range 80=Blue - 180=Red step 10
	value = value - 80# adjust to 0-100
	if value < 50:
		r = 0.1
		b += value / 100
	if value > 49:
		b = 0.2 # value / 100 # gradual change?
		r += value / 100
	
	var color = Color(r, 0.1, b, 0.5)
	print("slider value: ", value, " ", r, " ", b)#, '-', color)
	$SpoutBase/CPUWaterParticles.mesh.material.albedo_color = color
	
	if !sliderUsed and value > 40 and value < 70:
		sliderUsed = true # only fire once
		# show thumbs up
		$GUI/MarginContainer/thumbHand.visible = true
		# add points
		$Pointsprite.visible = true
		$AnimationPlayer.play("showPointsprite")
		$World/AudioStreamPlayer.play()
		points += 10
		$GUI/GridRow/LeftUI/score.text = "SCORE: " + str(points)

func changeInstructions(index):
	stepIndex = index
	$GUI/GridRow/CenterUI/instructions.text = steps[index] # array of strings
	#print("change instructions: ", stepIndex, " ", steps[stepIndex])
	# play +10 animation and add to score
	if stepIndex > 0:
		$Pointsprite.visible = true
		$AnimationPlayer.play("showPointsprite")
		$World/AudioStreamPlayer.play()
		points += 10
		$GUI/GridRow/LeftUI/score.text = "SCORE: " + str(points)
	
	if stepIndex == 5:
		waterDone = true # "Step 5: Use a paper towel.",


# connected signals
func _on_Handle_Hot_mouse_entered():
	if waterDone:
		return # stop interaction
	
	if !waterHot:
		waterHot = true
		# +1 water must be hot
		actionCount = actionCount + 1
		$GUI/GridRow/RightUI.visible = true
		# Too HOT color red. set slider value too high, points for slider lowered
		tempSlider.value = 170
		$GUI/GridRow/RightUI/temp.text = "170"
		$SpoutBase/CPUWaterParticles.mesh.material.albedo_color = Color(0.68, 0.11, 0.33, 0.5)
		$SpoutBase/CPUWaterParticles.emitting = true
	
	if waterOn and completed:
		waterOn = false
		$SpoutBase/CPUWaterParticles.emitting = waterOn
		$GUI/GridRow/RightUI.visible = false
		changeInstructions(5)
		return
	
	waterOn = true


func _on_Handle_Cold_mouse_entered():
	if waterDone:
		return # stop interaction
	
	if !waterOn:
		# +1 water must be turned on
		actionCount = actionCount + 1
		$GUI/GridRow/RightUI.visible = true
		# COLD make the color blue and show particles
		$SpoutBase/CPUWaterParticles.mesh.material.albedo_color = Color(0.11, 0.29, 0.48, 0.5)
		$SpoutBase/CPUWaterParticles.emitting = true
	
	if waterOn and completed:
		waterOn = false
		$SpoutBase/CPUWaterParticles.emitting = waterOn
		$GUI/GridRow/RightUI.visible = false
		changeInstructions(5)
		return
	
	waterOn = true


func _on_SpoutArea_mouse_entered():
	if waterDone:
		return # stop interaction
	
	# +1 simulate handwashing by touching 15 times?  $BUTTON_LEFT = down
	# WIP: viewer clicks on png sequence of hands scrubbing (animated loop). 
	# for 15 seconds to change the sequence image. maybe? 
	actionCount = actionCount + 1
	checkIfCompleted() # trigger Step 4: Rinse
	
	if actionCount > 4 and stepIndex == 0:
		changeInstructions(1)# "Step 2: Use soap from the wall dispenser.",
	
	if completed and stepIndex == 2:
		changeInstructions(3)# "Step 4: Rinse off the soap.",
	
	if stepIndex == 3 and actionCount > 12:
		# hide thumbs up
		$GUI/MarginContainer/thumbHand.visible = false
		changeInstructions(4)# "O.K. Turn off the water.",
	
	var dur = 0.3 # duration
	var rotateTo = spoutRotation # flip if condition
	#var spoutFrom = get_node("SpoutBase").rotation_degrees.y
	var faucetFrom = get_node("hand_sink/Faucet_spout").rotation_degrees.y
	var stween = get_node("World/Tween")
	var ftween = get_node("World/Tween")
	#example: toggle Tween rotate spout and SpoutBase left or right
	#tween.interpolate_property(obj, "position", from, to, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.start()
	
	if !spoutRotated:
		rotateTo = -rotateTo
	
	# scripted and Tween animation for both base and mesh
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
	if stepIndex == 1 and !soapUsed:
		# +1 must use soap
		soapUsed = true
		changeInstructions(2)# "Step 3: Scrub hands.",
	
	$Triggers/CPUSoapParticles.emitting = true# One Shot then stops


func _on_Paper_Towels_mouse_entered():
	if stepIndex == 5 and !paperTowelUsed:
		# +1 use a paper towel to dry hands
		paperTowelUsed = true
		changeInstructions(6)# open the door, touch trash
		# set cursor to cursors[stepIndex]
		Input.set_custom_mouse_cursor(grabCursor, Input.CURSOR_ARROW, Vector2(5,5))
	
	$Triggers/CPUPaperParticles.emitting =  true# One Shot then stops
	
	if completed and stepIndex == 6:
		# wait for seconds
		yield(get_tree().create_timer(4.5), "timeout")
		# move back and rotate left to look at door handle
		$AnimationPlayer.play("LookDoor")


func _on_Door_Handle_mouse_entered():
	# scripted animation rotates door handle
	if stepIndex == 6 and doorOpened:
		get_node("hand_sink/Door_wooden/Door_handle").transform.basis = Basis(Vector3(0, 0, 1), 0)
		return
	
	get_node("hand_sink/Door_wooden/Door_handle").transform.basis = Basis(Vector3(0, 0, 1), -13)
#	var ftween = get_node("World/Tween")
#	ftween.interpolate_property($hand_sink/Door_wooden/Door_handle, "rotation_degrees", 
#		Vector3(0.3, 0, 0), Vector3(0.835, 0, 0), 0.3, 
#		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	ftween.start()
	doorOpened = true
	changeInstructions(7)# "Throw away the paper towel.",


func _on_Trash_mouse_entered():
	if stepIndex == 7:
		$GUI/MarginContainer/thumbHand.visible = true
		changeInstructions(8)# Congratulations
		$GUI/GridRow/CenterUI/againBtn.visible = true
		# set cursor to cursors[stepIndex]
		Input.set_custom_mouse_cursor(pointCursor, Input.CURSOR_ARROW, Vector2(5,5))
