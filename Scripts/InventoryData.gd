extends Resource

class_name InventoryData

signal inventory_updated(inventory_data)
signal inventory_interact(inventory_data, index, button_pressed)

export(Array, Resource) var Data

func on_slot_clicked(index : int, button_pressed : int) -> void:
	emit_signal("inventory_interact", self, index, button_pressed)

func grab_slot_data(index : int) -> SlotData:
	var slot_data = Data[index]
	if slot_data:
		Data[index] = null
		emit_signal("inventory_updated", self)
		return slot_data
	else:
		return null
		
func drop_slot_data(grabbed_slot_data : SlotData, index : int) -> SlotData:
	var slot_data = Data[index]
	
	var can_stack_slot_data : SlotData
	if slot_data and slot_data.can_fully_stack(grabbed_slot_data):
		slot_data.fully_stack(grabbed_slot_data)
		
	else:
		Data[index] = grabbed_slot_data
		can_stack_slot_data = slot_data
	
	emit_signal("inventory_updated", self)
	return can_stack_slot_data
	
func drop_single_slot_data(grabbed_slot_data : SlotData, index : int) -> SlotData:
	var slot_data = Data[index]
	
	if not slot_data:
		Data[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_stack(grabbed_slot_data):
		slot_data.fully_stack(grabbed_slot_data.create_single_slot_data())
		
		
	
	emit_signal("inventory_updated", self)
	
	if grabbed_slot_data.stack_size > 0:
		return grabbed_slot_data
	else:
		return null
		
func pick_up_slot_data(slot_data : SlotData) -> bool:
	
	for index in Data.size():
		if Data[index] and Data[index].can_fully_stack(slot_data):
			Data[index].fully_stack(slot_data)
			emit_signal("inventory_updated", self)
			return true
			
	for index in Data.size():
		if not Data[index]:
			Data[index] = slot_data
			emit_signal("inventory_updated", self)
			return true
	return false
