extends "res://Battles/GridManager/BattleElement.gd"


var type = null
var number = 0;
var gridSlot = null
var splashSlots = []
var targets = []
var depth = 0
var selected = false
var attack = null

# Called when the node enters the scene tree for the first time.
func _ready():
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
func _on_Area2D_mouse_entered(AIPass = false):
	if($Sprite.visible  and depth == attack.depth) or AIPass:
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
	for target in targets:
		if(is_instance_valid(target)):
			target.delete_self()
	targets = []
func delete_self():
	remove_splash_targets()
	queue_free()

func _on_Area2D_mouse_exited(AIpass = false):
	if(!selected and $Sprite.visible and depth == attack.depth) or AIpass:
		remove_splash_targets()

func _on_Area2D_input_event(viewport, event, shape_idx,AIpass = false):
	if (event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and $Sprite.visible  and depth == attack.depth) or AIpass:
		selected = true
		if(targets.size() != 0):
			attack.update_depth(1)
		else:
			attack.update_depth((attack.maxDepth+1)-attack.depth)
		print("Change")
		

func configure_visibility():
	if battleManager.is_state("Enemy"):
		pass
	
		
func _on_state_changed_triggered():
	if !battleManager.is_state("Targeting"):
		delete_self()

func validate_self():
	
			for target in targets:
				if(is_instance_valid(target)):
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
	if(type == "Unselectable"):
		print("I AM Unselectable...")
		print(self)
	if($Sprite.visible):
		print("I am Visible")
		print(self)
		print("I am at...")
		print(gridSlot.location)
		attack.attack_code(gridSlot)
		for target in targets:
			if(target.type == "Unselectable" || depth >= 3):
				print("My name is...")
				print(self)
				print("My depth is...")
				print(depth)
				print("My type is...")
				print(type)
				print("I am about to activate...")
				print(target)
				print("which is type...")
				print(target.type)
				print("test")
			target.perform_attack()
func create_splash_targets():
		if($Sprite.visible):
			print(depth)
			var targetType = ""
			if(depth >= attack.maxDepth):
				targetType = "Unselectable"
			targets = gridManager.create_targets(splashSlots,attack,targetType,depth+1)
