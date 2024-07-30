extends TileMap


const ENTITY_TEXTURE_BUTTON = preload("res://Scenes/MainScene/CreationMode/Entities/EntityTextureButton.tscn")
const ENTITIES_BASE_NODE = preload("res://Scenes/MainScene/CreationMode/Entities/EntitiesBaseNode.tscn")
const SLIME = preload("res://Scenes/Charactors/Slime.tscn")
const PLAYER = preload("res://Scenes/Charactors/Player.tscn")
const COIN = preload("res://Scenes/Float/Coin.tscn")
const FINAL_COIN = preload("res://Scenes/Float/FinalCoin.tscn")
const STATIC_PLATFORM = preload("res://Scenes/Platforms/StaticPlatform.tscn")
const MOVEMENT_PLATFORM = preload("res://Scenes/Platforms/MovementPlatform.tscn")


var EntitiesBaseNode;
var CurrentLevelName:String = "";


func _ready():
	EntitiesBaseNode = ENTITIES_BASE_NODE.instantiate();
	get_tree().root.add_child(EntitiesBaseNode);

	DrawBackGround(MapBlockVar.MapWidth, MapBlockVar.MapHeight);
	DrawWall(MapBlockVar.MapWidth, MapBlockVar.MapHeight);
	add_to_group("TileMap");


####################################################################################################
func RestartGame() -> void:
	ClearWhole();
	LoadLevelByName(CurrentLevelName);


func BackToSelectLevel() -> void:
	ClearWhole();
	MapBlockVar.CurrentLevelNum = 0;
	get_tree().reload_current_scene();
	#get_tree().get_first_node_in_group("SetupUIManager").InitSelectLevelUI();


func SaveCurrentScene() -> void:
	SaveScene(CurrentLevelName);
func SaveScene(levelName: String) -> void:
	var levelData = LevelData.new();
	levelData.SaveLevelData(levelName);
func LoadLevelByName(levelName: String) -> void:
	ClearWhole();
	Engine.time_scale = 1;
	CurrentLevelName = levelName;
	var levelData = LevelData.new();
	levelData.LoadLevelData(levelName);
	if MapBlockVar.IsCreationMode:
		SetMatrixBlockVarToCreationScene();
	else:
		SetMatrixBlockVarToScene();


func SetMatrixBlockVarToCreationScene() -> void:
	for x in range(MapBlockVar.MapWidth):
		for y in range(MapBlockVar.MapHeight):
			SetMapBlock(Vector2i(x, -y), MapBlockVar.MapBlockMatrix[x][y]);
	SetButtonListToScene(MapBlockVar.PlayerBornPosList, MapBlockVar.MapBlock.PLAYER);
	SetButtonListToScene(MapBlockVar.RebornSlimePosList, MapBlockVar.MapBlock.REBORN_SLIME);
	SetButtonListToScene(MapBlockVar.BombSlimePosList, MapBlockVar.MapBlock.BOMB_SLIME);
	SetButtonListToScene(MapBlockVar.CoinPosList, MapBlockVar.MapBlock.COIN);
	SetButtonListToScene(MapBlockVar.FinalCoinPosList, MapBlockVar.MapBlock.FINAL_COIN);
	SetButtonListToScene(MapBlockVar.StaticPlatform0PosList, MapBlockVar.MapBlock.STATIC_PLATFORM_0);
	SetButtonListToScene(MapBlockVar.StaticPlatform1PosList, MapBlockVar.MapBlock.STATIC_PLATFORM_1);
	SetButtonListToScene(MapBlockVar.MovementPlatform0PosList, MapBlockVar.MapBlock.MOVEMENT_PLATFORM_0);
	SetButtonListToScene(MapBlockVar.MovementPlatform1PosList, MapBlockVar.MapBlock.MOVEMENT_PLATFORM_1);
func SetButtonListToScene(posList: Array, blockType: MapBlockVar.MapBlock) -> void:
	for pos in posList:
		SetMapEntityButton(pos, blockType);


