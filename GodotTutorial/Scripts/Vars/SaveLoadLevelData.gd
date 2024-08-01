class_name LevelData


func SaveLevelName(levelName:String, dataPath:String = "SceneNameList.txt") -> void:
	print(levelName);
	var levelNameList: Array = LoadLevelNameList(dataPath);
	for name in levelNameList:
		if levelName == name:
			return;
	levelNameList.append(levelName);
	dataPath = BaseDataPath + dataPath;
	SaveVar(dataPath, levelNameList);
func LoadLevelNameList(dataPath:String = "SceneNameList.txt") -> Array:
	dataPath = BaseDataPath + dataPath;
	return LoadVar(dataPath);


var BaseDataPath = "GameData/"; 
#var BaseDataPath = "user://";
#var BaseDataPath = "res://"; 


func SaveLevelData(dataPath:String) -> void:
	SaveLevelName(dataPath);
	dataPath = BaseDataPath + dataPath;
	SaveMapBlockMatrix(dataPath + "_MapBlockMatrix.txt");
	SavePlayer(dataPath + "_PlayerBornPos.txt");
	SaveFinalCoin(dataPath + "_FinalCoinPos.txt");
	
	SaveRebornSlimes(dataPath + "_RebornSlimes.txt");
	SaveBombSlimes(dataPath + "_BombSlimes.txt");
	SaveCoins(dataPath + "_Coins.txt");
	
	SaveStaticPlatform0(dataPath + "_StaticPlatform0.txt");
	SaveStaticPlatform1(dataPath + "_StaticPlatform1.txt");
	SaveMovementPlatform0(dataPath + "_MovementPlatform0.txt");
	SaveMovementPlatform1(dataPath + "_MovementPlatform1.txt");
func LoadLevelData(dataPath:String) -> void:
	dataPath = BaseDataPath + dataPath;
	LoadMapBlockMatrix(dataPath + "_MapBlockMatrix.txt");
	LoadPlayer(dataPath + "_PlayerBornPos.txt");
	LoadFinalCoin(dataPath + "_FinalCoinPos.txt");
	
	LoadRebornSlimes(dataPath + "_RebornSlimes.txt");
	LoadBombSlimes(dataPath + "_BombSlimes.txt");
	LoadCoins(dataPath + "_Coins.txt");
	
	LoadStaticPlatform0(dataPath + "_StaticPlatform0.txt");
	LoadStaticPlatform1(dataPath + "_StaticPlatform1.txt");
	LoadMovementPlatform0(dataPath + "_MovementPlatform0.txt");
	LoadMovementPlatform1(dataPath + "_MovementPlatform1.txt");


func SavePlayer(dataPath: String) -> void:
	SaveVar(dataPath, MapBlockVar.PlayerBornPosList);
func SaveRebornSlimes(dataPath: String) -> void:
	SaveVar(dataPath, MapBlockVar.RebornSlimePosList);
func SaveBombSlimes(dataPath: String) -> void:
	SaveVar(dataPath, MapBlockVar.BombSlimePosList);
func SaveCoins(dataPath: String) -> void:
	SaveVar(dataPath, MapBlockVar.CoinPosList);
func SaveFinalCoin(dataPath: String) -> void:
	SaveVar(dataPath, MapBlockVar.FinalCoinPosList);
func SaveStaticPlatform0(dataPath: String) -> void:
	SaveVar(dataPath, MapBlockVar.StaticPlatform0PosList);
func SaveStaticPlatform1(dataPath: String) -> void:
	SaveVar(dataPath, MapBlockVar.StaticPlatform1PosList);
func SaveMovementPlatform0(dataPath: String) -> void:
	SaveVar(dataPath, MapBlockVar.MovementPlatform0PosList);
func SaveMovementPlatform1(dataPath: String) -> void:
	SaveVar(dataPath, MapBlockVar.MovementPlatform1PosList);




func LoadPlayer(dataPath: String) -> void:
	var playerVar = LoadVar(dataPath);
	MapBlockVar.InitPlayerBornPosList();
	if playerVar == []:
		return;
	MapBlockVar.PlayerBornPosList[0] = playerVar[0];
func LoadRebornSlimes(dataPath: String) -> void:
	var rebornSlimesVar = LoadVar(dataPath);
	MapBlockVar.InitVac2List(MapBlockVar.RebornSlimePosList);
	if rebornSlimesVar == []:
		return;
	for rebornSlime in rebornSlimesVar:
		MapBlockVar.RebornSlimePosList.append(rebornSlime);
