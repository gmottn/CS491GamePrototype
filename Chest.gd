extends StaticBody

signal toggle_inventory(external_inventory_owner)

export var inventory_data : Resource

func player_interact() -> void:
	emit_signal("toggle_inventory", self)
