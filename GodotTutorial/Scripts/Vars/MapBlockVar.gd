extends Node


var MapWidth: int = 300;
var MapHeight: int = 300;

var IsCreationMode: bool = false;
var CurrentLevelNum: int = 0;

var MapBlockMatrix: Array[Array];
var PlayerBornPosList: Array[Vector2];
var RebornSlimePosList: Array[Vector2];
var BombSlimePosList: Array[Vector2];
var StaticPlatform0PosList: Array[Vector2];
var StaticPlatform1PosList: Array[Vector2];
var MovementPlatform0PosList: Array[Vector2];
var MovementPlatform1PosList: Array[Vector2];
var CoinPosList:Array[Vector2];
var FinalCoinPosList: Array[Vector2] = [Vector2(20, -15) * 16];


func _ready():
	InitMapBlockMatrix(MapWidth, MapHeight);
	InitPlayerBornPosList();
	InitFinalCoinPosList();
func InitMapBlockMatrix(width: int, height: int) -> void:
	MapWidth = width;
	MapHeight = height;
	MapBlockMatrix = [];
	for x in range(MapWidth):
		var mapBlockList: Array[MapBlock] = [];
		for y in range(MapHeight):
			mapBlockList.append(MapBlock.EMPTY);
		MapBlockMatrix.append(mapBlockList);
func InitPlayerBornPosList() -> void:
	PlayerBornPosList = [Vector2(15 , -15) * 16];
func InitFinalCoinPosList() -> void:
	FinalCoinPosList = [Vector2(20, -15) * 16];
func InitVac2List(vec2List: Array[Vector2]) -> void:
	vec2List.clear();
	vec2List = [];


func SetMapBlock(position: Vector2i, block: MapBlockVar.MapBlock) -> void:
	MapBlockMatrix[position.x][-position.y] = block;


func SetMapEntity(position: Vector2, block: MapBlockVar.MapBlock) -> void:
	match(block):
		MapBlockVar.MapBlock.PLAYER:
			PlayerBornPosList = [position];
		MapBlockVar.MapBlock.REBORN_SLIME:
			RebornSlimePosList.append(position);
		MapBlockVar.MapBlock.BOMB_SLIME:
			BombSlimePosList.append(position);
		MapBlockVar.MapBlock.COIN:
			CoinPosList.append(position);
		MapBlockVar.MapBlock.FINAL_COIN:
			FinalCoinPosList = [position];
		MapBlockVar.MapBlock.STATIC_PLATFORM_0:
			StaticPlatform0PosList.append(position);
		MapBlockVar.MapBlock.STATIC_PLATFORM_1:
			StaticPlatform1PosList.append(position);
		MapBlockVar.MapBlock.MOVEMENT_PLATFORM_0:
			MovementPlatform0PosList.append(position);
		MapBlockVar.MapBlock.MOVEMENT_PLATFORM_1:
			MovementPlatform1PosList.append(position);
func RemoveMapEntity(position: Vector2, block: MapBlockVar.MapBlock) -> void:
	match(block):
		MapBlockVar.MapBlock.PLAYER:
			pass
		MapBlockVar.MapBlock.REBORN_SLIME:
			RemoveVector2FromList(position, RebornSlimePosList);
		MapBlockVar.MapBlock.BOMB_SLIME:
			RemoveVector2FromList(position, BombSlimePosList);
		MapBlockVar.MapBlock.COIN:
			RemoveVector2FromList(position, CoinPosList);
		MapBlockVar.MapBlock.FINAL_COIN:
			pass
		MapBlockVar.MapBlock.STATIC_PLATFORM_0:
			RemoveVector2FromList(position, StaticPlatform0PosList);
		MapBlockVar.MapBlock.STATIC_PLATFORM_1:
			RemoveVector2FromList(position, StaticPlatform1PosList);
		MapBlockVar.MapBlock.MOVEMENT_PLATFORM_1:
			RemoveVector2FromList(position, MovementPlatform0PosList);
		MapBlockVar.MapBlock.MOVEMENT_PLATFORM_1:
			RemoveVector2FromList(position, MovementPlatform1PosList);

func RemoveVector2FromList(position: Vector2, Vector2List: Array[Vector2]) -> void:
	Vector2List.erase(position);


var BlockWidth: int = 16;
var BlockHeight: int = 16;
var CurrentSelectedBlock: MapBlock = MapBlock.MOVEMENT;

enum MapBlock{EMPTY, GRASS_TOP_0, GRASS_0, GRASS_1, GRASS_2, 
SAND_TOP_0, SAND_TOP_1, SAND_0, SAND_1, SAND_2, 
COFFE_TOP_0, COFFE_0, COFFE_1, COFFE_2, 
ICE_TOP_0, ICE_TOP_1, ICE_TOP_2, ICE_0, ICE_1, 
ROCK_0, ROCK_1, 
TREE_0_BOTTOM, TEEE_0_MID, TREE_0_TOP, 
TREE_1_BOTTOM, TREE_1_MID, TREE_1_TOP, 
TREE_2_BOTTOM, TREE_2_MID, TREE_2_TOP,
MOVEMENT, PLAYER, REBORN_SLIME, BOMB_SLIME, COIN, FINAL_COIN,
STATIC_PLATFORM_0, STATIC_PLATFORM_1, MOVEMENT_PLATFORM_0, MOVEMENT_PLATFORM_1}

var MapBlockList: Array[Vector2i] = [
	Vector2i(15, 0), Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1),
	Vector2i(2, 0), Vector2i(2, 2), Vector2i(2, 1), Vector2i(3, 0), Vector2i(3, 1),
	Vector2i(4, 0), Vector2i(4, 1), Vector2i(5, 0), Vector2i(5, 1),
	Vector2i(6, 0), Vector2i(7, 0), Vector2i(7, 1), Vector2i(6, 1), Vector2i(6, 2),
	Vector2i(8, 0), Vector2i(8, 1),
	Vector2i(0, 5), Vector2i(0, 4), Vector2i(0, 3),
	Vector2i(5, 5), Vector2i(5, 4), Vector2i(5, 3),
	Vector2i(6, 5), Vector2i(6, 4), Vector2i(6, 3),
];


enum MapBackGround{SKY, SKY_AIR, AIR, AIR_LAND, LAND, LAND_BOTTOM, BOTTOM}
var MapBcakGroundList: Array[Vector2i] = [
	Vector2i(0, 9),
	Vector2i(0, 10),
	Vector2i(0, 11),
	Vector2i(0, 12),
	Vector2i(0, 13),
	Vector2i(0, 14),
	Vector2i(0, 15),
]
