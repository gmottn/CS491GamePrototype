extends Button

var battleManager = null
var myPanel = null 


var attack = null
var active = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	battleManager = get_tree().get_root().find_node("BattleManager",true,false)
	if(is_instance_valid(attack)):
		text = attack.get_script().resource_path.get_file().get_basename()
		battleManager.connect("state_changed",self,"_on_state_changed_triggered")

	

		
func _on_state_changed_triggered():
	if battleManager.is_state("Hero") or battleManager.is_state("enemy"):
		delete_self()
func delete_self():
	if(text != "Move"):
		attack.delete_self()
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_Button_mouse_entered(AIPass = false):
	if (battleManager.is_state("slotselected") and visible and is_instance_valid(attack))or AIPass:
		
		attack.target_code()


func _on_Button_mouse_exited(AIPass = false):
	if(!battleManager.is_state("targeting") and visible and is_instance_valid(attack)) or AIPass:
		attack.target_removal_code()

	



func _on_Button_pressed(AIPass = false):
	if battleManager.is_state("slotselected") or AIPass:
		if(AIPass or attack.enough_MP()):
			print("Selected Attack...")
			
			battleManager.changeState("Targeting")
			attack.update_depth(1)


		
		
