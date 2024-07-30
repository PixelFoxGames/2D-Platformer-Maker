extends Button


func _ready():
	if MapBlockVar.IsCreationMode:
		text = "Play";
	else:
		text = "Create";


func _on_button_down():
	var mainTileMap = get_tree().get_first_node_in_group("TileMap");
	mainTileMap.ClearWhole();
	var selectLevelUIs = get_tree().get_nodes_in_group("SelectLevelUIManager");
	if selectLevelUIs.size() > 0:
		for selectLevelUI in selectLevelUIs:
			selectLevelUI.ClearSelf();

	if MapBlockVar.CurrentLevelNum != 0:
		get_tree().get_first_node_in_group("SetupUIManager").DeleteSeletLevelUI();
	if MapBlockVar.IsCreationMode:
		if MapBlockVar.CurrentLevelNum != 0:
			mainTileMap.SaveCurrentScene();
		get_tree().change_scene_to_file("res://Scenes/MainScene/GameScene.tscn");
	else:
		get_tree().change_scene_to_file("res://Scenes/MainScene/CreationScene.tscn");

	MapBlockVar.IsCreationMode = not MapBlockVar.IsCreationMode;
