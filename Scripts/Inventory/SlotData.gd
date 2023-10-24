extends Resource

class_name SlotData

export var max_stack_size : int = 99
export(Resource) var item_data 
export(int, 1, 10) var stack_size = 1  setget set_stack_size

func set_stack_size(value : int) -> void:
	stack_size = value
	if stack_size > 1 and not item_data.stackable:
		stack_size = 1
		push_error("%s is not stackable, reset to 1" % item_data.name)
