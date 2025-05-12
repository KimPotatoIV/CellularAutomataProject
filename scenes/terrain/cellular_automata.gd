extends Node

'''
▶ Cellular Automata란?
	ㄴ 격자(Grid) 형태의 공간에 놓인 각 셀이 주변 셀들의 상태와 미리 정해진 규칙에 따라
	   자신의 상태를 바꾸면서 전체 시스템이 진화하는 방식
'''
##################################################
enum TILE {
	EMPTY,
	WALL
}
# 지형을 빈 공간과 벽으로 구분하는 열거형 변수

const WALL_CHANCE: float = 0.55
# 벽이 생성될 확률 55%
const WALL_COUNT: int = 5
# 주변에 벽이 몇 개 이상 있으면 벽으로 간주할지 결정하는 기준값
const ITERATIONS = 5
# 지형 생성 알고리즘 반복 횟수로 더 높은 값일수록 더 정제된 지형 생성

##################################################
func init(terrain_value: Array, cell_size_value: Vector2i) -> void:
	terrain_value.clear()
	# 기존 지형 데이터 초기화
	
	for x in range(cell_size_value.x):
		var row: Array = []
		for y in range(cell_size_value.y):
			if x == 0 or x == cell_size_value.x - 1 or \
				y == 0 or y == cell_size_value.y - 1:
					row.append(TILE.WALL)
			# 테두리(가장자리)는 무조건 벽으로 설정
			elif randf() < WALL_CHANCE:
				row.append(TILE.WALL)
			else:
				row.append(TILE.EMPTY)
			# 랜덤 확률에 따라 벽 또는 빈 공간 설정
		terrain_value.append(row)

##################################################
func generate(terrain_value: Array, cell_size_value: Vector2i) -> void:
	for i in range(ITERATIONS):
	# ITERATIONS 횟수만큼 반복하여 지형을 정제
		var new_terrain: Array = []
		# 기존 데이터 보존을 위한 임시 배열
		for x in range(cell_size_value.x):
			var row: Array = []
			for y in range(cell_size_value.y):
				row.append(terrain_value[x][y])
			new_terrain.append(row)
		# 기존 데이터를 복사
		'''
		new_terrain은 현재 셀 주변의 상태를 읽는 용도로 쓰이고
		terrain_value는 기록/수정하는 용도로 쓰임
		한 셀의 값을 갱신하면서 그다음 셀이 이미 바뀐 값을 참조하게 되면
		의도하지 않은 지형이 생성됨
		'''
		
		for x in range(1, cell_size_value.x - 1):
			for y in range(1, cell_size_value.y - 1):
				var wall_count: int = 0
				# 주변 벽 개수를 세는 변수
				if new_terrain[x - 1][y - 1] == 1:
					wall_count += 1
				if new_terrain[x][y - 1] == 1:
					wall_count += 1
				if new_terrain[x + 1][y - 1] == 1:
					wall_count += 1
				if new_terrain[x - 1][y] == 1:
					wall_count += 1
				if new_terrain[x + 1][y] == 1:
					wall_count += 1
				if new_terrain[x - 1][y + 1] == 1:
					wall_count += 1
				if new_terrain[x][y + 1] == 1:
					wall_count += 1
				if new_terrain[x + 1][y + 1] == 1:
					wall_count += 1
				
				if wall_count >= WALL_COUNT:
					terrain_value[x][y] = TILE.WALL
				else:
					terrain_value[x][y] = TILE.EMPTY
				# 주변 벽 개수가 WALL_COUNT 이상이면 해당 셀을 벽으로 설정
	
	for x in range(1, cell_size_value.x - 1):
		for y in range(1, cell_size_value.y - 1):
			if terrain_value[x][y - 1] == TILE.EMPTY and \
				terrain_value[x][y + 1] == TILE.EMPTY:
					terrain_value[x][y] = TILE.EMPTY
			elif terrain_value[x - 1][y] == TILE.EMPTY and \
				terrain_value[x + 1][y] == TILE.EMPTY:
					terrain_value[x][y] = TILE.EMPTY
	# 벽이 너무 좁은 공간에서 존재하지 않도록 일부 빈 공간을 설정
	# 뾰족뾰족 튀어나온 지형을 다듬어줌
	
	for x in range(1, cell_size_value.x - 1):
		for y in range(1, cell_size_value.y - 1):
			if terrain_value[x - 1][y] == TILE.EMPTY and \
				terrain_value[x + 1][y] == TILE.EMPTY and \
				terrain_value[x][y - 1] == TILE.EMPTY and \
				terrain_value[x][y + 1] == TILE.EMPTY:
					terrain_value[x][y] = TILE.EMPTY
	# 주변 네 방향이 빈 공간이면 현재 셀도 빈 공간으로 변경
