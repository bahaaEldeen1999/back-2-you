extends RigidBody2D


export var HIT_FORCE = 100;

func _ready():
	get_parent().get_node("Player").connect("hit_ball",self,"_on_player_attack");
	print("ball ready")

func _on_player_attack(hit_vector):
	print("hit vector",hit_vector);
	apply_central_impulse(hit_vector*HIT_FORCE);
	apply_torque_impulse(1000)
