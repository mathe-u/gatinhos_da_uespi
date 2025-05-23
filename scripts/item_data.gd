@tool
extends Resource
class_name ItemData

@export var id: StringName
@export var display_name: String
@export var icon: Texture2D
@export var type: DataTypes.ItemType
@export var effect: DataTypes.Effect
@export var effect_amount: int
@export var stackable: bool = true
@export var max_stack_size: int = 999
@export var units: int = 1
@export var item_scene: PackedScene

@export_group("recipe")
@export var is_craftable: bool = false
#@export var crafting_ingredients: Array[Ingredient]
@export var crafting_ingredients: Array

@export var items_produced: int
@export var time_to_craft: float
