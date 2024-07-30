extends Camera2D


@onready var mainTileMap = %MainTileMap
@export var cameraSpeed: float = 1024.0;
var limitTop: float;
var limitRight: float;
var limitBottom: float;
var limitLeft: float;
func _ready():
	limitTop = -MapBlockVar.MapHeight * MapBlockVar.BlockHeight;
	limitRight = MapBlockVar.MapWidth * MapBlockVar.BlockWidth;
	limitBottom = 5 * MapBlockVar.BlockHeight;
	limitLeft = MapBlockVar.BlockWidth;
	MapBlockVar.CurrentSelectedBlock = MapBlockVar.MapBlock.MOVEMENT;
	position = Vector2(500, -300);


func _unhandled_input(event):
	if MapBlockVar.CurrentLevelNum == 0:
		return;
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		MoveCamera();
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if MapBlockVar.CurrentSelectedBlock < MapBlockVar.MapBlockList.size():
			ChangeMapBlock();
		elif MapBlockVar.CurrentSelectedBlock == MapBlockVar.MapBlock.MOVEMENT:
			MoveCamera();
		elif event.is_action_pressed("MouseClick"):
			SetEntityButton();
func _input(event) -> void:
	if event is InputEventMouseButton: # Ready for move camera
		lastMousePosition = get_viewport().get_mouse_position();
func _process(delta):
	if Input.is_action_just_pressed("MouseScrollDown"):
		var newZoom:float = zoom.x * 0.9;
		if newZoom < 0.18:
			newZoom = 0.18;
		zoom = Vector2(newZoom, newZoom);
	elif Input.is_action_just_pressed("MouseScrollUp"):
		var newZoom:float = zoom.x * 1.1;
		if newZoom > 5:
			newZoom = 5;
		zoom = Vector2(newZoom, newZoom);
	var movementX = Input.get_axis("MoveLeft", "MoveRight")
	var movementY = Input.get_axis("MoveUp", "MoveDown")
	if movementX != 0 or movementY != 0:
		position += Vector2(movementX, movementY) * cameraSpeed * delta / zoom.x;



var lastMousePosition: Vector2;
func MoveCamera() -> void:
	var currentMousePosition:Vector2 = get_viewport().get_mouse_position();
	var newCameraPosition = position - (currentMousePosition - lastMousePosition) / zoom.x;
	if newCameraPosition.x < limitLeft:
		newCameraPosition.x = limitLeft;
	if newCameraPosition.y < limitTop:
		newCameraPosition.y = limitTop;
	if newCameraPosition.x > limitRight:
		newCameraPosition.x = limitRight;
	if newCameraPosition.y > limitBottom:
		newCameraPosition.y = limitBottom;
	position = newCameraPosition;
	lastMousePosition = currentMousePosition;


func getMousePositionOnMatrix() -> Vector2:
	var localMousePosition:Vector2 = get_viewport().get_mouse_position();
	var halfWindowSize:Vector2 = DisplayServer.window_get_size() / 2;
	var localMouseRelativePostion:Vector2 = (halfWindowSize - localMousePosition) / zoom.x;
	var mousePositionOnMatrix:Vector2 = position - localMouseRelativePostion;
	return mousePositionOnMatrix;


func ChangeMapBlock() -> void:
	var mousePositionOnMatrix:Vector2 = getMousePositionOnMatrix();

	var posX:int = int(mousePositionOnMatrix.x / MapBlockVar.BlockWidth);
	var posY:int = int(mousePositionOnMatrix.y / MapBlockVar.BlockHeight) - 1;
	if posX > -1 and posX < MapBlockVar.MapWidth and posY < -1 and posY > -MapBlockVar.MapHeight:
		mainTileMap.SetMapBlock(Vector2i(posX, posY), MapBlockVar.CurrentSelectedBlock);


func SetEntityButton() -> void:
	var mousePositionOnMatrix:Vector2 = getMousePositionOnMatrix();
	var pos = mousePositionOnMatrix;
	if pos.x > 0 and pos.x < MapBlockVar.MapWidth * MapBlockVar.BlockWidth and pos.y < 0 and pos.y > -MapBlockVar.MapHeight * MapBlockVar.BlockHeight:
		mainTileMap.SetMapEntityButton(pos, MapBlockVar.CurrentSelectedBlock);
		MapBlockVar.SetMapEntity(pos, MapBlockVar.CurrentSelectedBlock);

