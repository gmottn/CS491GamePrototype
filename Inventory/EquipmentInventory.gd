extends InventoryData
class_name EquipmentInventory

func drop_slot_data(grabbed_slot_data : SlotData, index : int) -> SlotData:
	if not grabbed_slot_data.item_data is EquipmentData:
		return grabbed_slot_data
	return .drop_slot_data(grabbed_slot_data, index)
	
func drop_single_slot_data(grabbed_slot_data : SlotData, index : int) -> SlotData:
	if not grabbed_slot_data.item_data is EquipmentData:
		return grabbed_slot_data
	return .drop_single_slot_data(grabbed_slot_data, index)
