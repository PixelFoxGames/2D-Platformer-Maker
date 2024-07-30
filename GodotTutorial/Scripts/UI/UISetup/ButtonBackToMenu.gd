extends Button


func _ready():
	pass


func _on_button_down():
	var setupUIManager = get_tree().get_first_node_in_group("SetupUIManager");
	if MapBlockVar.CurrentLevelNum != 0:
		MapBlockVar.CurrentLevelNum = 0;
		get_tree().get_first_node_in_group("TileMap").ClearWhole();
		get_tree().reload_current_scene();
	else:
		MapBlockVar.CurrentLevelNum = 0;
		setupUIManager.DeleteSeletLevelUI();
		get_tree().change_scene_to_file("res://Scenes/MainScene/StartScene.tscn");
