extends Node
class_name GridSlot
var gridManager = null
var battleManager = null
var battleEntityScene = preload("res://Battles/BattleEntities/BattleEntity.tscn")
var sprite = null #which sprite for it to display
var location = [0,0] # position on the grid 
var entityName = null
var entity = null # reference to the entity inside of this GridSlot, null means this GridSlot is empty
var affiliation = null # either "hero" or "enemy" to dictate which grid it is part of
var selected = false




# Called when the node enters the scene tree for the first time.
func _ready():
	
	battleManager = get_tree().get_root().find_node("BattleManager",true,false)
	battleManager.connect("state_changed",self,"_on_state_changed_triggered")
	gridManager = get_tree().get_root().find_node("GridManager",true,false)
	#set_sprite()
	#create_entity()


func create_entity(entityName):
	entity = battleEntityScene.instance()
	entity.entityName = entityName
	entity.gridSlot = self
	add_child(entity)
		
	
func set_sprite():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func get_x_location():
	return location[0]
func get_y_location():
	return location[1]


func _on_Area2D_mouse_entered():
	if(battleManager.gameState == "Hero"):
		$SelectedSprite.visible = true



func _on_Area2D_mouse_exited():
	if(!selected):
		$SelectedSprite.visible = false


func _on_Area2D_input_event(viewport, event, shape_idx):
	if battleManager.gameState == "Hero" and event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and entity != null:
		selected = true
		battleManager.changeState("SlotSelected")
		entity.selected_code()

func perform_damage(attack):
	if(entity != null and !entity.dead):
		print("damage done")
		var damage = attack.damage
		var statusEffects = attack.statusEffects
		entity.take_damage(damage,statusEffects)
	if (attack.knockback[0] != 0 or attack.knockback[1] != 0) and entity != null:
		var newLocation = [location[0] + attack.knockback[0],location[1] + attack.knockback[1]]
		
		var newSlot= gridManager.get_slot(newLocation,affiliation)
		gridManager.transfer_entity(self,newSlot)
	
func _on_state_changed_triggered(newState,oldState):
	
	if(newState != "SlotSelected" and newState != "Targeting"):
		selected = false
		$SelectedSprite.visible = false



	

