extends Area2D


var goal_sound = preload("res://sound/goal.wav")
signal goal_signal;

export var light_color = Color(1,0,0);
export var goal_number = "1";
onready var light = $Light2D;
onready var audioStreamPlayer2dNode = $AudioStreamPlayer2D;
# Called when the node enters the scene tree for the first time.
func _ready():
	audioStreamPlayer2dNode.stream = goal_sound;
	light.color =  light_color;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Goal_area_entered(area):
	if area.is_in_group("ball"):
		audioStreamPlayer2dNode.play();
		emit_signal("goal_signal",goal_number);
