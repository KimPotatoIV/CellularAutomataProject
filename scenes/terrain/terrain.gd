extends Node2D

##################################################
enum TILE {
	EMPTY,
	WALL
}
# 지형을 빈 공간과 벽으로 구분하는 열거형 변수

const CELL_SIZE: Vector2i = Vector2i(1920 / 16, int(ceil(1080.0 / 16.0)))
# 해상도를 기준으로 타일맵의 셀 크기 설정

var tile_map_layer_node: TileMapLayer
# 타일맵 레이어 노드
var terrain: Array = []
# 지형 데이터를 저장하는 배열

##################################################
func _ready() -> void:
	tile_map_layer_node = $TileMapLayer
	# 타일맵 레이어 노드 설정
	
	init_terrain()
	# 지형 초기화
	generate_terrain()
	# 지형 생성
	draw_terrain()
	# 지형을 타일맵으로 그리기

##################################################
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
	# 스페이스 혹은 엔터 키를 누르면
		init_terrain()
		generate_terrain()
		draw_terrain()
		# 맵을 초기화 및 재생성하여 그림

##################################################
func init_terrain() -> void:
	var init_instance = load("res://scenes/terrain/cellular_automata.gd").new()
	init_instance.init(terrain, CELL_SIZE)
	# cellular_automata.gd를 이용해 지형 초기화

##################################################
func generate_terrain() -> void:
	var generate_terrain_instance = \
		load("res://scenes/terrain/cellular_automata.gd").new()
	generate_terrain_instance.generate(terrain, CELL_SIZE)
	# cellular_automata.gd를 이용해 지형 생성

##################################################
func draw_terrain() -> void:
	for x in range(1, CELL_SIZE.x - 1):
		for y in range(1, CELL_SIZE.y - 1):
	# 가장자리 셀을 제외하고 순회하며
			if terrain[x][y] == TILE.EMPTY:
			# 해당 지형 데이터가 TILE.EMPTY면
				var rand_num = randi_range(0, 3)
				# 0부터 3까지의 임의의 정수를 구해서
				match rand_num:
					0:
						tile_map_layer_node.set_cell(Vector2i(x, y), 0, Vector2i(0, 7))
					1:
						tile_map_layer_node.set_cell(Vector2i(x, y), 0, Vector2i(1, 7))
					2:
						tile_map_layer_node.set_cell(Vector2i(x, y), 0, Vector2i(2, 7))
					3:
						tile_map_layer_node.set_cell(Vector2i(x, y), 0, Vector2i(3, 7))
				# 바닥 타일을 그림
			elif terrain[x][y] == TILE.WALL:
			# 해당 지형 데이터가 TILE.WALL면
				if terrain[x][y - 1] == TILE.WALL and terrain[x][y + 1] == TILE.EMPTY:
					tile_map_layer_node.set_cell(Vector2i(x, y), 0, Vector2i(1, 0))
				elif terrain[x][y - 1] == TILE.EMPTY and terrain[x][y + 1] == TILE.WALL:
					tile_map_layer_node.set_cell(Vector2i(x, y), 0, Vector2i(1, 4))
				elif terrain[x - 1][y] == TILE.WALL and terrain[x + 1][y] == TILE.EMPTY:
					tile_map_layer_node.set_cell(Vector2i(x, y), 0, Vector2i(0, 1))
				elif terrain[x - 1][y] == TILE.EMPTY and terrain[x + 1][y] == TILE.WALL:
					tile_map_layer_node.set_cell(Vector2i(x, y), 0, Vector2i(5, 1))
				else:
					tile_map_layer_node.set_cell(Vector2i(x, y), 0, Vector2i(8, 7))
				# 주변 타일 상태를 고려하여 특정 타일 배치
	
	for x in range(CELL_SIZE.x):
			tile_map_layer_node.set_cell(Vector2i(x, 0), 0, Vector2i(8, 7))
			tile_map_layer_node.set_cell(Vector2i(x, CELL_SIZE.y - 1), 0, Vector2i(8, 7))
	for y in range(CELL_SIZE.y):
		tile_map_layer_node.set_cell(Vector2i(0, y), 0, Vector2i(8, 7))
		tile_map_layer_node.set_cell(Vector2i(CELL_SIZE.x - 1, y), 0, Vector2i(8, 7))
	# 가장자리 네 면의 타일을 특정 타일로 그림
