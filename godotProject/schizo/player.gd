extends CharacterBody3D

@onready var head = $head
@onready var camera = $head/Camera3D
@onready var use = $head/Camera3D/use # interact button
@onready var delusionStare = $head/Camera3D/delusionStare
@onready var staring = $"../staring" # timer for staring to normalize amount


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
		
		if use.is_colliding() and use.get_collider().is_in_group("delusion"):
			print("delusion interact")
		
		#end of interacting


	# staring either at normal things or delusions
	# note: there will be a cool down for staring so delusion meter doesnt get maxed in 1s


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


	
