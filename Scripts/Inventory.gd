extends PanelContainer

const Slot = preload("res://Levels/Slot.tscn")

onready var ItemGrid :GridContainer = $MarginContainer/ItemGrid

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.connect("inventory_updated", self, "populate_item_grid")
	populate_item_grid(inventory_data)
	
func clear_inventory_data(inventory_data : InventoryData) -> void:
	inventory_data.disconnect("inventory_updated", self, "populate_item_grid")
	
		
func populate_item_grid(inventory_data : InventoryData)  -> void:
	for child in ItemGrid.get_children():
		child.queue_free()
		
	var data = inventory_data.Data
	
	for slot_data in data:
		var slot = Slot.instance()
		ItemGrid.add_child(slot)
		slot.connect("slot_clicked", inventory_data, "on_slot_clicked")
		
		if slot_data != null:
			slot.set_slot_data(slot_data)
		
	
