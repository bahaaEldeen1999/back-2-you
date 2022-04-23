extends KinematicBody2D

signal hit_ball(hit_vector);

export var MAX_SPEED = 405;
export var GRAVITY = 100;
export var MAX_JUMP_COUNT = 2;
export var ACCELERATION = 300;
export var JUMP_FORCE = [300,250];
export var GRAVITY_INCREASE_FACTOR = 1.1;
export var SNAP_SIZE = 64;
export var PLAYER_HEIGHT = 64;

onready var animatedSpriteNode = $AnimatedSprite; 
onready var attackUpCollision = $Area2D/attack_up_collsion;
onready var attackDownCollision = $Area2D/attack_down_collsion;
onready var attackMiddleCollision = $Area2D/attack_middle_collision;
onready var area2D = $Area2D;

var hit_vector = Vector2.ZERO;
var snap = true;
var curr_jump_counter = 0;
var velocity = Vector2.ZERO;
var gravity = GRAVITY;
var facing_direction = false; # facing right
enum states  {NOT_ATTACKING,ATTACK_UP,ATTACK_MIDDLE,ATTACK_DOWN};
var curr_state = states.NOT_ATTACKING; 

func _physics_process(delta):
	# to fix last frame bug 
	# HACK
	if animatedSpriteNode.frame == animatedSpriteNode.frames.get_frame_count(animatedSpriteNode.animation)-1:
		curr_state = states.NOT_ATTACKING
		attackDownCollision.disabled = true;
		attackUpCollision.disabled = true;
		attackMiddleCollision.disabled = true;
	###########################################
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
				invert_attack_collisions();
	elif velocity.x > 0:
		if facing_direction:
			facing_direction = false;
			animatedSpriteNode.flip_h = facing_direction
			invert_attack_collisions();
	
	# directional attack 
	if Input.is_action_just_pressed("attack"):
		#var mouse_coords = get_viewport().get_mouse_position();
		#var mouse_coords = 
		#hit_vector = (mouse_coords-position).normalized();
		hit_vector = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),Input.get_action_strength("down")-Input.get_action_strength("up"));
		""" if mouse_coords.y < position.y-PLAYER_HEIGHT/2:
			curr_state = states.ATTACK_UP;
			attackUpCollision.disabled = false;
			print("up");
		elif mouse_coords.y > position.y+PLAYER_HEIGHT/2:
			curr_state = states.ATTACK_DOWN;
			attackDownCollision.disabled = false;
			print("down");
		else:
			curr_state = states.ATTACK_MIDDLE;
			attackMiddleCollision.disabled = false;
			print("middle"); """
		
		if hit_vector.y < -0.4:
			curr_state = states.ATTACK_UP;
			attackUpCollision.disabled = false;
			attackDownCollision.disabled = true;
			attackMiddleCollision.disabled = true;
			print("up");
		elif hit_vector.y > 0.4:
			curr_state = states.ATTACK_DOWN;
			attackDownCollision.disabled = false;
			attackUpCollision.disabled = true;
			attackMiddleCollision.disabled = true;
			print("down");
		else:
			curr_state = states.ATTACK_MIDDLE;
			attackMiddleCollision.disabled = false;
			attackDownCollision.disabled = true;
			attackUpCollision.disabled = true;
			print(animatedSpriteNode.frame)
			print("middle");
	#print("cur state",curr_state);
	if curr_state == states.ATTACK_UP:
		play_animation_if_not_playing("attack_up");
	elif  curr_state == states.ATTACK_MIDDLE:
		play_animation_if_not_playing("attack_middle");
	elif curr_state == states.ATTACK_DOWN:
		play_animation_if_not_playing("attack_down");
	elif velocity.y < 0:
		play_animation_if_not_playing("jump");
	elif velocity.y > 0 :
		play_animation_if_not_playing("fall");
	elif velocity.x != 0: 
		play_animation_if_not_playing("run");
	else: 
		play_animation_if_not_playing("idle");
	move_and_slide_with_snap(velocity,snap_vector,Vector2(0,-1));
	#print(velocity.y)
	if is_on_floor():
		snap = true
		curr_jump_counter = 0
		velocity.y = 0
		gravity = GRAVITY
	#print(curr_jump_counter)
	
	
func getPressDirection():
	return Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),Input.is_action_just_pressed("jump"));


func _on_AnimatedSprite_animation_finished():
	#print("fin")
	attackDownCollision.disabled = true;
	attackUpCollision.disabled = true;
	attackMiddleCollision.disabled = true;
	curr_state = states.NOT_ATTACKING

func  invert_attack_collisions():
	attackMiddleCollision.position.x = - attackMiddleCollision.position.x;
	attackUpCollision.position.x = - attackUpCollision.position.x;
	attackDownCollision.position.x = - attackDownCollision.position.x;
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("ball"):
		print("player hit vector",hit_vector)
		emit_signal("hit_ball",hit_vector)
		attackDownCollision.set_deferred("disabled",true);
		attackUpCollision.set_deferred("disabled",true);
		attackMiddleCollision.set_deferred("disabled",true);
func play_animation_if_not_playing(animation):
	if animatedSpriteNode.is_playing() && animatedSpriteNode.animation == animation:
		return;
	animatedSpriteNode.stop();
	animatedSpriteNode.play(animation);
