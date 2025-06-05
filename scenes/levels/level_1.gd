extends Node2D

@onready var grass: TileMapLayer = $GameTileMap/Grass

var tileset_source_id: int = 9
var repaired_brigde_top_atlas_coord: Vector2i = Vector2i(1, 0)
var repaired_brigde_down_atlas_coord: Vector2i = Vector2i(0, 0)

var coords_top_broken_bridge_cells: Array[Vector2i] = [
	Vector2i(90, 35),
	Vector2i(91, 35),
	Vector2i(92, 35),
	Vector2i(93, 35),
]

var coords_down_broken_bridge_cells: Array[Vector2i] = [
	Vector2i(90, 36),
	Vector2i(91, 36),
	Vector2i(92, 36),
	Vector2i(93, 36),
]

#var tilemap_layer_index: int = 0

func repair_bridge() -> void:
	if not grass:
		print("Erro: Nó TileMapLayer não encontrado!")
		return
	
	for coord_cell: Vector2i in coords_top_broken_bridge_cells:
		grass.set_cell(
			coord_cell,
			tileset_source_id,
			repaired_brigde_top_atlas_coord,
		)
	
	for coord_cell: Vector2i in coords_down_broken_bridge_cells:
		grass.set_cell(
			coord_cell,
			tileset_source_id,
			repaired_brigde_down_atlas_coord,
		)
	
	print("Ponte consertada!")
