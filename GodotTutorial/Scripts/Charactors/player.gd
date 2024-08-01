extends CharacterBody2D

@onready var camera_2d = $Camera2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var main_tile_map = %MainTileMap
@onready var ray_cast_2d_left = $RayCast2DLeft
@onready var ray_cast_2d_right = $RayCast2DRight
@onready var audio_player_attack = $AudioPlayerAttack
@onready var audio_player_be_attacked = $AudioPlayerBeAttacked
@onready var audio_player_win = $AudioPlayerWin
@onready var be_attacked_area = $BeAttackedArea


enum PlayerState {IDLE, WALK, JUMP, CRAWL, FORWARD_ROLL, ON_TREE, DIE, WIN}

var currentPlayerState: PlayerState;
const INERTIA:float = 650.0;
const INERTIA_FORWARD_ROLL: float = 260.0;
const SPEED_X_MAX:float = 130.0;
const SPEED_X_UNSTOPPABLE:float = 195.0;
const SPEED_X_FORWARD_ROLL_MAX:float = 390.0;

const JUMP_VELOCITY:float = -300.0;
const JUMP_VELOCITY_MAX:float = -500;

const SPEED_CLIMB_TREE: float = 130.0;

const CAMERA_ZOOM: float = 4;

var inertia: float = INERTIA;
var speedXMax: float = SPEED_X_MAX;
var speedX: float = 0;
var jumpVelocity: float = JUMP_VELOCITY;
var cameraZoom: float = CAMERA_ZOOM;

func _ready():
	add_to_group("GameManager");
	camera_2d.limit_top = -MapBlockVar.MapHeight * MapBlockVar.BlockHeight;
	camera_2d.limit_right = MapBlockVar.MapWidth * MapBlockVar.BlockWidth;
	camera_2d.limit_bottom = 5 * MapBlockVar.BlockHeight;
	camera_2d.limit_left = MapBlockVar.BlockWidth;
	cameraZoom = CAMERA_ZOOM;
	camera_2d.zoom = Vector2(cameraZoom, cameraZoom);
	main_tile_map = get_tree().get_first_node_in_group("TileMap");
func _physics_process(delta):
	inputUpdatePlatformCollision(delta);
	StateUpdate(currentPlayerState, delta);
	updateCameraZoom(delta);
	move_and_slide()
func startState(playerState: PlayerState) -> void:
	match(playerState):
		PlayerState.IDLE:
			startIdle();
		PlayerState.WALK:
			startWalk();
		PlayerState.JUMP:
			startJump();
		PlayerState.FORWARD_ROLL:
			startForwardRoll();
		PlayerState.CRAWL:
			startCrawl();
		PlayerState.ON_TREE:
			startOnTree();
		PlayerState.DIE:
			startDie();
		PlayerState.WIN:
			startWin();
	currentPlayerState = playerState;
func StateUpdate(playerState: PlayerState, delta:float) -> void:
	match(playerState):
		PlayerState.IDLE:
			inputUpdateNormalXMove(delta);
			inputUpdateNormalYMove(delta);
			updateGravity(delta);
			inputTryTransToCrawl();
			updateIdle(delta);
		PlayerState.WALK:
			inputUpdateNormalXMove(delta);
			inputUpdateNormalYMove(delta);
			inputTryTransWalkToForwardRoll();
			updateGravity(delta);
			inputTryTransToCrawl();
			updateWalk(delta);
		PlayerState.JUMP:
			inputUpdateNormalXMove(delta);
			updateGravity(delta);
			inputTryTransJumpToOnTree();
			inputUpdateJumpPower(delta);
			updateJump(delta);
		PlayerState.FORWARD_ROLL:
			inputUpdateNormalXMove(delta);
			inputUpdateForwardRoll();
			updateGravity(delta);
			updateForwardRoll(delta);
		PlayerState.CRAWL:
			inputUpdateNormalXMove(delta);
			inputUpdateNormalYMove(delta);
			updateGravity(delta);
			inputUpdateCrawState();
			updateCrawl(delta);
		PlayerState.ON_TREE:
			inputUpdateNormalXMove(delta);
			inputUpdateTreeYMove(delta);
			updateOnTree(delta);
		PlayerState.DIE:
			updateGravity(delta);
			updateDie(delta);
		PlayerState.WIN:
			updateWin(delta);
####################################################################################################
func checkPlayerIsOnTree() -> bool:
	if main_tile_map == null:
		return false;
	var playerPosition:Vector2 = self.position;
	var tileData = main_tile_map.local_to_map(playerPosition);
	var playerPosData = main_tile_map.get_cell_tile_data(0, tileData);
	if playerPosData == null:
		return false;
	var isOnTree:bool = playerPosData.get_custom_data("IsTree");
	return isOnTree;
func calcSpeedXProportion(speed: float) -> float:
	var speedAbs = abs(speed);
	if speedAbs < SPEED_X_MAX:
		return 0;
	return (speedAbs - SPEED_X_MAX) / (SPEED_X_FORWARD_ROLL_MAX - SPEED_X_MAX)
