extends Panel

var numButtons = 0
var offset = 0 setget set_offset
var leftButton = null
var rightButton = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	leftButton = get_parent().get_node("LeftButton")
	rightButton = get_parent().get_node("RightButton")
	update_arrows()
func clear():
	numButtons = 0
	rightButton.visible = false
	leftButton.visible = false
	for index in range(get_child_count()):
		var attackButton = get_child(index)
		attackButton.delete_self()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_buttons():
	for i  in range(get_child_count()):
		var button = get_child(i)
		var num = ((i+1) - (4 * offset))
		place_button(button,num)
	
		
		

func _on_Attacks_child_entered_tree(node):
	numButtons+=1
	place_button(node,numButtons)
	update_arrows()
func place_button(node,num):
	var xPosition = 0
	var yPosition = 0
	if(num > 4 or num < 1):
		xPosition = -10000
		yPosition = -10000
	else:
		xPosition = ((num % 2) * -300) + 350
		if(num > 2):
			num = 1
		else:
			num = 0 
		yPosition = ((50 * num) + 25)
	node.set_position(Vector2(xPosition,yPosition))


func reset():
	
	offset = 0

func update_arrows():
	var effectiveNum = (numButtons + (-4 * offset))
	if(effectiveNum > 4):
		rightButton.visible = true
	else:
		rightButton.visible = false
	if(offset > 0):
		leftButton.visible = true
	else:
		leftButton.visible = false
	

func set_offset(value):
	offset = value
	update_arrows()
	update_buttons()
func _on_LeftButton_pressed():
	set_offset(offset - 1)


func _on_RightButton_pressed():
	set_offset(offset + 1)