func SetMatrixBlockVarToScene() -> void:
	for x in range(MapBlockVar.MapWidth):
		for y in range(MapBlockVar.MapHeight):
			SetMapBlock(Vector2i(x, -y), MapBlockVar.MapBlockMatrix[x][y]);
	SetVarToScene(MapBlockVar.PlayerBornPosList, PLAYER);
	SetSlimeListVarToScene(MapBlockVar.RebornSlimePosList, SLIME, Slime.SlimeType.REBORN_SLIME);
	SetSlimeListVarToScene(MapBlockVar.BombSlimePosList, SLIME, Slime.SlimeType.BOMB_SLIME);
	SetVarToScene(MapBlockVar.CoinPosList, COIN);
	SetVarToScene(MapBlockVar.FinalCoinPosList, FINAL_COIN);
	SetPlatformToScene(MapBlockVar.StaticPlatform0PosList, STATIC_PLATFORM);
	SetPlatformToScene(MapBlockVar.StaticPlatform1PosList, STATIC_PLATFORM);
	SetPlatformToScene(MapBlockVar.MovementPlatform0PosList, MOVEMENT_PLATFORM);
	SetPlatformToScene(MapBlockVar.MovementPlatform1PosList, MOVEMENT_PLATFORM);
func SetSlimeListVarToScene(slimePosList:Array[Vector2], SlimePrefab, slimeType: Slime.SlimeType) -> void:
	var slimeList = SetEntityListVarToScene(slimePosList, SlimePrefab, 3, 9);
	for slime in slimeList:
		slime.SetSlimeType(slimeType);
func SetVarToScene(posList:Array[Vector2], Prefab):
	SetEntityListVarToScene(posList, Prefab, 3, 0);
func SetPlatformToScene(posList:Array[Vector2], Prefab):
	SetEntityListVarToScene(posList, Prefab, 0, 0);
func SetEntityListVarToScene(entityPosList:Array[Vector2], Entity, xAdjust:int, yAdjust:int) -> Array:
	var entityList: Array;
	for pos in entityPosList:
		var entity = Entity.instantiate();
		EntitiesBaseNode.add_child(entity);
		pos.x = pos.x + xAdjust;
		pos.y = pos.y + yAdjust;
		entity.global_position = pos;
		entityList.append(entity);
	return entityList;


func SetMapBlock(position: Vector2i, block: MapBlockVar.MapBlock) -> void:
	set_cell(0, position, 0, MapBlockVar.MapBlockList[block]);
	MapBlockVar.SetMapBlock(position, block);


func SetMapEntityButton(position: Vector2, blockType: MapBlockVar.MapBlock) -> void:
	var globalPosition: Vector2 = position + Vector2(-8, -8);
	var entityButton = ENTITY_TEXTURE_BUTTON.instantiate();
	self.add_child(entityButton);
	entityButton.global_position = globalPosition;
	entityButton.SetEntityButton(blockType, false, position);
	MakeSomeEntityOnlyHas1InScene(entityButton, blockType);


var playerEntityButton;
var finalCoinEntityButton;
func MakeSomeEntityOnlyHas1InScene(entityButton, blockType: MapBlockVar.MapBlock) -> void:
	match(blockType):
		MapBlockVar.MapBlock.PLAYER:
			if playerEntityButton != null:
				playerEntityButton.queue_free();
			playerEntityButton = entityButton;
		MapBlockVar.MapBlock.FINAL_COIN:
			if finalCoinEntityButton != null:
				finalCoinEntityButton.queue_free();
			finalCoinEntityButton = entityButton;
################################################################################


func BoomMapBlock(globalPosition: Vector2, radius: float) -> void:
	const PIXEL: int = 16;
	var globalPositionInt: Vector2i = Vector2i(globalPosition);
	var radiusInt: int = radius / PIXEL;
	if globalPositionInt.x % PIXEL < PIXEL / 2:
		globalPositionInt.x /= PIXEL;
		if globalPosition.x > 0:
			globalPositionInt.x += 1;
		else:
			globalPositionInt.x -= 1;
	else:
		globalPositionInt.x /= PIXEL;
	globalPositionInt.y /= PIXEL;
	
	var radiusPow2:float = pow(radiusInt, 2);
	for x in range(-radiusInt, radiusInt+1):
		for y in range(-radiusInt, radiusInt+1):
			if pow(x, 2) + pow(y, 2) < radiusPow2:
				set_cell(0, globalPositionInt + Vector2i(x, y), 0, Vector2i(15, 0));


func BoomGroup(globalPosition: Vector2, boomRadius: float, groupName: String) -> void:
	var targetGroup = get_tree().get_nodes_in_group(groupName);
	if targetGroup.size() == 0:
		return;
	var targets = targetGroup.filter(
		func(target: Node2D):
			return target.global_position.distance_squared_to(globalPosition) < pow(boomRadius, 2);
	)
	for target in targets:
		target.Die();
