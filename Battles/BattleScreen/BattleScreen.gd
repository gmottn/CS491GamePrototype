extends Node2D


var battleID = 1; # the id that will be used to find the battle layout in the BattleDatabase 
var gridTileScene = preload("res://Battles/GridManager/GridSlot.tscn")
var tileSize = gridTileScene.instance().get_node("Sprite").texture.get_width()

#sky and floor
var floorWidth = 50 # how many tiles the floor makes up horizonatlly
var floorHeight = 20# how many tiles the floor makes up vertically
var tileStartX = tileSize/2 #essentially where the first tile should be placed, all other tiles will use this as reference
var tileStartY = tileSize/2
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var grids = get_grids()
	$GridManager.enemyGrid = grids[1]
	$GridManager.heroGrid = grids[0]
	$GridManager.tileSize = tileSize
	$GridManager.tileStartX = tileStartX
	$GridManager.tileStartY = tileStartY
	build_background()
	$GridManager.build_grids()
	

#gets the grids based on the battle_id
func get_grids():
	var grids = $BattleDatabase.get_battle(battleID)
	assert(grids,"Invalid ID")
	return grids
#builds the background floor of the battle
func build_background():
	var texture = preload("res://Battles/GridManager/GridSprites/sPlaceHolderBattleFiller.PNG")
	for column in range(floorHeight/2):
		for row in range(floorWidth/2):
			var floorSprite = Sprite.new()
			floorSprite.texture = texture
			floorSprite.position = Vector2(tileStartX + (tileSize * row), tileStartY + (tileSize * column))
			add_child(floorSprite)
			floorSprite = Sprite.new()
			floorSprite.texture = texture
			floorSprite.position = Vector2(tileStartX + (tileSize * row * -1), tileStartY + (tileSize * column))
			add_child(floorSprite)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass