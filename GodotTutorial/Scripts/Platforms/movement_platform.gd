extends RigidBody2D

class_name  MovementPlatform

@export var platformColor:DataStruct.PlatformColor = DataStruct.PlatformColor.WHITE;
@export var PositiveRayCast2D: RayCast2D;
@export var NegativeRayCast2D: RayCast2D;
@export var PlatformSpeed: float = 60;
var PositiveMovement: Vector2;
var NegativeMovement: Vector2;
var isPositive:bool = true;
@onready var sprite_2d = $Sprite2D

const PLATFORMS = preload("res://brackeys_platformer_assets/sprites/platforms.png")

func _ready():
	if PositiveRayCast2D == null:
		PositiveRayCast2D = $PositiveRayCast2D;
	elif PositiveRayCast2D != $PositiveRayCast2D:
		$PositiveRayCast2D.queue_free();
	if NegativeRayCast2D == null:
		NegativeRayCast2D = $NegativeRayCast2D;
	elif NegativeRayCast2D != $NegativeRayCast2D:
		$NegativeRayCast2D.queue_free();
	switchPlatformColor(platformColor);
	freeze = true;
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC;
	PositiveMovement = PositiveRayCast2D.target_position.normalized();
	NegativeMovement = NegativeRayCast2D.target_position.normalized();


func _process(delta):
	if isPositive:
		linear_velocity = PositiveMovement * PlatformSpeed;
		position += PositiveMovement * PlatformSpeed * delta;
		if PositiveRayCast2D.is_colliding():
			isPositive = false;
	else:
		linear_velocity = NegativeMovement * PlatformSpeed;
		position += NegativeMovement * PlatformSpeed * delta;		
		if NegativeRayCast2D.is_colliding():
			isPositive = true;


func switchPlatformColor(targetPlatformColor:DataStruct.PlatformColor):
	var regionVec2:Vector2 = Vector2(16, 0);
	match targetPlatformColor:
		DataStruct.PlatformColor.GREEN:
			regionVec2.y = 0;
		DataStruct.PlatformColor.COFFE:
			regionVec2.y = 16;
		DataStruct.PlatformColor.YELLOW:
			regionVec2.y = 32;
		DataStruct.PlatformColor.WHITE:
			regionVec2.y = 48;
	var regionRect:Rect2 = Rect2(regionVec2, Vector2(32,9));
	sprite_2d.region_rect = regionRect;
	platformColor = targetPlatformColor;


func Die() -> void:
	queue_free();
