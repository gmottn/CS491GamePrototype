extends PanelContainer

signal slot_clicked(index, button_pressed) 

onready var texture_rect : TextureRect = $MarginContainer/TextureRect
onready var quantity_label : Label = $QuantatityLabel

func set_slot_data(slot_data : SlotData) -> void:
	if slot_data:
		var item_data = slot_data.item_data
		texture_rect.texture = item_data.texture
		var tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	
		if slot_data.stack_size > 1:
			quantity_label.text = "x%s" % slot_data.stack_size
			quantity_label.show()
		else:
			quantity_label.hide()
	else:
		texture_rect.texture = null
		quantity_label.text = ""


func _on_Slot_gui_input(event):
	if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT or event.button_index == BUTTON_RIGHT) and event.is_pressed():
		emit_signal("slot_clicked", get_index(), event.button_index)
