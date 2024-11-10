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

@onready var w2b = $"../gList/w2b"
@onready var w2bw = $"../gList/w2bw"
@onready var w2bwe = $"../gList/w2bwe"
@onready var w2e = $"../gList/w2e"
@onready var w2em = $"../gList/w2em"
@onready var w2w = $"../gList/w2w"
@onready var w2we = $"../gList/w2we"
@onready var w2be = $"../gList/w2be"

@onready var w3c = $"../gList/w3c"
@onready var w3cm = $"../gList/w3cm"
@onready var w3e = $"../gList/w3e"
@onready var w3m = $"../gList/w3m"

@onready var w4c = $"../gList/w4c"
@onready var w4e = $"../gList/w4e"
@onready var w4w = $"../gList/w4w"
@onready var w4wc = $"../gList/w4wc"

@onready var credits = $"../credits"


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
@onready var eggs_collected = false


var week1 = false
var week2 = false
var week3 = false
var week4 = false


static var delusionMeter = 0 # will increase when staring or interacting with delusions
static var week = 4 # updates the events that appear in the map

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
			if intObj.is_in_group("checkout"):
				if week == 1 and soda_collected and chips_collected:
					week+=1
					get_tree().reload_current_scene()
				elif week == 2 and bread_collected and water_collected and eggs_collected:
					week+=1
					get_tree().reload_current_scene()
				elif week == 3 and choco_bar_collected and milk_collected:
					week+=1
					get_tree().reload_current_scene()
				elif week == 4 and chips_collected and water_collected:
					print("end")
					credits.visible = true
					
				
			if intObj.is_in_group("npc"):
				print("npc")
			elif intObj.is_in_group("foodItem"):
				print("food")
				if intObj.is_in_group("chips"):
					chips_collected = true
					print (chips_collected,"chips")
				if intObj.is_in_group("soda"):
					soda_collected = true
					print (soda_collected, "soda")
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
				if intObj.is_in_group("eggs"):
					eggs_collected = true
				if intObj.is_in_group("bread"):
					bread_collected = true
		
		if use.is_colliding() and use.get_collider().is_in_group("delusion"):
			print("delusion interact")
		
		#end of interacting

# checking list
	if Input.is_action_just_pressed("groceryList") and !gList.visible:
		gList.visible = true
		if week == 1:
			w1e.visible = true
			# chips and soda
			if chips_collected and soda_collected:
				w1cs.visible = true
				w1c.visible = false
				w1e.visible = false
				w1s.visible = false
			elif chips_collected and !soda_collected:
				w1cs.visible = false
				w1c.visible = true
				w1e.visible = false
				w1s.visible = false
			elif !chips_collected and soda_collected:
				w1cs.visible = false
				w1c.visible = false
				w1e.visible = false
				w1s.visible = true
			print(week1)
		if week == 2:
			w2em.visible = true
			# bread, water, eggs
			if bread_collected and water_collected and eggs_collected:
				w2b.visible = false
				w2bw.visible = false
				w2bwe.visible = true
				w2e.visible = false
				w2em.visible = false
				w2w.visible = false
				w2we.visible = false
				w2be.visible = false
			elif !bread_collected and water_collected and eggs_collected:
				w2b.visible = false
				w2bw.visible = false
				w2bwe.visible = false
				w2e.visible = false
				w2em.visible = false
				w2w.visible = false
				w2we.visible = true
				w2be.visible = false
			elif bread_collected and !water_collected and eggs_collected:
				w2b.visible = false
				w2bw.visible = false
				w2bwe.visible = false
				w2e.visible = false
				w2em.visible = false
				w2w.visible = false
				w2we.visible = false
				w2be.visible = true
			elif bread_collected and water_collected and !eggs_collected:
				w2b.visible = false
				w2bw.visible = true
				w2bwe.visible = false
				w2e.visible = false
				w2em.visible = false
				w2w.visible = false
				w2we.visible = false
				w2be.visible = false
			elif !bread_collected and !water_collected and eggs_collected:
				w2b.visible = false
				w2bw.visible = false
				w2bwe.visible = false
				w2e.visible = true
				w2em.visible = false
				w2w.visible = false
				w2we.visible = false
				w2be.visible = false
			elif bread_collected and !water_collected and !eggs_collected:
				w2b.visible = true
				w2bw.visible = false
				w2bwe.visible = false
				w2e.visible = false
				w2em.visible = false
				w2w.visible = false
				w2we.visible = false
				w2be.visible = false
			elif !bread_collected and water_collected and !eggs_collected:
				w2b.visible = false
				w2bw.visible = false
				w2bwe.visible = false
				w2e.visible = false
				w2em.visible = false
				w2w.visible = true
				w2we.visible = false
				w2be.visible = false
				
			print(week2)
		if week == 3:
			w3e.visible = true
			if choco_bar_collected and milk_collected:
				w3e.visible = false
				w3c.visible = false
				w3m.visible = false
				w3cm.visible = true
			elif !choco_bar_collected and milk_collected:
				w3e.visible = false
				w3c.visible = false
				w3m.visible = true
				w3cm.visible = false
			elif choco_bar_collected and !milk_collected:
				w3e.visible = false
				w3c.visible = true
				w3m.visible = false
				w3cm.visible = false
			
			print(week3)
		if week == 4:
			w4e.visible = true
			if water_collected and chips_collected:
				w4e.visible = false
				w4w.visible = false
				w4c.visible = false
				w4wc.visible = true
			elif !water_collected and chips_collected:
				w4e.visible = false
				w4w.visible = false
				w4c.visible = true
				w4wc.visible = false
			elif water_collected and !chips_collected:
				w4e.visible = false
				w4w.visible = true
				w4c.visible = false
				w4wc.visible = false
			print(week4)
		
	elif Input.is_action_just_pressed("groceryList") and gList.visible:
		gList.visible = false



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




	
