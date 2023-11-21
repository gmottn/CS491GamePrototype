extends Spatial

const PickUp = preload("res://Item/Pickup.tscn")

onready var player : KinematicBody = $Player
onready var interface : Control = $CanvasLayer/Interface


func _ready() ->void:
	player.connect("toggle_inventory", self, "toggle_interface")
	interface.set_player_inventory_data(player.inventory_data)
	interface.set_player_equipment_data(player.equipment_data)
	
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
	
