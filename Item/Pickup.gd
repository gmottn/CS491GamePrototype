extends RigidBody

export var slot_data : Resource
onready var sprite_3d : Sprite3D = $Sprite3D

func _ready() -> void:
	sprite_3d.texture = slot_data.item_data.texture
	
	
func _physics_process(delta : float) -> void:
	sprite_3d.rotate_y(delta)
	
	

func _on_Area_body_entered(body):
	if body.inventory_data.pick_up_slot_data(slot_data):
		queue_free()

