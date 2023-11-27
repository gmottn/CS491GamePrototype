#This handles all the clicks from the user minus the clicks on the buttons on the panel
#The point of this is to avoid race conditions
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var mousePos = get_global_mouse_position()
		var space = get_world_2d().direct_space_state
		var collision_objects = space.intersect_point(mousePos, 1)
		if collision_objects:
			print(collision_objects[0].collider.name)
		else:
			print("no hit")
	
	# Implement your logic to identify the clicked object (e.g., based on node types or naming conventions)

