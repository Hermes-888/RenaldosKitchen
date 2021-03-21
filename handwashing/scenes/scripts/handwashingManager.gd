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

var completed = false
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

# UI
var points = 0
var scoreboard # for points
var instructions
var againBtn
var sliderPanel
var tempNum
var tempSlider
var pointSprite
var handCursor = load("res://textures/reachHand.png")
# possibly more. cursor changes at certain steps


func _on_GUI_ready():
	print("GUI ready first")
	scoreboard = get_node("GUI/GridRow/LeftUI/score")# points?
	instructions = get_node("GUI/GridRow/CenterUI/instructions")
	sliderPanel = get_node("GUI/GridRow/RightUI")
	tempNum = get_node("GUI/GridRow/RightUI/temp")# slider output
	tempSlider = get_node("GUI/GridRow/RightUI/tempSlider")
	againBtn = get_node("GUI/GridRow/CenterUI/againBtn")
	pointSprite = get_node("Pointsprite")
	
	# connect listeners to functions in this script
	var _bn = againBtn.connect("pressed", self, "playAgain")
	var _fn = tempSlider.connect("value_changed", self, "sliderChanged")
#	againBtn.visible = false
#	sliderPanel.visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready fired second")
	spoutEmitter = get_node("SpoutBase/CPUWaterParticles")
	paperEmitter = get_node("Triggers/CPUPaperParticles")
	soapEmitter = get_node("Triggers/CPUSoapParticles")
	animPlayer = get_node("AnimationPlayer")
	
	Input.set_custom_mouse_cursor(handCursor, Input.CURSOR_ARROW, Vector2(5,5))
	resetVariables()
	#changeInstructions(stepIndex)
	
	animPlayer.play("MoveCamera")# Start: move camera toward sink
	# at End: move camera back and rotate left to look at door handle


func checkIfCompleted():
	#print(waterOn, waterHot, soapUsed, paperTowelUsed)
	# figure out the best way to determine completed. stepIndex & actionCount?
	if (actionCount > 20):
		completed = true
	print("completed: ", completed, " count: ", actionCount)

func resetVariables():
	actionCount = 0 # +1 for each action until completed
	stepIndex = 0
	points = 0
	completed = false
	waterOn = false
	waterHot = false
	soapUsed = false
	paperTowelUsed = false
	doorOpened = false
	tempSlider.value = 80
	tempNum.text = "80"
	againBtn.visible = false
	sliderPanel.visible = false
	pointSprite.visible = false
	changeInstructions(stepIndex)
	# start w/ blue cold water color
	spoutEmitter.mesh.material.albedo_color = Color(0.11, 0.29, 0.48, 0.5)

# GUI listeners
func playAgain():
	print("play again btn pressed")
	againBtn.visible = false
	resetVariables()
	animPlayer.play("MoveCamera")# Start: move camera toward sink

# GUI tempSlider adjusts water material color (R+, 0.33, B+)
func sliderChanged(value):
	#var e = get_node("GUI/GridRow/RightUI/tempSlider").value
	get_node("GUI/GridRow/RightUI/temp").text = str(value)
	var r = 0.0
	var b = 0.3
	# range 80=Blue - 180=Red step 10
	value = value - 80# adjust to 0-100
	if (value < 50):
		r = 0.1
		b += value / 100
	if (value > 49):
		b = 0.2 # value / 100 # gradual change?
		r += value / 100
	
	var color = Color(r, 0.1, b, 0.5)
	print("slider value: ", value, " ", r, " ", b)#, '-', color)
	spoutEmitter.mesh.material.albedo_color = color

func changeInstructions(index):
	stepIndex = index
	instructions.text = steps[index] # array of steps
	print("change instructions: ", stepIndex, " ", steps[stepIndex])
	# if stepIndex > 0 play +10 animation, add to score
	if (stepIndex > 0):
		points += 10
		scoreboard.text = "SCORE: " + str(points)
		pointSprite.visible = true
		animPlayer.play("showPointsprite")


# connected signals
func _on_Handle_Hot_mouse_entered():
	if (!waterHot):
		waterHot = true
		# +1 water must be hot
		actionCount = actionCount + 1
		sliderPanel.visible = true
	
	if (waterOn and completed):
		waterOn = false
		spoutEmitter.emitting = waterOn
		sliderPanel.visible = false
		changeInstructions(5)
		return
	
	# HOT gui visible above handle?
	# make the color red. ToDo: tempSlider will adjust color (R+, 0.33, B+)
	spoutEmitter.mesh.material.albedo_color = Color(0.48, 0.11, 0.33, 0.5)
	# set slider value?
	spoutEmitter.emitting = true
	waterOn = true


func _on_Handle_Hot_mouse_exited():
	# HOT gui off?
	# why is there no Click Signal?
	pass # UNUSED


func _on_Handle_Cold_mouse_entered():
	if (!waterOn):
		# +1 water must be turned on
		actionCount = actionCount + 1
		sliderPanel.visible = true
	
	if (waterOn and completed):
		waterOn = false
		spoutEmitter.emitting = waterOn
		sliderPanel.visible = false
		changeInstructions(5)
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
	#if (checkIfCompleted()): change to paper towels
	
	if (actionCount > 4):
		if (stepIndex == 0):
			changeInstructions(1)# "Step 2: Use soap from the wall dispenser.",
		
	
	if (completed):
		if (stepIndex == 2):
			changeInstructions(3)# "Step 4: Rinse off the soap.",
	
	if (stepIndex == 3 and actionCount > 12):
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
	if (stepIndex == 1 and !soapUsed):
		# +1 must use soap
#		actionCount = actionCount + 1
#		checkIfCompleted()
		soapUsed = true
		#if (stepIndex == 1):
		changeInstructions(2)# "Step 3: Scrub hands.",
	
	soapEmitter.emitting = true# One Shot then stops


func _on_Paper_Towels_mouse_entered():
	if (stepIndex == 5 and !paperTowelUsed):
		# +1 use a paper towel to dry hands
		paperTowelUsed = true
#		actionCount = actionCount + 1
#		checkIfCompleted()
#		changeInstructions(4)# "O.K. Turn off the water.",
	
	if (actionCount > 20):
		changeInstructions(6)# open the door, touch trash
	
	paperEmitter.emitting =  true# One Shot then stops
	if (completed):
		# wait for seconds?
		# move back and rotate left to look at door handle
		animPlayer.play("LookDoor")


func _on_Door_Handle_mouse_entered():
	# scripted animation rotates door handle
	if (stepIndex == 6 and doorOpened):
		get_node("hand_sink/Door_wooden/Door_handle").transform.basis = Basis(Vector3(0, 0, 1), 0)#13
		#animPlayer.play_backwards("LookDoor")# go back to sink for now
		#resetVariables()
		return
	
	get_node("hand_sink/Door_wooden/Door_handle").transform.basis = Basis(Vector3(0, 0, 1), -13)
	doorOpened = true
	changeInstructions(7)# "Throw away the paper towel.",


func _on_Trash_mouse_entered():
	if (stepIndex == 7):
		changeInstructions(8)# Congratulations
		againBtn.visible = true
