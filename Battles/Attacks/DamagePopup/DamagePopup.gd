extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var distance = Vector2(0,-10)
var initialOffset = Vector2(0,-15)
var duration = 1
var damage = 0
var statusEffects = []
var color = Color(1,1,1,1)
var green = Color(0,1,0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	#position  += initialOffset
	if(typeof(damage) == TYPE_STRING):
		$Label.modulate = color
		$Label.text =  damage
	else:
		$Label.text = str(abs(damage))
		if(damage >= 0):
			$Label.modulate = color
		else:
			$Label.modulate = green
	start_movement_and_fadeout()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
func start_movement_and_fadeout():
	$Tween.interpolate_property(self,"position", position,position + distance,1.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self,"modulate:a", 1, 0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	


func _on_Tween_tween_completed(object, key):
	queue_free()
