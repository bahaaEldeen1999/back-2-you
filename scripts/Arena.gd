extends Node2D
var ballSc = preload("res://Ball.tscn");

onready var canvasModulateNode = $CanvasModulate;
var ballNode = ballSc.instance();
func _ready():
	get_node("CanvasModulate/Goal1").connect("goal_signal",self,"_on_goal_hit");
	get_node("CanvasModulate/Goal2").connect("goal_signal",self,"_on_goal_hit");
	ballNode.name = "Ball"

	
func _on_goal_hit(goal_number):
	#get_tree().reload_current_scene();
	#$CanvasModulate/Ball.global_transform = Vector2.ZERO;
	pass

func _process(delta):
	#if Input.is_action_just_pressed("pause"):
	#	get_tree().paused = !get_tree().paused;
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene();
