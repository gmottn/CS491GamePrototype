extends Node
var AI = null
var num = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_AnimatedSprite2_animation_finished():
	AI.AI_continue()
	print("I am...")
	print(self)
	print(num)
	queue_free()
	print("TEst")
