extends TileMapLayer

@export var default: bool = false

func _ready() -> void:
	set_active(default)


func set_active(status: bool) -> void:
	enabled = status
	
	for child: TileMapLayer in get_children():
		child.enabled = status
