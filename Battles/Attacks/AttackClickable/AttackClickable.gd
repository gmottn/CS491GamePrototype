extends Node2D

var battleManager = null
var basePositionX = position.x - 20
var basePositionY = position.y + 10
var basePosition = Vector2(basePositionX,basePositionY)
var distanceBetween = 10
var distanceMult = 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	battleManager = get_tree().get_root().find_node("BattleManager",true,false)
	battleManager.connect("state_changed",self,"_on_state_changed_triggered")
	print("Attack Clickable created At")
	var offset = Vector2(distanceMult * distanceBetween,0)
	position = basePosition + offset
	print(position)
	
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and battleManager.gameState == "SlotSelected":
		print("Selected Attack...")
		print(distanceMult)
		battleManager.changeState("Targeting")
		get_parent().update_depth(1)
		
func _on_state_changed_triggered(newState,oldState):
	if(newState == "Hero"):
		queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_mouse_entered():
	get_parent().target_code()



func _on_Area2D_mouse_exited():
	if(battleManager.gameState != "Targeting"):
		get_parent().target_removal_code()


