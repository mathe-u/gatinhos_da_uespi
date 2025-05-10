@tool
extends Resource
class_name ItemData

@export var id: StringName
@export var display_name: String
@export var icon: Texture2D
@export var type: DataTypes.ItemType
@export var effect: DataTypes.Effect
@export var stackable: bool = true
@export var max_stack_size: int = 999
@export var item_scene: PackedScene

@export_group("recipe")
@export var crafting_ingredients: Array[Dictionary]
#   Element 0 (Dictionary)
#     item_id (StringName): "wood_log"
#     quantity (int): 3
#   Element 1 (Dictionary)
#     item_id (StringName): "stone_pebble"
#     quantity (int): 2
@export var items_produced: int
@export var time_to_craft: float
