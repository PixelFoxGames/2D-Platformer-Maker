extends TextureButton


func _ready():
	self.pressed.connect(OnButtonDown);


var Block: MapBlockVar.MapBlock;


func SetBlock(blockInt: int, texture: ImageTexture) -> void:
	Block = blockInt;
	custom_minimum_size = Vector2(32, 32);
	$TextureRect.texture = texture;
	$TextureRect.custom_minimum_size = Vector2(32, 32);


func OnButtonDown():
	MapBlockVar.CurrentSelectedBlock = Block;