func LoadBombSlimes(dataPath: String) -> void:
	var bombSlimesVar = LoadVar(dataPath);
	MapBlockVar.InitVac2List(MapBlockVar.BombSlimePosList);
	if bombSlimesVar == []:
		return;
	for bombSlime in bombSlimesVar:
		MapBlockVar.BombSlimePosList.append(bombSlime);
func LoadCoins(dataPath: String) -> void:
	var coinsVar = LoadVar(dataPath);
	MapBlockVar.InitVac2List(MapBlockVar.CoinPosList);
	if coinsVar == []:
		return;
	for coinVar in coinsVar:
		MapBlockVar.CoinPosList.append(coinVar);
func LoadFinalCoin(dataPath: String) -> void:
	var finalCoinVar = LoadVar(dataPath);
	MapBlockVar.InitFinalCoinPosList();
	if finalCoinVar == []:
		return;
	MapBlockVar.FinalCoinPosList[0] = finalCoinVar[0];
func LoadStaticPlatform0(dataPath: String) -> void:
	var staticPlatrform0 = LoadVar(dataPath);
	MapBlockVar.InitVac2List(MapBlockVar.StaticPlatform0PosList);
	if staticPlatrform0 == []:
		return;
	for pos in staticPlatrform0:
		MapBlockVar.StaticPlatform0PosList.append(pos);
func LoadStaticPlatform1(dataPath: String) -> void:
	var staticPlatrform1 = LoadVar(dataPath);
	MapBlockVar.InitVac2List(MapBlockVar.StaticPlatform1PosList);
	if staticPlatrform1 == []:
		return;
	for pos in staticPlatrform1:
		MapBlockVar.StaticPlatform1PosList.append(pos);
func LoadMovementPlatform0(dataPath: String) -> void:
	var movementPlatrform0 = LoadVar(dataPath);
	MapBlockVar.InitVac2List(MapBlockVar.MovementPlatform0PosList);
	if movementPlatrform0 == []:
		return;
	for pos in movementPlatrform0:
		MapBlockVar.MovementPlatform0PosList.append(pos);
func LoadMovementPlatform1(dataPath: String) -> void:
	var movementPlatrform1 = LoadVar(dataPath);
	MapBlockVar.InitVac2List(MapBlockVar.MovementPlatform1PosList);
	if movementPlatrform1 == []:
		return;
	for pos in movementPlatrform1:
		MapBlockVar.MovementPlatform1PosList.append(pos);





func SaveMapBlockMatrix(dataPath:String) -> void:
	SaveVar(dataPath, MapBlockVar.MapBlockMatrix);
func LoadMapBlockMatrix(dataPath:String) -> void:
	var mapBlockMatrix = LoadVar(dataPath);
	MapBlockVar.InitMapBlockMatrix(MapBlockVar.MapWidth, MapBlockVar.MapHeight);
	if mapBlockMatrix == []:
		return;
	for x in range(MapBlockVar.MapWidth):
		for y in range(MapBlockVar.MapHeight):
			MapBlockVar.MapBlockMatrix[x][y] = mapBlockMatrix[x][y];
func SaveVar(dataPath: String, dataVar) -> void:
	var fileAccess = FileAccess.open(dataPath, FileAccess.WRITE);
	fileAccess.store_var(dataVar);
	fileAccess.close();
func LoadVar(dataPath: String) -> Array:
	var fileAccess = FileAccess.open(dataPath, FileAccess.READ);
	if fileAccess == null:
		return [];
	var dataVar = fileAccess.get_var();
	fileAccess.close();
	return dataVar;


#LoadVec2List(dataPath + "_RebornSlimes.txt", MapBlockVar.RebornSlimePosList);
#LoadVec2List(dataPath + "_BombSlimes.txt", MapBlockVar.BombSlimePosList);
#LoadVec2List(dataPath + "_Coins.txt", MapBlockVar.CoinPosList);
"""
func LoadVec2List(dataPath: String, vec2List: Array[Vector2]) -> void:
	var vec2ListData = LoadVar(dataPath);
	vec2List.clear();
	vec2List = [];
	if vec2ListData == []:
		return;
	for data in vec2ListData:
		print(data);
		vec2List.append(data);
"""
