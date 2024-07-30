extends CharacterBody2D

class_name Slime

enum SlimeType{REBORN_SLIME, BOMB_SLIME}

@export var slimeType:SlimeType = SlimeType.REBORN_SLIME;
@export var speed:float = 15;
@export var direction:int = 1;

@onready var game_scene = $"../.."
const BOMB = preload("res://Scenes/HurtBoxs/bomb.tscn")
@onready var ray_cast_2d_left = $RayCast2DLeft
@onready var ray_cast_2d_right = $RayCast2DRight
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var risen_timer = $RisenTimer
@onready var game_manager = %GameManager
@onready var audio_player_be_attacked = $AudioPlayerBeAttacked

enum SlimeState {BORN, WALK, DIE}
var currentState: SlimeState = SlimeState.BORN;
var IsDead:bool = false;
var isReborn:bool = false;

func _ready():
	startState(SlimeState.BORN);


func _process(delta):
	updateState(currentState, delta);
	move_and_slide();


func SetSlimeType(_slimeType: SlimeType):
	slimeType = _slimeType;
	startState(currentState);


func startState(newState: SlimeState) -> void:
	match(newState):
		SlimeState.BORN:
			startBornState();
		SlimeState.WALK:
			startWalkState();
		SlimeState.DIE:
			startDieState();
	currentState = newState;


func updateState(slimeState: SlimeState, delta: float) -> void:
	match(slimeState):
		SlimeState.BORN:
			updateBornState(delta);
		SlimeState.WALK:
			updateXMove(delta);
			updateGravity(delta);
			updateWalkState(delta);
		SlimeState.DIE:
			updateGravity(delta);
			updateDieState(delta);
	move_and_slide();


func updateGravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += EnvVar.Gravity * delta


func startBornState() -> void:
	IsDead = false;
	isReborn = false;
	
	if slimeType == SlimeType.REBORN_SLIME:
		animated_sprite_2d.play("Born");
	elif slimeType == SlimeType.BOMB_SLIME:
		animated_sprite_2d.play("BombBorn");
func updateBornState(delta: float) -> void:
	if animated_sprite_2d.is_playing() == false:
		collision_shape_2d.disabled = false;
		startState(SlimeState.WALK);


func startWalkState() -> void:
	if slimeType == SlimeType.REBORN_SLIME:
		animated_sprite_2d.play("Walk");
	elif slimeType == SlimeType.BOMB_SLIME:
		animated_sprite_2d.play("BombWalk");
func updateWalkState(delta: float):
	pass


func startDieState() -> void:
	audio_player_be_attacked.play();
	if slimeType == SlimeType.REBORN_SLIME:
		animated_sprite_2d.play("Die");
	elif slimeType == SlimeType.BOMB_SLIME:
		animated_sprite_2d.play("BombDie");
func updateDieState(delta: float) -> void:
	if IsDead and isReborn == false and animated_sprite_2d.is_playing() == false:
		risen_timer.start();
		isReborn = true;


func updateXMove(delta: float):
	if direction > 0:
		if ray_cast_2d_right.is_colliding():
			direction = -1;
			animated_sprite_2d.flip_h = true;
	elif ray_cast_2d_left.is_colliding():
		direction = 1;
		animated_sprite_2d.flip_h = false;
	velocity.x = direction * speed;


func Die() -> void:
	if IsDead == true or isReborn:
		return;
	velocity.x = 0;
	IsDead = true;
	startState(SlimeState.DIE);


func Destory() -> void:
	queue_free();


func _on_risen_timer_timeout():
	match(slimeType):
		SlimeType.REBORN_SLIME:
			startState(SlimeState.BORN);
		SlimeType.BOMB_SLIME:
			var bomb = BOMB.instantiate();
			bomb.SetRadius(100);
			game_scene.add_child(bomb);
			bomb.global_position = global_position;
			queue_free();
