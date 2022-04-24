extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var light_color = Color(1,0,0);
onready var light = $Light2D;
# Called when the node enters the scene tree for the first time.
func _ready():
	light.color =  light_color;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
