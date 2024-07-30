extends CanvasLayer


@onready var grid_container = %GridContainer
@onready var scroll_container = $ScrollContainer
const BUTTON_SELECT_LEVEL = preload("res://Scenes/MainScene/SelectLevel/ButtonSelectLevel.tscn")


var buttonList:Array = [];


func _ready():
	add_to_group("SelectLevelUIManager");
	if MapBlockVar.CurrentLevelNum > 0:
		if EnterLevel(MapBlockVar.CurrentLevelNum):
			return;
	BuildSelectLevelPanel();


func BuildSelectLevelPanel() -> void:
	var levelNameList = LevelData.new().LoadLevelNameList();
	if MapBlockVar.IsCreationMode:
		levelNameList.append(str(levelNameList.size()+1));
	SetLevelSelectButton(levelNameList);
	SetColumns(levelNameList.size());


func SetColumns(buttonAmount: int) -> void:
	var columnNum:int = int(pow(buttonAmount, 0.5));
	if columnNum < 1:
		columnNum = 1;
	grid_container.columns = columnNum;
	
	var rowNum:int = int(buttonAmount / columnNum);
	var minuMumSize: Vector2 = Vector2(columnNum * 64, rowNum * 64);
	if minuMumSize.x > 1920:
		minuMumSize.x = 1920;
	if minuMumSize. y > 880:
		minuMumSize.y = 880;
	scroll_container.custom_minimum_size = minuMumSize;


func SetLevelSelectButton(sceneNameList:Array) -> void:
	ClearButtonList();
	for i in sceneNameList.size():
		var button = BUTTON_SELECT_LEVEL.instantiate();
		button.SetLevel(i + 1, sceneNameList[i]);
		grid_container.add_child(button);
		buttonList.append(button);


func ClearSelf() -> void:
	ClearButtonList();
	self.queue_free();


func ClearButtonList() -> void:
	for button in buttonList:
		button.queue_free();


func EnterLevel(levelNum: int) -> bool:
	var levelNameList = LevelData.new().LoadLevelNameList();
	if levelNum > 0 and levelNum < levelNameList.size() + 1:
		MapBlockVar.CurrentLevelNum = levelNum;
		
		var mainTileMap = get_tree().get_first_node_in_group("TileMap");
		mainTileMap.LoadLevelByName(levelNameList[levelNum - 1]);
		get_tree().get_first_node_in_group("SetupUIManager").DeleteSeletLevelUI();
		return true;
	else:
		return false;
