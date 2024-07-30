extends TextureButton


@onready var entity_animation = $EntityAnimation;
@export var Block: MapBlockVar.MapBlock;
var IsUI: bool = true;
var EntityPosition: Vector2 = Vector2(0, 0);


func _ready():
	self.pressed.connect(OnButtonDown);
	setAnimation(Block);
func setAnimation(block: MapBlockVar.MapBlock) -> void:
	match (block):
		MapBlockVar.MapBlock.PLAYER:
			entity_animation.play("Player");
		MapBlockVar.MapBlock.REBORN_SLIME:
			entity_animation.play("RebornSlime");
		MapBlockVar.MapBlock.BOMB_SLIME:
			entity_animation.play("BombSlime");
		MapBlockVar.MapBlock.COIN:
			entity_animation.play("Coin");
		MapBlockVar.MapBlock.FINAL_COIN:
			entity_animation.play("FinalCoin");
		MapBlockVar.MapBlock.STATIC_PLATFORM_0:
			entity_animation.play("StaticPlatform0");
			entity_animation.scale = Vector2(3, 1);
		MapBlockVar.MapBlock.STATIC_PLATFORM_1:
			entity_animation.play("StaticPlatform1");
			entity_animation.scale = Vector2(3, 1);
		MapBlockVar.MapBlock.MOVEMENT_PLATFORM_0:
			entity_animation.play("MovementPlatform0");
			entity_animation.scale = Vector2(3, 1);
		MapBlockVar.MapBlock.MOVEMENT_PLATFORM_1:
			entity_animation.play("MovementPlatform1");
			entity_animation.scale = Vector2(3, 1);


func SetEntityButton(block: MapBlockVar.MapBlock, isUI: bool = true, pos2:Vector2 = Vector2(0, 0)):
	Block = block;
	IsUI = isUI;
	setAnimation(block);
	if not isUI:
		self.EntityPosition = pos2;
		self.scale = Vector2(0.5, 0.5);
		self.position.y -= 4;


func Free() -> void:
	match(Block):
		MapBlockVar.MapBlock.PLAYER:
			return;
		MapBlockVar.MapBlock.FINAL_COIN:
			return;
	MapBlockVar.RemoveMapEntity(EntityPosition, Block);
	queue_free();


func OnButtonDown():
	if IsUI:
		MapBlockVar.CurrentSelectedBlock = Block;
	else:
		Free();
