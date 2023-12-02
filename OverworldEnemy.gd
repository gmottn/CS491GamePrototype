extends StaticBody
var battleScene = preload("res://Battles/BattleScreen/BattleScreen.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null
var interface = null
var inventory = null
var stats = null
var check = true
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	stats = get_parent().get_node("PlayerStats")
	interface = get_parent().get_node("CanvasLayer/Interface")
	inventory = get_parent().get_node("CanvasLayer/Interface/Player_Inventory")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if(body.name == "Player"):
		initiate_battle()
func initiate_battle():
	var battleInstance = battleScene.instance()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	battleInstance.player = player
	battleInstance.stats = stats
	battleInstance.battleID = random_battle_ID()
	get_tree().root.add_child(battleInstance)
	player.set_process_input(false)
	player.set_process(false)
	interface.visible = false
	
	queue_free()
func _input(event):

	if event is InputEventKey:
		if(event.is_pressed() and event.scancode == KEY_1):
			check = false

func random_battle_ID():
	#if(check):
	#	return 1
	#else:
	#	return 4
	return (randi()%6) + 1
	
