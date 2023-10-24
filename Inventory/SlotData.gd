extends Resource

class_name SlotData


export var MAX_STACK_SIZE : int = 99
export(Resource) var item_data
export(int, 1, 99) var stack_size = 1  setget set_stack_size

func can_fully_stack(other_data : SlotData) -> bool:
	return item_data == other_data.item_data and item_data.stackable and stack_size + other_data.stack_size <= MAX_STACK_SIZE
	
func fully_stack(other_data : SlotData) -> void:
	stack_size += other_data.stack_size
	
func can_stack(other_data : SlotData) -> bool:
	return item_data == other_data.item_data and item_data.stackable and stack_size + other_data.stack_size < MAX_STACK_SIZE

func set_stack_size(value : int) -> void:
	stack_size = value
	if stack_size > 1 and not item_data.stackable:
		stack_size = 1
		push_error("%s is not stackable, reset to 1" % item_data.name)

func create_single_slot_data() -> SlotData:
	var single_slot_data  : SlotData = duplicate()
	single_slot_data.stack_size = 1
	stack_size -= 1
	return single_slot_data
