extends "res://Battles/GridManager/BattleElement.gd"
var attached = null
var passOffEntities = []
var clickSpriteScene = preload("res://Battles/clickSprite/ClickSprite.tscn")
var attacks = []
var clicknum = 0

var path = []
var pathTargetSelection = []
var pathSpot = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	if(attached == null):
		attached = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func activate(passOffEntities):
	passOffEntities.remove(0)
	self.passOffEntities = passOffEntities
	print("I am AI attached to")
	print(attached)
	click(attached.gridSlot)
	
	
func deactivate():
	#attached.active = false
	path = []
	pathTargetSelection = []
	pathSpot = 0
	if(passOffEntities.size() > 0):
		var entity = passOffEntities[0]
		if(is_instance_valid(entity.AI)):
			entity.AI.activate(passOffEntities)
	
func AI_continue():
	print(battleManager.stateToChangeTo)
	if(battleManager.is_state("slotselected")):
		slotselected_code()
	elif(battleManager.is_state("targeting")):
		targeting_code()
	else:
		deactivate()

func slotselected_code():
	var move = attached.moveAttack
	hidden_button_hover(move.attackClickable)
	if(move.targets.size() > 0 and (randi() % 100) >75):
		#movement instead
		var targetNum = randi() % move.targets.size()
		path = [move,[targetNum]]
		click_button(path[0].attackClickable)
		pathTargetSelection = path[0].targets
		
		
	else:
		undo_button_hover(move.attackClickable)
		#perform attack
		path = get_best_path()
		print("Best ATTACK is...")
		print(path[0])
		print("Best path is...")
		print(path[1])
		click_button(path[0].attackClickable)
		if(path.size() > 0):
			print("Attack depth is...")
			print(path[0].depth)
			pathTargetSelection = path[0].targets
func targeting_code():
	print("path is...")
	print(path[1])
	if(pathSpot < path[1].size()):
		var currentTarget = pathTargetSelection[path[1][pathSpot]]
		print(currentTarget)
		click(currentTarget)
		pathSpot +=1
		pathTargetSelection = currentTarget.targets
	else:
		deactivate()
	
	
	
	
			#do this based on index of the target since that should be consistent?
		
func click_button(object):
	object._on_Button_mouse_entered(true)
	object._on_Button_pressed(true)
	var clickSprite = clickSpriteScene.instance()
	clickSprite.AI = self
	clicknum +=1
	clickSprite.num = clicknum
	object.add_child(clickSprite)
func click(object):
	var input_event = InputEventScreenTouch.new()
	input_event.position = Vector2(100, 100)  # Set the touch position as needed
	object._on_Area2D_mouse_entered(true)
	object._on_Area2D_input_event(0,input_event,0,true)
	var clickSprite = clickSpriteScene.instance()
	clickSprite.AI = self
	clicknum +=1
	clickSprite.num = clicknum
	object.add_child(clickSprite)
func hidden_click(object):
	var input_event = InputEventScreenTouch.new()
	input_event.position = Vector2(100, 100)  # Set the touch position as needed
	object._on_Area2D_mouse_entered(true)
	object._on_Area2D_input_event(0,input_event,0,true)
	
func get_best_path():#goes through each attack
	var bestAttack = null
	var bestAttackValue = 0
	var bestAttackPath = []
	for attack in attacks:
		
		var relativeBest = 0
		var path = []
		
		
		var bestPath = null
		if(attack.maxDepth == 0):
			hidden_button_hover(attack.attackClickable)
			for target in attack.targets:
				relativeBest+= best_amount_of_hits(target)
			undo_button_hover(attack.attackClickable)
		else:
			attack.attackClickable._on_Button_mouse_entered()
			var myTarget = attack.targets[0]
			attack.attackClickable._on_Button_pressed()
			bestPath = go_through(attack,myTarget,[])
		
			if(relativeBest < bestPath[0]):
				relativeBest = bestPath[0]
				path = bestPath[1]
		#compare attack
		print("Best number of hits for this attack is...")
		print(relativeBest)
		if(bestAttack == null):
			bestAttack = attack
			bestAttackValue = relativeBest
			bestAttackPath = path
		else:
			if bestAttackValue < relativeBest:
				bestAttack = attack
				bestAttackValue = relativeBest
				bestAttackPath = path
		
		attack.update_depth(attack.depth * -1)
	print("Best number of hits is...")
	print(bestAttackValue)
	
	return [bestAttack,bestAttackPath]
		#while(myTarget.depth < attack.maxDepth and myTarget.targets.size() != 0):
		#	hidden_click(myTarget)
		#	myTarget = myTarget.targets[0]
			#hidden_click(myTarget)
func go_through(attack,myTarget,path): #goes through all the paths
	
	var relativeBest = 0
	var returnBest = best_amount_of_hits(myTarget)
	path.append(myTarget.number-1)
	var pathToReturn = path
	hidden_hover(myTarget)
	if(myTarget.depth == attack.maxDepth or myTarget.targets.size() == 0):# you reached the target of maxDepth, going further would trigger the attack
		for target in myTarget.targets:
				returnBest+= best_amount_of_hits(target)
		return[returnBest,pathToReturn]
	else:
		undo_hover(myTarget)
		hidden_click(myTarget)
	var targets = myTarget.targets
	for i in range(targets.size()):
		if(targets[i].type == "Unselectable"): #blue target encountered
			returnBest += best_amount_of_hits(targets[i])
		else:
			var check = go_through(attack,targets[i],path.duplicate())
			if(relativeBest < check[0]):
				relativeBest = check[0]
				pathToReturn = check[1]
	returnBest += relativeBest
	attack.update_depth(-1)
	
	return[returnBest,pathToReturn]
func best_amount_of_hits(myTarget):
	if(is_instance_valid(myTarget.gridSlot.entity)):
		return 1
	else:
		return 0
func hidden_hover(object):
	object._on_Area2D_mouse_entered(true)
func undo_hover(object):
	object._on_Area2D_mouse_exited(true)
func hidden_button_hover(object):
	object._on_Button_mouse_entered(true)
func undo_button_hover(object):
	object._on_Button_mouse_exited(true)
		
		
		
		
		
			
	
	
