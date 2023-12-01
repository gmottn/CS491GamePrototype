extends KinematicBody

signal toggle_inventory

export var inventory_data : Resource
export var equipment_data : Resource
onready var ray_cast = $RayCast
onready var camera : Camera = $Head/Camera

# Player class, Ahmed Faisal september 27th


var speed = 20
var acceleration = 20
var gravity = 9.8
var jump = 5

var mouse_sensitivity = 0.05;

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

onready var head = $Head

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		
		head.rotation.x = clamp(head.rotation.x, deg2rad(-85),deg2rad(70))
	if event is InputEventKey:
		if(event.is_pressed() and event.scancode == KEY_R):
			get_tree().reload_current_scene()

func _process(delta):
	
	direction = Vector3()
	#print(translation)
	if not is_on_floor():
		fall.y -= gravity * delta
	
	#disable jump because its pointless
	#if Input.is_action_pressed("player_jump"):
	#	fall.y = jump

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_pressed("player_up"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("player_down"):
		direction += transform.basis.z

	if Input.is_action_pressed("player_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("player_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	
	velocity = move_and_slide(velocity,Vector3.UP)
	
	move_and_slide(fall,Vector3.UP)
	
	if Input.is_action_just_pressed("inventory"):
		emit_signal("toggle_inventory")
	if Input.is_action_just_pressed("interact"):
		interact()
		
func interact() -> void:
	if ray_cast.is_colliding():
		ray_cast.get_collider().player_interact()
	
func get_drop_position() -> Vector3:
	var direction = -camera.global_transform.basis.z
	return camera.global_transform.origin + direction
