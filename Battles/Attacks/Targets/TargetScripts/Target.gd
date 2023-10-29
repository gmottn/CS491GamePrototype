extends Node2D

var battleManager = null
var gridManager = null
var type = null
var gridSlot = null
var splashSlots = []
var splashTargets = []
var depth = 0
var selected = false
var attack = null

# Called when the node enters the scene tree for the first time.
func _ready():
	gridManager = get_tree().get_root().find_node("GridManager",true,false)
	battleManager = get_tree().get_root().find_node("BattleManager",true,false)
	battleManager.connect("state_changed",self,"_on_state_changed_triggered")
	battleManager.connect("depth_changed",self,"_on_depth_changed_triggered")
	var orange = Color(1,0.647,0,1)
	$Sprite.modulate = orange
	
		
	configure_splash_slots()
	configure_visibility()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func configure_splash_slots():
	var x = 0
	var y = 0
	for slotOffset in attack.splashSpots:
		x = gridSlot.get_x_location() + slotOffset[0]
		y = gridSlot.get_y_location() + slotOffset[1]
		var location = Vector2(x,y)
		var slot = get_opposing_slot(location)
		if(slot):
			splashSlots.append(slot)
func _on_Area2D_mouse_entered():
	create_splash_targets()

func get_opposing_slot(location):
	if(attack.affiliation == "hero"):
		return gridManager.get_slot(location,"enemy")
	else:
		return gridManager.get_slot(location,"hero")
func get_my_slot(location):
	print(attack.affiliation)
	
	return gridManager.get_slot(location,attack.affiliation)
func remove_splash_targets():
	for target in splashTargets:
		target.delete_self()
	splashTargets = []
func delete_self():
	remove_splash_targets()
	queue_free()

func _on_Area2D_mouse_exited():
	if(!selected and $Sprite.visible):
		remove_splash_targets()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if(depth == 0):
		battleManager.baseAttacker = [self]
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and $Sprite.visible:
		selected = true
		attack.update_depth(1)
		print("Change")
		
func perform_damage(emit):
	if($Sprite.visible):
		for target in splashTargets:
			target.perform_damage(false)
		gridSlot.perform_damage(attack)
		if(emit):
			battleManager.changeState("Hero")
	delete_self()
func configure_visibility():
	if battleManager.gameState == "Enemy":
		$Sprite.visible = false
	
		
func _on_state_changed_triggered(newState,oldState):
	if(newState != "Targeting"):
		delete_self()

func validate_self():
	for target in splashTargets:
		target.validate_self()
	if(attack.depth == depth):
		selected = false
	if(attack.depth < depth):
		delete_self()
	if(attack.depth != depth and !selected):
		$Sprite.visible = false
	else:
		$Sprite.visible = true
func perform_attack():
	if($Sprite.visible):
		attack.attack_code(gridSlot)
		for target in splashTargets:
			target.perform_attack()
func create_splash_targets():
		if($Sprite.visible):
			var targetType = ""
			if(depth >= attack.maxDepth):
				targetType = "Unselectable"
			splashTargets = gridManager.create_targets(splashSlots,attack,targetType,depth+1)