func bounce(isDeadSlime: bool) -> void:
	if isDeadSlime:
		jumpVelocity += 100;
		if jumpVelocity > JUMP_VELOCITY:
			jumpVelocity = JUMP_VELOCITY;
	else:
		jumpVelocity -= 100;
		if jumpVelocity < JUMP_VELOCITY_MAX:
			jumpVelocity = JUMP_VELOCITY_MAX;
func checkIsTouchWall(v: float) -> bool:
	if v > 0:
		if ray_cast_2d_right.is_colliding():
			return true;
	elif v < 0:
		if ray_cast_2d_left.is_colliding():
			return true;
	return false;
####################################################################################################
func updateGravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += EnvVar.Gravity * delta
	else:
		jumpVelocity = JUMP_VELOCITY;
func updateCameraZoom(delta: float) -> void:
	cameraZoom = move_toward(camera_2d.zoom.x, cameraZoom, delta);
	camera_2d.zoom = Vector2(cameraZoom, cameraZoom);
####################################################################################################
#Translation
func transToFloor() -> void:
	if velocity.x == 0:
		startState(PlayerState.IDLE);
	else:
		startState(PlayerState.WALK);
####################################################################################################
#Input Update
func inputUpdatePlatformCollision(delta: float) -> void:
	if Input.is_action_pressed("MoveDown"):
		set_collision_mask_value(5, false);
	elif Input.is_action_just_released("MoveDown"):
		set_collision_mask_value(5, true);


func inputUpdateTreeYMove(delta: float) -> void:
	if checkPlayerIsOnTree() == false:
		return;
	if velocity.y >= 0 and Input.is_action_pressed("Jump"):
		velocity.y = jumpVelocity;
		startState(PlayerState.JUMP);
	else:
		if Input.is_action_pressed("MoveUp"):
			velocity.y = -SPEED_CLIMB_TREE;
		elif Input.is_action_pressed("MoveDown"):
			if is_on_floor():
				transToFloor();
			else:
				velocity.y = SPEED_CLIMB_TREE;
		else:
			velocity.y = 0;


func inputUpdateJumpPower(delta: float) -> void:
	if Input.is_action_just_released("Jump") or Input.is_action_just_released("MoveUp"):
		if velocity.y < 0:
			velocity.y = 0;
		jumpVelocity = JUMP_VELOCITY;


func inputUpdateNormalYMove(delta: float) -> void:
	if not is_on_floor():
		return;
	if Input.is_action_pressed("Jump"):
		velocity.y = jumpVelocity
		startState(PlayerState.JUMP);
	elif Input.is_action_pressed("MoveUp"):
		if checkPlayerIsOnTree():
			velocity.y = -SPEED_CLIMB_TREE;
			startState(PlayerState.ON_TREE);
		else:
			velocity.y = jumpVelocity;
			startState(PlayerState.JUMP);


func inputUpdateNormalXMove(delta: float) -> void:
	var direction = Input.get_axis("MoveLeft", "MoveRight")
	if direction:
		speedX = move_toward(speedX, direction * speedXMax, inertia * delta)
		if checkIsTouchWall(direction) == true:
			speedX = 0;
	else:
		speedX = move_toward(speedX, 0, inertia * delta)	
	velocity.x = speedX;
	cameraZoom = CAMERA_ZOOM - 2 * calcSpeedXProportion(speedX);
	if direction > 0:
		animated_sprite_2d.flip_h = false;
	elif direction < 0:
		animated_sprite_2d.flip_h = true;


func inputUpdateForwardRoll() -> void:
	if is_on_floor():
		if Input.is_action_pressed("MoveDown") == false:
			transToFloor();
		elif checkIsTouchWall(speedX) == true:
			speedX = 0;
	if Input.is_action_pressed("Jump"):
		velocity.y = jumpVelocity;
		startJump();


func inputTryTransWalkToForwardRoll() -> void:
	if currentPlayerState == PlayerState.WALK and Input.is_action_pressed("MoveDown"):
		if is_on_floor():
			startState(PlayerState.FORWARD_ROLL);


func inputTryTransJumpToOnTree() -> void:
	if velocity.y > 0 and checkPlayerIsOnTree():
		if Input.is_action_pressed("Jump"):
			velocity.y = jumpVelocity;
		elif Input.is_action_pressed("MoveUp"):
			velocity.y = -SPEED_CLIMB_TREE;
			startState(PlayerState.ON_TREE);


func inputTryTransToCrawl() -> void:
	if currentPlayerState != PlayerState.WALK and currentPlayerState != PlayerState.IDLE:
		return;
	if is_on_floor() and Input.is_action_pressed("MoveDown"):
		startState(PlayerState.CRAWL);


func inputUpdateCrawState() -> void:
	if Input.is_action_just_released("MoveDown"):
		if velocity.x == 0:
			startState(PlayerState.IDLE);
		else:
			startState(PlayerState.WALK);
