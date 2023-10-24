extends PanelContainer

const Slot = preload("res://Levels/Slot.tscn")

onready var ItemGrid :GridContainer = $MarginContainer/ItemGrid



func populate_item_grid(slot_datas : Array)  -> void:
	for child in ItemGrid.get_children():
		child.queue_free()
	
	for slot_data in slot_datas:
		var slot = Slot.instance()
		ItemGrid.add_child(slot)
		
		if slot_data != null:
			slot.set_slot_data(slot_data)
		
	
