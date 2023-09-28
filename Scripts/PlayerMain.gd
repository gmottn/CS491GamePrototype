extends KinematicBody

# Player class, Ahmed Faisal september 27th


onready var camera = $Head/Camera

var gravity = -30
export var max_speed = 8
export var mouse_sensitivity = 0.002  # radians/pixel

var velocity = Vector3()

func mouse_input(event):
	pass

func get_input(delta):
	var input_dir = Vector3()
	
	if Input.is_action_pressed("player_up"):
		input_dir += -global_transform.basis.z * delta
	if Input.is_action_pressed("player_down"):
		input_dir += global_transform.basis.z * delta
	if Input.is_action_pressed("player_left"):
		input_dir += -global_transform.basis.x * delta
	if Input.is_action_pressed("player_right"):
		input_dir += global_transform.basis.x * delta
	
	input_dir = input_dir.normalized()
	return input_dir



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = get_input(delta)
	
	
