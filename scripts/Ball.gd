extends RigidBody2D


export var HIT_FORCE = 100;

var ball_hit_sound = preload("res://sound/ball_kick.wav");
var reset_state = false;
onready var audioStreamPlayer2dNode = $AudioStreamPlayer2D;

func _ready():
	get_parent().get_node("Player1").connect("hit_ball",self,"_on_player_attack");
	get_parent().get_node("Player2").connect("hit_ball",self,"_on_player_attack");
	get_parent().get_node("Goal1").connect("goal_signal",self,"_on_goal_hit");
	get_parent().get_node("Goal2").connect("goal_signal",self,"_on_goal_hit");
	print("ball ready")

func _on_player_attack(hit_vector):
	audioStreamPlayer2dNode.stream = ball_hit_sound;
	audioStreamPlayer2dNode.play();
	print("hit vector",hit_vector);
	linear_velocity *= 0;
	apply_central_impulse(hit_vector*HIT_FORCE);
	apply_torque_impulse(100)
	
func _on_goal_hit(goal_number):
	reset_state = true;
	print("reset ball")


func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0, Vector2(520, 424));
		linear_velocity *= 0
		reset_state = false