####################################################################################################
func startIdle() -> void:
	animated_sprite_2d.play("Idle");
	speedXMax = SPEED_X_MAX;
	inertia = INERTIA;
func updateIdle(delta: float) -> void:
	if currentPlayerState != PlayerState.IDLE:
		return;
	if is_on_floor() == false:
		startState(PlayerState.JUMP);
	elif velocity.x != 0:
		startState(PlayerState.WALK);


func startWalk() -> void:
	animated_sprite_2d.play("Walk");
	speedXMax = SPEED_X_MAX;
	inertia = INERTIA;
func updateWalk(delta: float) -> void:
	if currentPlayerState != PlayerState.WALK:
		return;
	if is_on_floor() == false:
		startState(PlayerState.JUMP);
	elif velocity.x == 0:
		startState(PlayerState.IDLE);


func startJump() -> void:
	animated_sprite_2d.play("Jump");
func updateJump(delta: float) -> void:
	if currentPlayerState != PlayerState.JUMP:
		return;
	if is_on_floor():
		if Input.is_action_pressed("MoveDown"):
			if velocity.x == 0:
				startState(PlayerState.CRAWL);
			else:
				startState(PlayerState.FORWARD_ROLL);
		else:
			if velocity.x == 0:
				startState(PlayerState.IDLE);
			else:
				startState(PlayerState.WALK);
	else:
		if velocity.x == 0:
			animated_sprite_2d.play("Jump");
		else:
			animated_sprite_2d.play("ForwardJump");


func startCrawl() -> void:
	animated_sprite_2d.play("Crawl");
	speedXMax = SPEED_X_FORWARD_ROLL_MAX;
	inertia = INERTIA_FORWARD_ROLL;
func updateCrawl(delta: float) -> void:
	if currentPlayerState != PlayerState.CRAWL:
		return;
	if velocity.x != 0:
		startState(PlayerState.FORWARD_ROLL);
	elif is_on_floor() == false:
		startState(PlayerState.JUMP);


func startForwardRoll() -> void:
	animated_sprite_2d.play("ForwardRoll");
	speedXMax = SPEED_X_FORWARD_ROLL_MAX;
	inertia = INERTIA_FORWARD_ROLL;
func updateForwardRoll(delta: float) -> void:
	if is_on_floor():
		if velocity.x == 0:
			transToFloor();
	else:
		startState(PlayerState.JUMP);


func startOnTree() -> void:
	animated_sprite_2d.play("OnTree")
	jumpVelocity = JUMP_VELOCITY;
func updateOnTree(delta: float) -> void:
	if currentPlayerState != PlayerState.ON_TREE:
		return;
	if velocity.x == 0 and velocity.y == 0:
		animated_sprite_2d.pause();
	else:
		if checkPlayerIsOnTree():
			animated_sprite_2d.play();
		else:
			if is_on_floor():
				transToFloor();
			else:
				if Input.is_action_pressed("MoveUp"):
					velocity.y = jumpVelocity;
				startState(PlayerState.JUMP);


func startDie() -> void:
	audio_player_be_attacked.volume_db += 10;
	audio_player_be_attacked.play();
	velocity = Vector2(0, 0);
	Engine.time_scale = 0.5;
	animated_sprite_2d.play("Die");
func updateDie(delta: float) -> void:
	updateGravity(delta);
	if animated_sprite_2d.is_playing() == false:
		Engine.time_scale = 1;
		get_tree().get_first_node_in_group("TileMap").RestartGame();
		queue_free();


func startWin() -> void:
	if currentPlayerState == PlayerState.WIN:
		return;
	velocity = Vector2(0, 0);
	animated_sprite_2d.play("Win");
	audio_player_win.play();
func updateWin(delta: float) -> void:
	if animated_sprite_2d.is_playing() == false:
		get_tree().get_first_node_in_group("TileMap").BackToSelectLevel();
####################################################################################################
func Die() -> void:
	if currentPlayerState == PlayerState.DIE or currentPlayerState == PlayerState.WIN:
		return;
	startState(PlayerState.DIE);


func Destory() -> void:
	Die();


func GetCoin() -> void:
	print("+1...");


func _on_be_attacked_area_body_entered(body):
	if currentPlayerState == PlayerState.DIE:
		return;
	if velocity.y < 0 or body.position.y - position.y > 3 or abs(speedX) > SPEED_X_UNSTOPPABLE or body.IsDead: #Is Falling
		attackSlime(body);
	else:
		Die();
func _on_head_area_2d_body_entered(body):
	if currentPlayerState == PlayerState.DIE:
		return;
func attackSlime(body) -> void:
	audio_player_attack.play();
	bounce(body.IsDead);
	velocity.y = jumpVelocity;
	startState(PlayerState.JUMP);
	body.Die();


func _on_final_coin_area_2d_area_entered(area):
	startState(PlayerState.WIN);
