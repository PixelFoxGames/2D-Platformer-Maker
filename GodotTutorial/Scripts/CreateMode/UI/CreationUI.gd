extends PanelContainer


const WORLD_TILESET: = preload("res://brackeys_platformer_assets/sprites/world_tileset.png")
const BLOCK_TEXTURE_BUTTON = preload("res://Scenes/MainScene/CreationMode/BlockTextureButton.tscn")
@onready var h_box_map_block = $HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var IMAGE_WORLD_TILESET:Image = WORLD_TILESET.get_image();
	var imageButton:Image;
	var imageTexture:ImageTexture;
	var imageWidth: int = 16;
	var imageHeight: int = 16;
	var imagePosition:Vector2i;
	var imageSize:Vector2i = Vector2i(imageWidth, imageHeight);

	var button;
	#Draw Buttons
	for i in range(MapBlockVar.MapBlockList.size()):
		imagePosition = Vector2i(MapBlockVar.MapBlockList[i] * imageWidth);
		imageButton = IMAGE_WORLD_TILESET.get_region(Rect2i(imagePosition, imageSize));
		imageTexture = ImageTexture.create_from_image(imageButton);

		button = BLOCK_TEXTURE_BUTTON.instantiate();
		h_box_map_block.add_child(button);
		button.SetBlock(i, imageTexture);

