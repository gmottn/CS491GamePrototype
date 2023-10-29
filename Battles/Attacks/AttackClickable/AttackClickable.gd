extends Button

var battleManager = null
var basePositionX = rect_position.x - 10
var basePositionY = rect_position.y + 100
var basePosition = Vector2(basePositionX,basePositionY)
var distanceBetween = (86 * 2)
var distanceMult = 1
var attack = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	text = attack.get_script().resource_path.get_file().get_basename()
	rect_size.x = 86
	rect_size.y = 34
	battleManager = get_tree().get_root().find_node("BattleManager",true,false)
	battleManager.connect("state_changed",self,"_on_state_changed_triggered")
	print("Attack Clickable created At")
	var offset = Vector2(distanceMult * distanceBetween,0)
	rect_position = basePosition + offset
	print(rect_position)
	

		
func _on_state_changed_triggered(newState,oldState):
	if(newState == "Hero"):
		queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_Button_mouse_entered():
	if battleManager.gameState == "SlotSelected":
		attack.target_code()


func _on_Button_mouse_exited():
	if(battleManager.gameState != "Targeting"):
		attack.target_removal_code()


func _on_Button_pressed():
	if battleManager.gameState == "SlotSelected":
		print("Selected Attack...")
		print(distanceMult)
		battleManager.changeState("Targeting")
		attack.update_depth(1)
