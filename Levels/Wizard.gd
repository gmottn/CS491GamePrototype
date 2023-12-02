extends Node


export var max_health : int = 50
onready var health = max_health
export var max_mp : int = 75
onready var mp = max_mp
export var strength : int = 0
export var defense : int = 0
export var agility : int = 5
export var speed : int = 5
export var luck : int = 5
export var intelligance : int = 5
export var color = Color(0.5,0.5,0.5,1)
export var moveSpots = [[1,1],[1,-1],[-1,1],[-1,-1]]
export var attacks = ["Lightning"]