func Boom(globalPosition: Vector2, boomRadius: float) -> void:
	BoomGroup(globalPosition, boomRadius, "Player");
	BoomGroup(globalPosition, boomRadius, "Slime");
	BoomMapBlock(globalPosition, boomRadius);
####################################################################################################
func ClearWhole() -> void:
	ClearMapBlock(MapBlockVar.MapWidth, MapBlockVar.MapHeight);
	EntitiesBaseNode.queue_free();
	EntitiesBaseNode = ENTITIES_BASE_NODE.instantiate();
	get_tree().root.add_child(EntitiesBaseNode);


func ClearMapBlock(width:int, height:int) -> void:
	#var emptyBlock:Vector2i = MapBlockVar.MapBlockList[MapBlockVar.MapBlock.EMPTY];
	var emptyBlock:Vector2i = Vector2i(-1, -1);
	for y in range(0, height):
		for x in range(0, width):
			#set_cell(0, Vector2i(x, y), 0, emptyBlock);
			set_cell(0, Vector2i(x, y), -1, emptyBlock);


func DrawBackGround(width:int, height:int) -> void:
	var baseY: int = -10;
	while baseY < height:
		baseY = Draw1BackGround(width, baseY, randi_range(0, 4));
func Draw1BackGround(width:int, baseY:int, backGroundColor:int) -> int:
	var y:int = baseY;
	var BackGroundBlock: Vector2i;
	backGroundColor = clamp(backGroundColor, 0, 3);

	var colorVector2i: Vector2i = Vector2i(backGroundColor, 0);

	BackGroundBlock = MapBlockVar.MapBcakGroundList[MapBlockVar.MapBackGround.LAND_BOTTOM] + colorVector2i;
	for x in range(0, width):
		set_cell(1, Vector2i(x, -y), 0, BackGroundBlock);
	y += 1;

	BackGroundBlock = MapBlockVar.MapBcakGroundList[MapBlockVar.MapBackGround.BOTTOM] + colorVector2i;
	while(y < baseY+9):
		for x in range(0, width):
			set_cell(1, Vector2i(x, -y), 0, BackGroundBlock);
		y += 1;
		
	BackGroundBlock = MapBlockVar.MapBcakGroundList[MapBlockVar.MapBackGround.LAND_BOTTOM] + colorVector2i;
	for x in range(0, width):
		set_cell(1, Vector2i(x, -y), 0, BackGroundBlock);
	y += 1;

	BackGroundBlock = MapBlockVar.MapBcakGroundList[MapBlockVar.MapBackGround.LAND] + colorVector2i;
	while(y < baseY+17):
		for x in range(0, width):
			set_cell(1, Vector2i(x, -y), 0, BackGroundBlock);
		y += 1;

	BackGroundBlock = MapBlockVar.MapBcakGroundList[MapBlockVar.MapBackGround.AIR_LAND] + colorVector2i;
	for x in range(0, width):
		set_cell(1, Vector2i(x, -y), 0, BackGroundBlock);
	y += 1;

	BackGroundBlock = MapBlockVar.MapBcakGroundList[MapBlockVar.MapBackGround.AIR] + colorVector2i;
	while(y < baseY+25):
		for x in range(0, width):
			set_cell(1, Vector2i(x, -y), 0, BackGroundBlock);
		y += 1;

	BackGroundBlock = MapBlockVar.MapBcakGroundList[MapBlockVar.MapBackGround.SKY_AIR] + colorVector2i;
	for x in range(0, width):
		set_cell(1, Vector2i(x, -y), 0, BackGroundBlock);
	y += 1;

	BackGroundBlock = MapBlockVar.MapBcakGroundList[MapBlockVar.MapBackGround.SKY] + colorVector2i;
	while(y < baseY+33):
		for x in range(0, width):
			set_cell(1, Vector2i(x, -y), 0, BackGroundBlock);
		y += 1;
	return y;


func DrawWall(width: int, height: int) -> void:
	var FloorBlock:Vector2i = Vector2i(1,1);
	for y in range(0, height):
		set_cell(0, Vector2i(-1, -y), 0, FloorBlock);
		set_cell(0, Vector2i(width, -y), 0, FloorBlock);
