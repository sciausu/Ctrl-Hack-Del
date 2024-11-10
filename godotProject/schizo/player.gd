extends CharacterBody3D

@onready var head = $head
@onready var camera = $head/Camera3D
@onready var use = $head/Camera3D/use # interact button
@onready var delusionStare = $head/Camera3D/delusionStare
@onready var staring = $"../staring" # timer for staring to normalize amount

@onready var gList = $"../gList"
@onready var w1e = $"../gList/w1e"
@onready var w1c = $"../gList/w1c"
@onready var w1s = $"../gList/w1s"
@onready var w1cs = $"../gList/w1cs"

# Defines the images to toggle betweeen
var images = []
var current_image_index = 0

@onready var chips_collected = false
@onready var soda_collected = false
@onready var choco_bar_collected = false
@onready var candy_collected = false
@onready var milk_collected = false
@onready var water_collected = false
@onready var lotto_collected = false
@onready var bread_collected = false


var week1 = false
var week2 = false
var week3 = false
var week4 = false


static var delusionMeter = 0 # will increase when staring or interacting with delusions
static var week = 1 # updates the events that appear in the map

var mouseSens = 0.02
var cursor = false

const SPEED = 5.0



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	
	if event is InputEventMouseMotion and !cursor:
		head.rotate_y(-event.relative.x * (mouseSens/4))
		camera.rotate_x(-event.relative.y * (mouseSens/4))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# interacting with objects
	if Input.is_action_just_pressed("interact"):
		# interactable obj
		if use.is_colliding() and use.get_collider().is_in_group("interactable"):
			print("interacting") # testing
			var intObj = use.get_collider()
			if intObj.is_in_group("npc"):
				print("npc")
			elif intObj.is_in_group("food"):
				print("food")
				if intObj.is_in_group("chips"):
					chips_collected = true
					print (chips_collected)
				if intObj.is_in_group("soda"):
					soda_collected = true
					print (soda_collected)
				if intObj.is_in_group("choco_bar"):
					choco_bar_collected = true
					print (choco_bar_collected)
				if intObj.is_in_group("candy"):
					candy_collected = true
					print (candy_collected)
				if intObj.is_in_group("milk"):
					milk_collected = true
					print (milk_collected)
				if intObj.is_in_group("water"):
					water_collected = true
					print (water_collected)
				if intObj.is_in_group("lotto"):
					lotto_collected = true
					print (lotto_collected)
		
		if use.is_colliding() and use.get_collider().is_in_group("delusion"):
			print("delusion interact")
		
		#end of interacting

	# stop movement and mouse movement
	if Input.is_action_just_pressed("escape") and !cursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cursor = true
	elif Input.is_action_just_pressed("escape") and cursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		cursor = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		velocity = velocity.lerp(direction * (SPEED-0), (SPEED*3.4) * delta)
	else:
		velocity = velocity.lerp(direction * SPEED, (SPEED-3) * delta)
	
	#if direction and !cursor: # dissables movement if mouse cursor is on
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
		
	
	
	
	move_and_slide()




	
