extends Node
# this is an abstract meant to extend all scenes and scripts that go in a battle so they all have acces to the battle manager and the grid manager
var gridManager = null
var battleManager = null
var UI = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	battleManager = get_tree().get_root().find_node("BattleManager",true,false)
	gridManager = get_tree().get_root().find_node("GridManager",true,false)
	UI = gridManager.get_node("UI_Layer").get_node("Panel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
