extends Button


var LevelNum: int = 0;
var LevelName: String = "1";


#func _ready():
#	pressed.connect(OnButtonPressed);


func SetLevel(levelNum: int, levelName: String) -> void:
	LevelNum = levelNum;
	LevelName = levelName;
	text = levelName;


func OnButtonPressed():
	var mainTileMap = get_tree().get_first_node_in_group("TileMap");
	MapBlockVar.CurrentLevelNum = LevelNum;
	mainTileMap.LoadLevelByName(LevelName);
	get_tree().get_first_node_in_group("SetupUIManager").SetButtonChangeModeVisible(true);

	var setupUIManager = get_tree().get_first_node_in_group("SetupUIManager");
	if not MapBlockVar.IsCreationMode:
		setupUIManager.SetUIsVisible(false);
	setupUIManager.DeleteSeletLevelUI();


func _on_button_down():
	OnButtonPressed();
