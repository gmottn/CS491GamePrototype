extends "res://Battles/Attacks/AttackScripts/AttackBase.gd"
var itemClickableScene = preload("res://Battles/Attacks/AttackClickable/ItemClickable.tscn")
var amount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func enough_MP():
	if(amount > 0):
		return true
	else:
		UI.temp_message("None of that item left", "", 2)
		return false
	
func deduct_MP():
	amount -= 1;
	attackClickable.get_node("Label").text = "X" + str(amount)
	battleManager.deduct_from_inventory(attackName)
	

func initialize_attack():
	attackClickable = itemClickableScene.instance()
	attackClickable.attack = self
	gridManager.get_node("UI_Layer/Panel/Items").add_child(attackClickable)

