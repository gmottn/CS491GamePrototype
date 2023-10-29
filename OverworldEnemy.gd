extends StaticBody
var battleScene = preload("res://Battles/BattleScreen/BattleScreen.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if(body.name == "Player"):
		initiate_battle()
func initiate_battle():
	var battleInstance = battleScene.instance()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().root.add_child(battleInstance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = battleInstance
	
