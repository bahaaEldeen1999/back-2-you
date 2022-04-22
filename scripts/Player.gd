extends KinematicBody2D

export var MAX_SPEED = 405;
export var GRAVITY = 100;
export var MAX_JUMP_COUNT = 2;
export var ACCELERATION = 300;
export var JUMP_FORCE = [300,250];
export var GRAVITY_INCREASE_FACTOR = 1.1;
var snap = true;
var curr_jump_counter = 0;
var velocity = Vector2.ZERO;
var gravity = GRAVITY;
func _ready():
	pass
	
func _physics_process(delta):
	var direction = getPressDirection();
	velocity.x = 0;
	velocity.x += direction.x*ACCELERATION*delta;
	velocity.x = clamp(velocity.x,-MAX_SPEED,MAX_SPEED);
	position.x += velocity.x;
	if (is_on_floor() || curr_jump_counter < MAX_JUMP_COUNT) && direction.y > 0:
		snap = false;
		velocity.y -=  JUMP_FORCE[curr_jump_counter];
		curr_jump_counter+=1;
	elif !is_on_floor():
		snap = false;
		velocity.y += gravity*delta
		gravity *= GRAVITY_INCREASE_FACTOR
	var snap_vector =  Vector2(0, 64) if snap  else Vector2.ZERO;
	move_and_slide_with_snap(velocity,snap_vector,Vector2(0,-1));
	#print(velocity.y)
	if is_on_floor():
		snap = true
		curr_jump_counter = 0
		velocity.y = 0
		gravity = GRAVITY
	#print(curr_jump_counter)
	
	
func getPressDirection():
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),Input.is_action_just_pressed("ui_up"));
