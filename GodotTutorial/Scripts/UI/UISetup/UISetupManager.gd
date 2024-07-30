extends CanvasLayer


@onready var buttonChangeMode = $CenterContainer/VBoxContainer/ButtonChangeMode
@onready var buttonBackToMenu = $CenterContainer/VBoxContainer/ButtonBackToMenu
const SELECT_LEVEL_UI = preload("res://Scenes/MainScene/SelectLevel/SelectLevelUI.tscn")

var IsUIVisible:bool = false;


func _ready():
	add_to_group("SetupUIManager");
	InitSelectLevelUI();
	if MapBlockVar.IsCreationMode:
		if MapBlockVar.CurrentLevelNum == 0:
			var levelNameList = LevelData.new().LoadLevelNameList();
			if levelNameList.size() < 1:
				SetButtonChangeModeVisible(false);
			else:
				SetButtonChangeModeVisible(true);
		SetUIsVisible(true);
	else:
		if MapBlockVar.CurrentLevelNum == 0:
			SetUIsVisible(true);
		else:
			SetUIsVisible(false);


func InitSelectLevelUI() -> void:
	var selectLevelUI = SELECT_LEVEL_UI.instantiate();
	get_tree().root.add_child(selectLevelUI);
func DeleteSeletLevelUI() -> void:
	var selectLevelUIGroup = get_tree().get_nodes_in_group("SelectLevelUIManager");
	if selectLevelUIGroup.size() != 0:
		for selectLevelUI in selectLevelUIGroup:
			selectLevelUI.queue_free();


func SwitchUIsVisible() -> void:
	SetUIsVisible(not IsUIVisible);


func SetUIsVisible(willShow: bool) -> void:
	IsUIVisible = willShow;
	buttonChangeMode.visible = willShow;
	buttonBackToMenu.visible = willShow;


func SetButtonChangeModeVisible(willShow: bool) -> void:
	buttonChangeMode.disabled = not willShow;
