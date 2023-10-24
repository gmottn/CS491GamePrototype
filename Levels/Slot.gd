extends PanelContainer

onready var texture_rect = $MarginContainer/TextureRect
onready var quantuty_label = $QuantatityLabel

func set_slot_data(slot_data : SlotData):
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	var tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	
	if slot_data.stack_size > 1:
		quantuty_label.text = "x%s" % slot_data.stack_size
		quantuty_label.show()
