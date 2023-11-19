extends Spatial

const PickUp = preload("res://Item/Pickup.tscn")

onready var player : KinematicBody = $Player
onready var interface : Control = $CanvasLayer/Interface

# Generation Code

const dir = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]

var grid_size = 10
var grid_steps = 100


func _generatemap():
	randomize()
	
	var current_pos = Vector2(0,0)
	var current_dir = Vector2.RIGHT
	
	var last_dir = current_dir * -1
		
	for x in range(-12,12):
		for y in range(-12,12):
			$GridMap.set_cell_item(x, -1, y, 0)
			$GridMap.set_cell_item(x, 0, y, 1)
			#$GridMap.set_cell_item(x, 1, y, 0)
	
	for i in range(0,grid_steps):
		var temp_dir = dir.duplicate()
		temp_dir.shuffle()
		var d = temp_dir.pop_front()
		
		while (abs(current_pos.x + d.x) > grid_size or 
		abs(current_pos.y + d.y) > grid_size or d == last_dir * -1):
			temp_dir.shuffle()
			d = temp_dir.pop_front()
			
		current_pos += d
		last_dir = d
		
		
		
		$GridMap.set_cell_item(current_pos.x, -1, current_pos.y, 0)
		$GridMap.set_cell_item(current_pos.x, 0, current_pos.y, -1)
		#$GridMap.set_cell_item(current_pos.x, 1, current_pos.y, 2)
		
	

func _ready() ->void:
	_generatemap()
	player.connect("toggle_inventory", self, "toggle_interface")
	interface.set_player_inventory_data(player.inventory_data)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.connect("toggle_inventory", self, "toggle_interface")
		

func toggle_interface(external_inventory_owner = null) -> void:
	interface.visible = not interface.visible
	
	if interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if external_inventory_owner and interface.visible:
		interface.set_external_inventory(external_inventory_owner)
	else:
		interface.clear_external_inventory()


func _on_Interface_drop_slot_data(slot_data):
	var pick_up = PickUp.instance()
	pick_up.slot_data = slot_data
	pick_up.global_transform.origin = player.get_drop_position()
	add_child(pick_up)
	
