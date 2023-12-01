extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var defaultPortrait = preload("res://Battles/BattleEntities/EntitySprites/Portraits/blank-profile-picture-973460_1280-705x705.png")
var HP = null
var MP = null
var attacksPanel = null
var itemsPanel = null
var portrait = null
var selected = null setget selected_code
var moveButton = null
var itemButton = null
var message = null
var subMessage = null
var battleManager = null
var tempMessageTimer = null
var mode = "item"



# Called when the node enters the scene tree for the first time.
func _ready():
	
	update_switchButton()
	battleManager = get_tree().get_root().find_node("BattleManager",true,false)
	battleManager.connect("state_changed",self,"_on_state_changed_triggered")
	HP = get_node("HP")
	MP = get_node("MP")
	attacksPanel = get_node("Attacks")
	itemsPanel = get_node("Items")
	portrait = get_node("Portrait")
	moveButton = get_node("MoveButton")
	itemButton = get_node("ItemButton")
	message = get_node("Message")
	subMessage = get_node("SubMessage")
	tempMessageTimer = get_node("TempMessageTimer")
	_on_state_changed_triggered()
	
	selected_code(null)
func selected_code(value):
		if(mode == "item"):
			update_switchButton()
		selected = value
		var selectedHP = null
		var selectedMaxHP = null
		var selectedMP = null
		var selectedMaxMP = null
		var selectedPortrait = null
		attacksPanel.reset()
		itemsPanel.reset()
		if(is_instance_valid(selected)):
			selectedHP = selected.hp
			selectedMaxHP = selected.maxHp
			selectedMP = selected.mp
			selectedMaxMP = selected.maxMp
			selectedPortrait = selected.portrait
			itemsPanel.set_caster(selected)
		else:
			selectedHP = "-"
			selectedMaxHP = "-"
			selectedMP = "-"
			selectedMaxMP = "-"
			selectedPortrait = defaultPortrait
			attacksPanel.clear()
			
		update_HP(selectedHP,selectedMaxHP)
		update_MP(selectedMP,selectedMaxMP)
		update_portrait(selectedPortrait)
		update_move()
		update_items()
func update_HP(selectedHP,selectedMaxHP):
	selectedHP = str(selectedHP)
	selectedMaxHP = str(selectedMaxHP)
	HP.text = selectedHP + " / " + selectedMaxHP
func update_MP(selectedMP,selectedMaxMP):
	selectedMP = str(selectedMP)
	selectedMaxMP = str(selectedMaxMP)
	MP.text = selectedMP + " / " + selectedMaxMP
func update_portrait(selectedPortrait):
	portrait.texture = selectedPortrait
	if(is_instance_valid(selected) and selected.affiliation == "enemy"):
		portrait.flip_h = true
	else:
		portrait.flip_h = false
	if(is_instance_valid(selected) and !(selected.active)):
		portrait.self_modulate.a= 0.5
	else:
		portrait.self_modulate.a= 1
func update_move():
	if(is_instance_valid(selected)):
		moveButton.visible = true
	else:
		moveButton.visible = false
func update_items():
	if(is_instance_valid(selected)):
		itemButton.visible = true
	else:
		itemButton.visible = false
		
func update_message(msg,sub):
	message.text = msg
	subMessage.text = sub
	
func _on_state_changed_triggered():
	if(battleManager.is_turn("hero") and !battleManager.is_state("finished")):
		if(battleManager.is_state("hero")):
			update_message("Hero Turn", "(Click on a hero on the left hand grid to select them)")
		elif(battleManager.is_state("slotSelected")):
			update_message("Select Attack","(BACKSPACE to deselect, Click on one of the attacks above to trigger it)")
		elif(battleManager.is_state("targeting")):
			update_message("Select Target", "(BACKPACE to deselect, Click on a target)")
	elif(battleManager.is_turn("enemy") and !battleManager.is_state("finished")):
		update_message("Enemy Turn", "(Please wait as the enemies carry out their attack)")
func temp_message(msg,sub,time):
	update_message(msg,sub)
	tempMessageTimer.start(time)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TempMessageTimer_timeout():
	_on_state_changed_triggered()




func _on_ItemButton_pressed():
	update_switchButton()
func update_switchButton():
	if mode == "attack":
		mode = "item"
		$Attacks.visible = false
		$Items.visible = true
		$Attacks.offset = 0
		$LeftButtonAttacks.visible = false
		$RightButtonAttacks.visible = false
		$Items.update_arrows()
		
	else:
		mode = "attack"
		$Attacks.visible = true
		$Items.visible = false
		$Items.offset = 0
		$LeftButtonItems.visible = false
		$RightButtonItems.visible = false
		$Attacks.update_arrows()
	$ItemButton.update()
	
