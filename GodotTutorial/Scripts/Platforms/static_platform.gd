extends AnimatableBody2D

@onready var sprite_2d = $Sprite2D
@export var platformColor:DataStruct.PlatformColor = DataStruct.PlatformColor.WHITE;


func _ready():
	switchPlatformColor(platformColor);


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
