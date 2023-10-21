extends Control

signal drop_slot_data(slot_data)

var grabbed_slot_data : SlotData
var external_inventory_owner

onready var player_inventory : PanelContainer = $Player_Inventory
onready var grabbed_slot : PanelContainer = $GrabbedSlot
onready var external_inventory : PanelContainer = $External_Inventory

func _physics_process(delta)-> void:
	if grabbed_slot.visible:
		grabbed_slot.rect_global_position = get_global_mouse_position() + Vector2(5, 5)

func set_player_inventory_data(inventory_data : InventoryData) -> void:
	inventory_data.connect("inventory_interact", self, "on_inventory_interact")
	player_inventory.set_inventory_data(inventory_data)
	
func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data
	inventory_data.connect("inventory_interact", self, "on_inventory_interact")
	external_inventory.set_inventory_data(inventory_data)
	
	external_inventory.show()
	
func clear_external_inventory() -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
		inventory_data.disconnect("inventory_interact", self, "on_inventory_interact")
		external_inventory.clear_inventory_data(inventory_data)
	
	external_inventory.hide()
	external_inventory_owner = null
	
func on_inventory_interact(inventory_data : InventoryData, index : int, button_pressed : int) -> void:
	match[grabbed_slot_data, button_pressed]:
		[null, BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
			
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()


func _on_Interface_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and grabbed_slot_data:
		match event.button_index:
			BUTTON_LEFT:
				emit_signal("drop_slot_data", grabbed_slot_data)
				grabbed_slot_data = null
			BUTTON_RIGHT:
				emit_signal("drop_slot_data", grabbed_slot_data.create_single_slot_data())
				if grabbed_slot_data.stack_size < 1:
					grabbed_slot_data = null
					

		update_grabbed_slot()


func _on_Interface_visibility_changed():
	if not visible and grabbed_slot_data:
		emit_signal("drop_slot_data", grabbed_slot_data)
		grabbed_slot_data = null
		update_grabbed_slot()
