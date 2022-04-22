extends KinematicBody2D

export var MAX_SPEED = 405;
export var GRAVITY = 100;
export var MAX_JUMP_COUNT = 2;
export var ACCELERATION = 300;
export var JUMP_FORCE = [300,250];
export var GRAVITY_INCREASE_FACTOR = 1.1;
export var SNAP_SIZE = 64;
export var PLAYER_HEIGHT = 64;

onready var animatedSpriteNode = $AnimatedSprite; 

var snap = true;
var curr_jump_counter = 0;
var velocity = Vector2.ZERO;
var gravity = GRAVITY;
var facing_direction = false; # facing right
enum states  {NOT_ATTACKING,ATTACK_UP,ATTACK_MIDDLE,ATTACK_DOWN};
var curr_state = states.NOT_ATTACKING; 

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
	var snap_vector =  Vector2(0, SNAP_SIZE) if snap  else Vector2.ZERO;
	
	# direction of sprite flip 
	if velocity.x < 0:
			if !facing_direction:
				facing_direction = true;
				animatedSpriteNode.flip_h = facing_direction
	elif velocity.x > 0:
		if facing_direction:
			facing_direction = false;
			animatedSpriteNode.flip_h = facing_direction
	
	# directional attack 
	if Input.is_action_just_pressed("mouse_click"):
		var mouse_coords = get_viewport().get_mouse_position();
		if mouse_coords.y < position.y-PLAYER_HEIGHT/2:
			curr_state = states.ATTACK_UP;
			print("up");
		elif mouse_coords.y > position.y+PLAYER_HEIGHT/2:
			curr_state = states.ATTACK_DOWN;
			print("down");
		else:
			curr_state = states.ATTACK_MIDDLE;
			print("middle");
	if curr_state == states.ATTACK_UP:
		animatedSpriteNode.play("attack_up")
	elif  curr_state == states.ATTACK_MIDDLE:
		animatedSpriteNode.play("attack_middle")
	elif curr_state == states.ATTACK_DOWN:
		animatedSpriteNode.play("attack_down")
	elif velocity.y < 0:
		animatedSpriteNode.play("jump");
	elif velocity.y > 0 :
		animatedSpriteNode.play("fall");
	elif velocity.x != 0: 
		animatedSpriteNode.play("run");
	else: 
		animatedSpriteNode.play("idle");
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


func _on_AnimatedSprite_animation_finished():
	curr_state = states.NOT_ATTACKING
