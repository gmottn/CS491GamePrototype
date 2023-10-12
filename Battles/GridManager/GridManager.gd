extends Node

var GridSlotScene = preload("res://Battles/GridManager/GridSlot.tscn")
var alternativeSlotSprite = preload("res://Battles/GridManager/GridSprites/sPlaceHolderGrid.PNG")
#define these
var tilesBetweenGrids = 2
	#vertical ratios
var topBetweenGridRatio = 0.30
var verticalGridRatio = 0.5
var gridBetweenBottomRatio = 0.20
	#horizontal ratios
var leftBetweenGridRatio = 0.15
var horizontalGridRatio = 0.7
var rightBetweenGridRatio = 0.15
#will be defined by BattleScreen scene
var heroGrid = []
var enemyGrid = []
var tileSize = 0
var tileStartX = 0
var tileStartY = 0




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

#builds the hero and enemy grids while configurng the camera to display everything properly
func build_grids():
	build_hero_grid()
	build_enemy_grid()
	configure_camera()
#builds hero grid on the left side, placing slots on occupiable spaces
func build_hero_grid():
	var y = -1
	var x = -1
	for i in heroGrid:
		y+=1
		for j in i:
			x+=1
			#if int(j) != 2:
			create_GridSlot(j,x,y,"hero")
			
		x = -1
#builds enemy grid on the right side, placing slots on occupiable spaces
func build_enemy_grid():
	var y = -1
	var x = -1
	for i in enemyGrid:
		y+=1
		for j in i:
			x+=1
			if typeof(j) != TYPE_INT or j != 2:
				create_GridSlot(j,x,y,"enemy")
		x = -1
#creates a gridslot based on the x,y position given by the previous build_rid functions
#entity = the name of the entity to create there if a string is given here
#type = hero or enemy, used to pass off to the slot instance itself TODO
func create_GridSlot(entity,x,y,type):
	var slotInstance = GridSlotScene.instance()
	var slotSprite = slotInstance.get_node("Sprite")
	var baseX = 0 #base is the base position that is different for hero and enemy grid used for calculating the position the grid should be
	var baseY = 0
	if(type == "hero"):
		baseX = tileStartX
		baseY = tileStartY
	else: #type = "enemy"
		baseX = tileStartX + ((get_grid_width(heroGrid) + tilesBetweenGrids) * tileSize)
		baseY = tileStartY
		
	change_sprite(x,y, slotSprite)
	slotInstance.position = Vector2(baseX + x*slotSprite.texture.get_width(),baseY + y*slotSprite.texture.get_height())
	slotInstance.z_index = 2
	slotInstance.type = type
	
	#if(type == "hero"):
		#heroGrid[x][y] = slotInstance
	#else:
		#enemyGrid[x][y] = slotInstance
	add_child(slotInstance)
#changes the sprite based on its placement on the board... should alternate so that the grid is clearly viible
func change_sprite(x,y,slotSprite):
	if((x + y) % 2 == 0):
		slotSprite.texture = alternativeSlotSprite
#configures the camera placement
func configure_camera():
	configure_camera_placement()
	configure_camera_zoom()
#zooms in camera according to screen ratios and sprite sizes
func configure_camera_zoom():
	var desiredHeight = (get_largest_column() * tileSize)/verticalGridRatio
	var desiredWidth = (((get_largest_row() * 2) + tilesBetweenGrids) * tileSize)/horizontalGridRatio
	var viewportSize = get_viewport().size
	var viewportWidth = viewportSize.x
	var viewportHeight = viewportSize.y
	var zoomY = desiredHeight/viewportHeight
	var zoomX = desiredWidth/viewportWidth
	var newZoom = 0
	if (zoomY > zoomX):
		newZoom = zoomY
	else:
		newZoom = zoomX
		#have the offset feature fix any discrepencies with the ratios
	$Camera2D.zoom = Vector2(newZoom,newZoom)
	
	configure_camera_offset(desiredHeight)
	
	#$Camera2D.configure_zoom(horizontalGridSize,verticalGridSize)
#sets initial camera placement
func configure_camera_placement():
	var xPlacement = (tileSize * (get_grid_width(heroGrid) + (tilesBetweenGrids/2)))
	var yPlacement = tileStartY + (tileSize * (get_largest_column()/2))
	$Camera2D.position = Vector2(xPlacement,yPlacement)
#offsets camra placement basd on vertical ratios
func configure_camera_offset(desiredHeight):
	var ratio =  gridBetweenBottomRatio - topBetweenGridRatio
	if(ratio == 0):
		return
	var offsetDirection = ratio/abs(ratio)
	ratio = abs(ratio)
	var change = desiredHeight * ratio
	$Camera2D.position = Vector2($Camera2D.position.x, $Camera2D.position.y + (change * offsetDirection))
	
		
		
			
	
func get_largest_row():
	var heroRowSize = get_grid_width(heroGrid);
	var enemyRowSize = get_grid_width(enemyGrid);
	if(heroRowSize > enemyRowSize):
		return heroRowSize
	else:
		return enemyRowSize
func get_largest_column():
	var heroColumnSize = get_grid_height(heroGrid);
	var enemyColumnSize = get_grid_height(enemyGrid);
	if(heroColumnSize > enemyColumnSize):
		return heroColumnSize
	else:
		return enemyColumnSize
func get_grid_width(grid):
	return grid[0].size()
func get_grid_height(grid):
	return grid.size()
	
